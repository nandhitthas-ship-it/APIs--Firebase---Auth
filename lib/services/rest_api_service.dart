import 'dart:convert';

import 'package:http/http.dart' as http;

class RestApiException implements Exception {
  const RestApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RestApiService {
  RestApiService({
    http.Client? client,
    this.baseUrl = 'https://jsonplaceholder.typicode.com',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Future<List<ApiPost>> fetchPosts() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/posts?_limit=10'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RestApiException('REST request failed (${response.statusCode}).');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const RestApiException('REST response was not a JSON array.');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(ApiPost.fromJson)
        .toList(growable: false);
  }
}

class ApiPost {
  const ApiPost({
    required this.id,
    required this.title,
    required this.body,
  });

  final int id;
  final String title;
  final String body;

  factory ApiPost.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! int ||
        json['title'] is! String ||
        json['body'] is! String) {
      throw const RestApiException('REST response contained an invalid post.');
    }
    return ApiPost(
      id: id,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
