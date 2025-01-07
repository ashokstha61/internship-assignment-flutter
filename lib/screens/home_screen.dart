import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_controller.dart';
import 'book_details.dart';
import '../models/book.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookController bookController = Get.find<BookController>();
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> categories = [
    'Technology', 'Science', 'Fiction', 'History', 'Business', 'Art',
  ];
  String selectedCategory = 'Technology';

  @override
  void initState() {
    super.initState();
    bookController.fetchBooks(selectedCategory);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        bookController.fetchMoreBooks(selectedCategory);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search Books',
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              String query = searchController.text.trim();
              if (query.isNotEmpty) {
                bookController.searchBooks(query);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildCategorySelector() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          bool isSelected = category == selectedCategory;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              selectedColor: Colors.blue,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
                });
                bookController.fetchBooks(selectedCategory);
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildBookListTile(Book book) {
    return ListTile(
      title: Text(book.title),
      subtitle: Text(book.authors.join(', ')),
      leading: book.thumbnail != null
          ? Image.network(book.thumbnail!)
          : Icon(Icons.book),
      onTap: () {
        Get.to(() => BookDetailScreen(book: book));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Finder'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          buildSearchBar(),
          buildCategorySelector(),
          Expanded(
            child: Obx(() {
              if (bookController.isLoading.value && bookController.books.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              if (bookController.books.isEmpty && !bookController.isLoading.value) {
                return Center(child: Text('No books available.'));
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: bookController.books.length,
                itemBuilder: (context, index) {
                  final book = bookController.books[index];
                  return buildBookListTile(book);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}