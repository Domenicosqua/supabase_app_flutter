import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_proj/models/book_image.dart';
import 'package:supabase_proj/models/book_model.dart';

class BookService {
  final SupabaseClient _client =
      Supabase.instance.client; // accesso all'instanza globale

  Future<List<Book>> fetchBookForCurrentUser() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return [];
    }

    final response = await _client
        .from('books')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((book) => Book.fromMap(book)).toList();
  }

  Future<void> createBook(Book book) async {
    final response = await _client.from('books').insert(book.toMap()).select();
    print('inserimento del libro $response');
  }

  Future<void> updateBook(Book book) async {
    await _client.from('books').update(book.toMap()).eq('id', book.id);
  }

  Future<void> deleteBook(String bookId) async {
    await _client.from('books').delete().eq('id', bookId);
  }

  Future<List<Book>> fetchBook() async {
    final response = await _client
        .from('books')
        // stiamo dicendo a supabase di prendere tutti i libri e per ognuno prendere roba anche dalle immagini
        .select('*, book_images (id, book_id, image_url)')
        .order('created_at', ascending: false);

    // risposta da supa sarà un lista di mappe
    final data = response as List;
    return data.map((map) {
      // processo di mappatura annidato, estraiamo la lista di immagini dal campo book image dalla mappa del libro e usiamo as list con punto interrogativo perché indica un operatore di accesso condizionale in quanto potrebbero esserci libri senza immagini associate e restituire null.
      final images = (map['book_images'] as List<dynamic>?)
          // se ci sono immagini iteriamo su ogni mappa di immagini e la convertiamo in un oggetto dart
          ?.map((img) => BookImage.fromMap(img))
          .toList();
      // creazione dell'oggetto book
      return Book.fromMap(map, images: images);
    }).toList();
  }
}
