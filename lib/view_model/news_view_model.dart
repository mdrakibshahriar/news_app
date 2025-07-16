


import 'package:news_app/model/categories_news_model.dart';
import 'package:news_app/model/news_channels_headlines_models.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {

  final _api = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi (String source) async {

    final response = await _api.fetchNewsChannelHeadlinesApi(source);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesChannelApi(String newsCategories) async {
    final response = await _api.fetchCategoriesChannelApi(newsCategories);
    return response;
  }
}