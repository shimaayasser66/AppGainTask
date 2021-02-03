import 'package:flutter/material.dart';
import 'package:flutter_movie_app/models/item_model.dart';
import 'package:flutter_movie_app/screens/movie_detail.dart';
import 'package:flutter_movie_app/screens/movie_list.dart';


void main() {
  runApp(App());
}


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: "/",
      routes: {
        "/":(_)=>MovieList(),
      },
    );
  }
}
