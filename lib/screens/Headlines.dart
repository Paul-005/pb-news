import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:pbnewsapp/screens/Loading.dart';

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
  var error = '';

  Future<void> getNews() async {
    String url =
        "http://newsapi.org/v2/top-headlines?country=in&sortBy=publishedAt&language=en&apiKey=560cfb6960394dee92010760a46d6f4b";

    try {
      var response = await get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);
      setState(() {
        loading = false;
        error = '';
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
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
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
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Card(
            elevation: 3,
            child: Column(
              children: news.map((element) => 
                  GestureDetector(
                        onTap: () => print(element['urlToImage']),
                        child: Column(
                          children: [
                            Image.network(element['urlToImage'],
                                height: 200, width: 300),
                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 50.0),
                              child: Column(
                                children: [
                                  Text(
                                    element['title'],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    element['description'],
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: 20.0)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? LoadingScreen()
          : Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                child: news.length == 0
                    ? Card(
                        child: Column(
                          children: [
                            ListTile(title: Text(error),leading: Icon(Icons.error_outline_rounded)),
                            TextButton.icon(onPressed: getNews, icon: Icon(Icons.refresh_outlined), label: Text('Refresh'))
                          ],
                        ),
                      )
                    : Column(
                        children: news.map((val) => newsCard(val)).toList(),
                      ),
              ),
            ),
    );
  }
}
