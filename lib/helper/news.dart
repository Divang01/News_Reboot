import 'dart:convert';

import 'package:news_reboot/models/article_model.dart';
import 'package:http/http.dart' as http;
class News{
  List<ArticleModel> news=[];
  Future<void> getNews() async{
    var url = Uri.parse("http://newsapi.org/v2/top-headlines?country=in&excludeDomains=stackoverflow.com&sortBy=publishedAt&language=en&apiKey=876c0a32bf52481bb821e7d4e63eabd4");

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if(jsonData['status']=="ok"){
      jsonData["articles"].forEach((element){
        if(element["urlToImage"] != null && element['description'] != null){
          ArticleModel articleModel= ArticleModel(
              element["author"],
              element['title'],
              element["url"],
              element["description"],
              element["context"],
            element["urlToImage"]
          );
          news.add(articleModel);
        }
      });
    }

  }

}

class CategoryNewsClass{
  List<ArticleModel> news=[];
  Future<void> getNews(String category) async{
    var url = Uri.parse("http://newsapi.org/v2/top-headlines?country=in&category=$category&excludeDomains=stackoverflow.com&sortBy=publishedAt&language=en&apiKey=876c0a32bf52481bb821e7d4e63eabd4");

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if(jsonData['status']=="ok"){
      jsonData["articles"].forEach((element){
        if(element["urlToImage"] != null && element['description'] != null){
          ArticleModel articleModel= ArticleModel(
              element["author"],
              element['title'],
              element["url"],
              element["description"],
              element["context"],
              element["urlToImage"]
          );
          news.add(articleModel);
        }
      });
    }

  }

}