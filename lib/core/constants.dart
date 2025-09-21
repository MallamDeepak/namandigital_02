class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://newsapi.org/v2/';
  static const String apiKey = 'e5018aea1451452f95e15dda1c84c9c1'; // Replace with your actual API key
  
  // Endpoints
  static const String topHeadlinesEndpoint = 'top-headlines';
  static const String everythingEndpoint = 'everything';
  
  // Default parameters
  static const String defaultCountry = 'us';
  static const String defaultCategory = 'general';
  static const int defaultPageSize = 20;
  
  // App Configuration
  static const String appName = 'News Reader';
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Error Messages
  static const String noInternetError = 'No internet connection available';
  static const String serverError = 'Server error occurred';
  static const String unexpectedError = 'An unexpected error occurred';
  static const String noNewsFoundError = 'No news articles found';
  
  // Categories
  static const List<String> newsCategories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];
}