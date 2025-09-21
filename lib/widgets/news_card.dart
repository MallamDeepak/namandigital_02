import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../utils/date_formatter.dart';
import '../utils/url_launcher_helper.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback? onTap;
  final bool showFullContent;
  final bool showSource;

  const NewsCard({
    super.key,
    required this.article,
    this.onTap,
    this.showFullContent = false,
    this.showSource = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article image
              if (article.hasValidImage) ...[
                _buildImage(context),
                const SizedBox(height: 12),
              ],
              
              // Article title
              _buildTitle(context),
              
              // Article metadata (source, date)
              if (showSource) ...[
                const SizedBox(height: 8),
                _buildMetadata(context),
              ],
              
              // Article description/content
              if (article.hasDescription || (showFullContent && article.hasContent)) ...[
                const SizedBox(height: 8),
                _buildContent(context),
              ],
              
              // Action buttons
              const SizedBox(height: 12),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          article.urlToImage!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            
            return Container(
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 48,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      article.title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      maxLines: showFullContent ? null : 3,
      overflow: showFullContent ? null : TextOverflow.ellipsis,
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Row(
      children: [
        // Source
        Expanded(
          child: Text(
            article.sourceName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // Date
        Text(
          DateFormatter.formatNewsDate(article.publishedAt),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final content = showFullContent && article.hasContent
        ? article.content!
        : article.description ?? '';
    
    if (content.isEmpty) return const SizedBox.shrink();
    
    return Text(
      content,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        height: 1.4,
        color: Colors.grey[700],
      ),
      maxLines: showFullContent ? null : 3,
      overflow: showFullContent ? null : TextOverflow.ellipsis,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Read more button
        TextButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.article, size: 18),
          label: const Text('Read More'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        
        const Spacer(),
        
        // Share button
        IconButton(
          onPressed: () => _shareArticle(),
          icon: const Icon(Icons.share),
          tooltip: 'Share Article',
          iconSize: 20,
        ),
        
        // Open in browser button
        IconButton(
          onPressed: () => _openInBrowser(),
          icon: const Icon(Icons.open_in_new),
          tooltip: 'Open in Browser',
          iconSize: 20,
        ),
      ],
    );
  }

  void _shareArticle() {
    UrlLauncherHelper.shareUrl(article.url, title: article.title);
  }

  void _openInBrowser() {
    UrlLauncherHelper.launchURL(article.url);
  }
}

// Compact version of NewsCard for lists
class CompactNewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback? onTap;

  const CompactNewsCard({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail image
              if (article.hasValidImage) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 80,
                    height: 60,
                    child: Image.network(
                      article.urlToImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      article.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Source and date
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            article.sourceName,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          DateFormatter.formatArticleDate(article.publishedAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hero news card for featured articles
class HeroNewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback? onTap;

  const HeroNewsCard({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large image
            if (article.hasValidImage)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    article.urlToImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 64,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Description
                  if (article.hasDescription)
                    Text(
                      article.description!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.4,
                        color: Colors.grey[700],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Metadata and actions
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.sourceName,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              DateFormatter.formatNewsDate(article.publishedAt),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Action buttons
                      IconButton(
                        onPressed: () => UrlLauncherHelper.shareUrl(article.url),
                        icon: const Icon(Icons.share),
                        tooltip: 'Share',
                      ),
                      IconButton(
                        onPressed: () => UrlLauncherHelper.launchURL(article.url),
                        icon: const Icon(Icons.open_in_new),
                        tooltip: 'Open in Browser',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}