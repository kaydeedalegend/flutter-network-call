import 'package:flutter/material.dart';\
// This package helps you make network requests.
import 'package:http/http.dart' as http;

// this is the async library that enables us to write asynchronous functions.
import 'dart:async';
// this helps us convert json into local dart maps.
import 'dart:convert';

/// First of we create a class that represents 
/// the data of what we will be calling from the api.
class Album {
  final int id;
  final int userId;
  final String title;

  const Album({
    required this.id,
    required this.title,
    required this.userId,
  });

  /// then we create a factory function called fromJson that is 
  /// called when ever a new instance of the class is created.
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

/// this is the actual function that makes the network call.
/// the 'async' keyword indicates that it is an asynchronous function.
Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    /// if the status code of the response we get is 200 which 
    /// means okay, we will return a the data in a map format.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    ///else throw an exception.
    throw Exception('failed to load album');
  }
}

/// Ignore this for now. was trying to make a delete request.
// Future<Album> deleteAlbum(String id) async {
//   final response = await http
//       .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'));

//   if (response.statusCode == 200) {
//     return Album.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception("not successfully deleted");
//   }
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///@override tells the app what to make it priority when starting.
  @override
  /// Inittstate function tells the app what to do when the app loads.
  void initState() {
    super.initState();
    /// here we tell the app to call for the api data so that we 
    /// can get it and input into the screen asap.
    fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Albums'),
        ),
        body: Center(
          /// we use a future builder here. 
          /// it builds our widget tree based on what it gets from a future.
          child: FutureBuilder<Album>(
            /// here we indicate what future we would like to build from.
            future: fetchAlbum(),
            builder: (context, snapshot) {
              /// here we check if the builder has data.
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data!.title),
                    Text(snapshot.data!.userId.toString()),
                    Text(snapshot.data!.id.toString()),
                  ],
                );
                // here we check if the builder has an error.
              } else if (snapshot.hasError) {
                return Text('$snapshot.error');
              }

              /// if the builder doesn't have any data but also doesn't have any error it means that it is still leading. 
              /// in that case we show a circular progress indicator, 
              /// so the screen isn't blank.
              return const CircularProgressIndicator();
            },
          ),
        ),
        
      ),
    );
  }
}
