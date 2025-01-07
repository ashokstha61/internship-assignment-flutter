import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_controller.dart';
import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  final BookController bookController = Get.find();

  BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'book-${book.title}',
                child: book.thumbnail != null
                    ? Image.network(book.thumbnail!, height: 200)
                    : Icon(Icons.book, size: 200),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      book.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Obx(() {
                    bool isFavorite = bookController.favorites.any((fav) => fav.id == book.id);
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        if (isFavorite) {
                          bookController.removeFromFavorites(book.id);
                        } else {
                          bookController.addToFavorites(book);
                        }
                      },
                    );
                  }),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Author: ${book.authors.join(", ") }',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Published: ${book.publishedDate ?? "N/A"}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                book.description ?? 'No description available.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}