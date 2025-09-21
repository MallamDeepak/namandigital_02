import 'package:json_annotation/json_annotation.dart';
import 'news_article.dart';

part 'news_response.g.dart';

@JsonSerializable()
class NewsResponse {
  final String status;
  final int totalResults;
  final List<NewsArticle> articles;
  final String? message; // For error responses

  const NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
    this.message,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NewsResponseToJson(this);

  bool get isSuccess => status == 'ok';
  
  bool get hasError => status == 'error' || message != null;
  
  bool get hasArticles => articles.isNotEmpty;

  @override
  String toString() {
    return 'NewsResponse{status: $status, totalResults: $totalResults, articlesCount: ${articles.length}}';
  }
}