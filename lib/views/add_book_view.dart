import 'package:flutter/material.dart';
import 'package:supabase_proj/models/book_model.dart';

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

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      //* logica di salvataggio da inserire
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Libro salvato')));
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
