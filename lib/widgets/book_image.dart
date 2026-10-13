import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/book.dart';

// shows just the book cover, cropped out of the reference screenshot
class BookImage extends StatelessWidget {
  const BookImage({super.key, required this.book, this.width = 100});

  final Book book;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: '${book.title} by ${book.author}',
      child: SizedBox(
        width: width,
        height: book.coverHeight * width / book.coverWidth,
        // the ListView can make this box taller than the cover, so scale
        // to whatever size we actually get and keep only the cover visible
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            final scale = math.max(
              size.width / book.coverWidth,
              size.height / book.coverHeight,
            );
            return ClipRect(
              child: Stack(
                children: [
                  Positioned(
                    left:
                        (size.width - book.coverWidth * scale) / 2 -
                        book.coverX * scale,
                    top:
                        (size.height - book.coverHeight * scale) / 2 -
                        book.coverY * scale,
                    width: book.imageWidth * scale,
                    child: Image.asset(
                      book.imageAsset,
                      excludeFromSemantics: true,
                      fit: BoxFit.fitWidth,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
