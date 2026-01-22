import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/purchase_service.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  Package? _package;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOfferings();
  }

  Future<void> _fetchOfferings() async {
    final offering = await PurchaseService().getCurrentOffering();
    if (offering != null && offering.availablePackages.isNotEmpty) {
      setState(() {
        _package = offering.availablePackages.first; // Usually "Lifetime" or "Annual"
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _purchase() async {
    if (_package == null) return;
    
    setState(() => _isLoading = true);
    final success = await PurchaseService().purchasePackage(_package!);
    setState(() => _isLoading = false);

    if (success && mounted) {
      // Prompt for review after successful purchase
      try {
        final InAppReview inAppReview = InAppReview.instance;
        if (await inAppReview.isAvailable()) {
          inAppReview.requestReview();
        }
      } catch (_) {}

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase Successful! Welcome Pro!')),
      );
      Navigator.pop(context, true); // Return success
    } else if (mounted) {
      // Handle failure case
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase failed or cancelled. Please try again.')),
      );
    }
  }

  Future<void> _restore() async {
    setState(() => _isLoading = true);
    final success = await PurchaseService().restorePurchases();
    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchases Restored!')),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No purchases found to restore.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unlock Full Access'),
        automaticallyImplyLeading: false, // Don't show back button automatically
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_open, size: 80, color: Colors.amber),
                  const SizedBox(height: 24),
                  const Text(
                    'Unlock All Features',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Get unlimited access to all 100 phrases, categories, and future updates.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 48),
                  if (_package != null)
                    ElevatedButton(
                      onPressed: _purchase,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'Buy Lifetime Access - ${_package!.storeProduct.priceString}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    )
                  else
                    const Text('No products available. Check configuration.'),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: _restore,
                    child: const Text('Restore Purchases'),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 4,
                    children: [
                      _buildFooterLink('Terms of Use', 'https://GHwyever.github.io/100zw/terms.html'),
                      const Text('|', style: TextStyle(color: Colors.grey)),
                      _buildFooterLink('Apple EULA', 'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/'),
                      const Text('|', style: TextStyle(color: Colors.grey)),
                      _buildFooterLink('Privacy Policy', 'https://GHwyever.github.io/100zw/privacy.html'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Maybe Later',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFooterLink(String text, String url) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url')),
          );
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
