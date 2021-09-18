import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchString = '';
  bool loading = true;

  List news = [];

  Widget newsCard(val) {
    return Column(
      children: [
        Card(
          child: Column(
            children: news
                .map((element) => GestureDetector(
                      onTap: () {
                        print(element['urlToImage']);
                      },
                      child: Column(
                        children: [
                          Image.network(element['urlToImage'],
                              height: 200, width: 300),
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 0),
                            child: Column(
                              children: [
                                Text(
                                  element['title'],
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  element['description'],
                                  style: TextStyle(
                                      fontSize: 10.0,
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
        SizedBox(
          height: 20.0,
        )
      ],
    );
  }

  Future<void> getResults() async {
    String url = "https://newsapi.org/v2/everything?q=" + searchString + "&apiKey=560cfb6960394dee92010760a46d6f4b";
    setState(() {
      news = [];
    });

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
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search News',
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                setState(() {
                  searchString = val;
                  news = [];
                });
              },
            ),
          ),
          TextButton(onPressed: getResults, child: Text('Get Result')),
          Expanded(
              child: ListView(
            children: news.map((element) => newsCard(element)).toList(),
          ))
        ],
      ),
    );
  }
}
