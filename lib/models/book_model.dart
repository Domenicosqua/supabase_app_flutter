import 'package:supabase_proj/models/book_image.dart';

enum BookStatus {
  nonLetto,
  inLettura,
  daLeggere,
  lasciato,
  nonInteressa;

  //* metodo per convertire un enum in stringa compatibile con supabase
  String toDbValue() {
    switch (this) {
      case BookStatus.nonLetto:
        return 'non_letto';
      case BookStatus.inLettura:
        return 'in_lettura';
      case BookStatus.daLeggere:
        return 'da_leggere';
      case BookStatus.lasciato:
        return 'lasciato';
      case BookStatus.nonInteressa:
        return 'non_interessa';
    }
  }

  //* metodo per convertire dal db all'app
  static BookStatus fromDbValue(String value) {
    switch (value) {
      case 'non_letto':
        return BookStatus.nonLetto;
      case 'in_lettura':
        return BookStatus.inLettura;
      case 'da_leggere':
        return BookStatus.daLeggere;
      case 'lasciato':
        return BookStatus.lasciato;
      case 'non_interessa':
        return BookStatus.nonInteressa;
      default:
        return BookStatus.nonLetto;
    }
  }
}

class Book {
  final String id;
  final String user_id;
  final String title;
  final String genre;
  final String author;
  final int pages;
  final int rating;
  final String comment;
  final BookStatus status;
  final DateTime created_at;

  //* lista di immagine per libro opzionale
  final List<BookImage>? images;

  Book({
    required this.id,
    required this.user_id,
    required this.title,
    required this.genre,
    required this.author,
    required this.pages,
    required this.rating,
    required this.comment,
    required this.status,
    required this.created_at,
    this.images,
  });

  factory Book.fromMap(Map<String, dynamic> map, {List<BookImage>? images}) {
    return Book(
      id: map['id'],
      user_id: map['user_id'],
      title: map['title'],
      genre: map['genre'],
      author: map['author'],
      pages: map['pages'],
      rating: map['rating'],
      comment: map['comment'],
      status: BookStatus.fromDbValue(map['status']),
      created_at: DateTime.parse(map['created_at']),
      images: images ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'title': title,
      'genre': genre,
      'author': author,
      'pages': pages,
      'rating': rating,
      'comment': comment,
      'status': status.toDbValue(),
      'created_at': created_at.toIso8601String(),
    };
  }
}
