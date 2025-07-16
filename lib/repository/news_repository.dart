import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:news_app/model/categories_news_model.dart';
import 'package:news_app/model/news_channels_headlines_models.dart';

class NewsRepository {

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi (String newsSource) async {
    String url = "https://newsapi.org/v2/top-headlines?sources=$newsSource&apiKey=${dotenv.env['NEWSAPI']}";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
         return NewsChannelsHeadlinesModel.fromJson(data);
      }
      else {
        throw Exception("Error");
      }
    }catch(e){
      throw Exception(e.toString());
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  Future<CategoriesNewsModel> fetchCategoriesChannelApi (String newsCategories) async {
    String url = "https://newsapi.org/v2/everything?q=$newsCategories&apiKey=${dotenv.env["NEWSAPI"]}";
    try{
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return CategoriesNewsModel.fromJson(data);
      }else {
        throw Exception('Fetching error');
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }
}