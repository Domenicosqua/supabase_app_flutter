import 'package:flutter/material.dart';
import 'package:supabase_proj/models/book_model.dart';

class BookDetailView extends StatelessWidget {
  final Book book;
  const BookDetailView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final images = book.images ?? [];
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (images.isNotEmpty)
              SizedBox(
                height: 200,
                child: CarouselView(
                  itemExtent: 300,
                  itemSnapping: true,
                  elevation: 2,
                  scrollDirection: Axis.horizontal,
                  children: images.map((img) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(img.imageUrl, fit: BoxFit.cover),
                    );
                  }).toList(),
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.lightGreen,
                child: const Center(child: Icon(Icons.photo, size: 40)),
              ),

            Text(book.title, style: Theme.of(context).textTheme.headlineMedium),
            Text('dell\'autore: ${book.author}'),
            Text(book.genre),
            Text('Pagine: ${book.pages}'),
            Text('Stato lettura: ${book.status}'),
            Text('Valutazione: ${book.rating}/5'),
            if (book.comment.isNotEmpty)
              Text(
                'Commento: \n ${book.comment}',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }
}
