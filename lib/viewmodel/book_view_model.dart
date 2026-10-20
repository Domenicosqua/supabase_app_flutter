import 'package:flutter/material.dart';
import 'package:supabase_proj/core/book_service.dart';
import 'package:supabase_proj/models/book_model.dart';

class BookViewModel extends ChangeNotifier {
  final BookService _bookService = BookService(); // instanza del bookservice

  List<Book> _books = [];
  bool isLoading = false;

  List<Book> get books => _books; //getter publico

  Future<void> loadBooks() async {
    isLoading = true;
    notifyListeners();

    try {
      _books = await _bookService.fetchBookForCurrentUser();
    } catch (e) {
      print('Errore caricamento: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    try {
      await _bookService.createBook(book);
      _books.insert(0, book);
      notifyListeners();
    } catch (e) {
      print('errore: $e');
    }
  }

  Future<void> updateBook(Book updatedBook) async {
    try {
      await _bookService.updateBook(updatedBook);
      // in questo blocco cerchiamo l'indice del libro da aggiornare
      final index = _books.indexWhere((b) => b.id == updatedBook.id);
      if (index != -1) {
        _books[index] = updatedBook;
        notifyListeners();
      }
    } catch (e) {
      print('errore: $e');
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await _bookService.deleteBook(bookId);
      // con questo cerco invece nel mio array dove sta il libro e lo rimuovo
      _books.removeWhere((b) => b.id == bookId);
      notifyListeners();
    } catch (e) {
      print('Errore: $e');
    }
  }
}
