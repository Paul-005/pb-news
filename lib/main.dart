import 'package:flutter/material.dart';
import 'package:pbnewsapp/screens/Headlines.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.newspaper, size: 30),
              SizedBox(width: 15),
              Center(
                child: Text('PB ', style: TextStyle(
                   color: Colors.yellow[700], fontWeight: FontWeight.bold)
                ),
              ),
              Text('News', style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          centerTitle: true,
        
            bottom: const TabBar(
              tabs: [
                Tab(icon: FaIcon(FontAwesomeIcons.solidNewspaper)),
                Tab(icon: Icon(Icons.search)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
          ),
          body:  TabBarView(
            children: [
              Headlines(),
              Headlines(),
              Headlines(),
            ],
          ),
        ),
      ),
      );
  }
}
