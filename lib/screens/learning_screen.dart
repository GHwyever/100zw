import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:go_router/go_router.dart';
import '../models/phrase.dart';
import '../data/mock_data.dart';
import '../widgets/emergency_call_overlay.dart';
import '../services/purchase_service.dart';

class LearningScreen extends StatefulWidget {
  final String phraseId;

  const LearningScreen({super.key, required this.phraseId});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late Phrase phrase;
  int _currentStep = 1; // 1: Listen, 2: Speak, 3: Use
  
  // TTS
  final FlutterTts flutterTts = FlutterTts();
  
  // STT
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _lastWords = '';
  double _confidence = 0.0;
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    phrase = phrases.firstWhere((p) => p.id == widget.phraseId);
    _checkAccess();
    _initTts();
    _initStt();
  }

  void _checkAccess() {
    final isPro = PurchaseService().isPro;
    final categoryPhrases = phrases.where((p) => p.categoryId == phrase.categoryId).toList();
    final index = categoryPhrases.indexWhere((p) => p.id == phrase.id);
    
    if (!isPro && index > 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final success = await context.push<bool>('/paywall');
        if (success == true) {
          setState(() {}); // Refresh to update UI if needed
          _playAudio(); // Auto play after successful purchase
        } else {
          if (mounted) {
            Navigator.pop(context); // Go back if not purchased
          }
        }
      });
    }
  }

  void _initTts() async {
    await flutterTts.setLanguage("zh-CN");
    await flutterTts.setSpeechRate(0.5); // Slower for learning
    
    // Auto play if user has access
    final isPro = PurchaseService().isPro;
    final categoryPhrases = phrases.where((p) => p.categoryId == phrase.categoryId).toList();
    final index = categoryPhrases.indexWhere((p) => p.id == phrase.id);
    
    if (isPro || index <= 2) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _playAudio();
      });
    }
  }

  void _initStt() async {
    _speechAvailable = await _speech.initialize(
      onError: (val) => print('onError: $val'),
      onStatus: (val) => print('onStatus: $val'),
    );
    if (mounted) setState(() {});
  }

  void _playAudio() async {
    await flutterTts.speak(phrase.chinese);
  }

  void _listen() async {
    if (!_isListening && _speechAvailable) {
      setState(() {
        _isListening = true;
        _lastWords = '';
      });
      _speech.listen(
        onResult: (val) {
          setState(() {
            _lastWords = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
            if (val.finalResult) {
              _isListening = false;
              _evaluateSpeech();
            }
          });
        },
        localeId: "zh_CN",
      );
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _evaluateSpeech() {
    // Simple evaluation: check if recognized words contain at least 50% of the target characters
    // Remove punctuation for comparison
    final target = phrase.chinese.replaceAll(RegExp(r'[^\u4e00-\u9fa5]'), '');
    final recognized = _lastWords.replaceAll(RegExp(r'[^\u4e00-\u9fa5]'), '');
    
    if (target.isEmpty) return;

    int matchCount = 0;
    for (var char in recognized.runes) {
      if (target.contains(String.fromCharCode(char))) {
        matchCount++;
      }
    }

    final score = matchCount / target.length;
    final isGood = score >= 0.5; // Threshold can be adjusted

    if (mounted) {
      setState(() {
        _confidence = score; // Update confidence to reflect accuracy
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(isGood ? Icons.check_circle : Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Text(isGood ? 'Great job! (${(score * 100).toInt()}%)' : 'Try again! (${(score * 100).toInt()}%)'),
            ],
          ),
          backgroundColor: isGood ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _getScenarioForCategory(String categoryId) {
    switch (categoryId) {
      case 'greetings':
        return 'Scenario: Meeting someone new';
      case 'transport':
        return 'Scenario: Getting around the city';
      case 'hotel':
        return 'Scenario: At the hotel reception';
      case 'dining':
        return 'Scenario: Ordering food';
      case 'shopping':
        return 'Scenario: Buying items';
      case 'sightseeing':
        return 'Scenario: Visiting attractions';
      case 'emergency':
        return 'Scenario: Urgent situation';
      default:
        return 'Scenario: Daily conversation';
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
        _lastWords = '';
        _confidence = 0.0;
      });
    } else {
      Navigator.pop(context); // Finish
    }
  }

  @override
  void dispose() {
    _speech.cancel();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress $_currentStep/3'),
      ),
      body: EmergencyCallOverlay(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _currentStep / 3,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildStepContent(),
              ),
            ),
            Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _nextStep,
                child: Text(_currentStep == 3 ? 'Finish' : 'Next'),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildListenStep();
      case 2:
        return _buildSpeakStep();
      case 3:
        return _buildUseStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildListenStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Step 1: Listen', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 40),
        Text(
          phrase.chinese,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          phrase.pinyin,
          style: const TextStyle(fontSize: 20, color: Colors.blueGrey),
        ),
        const SizedBox(height: 16),
        Text(
          phrase.translation,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 60),
        IconButton(
          icon: const Icon(Icons.volume_up_rounded),
          iconSize: 80,
          color: Theme.of(context).primaryColor,
          onPressed: _playAudio,
        ),
        const Text('Tap to Play'),
      ],
    );
  }

  Widget _buildSpeakStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Step 2: Speak', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 30),
        Text(
          phrase.chinese,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(phrase.pinyin, style: const TextStyle(fontSize: 18, color: Colors.grey)),
        const SizedBox(height: 40),
        
        // Microphone Button
        GestureDetector(
          onTap: _listen,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _isListening ? Colors.red : Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_isListening ? Colors.red : Colors.blue).withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(_isListening ? 'Listening...' : 'Tap to Record'),
        
        const SizedBox(height: 30),
        if (_lastWords.isNotEmpty) ...[
          const Text('Result:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          _buildFeedbackText(),
          const SizedBox(height: 8),
          Text(
            'Match: ${(_confidence * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              color: _confidence > 0.6 ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFeedbackText() {
    final target = phrase.chinese.replaceAll(RegExp(r'[^\u4e00-\u9fa5]'), '');
    List<InlineSpan> spans = [];
    
    for (var charCode in _lastWords.runes) {
      final char = String.fromCharCode(charCode);
      // Check if it's Chinese
      final isChinese = RegExp(r'[\u4e00-\u9fa5]').hasMatch(char);
      
      Color color = Colors.black;
      if (isChinese) {
        if (target.contains(char)) {
          color = Colors.green;
        } else {
          color = Colors.red;
        }
      }
      
      spans.add(TextSpan(
        text: char,
        style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
      ));
    }
    
    return RichText(
      text: TextSpan(children: spans),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUseStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Step 3: Use it!', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 40),
        const Icon(Icons.storefront, size: 80, color: Colors.orange),
        const SizedBox(height: 20),
        Text(
          _getScenarioForCategory(phrase.categoryId),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text('Clerk: "May I help you?"'),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text('You say:'),
              const SizedBox(height: 10),
              Text(
                phrase.chinese,
                style: const TextStyle(fontSize: 24, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _playAudio,
          icon: const Icon(Icons.volume_up),
          label: const Text('Sample Audio'),
        ),
      ],
    );
  }
}
