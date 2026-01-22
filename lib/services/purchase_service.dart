import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io' show Platform;

class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  // Replace with your RevenueCat API Keys
  static const _apiKeyIOS = 'appl_bnluOmlTeNbsJkEZggmbaTPUSLF';
  static const _apiKeyAndroid = 'goog_YOUR_ANDROID_API_KEY';

  // The entitlement ID you created in RevenueCat dashboard
  static const entitlementId = 'pro_access'; 

  bool _isPro = false;
  bool get isPro => _isPro;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    
    if (kDebugMode) {
      await Purchases.setLogLevel(LogLevel.debug);
    }

    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(_apiKeyAndroid);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(_apiKeyIOS);
    }

    if (configuration != null) {
      await Purchases.configure(configuration);
      _isInitialized = true;
      await _checkSubscriptionStatus();
    }
  }

  Future<void> _checkSubscriptionStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      _isPro = customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
      if (kDebugMode) {
        print('Is Pro User: $_isPro');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error checking subscription status: $e");
      }
    }
  }

  Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      
      if (kDebugMode) {
        print('Purchase finished. Entitlements: ${customerInfo.entitlements.all}');
        print('Checking entitlement ID: $entitlementId');
      }
      
      _isPro = customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
      return _isPro;
    } catch (e) {
      if (kDebugMode) {
        print("Purchase failed: $e");
      }
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      
      if (kDebugMode) {
        print('Restore finished. Info: $customerInfo');
        print('Entitlements: ${customerInfo.entitlements.all}');
      }

      _isPro = customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
      return _isPro;
    } catch (e) {
      if (kDebugMode) {
        print("Restore failed: $e");
      }
      return false;
    }
  }

  Future<Offering?> getCurrentOffering() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        return offerings.current;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching offerings: $e");
      }
    }
    return null;
  }
}
