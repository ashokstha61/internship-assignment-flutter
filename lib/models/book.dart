// class Book {
//   final String id;
//   final String title;
//   final List<String> authors;
//   final String? thumbnail;
//   final String? description;
//   final String? publishedDate;

//   Book({
//     required this.id,
//     required this.title,
//     required this.authors,
//     this.thumbnail,
//     this.description,
//     this.publishedDate,
//   });

//   factory Book.fromJson(Map<String, dynamic> json) {
//     final volumeInfo = json['volumeInfo'] as Map<String, dynamic>?;
//     final imageLinks = volumeInfo?['imageLinks'] as Map<String, dynamic>?;

//     return Book(
//       id: json['id'] as String,
//       title: volumeInfo?['title'] as String ,
//       authors: (volumeInfo?['authors'] as List<dynamic>?)?.cast<String>() ?? [],
//       thumbnail: imageLinks?['thumbnail'] as String?,
//       description: volumeInfo?['description'] as String?,
//       publishedDate: volumeInfo?['publishedDate'] as String?,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'authors': authors.join(', '),
//       'thumbnail': thumbnail,
//     };
//   }
// }



class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String? thumbnail;
  final String? description;
  final String? publishedDate;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    this.thumbnail,
    this.description,
    this.publishedDate,
  });

  /// Factory constructor to create a Book object from JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>? ?? {};
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>?;

    return Book(
      id: json['id'] as String? ?? 'Unknown ID', // Default fallback
      title: volumeInfo['title'] as String? ?? 'Untitled', // Default fallback
      authors: (volumeInfo['authors'] as List<dynamic>?)?.cast<String>() ?? ['Unknown Author'],
      thumbnail: imageLinks?['thumbnail'] as String?,
      description: volumeInfo['description'] as String? ?? 'No description available.',
      publishedDate: volumeInfo['publishedDate'] as String? ?? 'Unknown Date',
    );
  }

  /// Convert Book object into a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors.join('|'), // Safer separator than ', '
      'thumbnail': thumbnail,
    };
  }

  /// Factory constructor to create a Book object from a database map
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String,
      title: map['title'] as String,
      authors: (map['authors'] as String).split('|'), // Split back into a list
      thumbnail: map['thumbnail'] as String?,
      description: null, // DB schema doesn't include this field
      publishedDate: null, // DB schema doesn't include this field
    );
  }

  /// Create a copy of the Book object with updated values
  Book copyWith({
    String? id,
    String? title,
    List<String>? authors,
    String? thumbnail,
    String? description,
    String? publishedDate,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      publishedDate: publishedDate ?? this.publishedDate,
    );
  }
}
