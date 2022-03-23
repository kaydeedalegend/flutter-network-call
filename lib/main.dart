import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class Album {
  final int id;
  final int userId;
  final String title;

  const Album({
    required this.id,
    required this.title,
    required this.userId,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('failed to load album');
  }
}

Future<Album> deleteAlbum(String id) async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("not successfully deleted");
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
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
          child: FutureBuilder<Album>(
            future: fetchAlbum(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data!.title),
                    Text(snapshot.data!.userId.toString()),
                    Text(snapshot.data!.id.toString()),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('$snapshot.error');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
        
      ),
    );
  }
}
