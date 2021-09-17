import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Article {
  String title;
  String description;
  String urlToImage;
  String content;
  String articleUrl;

  Article(
      {required this.title,
      required this.description,
      required this.content,
      required this.urlToImage,
      required this.articleUrl});
}

class Headlines extends StatefulWidget {
  @override
  _HeadlinesState createState() => _HeadlinesState();
}

class _HeadlinesState extends State<Headlines> {
  bool loading = true;

  List news = [];

  Future<void> getNews() async {
    String url =
        "http://newsapi.org/v2/top-headlines?country=in&excludeDomains=stackoverflow.com&sortBy=publishedAt&language=en&apiKey=560cfb6960394dee92010760a46d6f4b";

    var response = await get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);
    setState(() {
      loading = false;
    });

    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['content'] != null &&
            element['url'] != null) {
          Map data = {
            'title': element['title'],
            'description': element['description'],
            'urlToImage': element['urlToImage'],
            'content': element["content"],
            'articleUrl': element["url"],
          };
          news.add(data);
        }
      });
    }
    print(news);
  }

  @override
  void initState() {
    super.initState();
    getNews();
  }

  Widget loadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget newsCard(val) {
    return Column(
      children: [
        Card(
         child: Column(
           children: news.map((element) => 
           Column(
             children: [
               Container(
                 margin: EdgeInsets.symmetric(horizontal:20.0),
                child: Text(element['title'], style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
               ),
               Image.network(element['urlToImage'], height: 200, width: 300,)
             ],
           )
          ).toList(),
        ),
      ),
      SizedBox(height: 20.0,)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading
            ? loadingWidget()
            : Container(
              margin: EdgeInsets.symmetric(vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                      children: news.map((val) => newsCard(val)).toList(),                 
                    ),
                  ),  
              ),
              );
  }
}
