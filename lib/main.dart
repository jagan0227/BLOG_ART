import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> blogs = [];

  Future<void> fetchBlogs() async {
    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    const String adminSecret = '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        setState(() {
          blogs = json.decode(response.body)['blogs'];
        });
      } else {
        if (kDebugMode) {
          print('Request failed with status code: ${response.statusCode}');
          print('Response data: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(), // Set the theme to dark mode
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BlogArt'),
          leading: IconButton(
            icon: const Icon(Icons.menu), // Add the menu icon (you can replace 'menu' with your desired icon)
            onPressed: () {
              // Define the action when the icon is pressed, e.g., show a menu.
              // You can open a drawer, show a popup menu, or navigate to a settings page.
            },
          ),
        ),
        body: ListView.builder(
          itemCount: blogs.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0), // Add top padding
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        blogs[index]['image_url'],
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: Text(
                        blogs[index]['title'],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}

class BlogDetailScreen extends StatelessWidget {
  final dynamic blogData;

  const BlogDetailScreen({Key? key, required this.blogData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(blogData['title']),
            backgroundColor: Colors.grey[800]), // Set the background color for the app bar
        body: Column(children: [
          Image.network(blogData['image_url']),
          Text(blogData['title'])
        ]));
  }
}
