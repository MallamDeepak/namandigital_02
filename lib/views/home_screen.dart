import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/news_viewmodel.dart';
import '../widgets/loading_indicator.dart';
import 'news_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  NewsListStyle _currentStyle = NewsListStyle.standard;
  
  final List<String> _categories = [
    'general',
    'business',
    'technology',
    'health',
    'science',
    'sports',
    'entertainment',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsViewModel>().changeCategory(_categories.first);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News Reader',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          // Style selector
          PopupMenuButton<NewsListStyle>(
            icon: const Icon(Icons.view_list),
            onSelected: (style) {
              setState(() {
                _currentStyle = style;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: NewsListStyle.standard,
                child: Row(
                  children: [
                    Icon(Icons.view_agenda),
                    SizedBox(width: 8),
                    Text('Standard View'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: NewsListStyle.compact,
                child: Row(
                  children: [
                    Icon(Icons.view_compact),
                    SizedBox(width: 8),
                    Text('Compact View'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: NewsListStyle.featured,
                child: Row(
                  children: [
                    Icon(Icons.featured_video),
                    SizedBox(width: 8),
                    Text('Featured View'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: NewsListStyle.magazine,
                child: Row(
                  children: [
                    Icon(Icons.article),
                    SizedBox(width: 8),
                    Text('Magazine View'),
                  ],
                ),
              ),
            ],
          ),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<NewsViewModel>().refreshArticles();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) {
            return Tab(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          }).toList(),
          onTap: (index) {
            final category = _categories[index];
            context.read<NewsViewModel>().changeCategory(category);
          },
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Theme.of(context).primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      body: Consumer<NewsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.articles.isEmpty) {
            return const LoadingIndicator();
          }

          if (viewModel.hasError && viewModel.articles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.error?.message ?? 'Unknown error occurred',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      viewModel.retry();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: _categories.map((category) {
              final categoryArticles = viewModel.getArticlesForCategory(category);
              final isCurrentCategory = viewModel.selectedCategory == category;
              
              return NewsList(
                articles: categoryArticles,
                isLoadingMore: isCurrentCategory ? viewModel.isLoadingMore : false,
                hasMoreData: isCurrentCategory ? viewModel.hasMoreData : true,
                showHeroCard: _currentStyle == NewsListStyle.standard,
                style: _currentStyle,
                onLoadMore: isCurrentCategory ? () {
                  viewModel.loadMoreArticles();
                } : null,
                onRefresh: () {
                  viewModel.changeCategory(category);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}