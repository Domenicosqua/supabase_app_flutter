class BookImage {
  final String id;
  final String book_id;
  final String image_url;

  BookImage({required this.id, required this.book_id, required this.image_url});

  factory BookImage.fromMap(Map<String, dynamic> map) {
    return BookImage(
      id: map['id'],
      book_id: map['book_id'],
      image_url: map['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'book_id': book_id, 'image_url': image_url};
  }
}
