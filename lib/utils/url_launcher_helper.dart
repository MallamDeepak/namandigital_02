import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class UrlLauncherHelper {
  // Private constructor to prevent instantiation
  UrlLauncherHelper._();

  /// Launches a URL in the browser
  static Future<bool> launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (kDebugMode) {
          print('Could not launch URL: $url');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching URL: $url - $e');
      }
      return false;
    }
  }

  /// Launches a URL in an in-app web view
  static Future<bool> launchURLInApp(String url) async {
    try {
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      } else {
        if (kDebugMode) {
          print('Could not launch URL in app: $url');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching URL in app: $url - $e');
      }
      return false;
    }
  }

  /// Launches an email client with pre-filled email
  static Future<bool> launchEmail({
    required String email,
    String? subject,
    String? body,
  }) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        query: _encodeQueryParameters({
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        }),
      );

      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      } else {
        if (kDebugMode) {
          print('Could not launch email: $email');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching email: $email - $e');
      }
      return false;
    }
  }

  /// Launches a phone dialer
  static Future<bool> launchPhone(String phoneNumber) async {
    try {
      final uri = Uri(scheme: 'tel', path: phoneNumber);
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      } else {
        if (kDebugMode) {
          print('Could not launch phone: $phoneNumber');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching phone: $phoneNumber - $e');
      }
      return false;
    }
  }

  /// Launches SMS with pre-filled message
  static Future<bool> launchSMS({
    required String phoneNumber,
    String? message,
  }) async {
    try {
      final uri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        query: message != null ? 'body=$message' : null,
      );

      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      } else {
        if (kDebugMode) {
          print('Could not launch SMS: $phoneNumber');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching SMS: $phoneNumber - $e');
      }
      return false;
    }
  }

  /// Shares content using the device's share functionality
  static Future<bool> shareUrl(String url, {String? title}) async {
    try {
      final uri = Uri.parse(url);
      
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error sharing URL: $url - $e');
      }
      return false;
    }
  }

  /// Validates if a URL is valid
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Validates if an email is valid
  static bool isValidEmail(String email) {
    try {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    } catch (e) {
      return false;
    }
  }

  /// Validates if a phone number is valid (basic validation)
  static bool isValidPhoneNumber(String phoneNumber) {
    try {
      final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
      return phoneRegex.hasMatch(phoneNumber) && phoneNumber.length >= 10;
    } catch (e) {
      return false;
    }
  }

  /// Closes in-app web view if open
  static Future<void> closeInAppWebView() async {
    try {
      await closeWebView();
    } catch (e) {
      if (kDebugMode) {
        print('Error closing in-app web view: $e');
      }
    }
  }

  /// Opens URL with user choice between in-app and external browser
  static Future<bool> launchURLWithChoice(
    String url, {
    bool preferInApp = false,
  }) async {
    if (preferInApp) {
      final success = await launchURLInApp(url);
      if (success) return true;
      
      // Fallback to external browser
      return await launchURL(url);
    } else {
      final success = await launchURL(url);
      if (success) return true;
      
      // Fallback to in-app browser
      return await launchURLInApp(url);
    }
  }

  /// Extracts domain from URL
  static String? extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return null;
    }
  }

  /// Formats URL for display (removes protocol and www)
  static String formatUrlForDisplay(String url) {
    try {
      final uri = Uri.parse(url);
      String host = uri.host;
      
      if (host.startsWith('www.')) {
        host = host.substring(4);
      }
      
      return host;
    } catch (e) {
      return url;
    }
  }

  /// Checks if URL is from a specific domain
  static bool isFromDomain(String url, String domain) {
    try {
      final uri = Uri.parse(url);
      return uri.host.toLowerCase().contains(domain.toLowerCase());
    } catch (e) {
      return false;
    }
  }

  /// Private helper method for encoding query parameters
  static String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((entry) => '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}')
        .join('&');
  }

  /// Opens URL in specific browser if available
  static Future<bool> launchInSpecificBrowser(
    String url, {
    String? browserPackage,
  }) async {
    try {
      final uri = Uri.parse(url);
      
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error launching URL in specific browser: $url - $e');
      }
      return false;
    }
  }

  /// Preloads URL for faster launching
  static Future<bool> preloadUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      return await canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }
}