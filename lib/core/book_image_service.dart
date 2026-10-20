import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_proj/models/book_image.dart';

class BookImageService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<BookImage>> fetchImagesFromBook(String bookId) async {
    final response = await _client
        .from('book_images')
        .select()
        .eq('id', bookId);

    return (response as List).map((img) => BookImage.fromMap(img)).toList();
  }

  Future<void> createBookImage(BookImage image) async {
    await _client.from('book_images').insert(image.toMap());
  }

  Future<void> deleteBookImage(String imageId) async {
    await _client.from('book_images').delete().eq('id', imageId);
  }
}
