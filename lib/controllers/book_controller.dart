import 'package:get/get.dart';
import '../models/book.dart';
import '../models/favorite_book.dart';
import '../services/api_service.dart';
import '../database/database_helper.dart';

class BookController extends GetxController {
  var isLoading = true.obs;
  var books = <Book>[].obs;
  var favorites = <FavoriteBook>[].obs;
  final apiService = ApiService();
  final dbHelper = DatabaseHelper();
  int startIndex = 0;
  int maxResults = 10;

  @override
  void onInit() {
    loadFavorites();
    super.onInit();
  }

  void loadFavorites() async {
    try {
      final maps = await dbHelper.getFavorites(); // Now returns a non-null list
      print('Raw Database Data: $maps'); // Debugging output

      // Ensure valid data and handle any type mismatch
      if (maps.isNotEmpty) {
        favorites.assignAll(maps
            .whereType<Map<String, dynamic>>() // Ensure correct type
            .map((map) => FavoriteBook.fromMap(map))
            .toList());
      } else {
        print('No favorites found in database');
        favorites.assignAll([]); // Assign empty list if no data
      }
    } catch (e) {
      print('Error loading favorites: $e');
      Get.snackbar('Error', 'Failed to load favorites!');
      favorites.assignAll([]); // Fallback to empty list
    } finally {
      isLoading(false);
    }
  }

  void addToFavorites(Book book) async {
    try {
      final favoriteBook = FavoriteBook(
        id: book.id,
        title: book.title,
        authors: book.authors.join(', '),
        thumbnail: book.thumbnail ?? '',
      );
      await dbHelper.insertFavorite(favoriteBook);
      loadFavorites();
      Get.snackbar('Success', 'Added to favorites!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add to favorites: $e');
    }
  }

  void removeFromFavorites(String id) async {
    try {
      await dbHelper.deleteFavorite(id);
      loadFavorites();
      Get.snackbar('Success', 'Removed from favorites!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove from favorites');
    }
  }

  Future<bool> isFavorite(String id) async {
    return await dbHelper.isFavorite(id);
  }

  void fetchBooks(String category) async {
    try {
      isLoading(true);
      startIndex = 0;

      // Fetch results from the API
      final results = await apiService.fetchBooks(
          'subject:$category&startIndex=$startIndex&maxResults=$maxResults');

      // Debugging API response
      print('API Response: $results');

      // Ensure the response is valid
      if (results == null || results.isEmpty) {
        throw Exception('No data found.');
      }

      // Process results if it is a list
      if (results is List) {
        books.assignAll(results.map((e) {
          if (e is Map<String, dynamic>) {
            // Safe conversion to Book
            return Book.fromJson(e as Map<String, dynamic>);
          } else if (e is Book) {
            // Already a Book object
            return e;
          } else {
            throw Exception('Invalid data type: ${e.runtimeType}');
          }
        }).toList());
      } else {
        throw Exception(
            'Unexpected API response format: ${results.runtimeType}');
      }
    } on ApiException catch (e) {
      // Handle API-specific errors
      Get.snackbar('API Error', e.message);
    } catch (e) {
      // Handle general errors
      Get.snackbar('Error', 'Failed to load books: $e');
    } finally {
      isLoading(false);
    }
  }

  void fetchMoreBooks(String category) async {
    if (isLoading.value) return;
    try {
      isLoading(true);
      startIndex = 0;

      // Fetch results from the API
      final results = await apiService.fetchBooks(
          'subject:$category&startIndex=$startIndex&maxResults=$maxResults');

      // Debugging API response
      print('API Response: $results');

      // Ensure the response is valid
      if (results == null || results.isEmpty) {
        throw Exception('No data found.');
      }

      // Process results if it is a list
      if (results is List) {
        books.assignAll(results.map((e) {
          if (e is Map<String, dynamic>) {
            // Safe conversion to Book
            return Book.fromJson(e as Map<String, dynamic>);
          } else if (e is Book) {
            // Already a Book object
            return e;
          } else {
            throw Exception('Invalid data type: ${e.runtimeType}');
          }
        }).toList());
      } else {
        throw Exception(
            'Unexpected API response format: ${results.runtimeType}');
      }
    } on ApiException catch (e) {
      // Handle API-specific errors
      Get.snackbar('API Error', e.message);
    } catch (e) {
      // Handle general errors
      Get.snackbar('Error', 'Failed to load books: $e');
    } finally {
      isLoading(false);
    }
  }

  void searchBooks(String query) async {
    try {
      isLoading(true);
      startIndex = 0;

      // Fetch books using API
      final results = await apiService
          .fetchBooks('$query&startIndex=$startIndex&maxResults=$maxResults');

      // Debug API Response
      print('Search API Response: $results');

      // Check for null or empty data
      if (results == null || results.isEmpty) {
        Get.snackbar('No Results', 'No books found matching your query.');
        books.assignAll([]); // Clear previous results
        return;
      }

      // Process valid data
      if (results is List) {
        books.assignAll(results.map((e) {
          if (e is Map<String, dynamic>) {
            return Book.fromJson(
                e as Map<String, dynamic>); // Convert JSON to Book
          } else if (e is Book) {
            return e; // Already a Book
          } else {
            throw Exception('Unexpected data type: ${e.runtimeType}');
          }
        }).toList());
      } else {
        throw Exception(
            'Unexpected API response format: ${results.runtimeType}');
      }
    } on ApiException catch (e) {
      Get.snackbar('API Error', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Failed to search books: $e');
    } finally {
      isLoading(false);
    }
  }
}
