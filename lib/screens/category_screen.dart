import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../widgets/emergency_call_overlay.dart';
import '../services/purchase_service.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryId;

  const CategoryScreen({super.key, required this.categoryId});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final category = categories.firstWhere((c) => c.id == widget.categoryId);
    final categoryPhrases = phrases.where((p) => p.categoryId == widget.categoryId).toList();
    final isPro = PurchaseService().isPro;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: [
          if (!isPro)
            IconButton(
              icon: const Icon(Icons.star_border, color: Colors.amber),
              onPressed: () async {
                final success = await context.push<bool>('/paywall');
                if (success == true) {
                  setState(() {}); // Refresh state to update lock status
                }
              },
            ),
        ],
      ),
      body: EmergencyCallOverlay(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          itemCount: categoryPhrases.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final phrase = categoryPhrases[index];
            // Lock content after index 2 if not pro
            final isLocked = !isPro && index > 2; 

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              title: Text(
                phrase.chinese,
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: isLocked ? Colors.grey : null,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(phrase.pinyin, style: TextStyle(color: isLocked ? Colors.grey[400] : Colors.grey[700])),
                  Text(phrase.translation, style: TextStyle(color: isLocked ? Colors.grey : null)),
                ],
              ),
              trailing: isLocked 
                ? const Icon(Icons.lock, color: Colors.grey)
                : const Icon(Icons.chevron_right),
              onTap: () {
                if (isLocked) {
                  context.push('/paywall').then((value) {
                     if (value == true) setState(() {});
                  });
                } else {
                  context.push('/learn/${phrase.id}');
                }
              },
            );
          },
        ),
      ),
    );
  }
}
