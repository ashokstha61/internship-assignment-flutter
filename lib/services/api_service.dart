import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class ApiService {
  final String apiKey = 'AIzaSyArPidkq5RQZqpp5mQ9XDeM4H7z5JtRj-o'; 
  final String baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  Future<List<Book>> fetchBooks(String query) async {
    final url = Uri.parse('$baseUrl?q=$query&key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final items = data['items'] as List?;
        if (items != null) {
          return items.map((item) => Book.fromJson(item)).toList();
        } else {
          return [];
        }
      } else {
        throw ApiException('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network or Parsing Error: $e');
    }
  }
}