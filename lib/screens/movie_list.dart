import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/auth/authService.dart';
import '../models/item_model.dart';
import '../blocs/movies_bloc.dart';
import '../screens/movie_detail.dart';
import '../blocs/movie_detail_bloc_provider.dart';
import 'package:flutter_movie_app/main.dart' as Main;
import 'package:flutter/services.dart';

class MovieList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieListState();
  }
}

class MovieListState extends State<MovieList> {

  String appDeepLink = "https://fluttermovieapp.page.link/63fF";

  final device_token = AuthService().firebaseCloudMessaging_Listeners().toString();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
    this.initDynamicLinks();
  }

  void initDynamicLinks() async {

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          // ignore: unrelated_type_equality_checks
          if (deepLink != null) {
            Navigator.pushNamed(context, deepLink.path);
            //Navigator.pushNamed(context, "/movie",arguments: deepLink.queryParameters["movie"]);
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
      //Navigator.pushNamed(context, "/movie",arguments: deepLink.queryParameters["movie"]);
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: StreamBuilder(
        stream: bloc.allMovies,
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () async {
              Clipboard.setData(ClipboardData(text: appDeepLink));
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Copied")));
            },
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white70,
                        blurRadius: 1,
                        spreadRadius: 0.9,
                        offset: Offset(.2, .5))
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Copy Deep Link",
                  style: const TextStyle(color: Colors.blue),
                ),
              ),

            ),
          ),

          SizedBox(height:10),

          GestureDetector(
            onTap: () async {
              Clipboard.setData(ClipboardData(text:device_token));
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Copied")));
            },
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white70,
                        blurRadius: 1,
                        spreadRadius: 0.9,
                        offset: Offset(.2, .5))
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Copy Device Token",
                  style: const TextStyle(color: Colors.blue),
                ),
              ),

            ),
          ),
        ],
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
        itemCount: snapshot.data.results.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GridTile(
            child: InkResponse(
              enableFeedback: true,
              child: Image.network(
                'https://image.tmdb.org/t/p/w185${snapshot.data
                    .results[index].poster_path}',
                fit: BoxFit.cover,
                loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null ?
                      loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
              onTap: () => openDetailPage(snapshot.data, index),
            ),
          );
        });
  }


  openDetailPage(ItemModel data, int index) {

    print(index);

    final page = MovieDetailBlocProvider(
      child: MovieDetail(
       index: index,
       data: data,
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return page;
      }),
    );
  }
}
