import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_controller.dart';
import '../models/favorite_book.dart';

// class FavoriteScreen extends StatelessWidget {
//   final BookController bookController = Get.find<BookController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Favorites')),
//       body: Obx(() {
//         if (bookController.favorites.isEmpty) {
//           return Center(child: Text('No favorites added yet!'));
//         }

//         return ListView.builder(
//           itemCount: bookController.favorites.length,
//           itemBuilder: (context, index) {
//             final FavoriteBook book = bookController.favorites[index];

//             return ListTile(
//               title: Text(book.title),
//               subtitle: Text(book.authors),
//               leading: book.thumbnail.isNotEmpty
//                   ? Image.network(book.thumbnail, height: 50, width: 50, fit: BoxFit.cover)
//                   : Icon(Icons.book),
//               trailing: IconButton(
//                 onPressed: () {
//                   Get.dialog(
//                     AlertDialog(
//                       title: Text('Confirm Delete'),
//                       content: Text('Are you sure you want to remove this book from favorites?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Get.back(),
//                           child: Text('Cancel'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             bookController.removeFromFavorites(book.id);
//                             Get.back();
//                           },
//                           child: Text('Delete'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 icon: Icon(Icons.delete, color: Colors.red),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }

class FavoriteScreen extends StatelessWidget {
  final BookController bookController = Get.find<BookController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: Obx(() {
        if (bookController.favorites.isEmpty) {
          return Center(child: Text('No favorites added yet!'));
        }

        return ListView.builder(
          itemCount: bookController.favorites.length,
          itemBuilder: (context, index) {
            final FavoriteBook book = bookController.favorites[index];

            return ListTile(
              title: Text(book.title),
              subtitle: Text(book.authors),
              leading: book.thumbnail != null && book.thumbnail!.isNotEmpty
                  ? Image.network(book.thumbnail!, height: 50, width: 50, fit: BoxFit.cover)
                  : Icon(Icons.book, size: 50), // Handle null or empty thumbnail
              trailing: IconButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text('Confirm Delete'),
                      content: Text('Are you sure you want to remove this book from favorites?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            bookController.removeFromFavorites(book.id);
                            Get.back();
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            );
          },
        );
      }),
    );
  }
}