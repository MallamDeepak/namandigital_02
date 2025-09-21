import 'package:json_annotation/json_annotation.dart';

part 'news_article.g.dart';

@JsonSerializable()
class NewsArticle {
  final Source? source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;

  const NewsArticle({
    this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleFromJson(json);

  Map<String, dynamic> toJson() => _$NewsArticleToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsArticle &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          title == other.title;

  @override
  int get hashCode => url.hashCode ^ title.hashCode;

  @override
  String toString() {
    return 'NewsArticle{title: $title, url: $url, publishedAt: $publishedAt}';
  }

  // Helper methods
  bool get hasValidImage => urlToImage != null && urlToImage!.isNotEmpty;
  
  bool get hasContent => content != null && content!.isNotEmpty;
  
  bool get hasDescription => description != null && description!.isNotEmpty;

  String get displayContent => hasDescription ? description! : 
                              (hasContent ? content! : 'No content available');

  String get sourceName => source?.name ?? 'Unknown Source';
}

@JsonSerializable()
class Source {
  final String? id;
  final String name;

  const Source({
    this.id,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  Map<String, dynamic> toJson() => _$SourceToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Source &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'Source{id: $id, name: $name}';
}