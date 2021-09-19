import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:pbnewsapp/screens/Loading.dart';
import 'package:url_launcher/url_launcher.dart';

class ChooseCategory extends StatefulWidget {
  @override
  _ChooseCategoryState createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  var category = 'business';
  List news = [];
  bool loading = true;
  var error = '';

  Future<void> getNews() async {
    String url = "https://newsapi.org/v2/top-headlines?country=in&category=" +
        category +
        "&apiKey=560cfb6960394dee92010760a46d6f4b";

    setState(() {
      loading = true;
    });

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

  Widget newsCard(val) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Card(
            elevation: 3,
            child: Column(
              children: news
                  .map((element) => GestureDetector(
                        onTap: () {
                          newsUrl(element['articleUrl']);
                        },
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
  void initState() {
    super.initState();
    getNews();
  }

  void newsUrl(_url) async {
    await canLaunch(_url) ? await launch(_url) : errorCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? LoadingScreen()
          : Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: RefreshIndicator(
                onRefresh: getNews,
                child: SingleChildScrollView(
                  child: news.length == 0
                      ? errorCard()
                      : Column(
                          children: [
                            Text(category.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                            Column(
                              children:
                                  news.map((val) => newsCard(val)).toList(),
                            )
                          ],
                        ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bottomSheet(context);
        },
        child: Icon(Icons.category),
      ),
    );
  }

  Card errorCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
              title:
                  Text(error.length == 0 ? 'No News Found' : error.toString()),
              leading: Icon(Icons.error_outline_rounded)),
          TextButton.icon(
              onPressed: getNews,
              icon: Icon(Icons.refresh_outlined),
              label: Text('Refresh'))
        ],
      ),
    );
  }

  Future<void> bottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        child: Text('General'),
                        onPressed: () {
                          setState(() {
                            category = 'general';
                            news = [];
                          });
                          getNews();
                        }),
                    SizedBox(width: 20.0),
                    ElevatedButton(
                        child: Text('Science'),
                        onPressed: () {
                          setState(() {
                            category = 'science';
                            news = [];
                          });
                          getNews();
                        }),
                    SizedBox(width: 20.0),
                    ElevatedButton(
                        child: Text('Health'),
                        onPressed: () {
                          setState(() {
                            category = 'health';
                            news = [];
                          });
                          getNews();
                        }),
                    SizedBox(width: 20.0),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        child: Text('Sports'),
                        onPressed: () {
                          setState(() {
                            category = 'sports';
                            news = [];
                          });
                          getNews();
                        }),
                    SizedBox(width: 20.0),
                    ElevatedButton(
                        child: Text('Technology'),
                        onPressed: () {
                          setState(() {
                            category = 'technology';
                            news = [];
                          });
                          getNews();
                        }),
                    SizedBox(width: 20.0),
                    ElevatedButton(
                        child: Text('Entertainment'),
                        onPressed: () {
                          setState(() {
                            category = 'entertainment';
                            news = [];
                          });
                          getNews();
                        })
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
