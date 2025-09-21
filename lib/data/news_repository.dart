import '../models/news_article.dart';
import '../core/error_handling.dart';
import '../core/constants.dart';
import 'api_client.dart';
import 'news_api_service.dart';

class NewsRepository {
  static NewsRepository? _instance;
  late final NewsApiService _apiService;
  
  // Category-specific caching
  final Map<String, List<NewsArticle>> _cachedArticlesByCategory = {};
  final Map<String, DateTime> _lastFetchTimeByCategory = {};

  NewsRepository._() {
    _apiService = NewsApiService(ApiClient.instance.dio);
  }

  static NewsRepository get instance {
    _instance ??= NewsRepository._();
    return _instance!;
  }

  // Cache management
  bool hasValidCacheForCategory(String? category) {
    final cacheKey = category ?? 'all';
    if (_lastFetchTimeByCategory[cacheKey] == null || 
        !_cachedArticlesByCategory.containsKey(cacheKey) ||
        _cachedArticlesByCategory[cacheKey]!.isEmpty) {
      return false;
    }
    
    final timeDifference = DateTime.now().difference(_lastFetchTimeByCategory[cacheKey]!);
    return timeDifference.inMinutes < 30; // Cache for 30 minutes
  }

  void _updateCacheForCategory(String? category, List<NewsArticle> articles) {
    final cacheKey = category ?? 'all';
    _cachedArticlesByCategory[cacheKey] = articles;
    _lastFetchTimeByCategory[cacheKey] = DateTime.now();
  }

  void clearCache() {
    _cachedArticlesByCategory.clear();
    _lastFetchTimeByCategory.clear();
  }

  // API methods with error handling
  Future<List<NewsArticle>> getTopHeadlines({
    String? country,
    String? category,
    String? sources,
    String? query,
    int? pageSize,
    int? page,
    bool forceRefresh = false,
  }) async {
    try {
      print('Repository: Getting top headlines...');
      print('Country: ${country ?? AppConstants.defaultCountry}');
      print('Category: $category');
      print('Force refresh: $forceRefresh');
      
      // Return cached data if available and not forcing refresh
      if (!forceRefresh && hasValidCacheForCategory(category) && query == null) {
        final cacheKey = category ?? 'all';
        final cachedArticles = _cachedArticlesByCategory[cacheKey] ?? [];
        print('Repository: Returning cached data (${cachedArticles.length} articles)');
        return List.from(cachedArticles);
      }

      print('Repository: Making API call...');
      final response = await _apiService.getTopHeadlines(
        country: country ?? AppConstants.defaultCountry,
        category: category,
        sources: sources,
        query: query,
        pageSize: pageSize ?? AppConstants.defaultPageSize,
        page: page ?? 1,
      );

      print('Repository: API response received');
      print('Success: ${response.isSuccess}');
      if (!response.isSuccess) {
        print('Error message: ${response.message}');
        throw ServerException(
          response.message ?? 'Failed to fetch top headlines',
          statusCode: 400,
        );
      }

      final articles = response.articles;
      final cacheKey = category ?? 'all';
      print('Repository: Fetched ${articles.length} articles');
      _updateCacheForCategory(cacheKey, articles);
      return articles;
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  Future<List<NewsArticle>> searchNews({
    required String query,
    String? sources,
    String? domains,
    String? excludeDomains,
    DateTime? from,
    DateTime? to,
    String? language,
    String? sortBy,
    int? pageSize,
    int? page,
  }) async {
    try {
      final response = await _apiService.getEverything(
        query: query,
        sources: sources,
        domains: domains,
        excludeDomains: excludeDomains,
        from: from?.toIso8601String().split('T')[0],
        to: to?.toIso8601String().split('T')[0],
        language: language,
        sortBy: sortBy ?? 'publishedAt',
        pageSize: pageSize ?? AppConstants.defaultPageSize,
        page: page ?? 1,
      );

      if (!response.isSuccess) {
        throw ServerException(
          response.message ?? 'Failed to search news',
          statusCode: 400,
        );
      }

      return response.articles;
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  Future<List<NewsArticle>> getNewsByCategory({
    required String category,
    String? country,
    int? pageSize,
    int? page,
    bool forceRefresh = false,
  }) async {
    try {
      // Check cache for category-specific requests
      if (!forceRefresh && hasValidCacheForCategory(category)) {
        final cachedArticles = _cachedArticlesByCategory[category] ?? [];
        return List.from(cachedArticles);
      }

      final response = await _apiService.getTopHeadlinesByCategory(
        category: category,
        country: country ?? AppConstants.defaultCountry,
        pageSize: pageSize ?? AppConstants.defaultPageSize,
        page: page ?? 1,
      );

      if (!response.isSuccess) {
        throw ServerException(
          response.message ?? 'Failed to fetch news by category',
          statusCode: 400,
        );
      }

      final articles = response.articles;
      _updateCacheForCategory(category, articles);

      return articles;
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  Future<List<NewsArticle>> getNewsByCountry({
    required String country,
    String? category,
    int? pageSize,
    int? page,
  }) async {
    try {
      final response = await _apiService.getTopHeadlinesByCountry(
        country: country,
        category: category,
        pageSize: pageSize ?? AppConstants.defaultPageSize,
        page: page ?? 1,
      );

      if (!response.isSuccess) {
        throw ServerException(
          response.message ?? 'Failed to fetch news by country',
          statusCode: 400,
        );
      }

      return response.articles;
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  Future<List<NewsArticle>> getNewsBySources({
    required String sources,
    int? pageSize,
    int? page,
  }) async {
    try {
      final response = await _apiService.getTopHeadlinesBySources(
        sources: sources,
        pageSize: pageSize ?? AppConstants.defaultPageSize,
        page: page ?? 1,
      );

      if (!response.isSuccess) {
        throw ServerException(
          response.message ?? 'Failed to fetch news by sources',
          statusCode: 400,
        );
      }

      return response.articles;
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  // Get cached articles for all categories
  List<NewsArticle> getCachedArticles() {
    final allArticles = <NewsArticle>[];
    for (final articleList in _cachedArticlesByCategory.values) {
      allArticles.addAll(articleList);
    }
    return allArticles;
  }

  // Get cached articles for a specific category
  List<NewsArticle> getCachedArticlesForCategory(String category) {
    return List.from(_cachedArticlesByCategory[category] ?? []);
  }

  // Utility methods
  Future<List<NewsArticle>> refreshTopHeadlines({
    String? country,
    String? category,
  }) async {
    return getTopHeadlines(
      country: country,
      category: category,
      forceRefresh: true,
    );
  }

  Future<List<NewsArticle>> loadMoreArticles({
    required int page,
    String? country,
    String? category,
    String? query,
  }) async {
    if (query != null) {
      return searchNews(query: query, page: page);
    } else {
      return getTopHeadlines(
        country: country,
        category: category,
        page: page,
      );
    }
  }
}