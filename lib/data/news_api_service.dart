import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/news_response.dart';
import '../core/constants.dart';

part 'news_api_service.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class NewsApiService {
  factory NewsApiService(Dio dio, {String baseUrl}) = _NewsApiService;

  @GET(AppConstants.topHeadlinesEndpoint)
  Future<NewsResponse> getTopHeadlines({
    @Query('country') String? country,
    @Query('category') String? category,
    @Query('sources') String? sources,
    @Query('q') String? query,
    @Query('pageSize') int? pageSize,
    @Query('page') int? page,
  });

  @GET(AppConstants.everythingEndpoint)
  Future<NewsResponse> getEverything({
    @Query('q') required String query,
    @Query('sources') String? sources,
    @Query('domains') String? domains,
    @Query('excludeDomains') String? excludeDomains,
    @Query('from') String? from,
    @Query('to') String? to,
    @Query('language') String? language,
    @Query('sortBy') String? sortBy,
    @Query('pageSize') int? pageSize,
    @Query('page') int? page,
  });

  @GET(AppConstants.topHeadlinesEndpoint)
  Future<NewsResponse> getTopHeadlinesByCategory({
    @Query('category') required String category,
    @Query('country') String? country,
    @Query('pageSize') int? pageSize,
    @Query('page') int? page,
  });

  @GET(AppConstants.topHeadlinesEndpoint)
  Future<NewsResponse> getTopHeadlinesByCountry({
    @Query('country') required String country,
    @Query('category') String? category,
    @Query('pageSize') int? pageSize,
    @Query('page') int? page,
  });

  @GET(AppConstants.topHeadlinesEndpoint)
  Future<NewsResponse> getTopHeadlinesBySources({
    @Query('sources') required String sources,
    @Query('pageSize') int? pageSize,
    @Query('page') int? page,
  });
}