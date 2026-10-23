import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_proj/core/book_image_service.dart';
import 'package:supabase_proj/core/storage_service.dart';
import 'package:supabase_proj/models/book_image.dart';
import 'package:supabase_proj/models/book_model.dart';
import 'package:supabase_proj/viewmodel/book_view_model.dart';
import 'package:uuid/uuid.dart';

String _statusLabel(BookStatus status) {
  switch (status) {
    case BookStatus.nonLetto:
      return 'non letto';
    case BookStatus.inLettura:
      return 'in lettura';
    case BookStatus.daLeggere:
      return 'da leggere';
    case BookStatus.lasciato:
      return 'lasciato';
    case BookStatus.nonInteressa:
      return 'non interessa';
  }
}

class AddBookView extends StatefulWidget {
  const AddBookView({super.key});

  @override
  State<AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _genreController = TextEditingController();
  final _pagesController = TextEditingController();
  BookStatus? _selectedStatus;
  double _rating = 3.0;
  final _commentController = TextEditingController();
  List<File> _selectedImages = [];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedStatus != null) {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('utente non autenticato')));
        return;
      }
      final newBook = Book(
        id: const Uuid().v4(), // genera un nuovo UUID
        user_id: userId,
        title: _titleController.text.trim(),
        genre: _genreController.text.trim(),
        author: _authorController.text.trim(),
        pages: int.tryParse(_pagesController.text.trim()) ?? 0,
        rating: _rating.toInt(),
        comment: _commentController.text.trim(),
        status: _selectedStatus!,
        created_at: DateTime.now(),
      );

      try {
        await Provider.of<BookViewModel>(
          context,
          listen: false,
        ).addBook(newBook);
        if (_selectedImages.isNotEmpty) {
          final storageService = StorageService();
          final imageService = BookImageService();
          for (final imageFile in _selectedImages) {
            final imageUrl = await storageService.uploadImage(
              imageFile,
              newBook.id,
            );
            final bookImage = BookImage(
              id: const Uuid().v4(),
              bookId: newBook.id,
              imageUrl: imageUrl,
            );
            await imageService.createBookImage(bookImage);
          }
        }
        if (mounted) {
          final messenger = ScaffoldMessenger.of(context);
          Navigator.pop(context);
          messenger.showSnackBar(
            const SnackBar(content: Text('Libro salvato')),
          );
        }
      } catch (e) {
        print('Errore: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Errore nel salvataggio: $e')));
        }
      }
    }
  }

  // metodo caricamento immagini
  Future<void> _pickMultipleImages() async {
    final List<PlatformFile> result = await FilePicker.pickFiles(
      type: FileType.image,
    );
    if (result.isNotEmpty) {
      setState(() {
        _selectedImages = result
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form inserimento libro'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // titolo
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titolo:',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Campo obbligatorio'
                    : null,
              ),
              const SizedBox(height: 8),
              // autore
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Autore:',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Campo obbligatorio'
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _genreController,
                decoration: InputDecoration(
                  labelText: 'Genere:',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _pagesController,
                decoration: InputDecoration(
                  labelText: 'Numero di Pagine',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final pages = int.tryParse(value);
                  if (pages == null || pages <= 0)
                    return 'inserisci numero valido';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                initialValue: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Stato di lettura',
                  border: OutlineInputBorder(),
                ),
                items: BookStatus.values.map((status) {
                  return DropdownMenuItem(
                    child: Text(_statusLabel(status)),
                    value: status,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleziona uno stato' : null,
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valutazione',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          min: 1,
                          max: 5,
                          divisions: 4,
                          value: _rating,
                          onChanged: (value) {
                            setState(() {
                              _rating = value;
                            });
                          },
                        ),
                      ),
                      Text('${_rating.toStringAsFixed(0)} stelle'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Commento:',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickMultipleImages,
                label: Text('Scegli immagini'),
                icon: Icon(Icons.photo_library),
              ),
              if (_selectedImages.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedImages.map((img) {
                    return Image.file(
                      img,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: Icon(Icons.arrow_forward),
                label: Text('Salva'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
