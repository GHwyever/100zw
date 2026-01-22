import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../data/mock_data.dart';
import '../widgets/emergency_call_overlay.dart';
import '../services/purchase_service.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  stt.SpeechToText? _speech;
  bool _isListening = false;
  bool _speechAvailable = false;
  Offset? _fabPosition;
  bool _isPro = false;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  bool _showDragHint = false;

  @override
  void initState() {
    super.initState();
    _checkProStatus();
    
    // Initialize bounce animation
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticOut,
      ),
    );

    // Defer SharedPreferences loading until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFabPosition();
      _checkFirstTimeHint();
    });
  }

  Future<void> _checkFirstTimeHint() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenHint = prefs.getBool('has_seen_mic_drag_hint_v2') ?? false;
    
    if (!hasSeenHint) {
      if (mounted) {
        setState(() => _showDragHint = true);
        // Bounce 3 times
        _bounceController.forward().then((_) => _bounceController.reverse())
          .then((_) => _bounceController.forward()).then((_) => _bounceController.reverse())
          .then((_) => _bounceController.forward()).then((_) => _bounceController.reverse());
          
        // Hide hint after 6 seconds
        Future.delayed(const Duration(seconds: 6), () {
          if (mounted) {
            setState(() => _showDragHint = false);
            prefs.setBool('has_seen_mic_drag_hint_v2', true);
          }
        });
      }
    }
  }

  void _checkProStatus() {
    setState(() {
      _isPro = PurchaseService().isPro;
    });
  }

  Future<void> _loadFabPosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final x = prefs.getDouble('fab_x');
      final y = prefs.getDouble('fab_y');
      if (x != null && y != null && x.isFinite && y.isFinite) {
        if (mounted) {
          setState(() {
            _fabPosition = Offset(x, y);
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading FAB position: $e');
    }
  }

  Future<void> _saveFabPosition(Offset position) async {
    try {
      if (!position.dx.isFinite || !position.dy.isFinite) return;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('fab_x', position.dx);
      await prefs.setDouble('fab_y', position.dy);
    } catch (e) {
      debugPrint('Error saving FAB position: $e');
    }
  }

  Future<bool> _initSpeech() async {
    try {
      debugPrint('Initializing speech recognition...');
      _speech ??= stt.SpeechToText();
      final available = await _speech!.initialize(
        onError: (val) => debugPrint('onError: $val'),
        onStatus: (val) {
          debugPrint('onStatus: $val');
          if (mounted && (val == 'done' || val == 'notListening')) {
            setState(() => _isListening = false);
          }
        },
        debugLogging: true, // Enable debug logging for more details
      );
      debugPrint('Speech initialization result: $available');
      if (mounted) {
        setState(() {
          _speechAvailable = available;
        });
      }
      return available;
    } catch (e) {
      debugPrint('Error initializing speech: $e');
      if (mounted) {
        setState(() {
          _speechAvailable = false;
        });
      }
      return false;
    }
  }

  void _startListening() async {
    // Lazy initialization
    if (!_speechAvailable) {
      final available = await _initSpeech();
      if (!available) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Speech recognition not available')),
          );
        }
        return;
      }
    }

    setState(() => _isListening = true);
    
    // Show a snackbar or dialog to indicate listening
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Listening... Say "Good morning"'),
        duration: Duration(seconds: 2),
      ),
    );

    await _speech!.listen(
      onResult: (val) {
        if (val.finalResult) {
          setState(() => _isListening = false);
          _handleVoiceResult(val.recognizedWords);
        }
      },
      localeId: 'en_US', // Listen for English input
    );
  }

  void _stopListening() async {
    if (_speech == null) return;
    await _speech!.stop();
    setState(() => _isListening = false);
  }

  void _handleVoiceResult(String text) {
    if (text.isEmpty) return;
    
    debugPrint('Recognized: $text');
    final query = text.toLowerCase().trim();
    
    // Simple matching logic
    // 1. Exact match first
    // 2. Contains match
    
    try {
      final match = phrases.firstWhere(
        (p) => p.translation.toLowerCase().replaceAll(RegExp(r'[!.,?]'), '') == query.replaceAll(RegExp(r'[!.,?]'), '') ||
               p.translation.toLowerCase().contains(query),
      );
      
      // Navigate to learning screen
      context.push('/learn/${match.id}');
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No phrase found for "$text"')),
      );
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _speech?.stop();
    _speech?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Separate Emergency from normal categories for special display
    final normalCategories = categories.where((c) => c.id != 'emergency').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('100 Chinese Travel Phrases'),
        actions: [
          if (!_isPro)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final success = await context.push<bool>('/paywall');
                  if (success == true) {
                    _checkProStatus();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700), // Gold color
                  foregroundColor: Colors.black87, // Dark text for contrast on gold
                  elevation: 4,
                  shadowColor: Colors.amber.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                icon: const Icon(Icons.workspace_premium, size: 20),
                label: const Text(
                  'GO PRO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.star, color: Colors.amber),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              _checkProStatus();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              EmergencyCallOverlay(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () => context.push('/emergency'),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 40),
                              SizedBox(width: 16),
                              Text(
                                'Emergency Help',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: normalCategories.length,
                        itemBuilder: (context, index) {
                          final category = normalCategories[index];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => context.push('/category/${category.id}'),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    category.icon,
                                    style: const TextStyle(fontSize: 48),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    category.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    category.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: _fabPosition?.dx ?? constraints.maxWidth - 80,
                top: _fabPosition?.dy ?? constraints.maxHeight - 100,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      final maxWidth = constraints.maxWidth;
                      final maxHeight = constraints.maxHeight;
                      double newX = (_fabPosition?.dx ?? maxWidth - 80) + details.delta.dx;
                      double newY = (_fabPosition?.dy ?? maxHeight - 100) + details.delta.dy;
                      
                      // Keep within bounds
                      if (newX < 0) newX = 0;
                      if (newX > maxWidth - 56) newX = maxWidth - 56;
                      if (newY < 0) newY = 0;
                      if (newY > maxHeight - 56) newY = maxHeight - 56;
                      
                      _fabPosition = Offset(newX, newY);
                    });
                  },
                  onPanEnd: (_) {
                    if (_fabPosition != null) {
                      _saveFabPosition(_fabPosition!);
                    }
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // The FAB itself (Layout Anchor)
                      AnimatedBuilder(
                        animation: _bounceAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _bounceAnimation.value),
                            child: child,
                          );
                        },
                        child: FloatingActionButton(
                          onPressed: _isListening ? _stopListening : _startListening,
                          backgroundColor: _isListening ? Colors.red : Theme.of(context).primaryColor,
                          child: Icon(_isListening ? Icons.mic_off : Icons.mic),
                        ),
                      ),
                      
                      // The Hint (Positioned relative to FAB, does not affect layout)
                       if (_showDragHint)
                         Positioned(
                           bottom: 70, // Position above the FAB
                           right: 0,   // Align to the right side of the FAB (expands to left)
                           child: AnimatedOpacity(
                             opacity: _showDragHint ? 1.0 : 0.0,
                             duration: const Duration(milliseconds: 500),
                             child: Container(
                               constraints: const BoxConstraints(maxWidth: 200),
                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                               decoration: BoxDecoration(
                                 color: Colors.black87,
                                 borderRadius: BorderRadius.circular(8),
                               ),
                               child: const Text(
                                 'Voice direct access, buttons can be dragged arbitrarily.',
                                 style: TextStyle(color: Colors.white, fontSize: 12),
                                 textAlign: TextAlign.center,
                               ),
                             ),
                           ),
                         ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
