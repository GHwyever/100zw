import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last Updated: January 2026',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildSection(
              '1. Acceptance of Terms',
              'By downloading, accessing, or using "100 Chinese Travel Phrases", you agree to be bound by these Terms of Use. If you do not agree to these terms, please do not use the application.',
            ),
            _buildSection(
              '2. License',
              'We grant you a personal, non-exclusive, non-transferable, revocable license to use the application for your personal, non-commercial use strictly in accordance with these Terms.',
            ),
            _buildSection(
              '3. Pro Access (In-App Purchase)',
              'The application offers a "Pro Access" upgrade available for a one-time fee of \$4.99 (or equivalent in your local currency). \n\n- This is a non-consumable purchase that unlocks all 100 phrases and additional features permanently.\n- Payment will be charged to your Apple ID account at the confirmation of purchase.\n- You can restore your purchase on other devices using the "Restore Purchases" button in the Settings menu.',
            ),
            _buildSection(
              '4. Intellectual Property',
              'The application and its original content (including but not limited to text, audio, graphics, and code) are and will remain the exclusive property of the developers. You may not reproduce, distribute, or create derivative works from any part of the app without explicit permission.',
            ),
            _buildSection(
              '5. User Conduct',
              'You agree not to use the application for any unlawful purpose or in any way that could damage, disable, or impair the service. You are responsible for maintaining the confidentiality of your device and account.',
            ),
            _buildSection(
              '6. Disclaimer of Warranties',
              'The application is provided on an "AS IS" and "AS AVAILABLE" basis. We make no warranties, expressed or implied, regarding the accuracy of the translations, pronunciation guides, or the reliability of the speech recognition features.',
            ),
            _buildSection(
              '7. Limitation of Liability',
              'In no event shall the developers be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or related to your use of the application.',
            ),
            _buildSection(
              '8. Governing Law',
              'These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which the developer resides, without regard to its conflict of law provisions.',
            ),
            _buildSection(
              '9. Contact Us',
              'If you have any questions about these Terms, please contact us.',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
