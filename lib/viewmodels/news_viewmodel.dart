import 'package:flutter/foundation.dart';
import '../models/news_article.dart';
import '../data/news_repository.dart';
import '../core/error_handling.dart';
import '../core/constants.dart';

enum NewsState {
  initial,
  loading,
  loaded,
  error,
  loadingMore,
}

class NewsViewModel extends ChangeNotifier {
  final NewsRepository _repository = NewsRepository.instance;

  // State management
  NewsState _state = NewsState.initial;
  Map<String, List<NewsArticle>> _articlesByCategory = {};
  AppException? _error;
  String _selectedCategory = AppConstants.defaultCategory;
  String _selectedCountry = AppConstants.defaultCountry;
  String _searchQuery = '';
  int _currentPage = 1;
  bool _hasMoreData = true;

  // Getters
  NewsState get state => _state;
  List<NewsArticle> get articles => _articlesByCategory[_selectedCategory] ?? [];
  AppException? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get selectedCountry => _selectedCountry;
  String get searchQuery => _searchQuery;
  int get currentPage => _currentPage;
  bool get hasMoreData => _hasMoreData;

  // Helper getters
  bool get isLoading => _state == NewsState.loading;
  bool get isLoadingMore => _state == NewsState.loadingMore;
  bool get hasError => _state == NewsState.error;
  bool get hasArticles => articles.isNotEmpty;
  bool get isSearchMode => _searchQuery.isNotEmpty;

  // Get articles for a specific category
  List<NewsArticle> getArticlesForCategory(String category) {
    return _articlesByCategory[category] ?? [];
  }

  // Initialize and load default news
  Future<void> initialize() async {
    print('NewsViewModel: Initializing...');
    await loadTopHeadlines();
  }

  // Load top headlines
  Future<void> loadTopHeadlines({
    String? category,
    String? country,
    bool forceRefresh = false,
  }) async {
    try {
      print('NewsViewModel: Loading top headlines...');
      print('Category: ${category ?? _selectedCategory}');
      print('Country: ${country ?? _selectedCountry}');
      
      _setState(NewsState.loading);
      _error = null;
      _currentPage = 1;
      _hasMoreData = true;

      if (category != null) _selectedCategory = category;
      if (country != null) _selectedCountry = country;

      final articles = await _repository.getTopHeadlines(
        category: _selectedCategory != 'all' ? _selectedCategory : null,
        country: _selectedCountry,
        forceRefresh: forceRefresh,
      );

      print('NewsViewModel: Received ${articles.length} articles');
      _articlesByCategory[_selectedCategory] = articles;
      _hasMoreData = articles.length >= AppConstants.defaultPageSize;
      _setState(NewsState.loaded);
    } catch (e) {
      print('NewsViewModel: Error loading headlines - $e');
      _handleError(e);
    }
  }

  // Search news
  Future<void> searchNews(String query) async {
    try {
      _setState(NewsState.loading);
      _error = null;
      _searchQuery = query;
      _currentPage = 1;
      _hasMoreData = true;

      if (query.isEmpty) {
        await loadTopHeadlines();
        return;
      }

      final articles = await _repository.searchNews(query: query);
      
      _articlesByCategory[_selectedCategory] = articles;
      _hasMoreData = articles.length >= AppConstants.defaultPageSize;
      _setState(NewsState.loaded);
    } catch (e) {
      _handleError(e);
    }
  }

  // Load more articles (pagination)
  Future<void> loadMoreArticles() async {
    if (!_hasMoreData || isLoadingMore) return;

    try {
      _setState(NewsState.loadingMore);
      final nextPage = _currentPage + 1;

      List<NewsArticle> newArticles;
      if (isSearchMode) {
        newArticles = await _repository.searchNews(
          query: _searchQuery,
          page: nextPage,
        );
      } else {
        newArticles = await _repository.loadMoreArticles(
          page: nextPage,
          country: _selectedCountry,
          category: _selectedCategory != 'all' ? _selectedCategory : null,
        );
      }

      if (newArticles.isNotEmpty) {
        final currentArticles = _articlesByCategory[_selectedCategory] ?? [];
        _articlesByCategory[_selectedCategory] = [...currentArticles, ...newArticles];
        _currentPage = nextPage;
        _hasMoreData = newArticles.length >= AppConstants.defaultPageSize;
      } else {
        _hasMoreData = false;
      }

      _setState(NewsState.loaded);
    } catch (e) {
      _setState(NewsState.loaded); // Don't change main state for load more errors
      _error = ErrorHandler.handleError(e);
    }
  }

  // Refresh articles
  Future<void> refreshArticles() async {
    if (isSearchMode) {
      await searchNews(_searchQuery);
    } else {
      await loadTopHeadlines(forceRefresh: true);
    }
  }

  // Change category
  Future<void> changeCategory(String category) async {
    if (_selectedCategory == category) return;
    
    _selectedCategory = category;
    _searchQuery = ''; // Clear search when changing category
    await loadTopHeadlines();
  }

  // Change country
  Future<void> changeCountry(String country) async {
    if (_selectedCountry == country) return;
    
    _selectedCountry = country;
    _searchQuery = ''; // Clear search when changing country
    await loadTopHeadlines();
  }

  // Clear search
  Future<void> clearSearch() async {
    if (_searchQuery.isEmpty) return;
    
    _searchQuery = '';
    await loadTopHeadlines();
  }

  // Get news by specific criteria
  Future<void> getNewsByCategory(String category) async {
    try {
      _setState(NewsState.loading);
      _error = null;
      _selectedCategory = category;
      _searchQuery = '';
      _currentPage = 1;
      _hasMoreData = true;

      final articles = await _repository.getNewsByCategory(
        category: category,
        country: _selectedCountry,
      );

      _articlesByCategory[category] = articles;
      _hasMoreData = articles.length >= AppConstants.defaultPageSize;
      _setState(NewsState.loaded);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> getNewsByCountry(String country) async {
    try {
      _setState(NewsState.loading);
      _error = null;
      _selectedCountry = country;
      _searchQuery = '';
      _currentPage = 1;
      _hasMoreData = true;

      final articles = await _repository.getNewsByCountry(
        country: country,
        category: _selectedCategory != 'all' ? _selectedCategory : null,
      );

      _articlesByCategory[_selectedCategory] = articles;
      _hasMoreData = articles.length >= AppConstants.defaultPageSize;
      _setState(NewsState.loaded);
    } catch (e) {
      _handleError(e);
    }
  }

  // Retry after error
  Future<void> retry() async {
    if (isSearchMode) {
      await searchNews(_searchQuery);
    } else {
      await loadTopHeadlines();
    }
  }

  // Utility methods
  NewsArticle? getArticleByUrl(String url) {
    try {
      return articles.firstWhere((article) => article.url == url);
    } catch (e) {
      return null;
    }
  }

  List<NewsArticle> getArticlesBySource(String sourceName) {
    return articles
        .where((article) => article.sourceName.toLowerCase() == sourceName.toLowerCase())
        .toList();
  }

  void clearCache() {
    _repository.clearCache();
  }

  // Private methods
  void _setState(NewsState newState) {
    _state = newState;
    notifyListeners();
  }

  void _handleError(dynamic error) {
    _error = ErrorHandler.handleError(error);
    _setState(NewsState.error);
  }

  @override
  void dispose() {
    // Cancel any pending requests if needed
    super.dispose();
  }
}