import 'package:equatable/equatable.dart';

import '../models/book.dart';

enum BookSort { author, title }

class BookState extends Equatable {
  BookState({
    List<Book> books = const [],
    this.sort = BookSort.author,
    this.selectedBook,
  }) : books = List.unmodifiable(books);

  final List<Book> books;
  final BookSort sort;
  final Book? selectedBook;

  // everything is in props so a new sort or selected book rebuilds the page
  @override
  List<Object?> get props => [books, sort, selectedBook];
}
