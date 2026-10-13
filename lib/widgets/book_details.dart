import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/book.dart';
import 'book_image.dart';

class BookDetails extends StatelessWidget {
  const BookDetails({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ValueKey('detail-${book.id}'),
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookImage(book: book, width: math.min(200, constraints.maxWidth)),
              const SizedBox(height: 16),
              Text(
                book.title,
                style: const TextStyle(fontSize: 28, color: Color(0xFF808080)),
              ),
              const SizedBox(height: 16),
              Text(
                book.author,
                style: const TextStyle(fontSize: 23, color: Color(0xFF808080)),
              ),
              const SizedBox(height: 16),
              Text(
                book.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: Color(0xFF808080),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
