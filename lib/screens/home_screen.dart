import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/strings/strings.dart';
import 'package:flutter_movie_app/style/theme.dart' as Style;
import 'package:flutter_movie_app/widgets/best_movies.dart';
import 'package:flutter_movie_app/widgets/genres.dart';
import 'package:flutter_movie_app/widgets/now_playing.dart';
import 'package:flutter_movie_app/widgets/persons.dart';



Strings strings = new Strings();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      /*appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        title: Text("Movie App"),
      ),*/
      body: ListView(
        children: <Widget>[
          NowPlaying(),
          GenresScreen(),
          PersonsList(),
          BestMovies(),
        ],
      ),
    );
  }
}