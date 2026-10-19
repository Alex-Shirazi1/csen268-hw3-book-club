import 'package:equatable/equatable.dart';

import '../models/book.dart';

enum BookSort { author, title }

enum BookStatus { loading, loaded }

class BookState extends Equatable {
  BookState({
    List<Book> books = const [],
    this.sort = BookSort.author,
    this.selectedBook,
    this.status = BookStatus.loaded,
  }) : books = List.unmodifiable(books);

  final List<Book> books;
  final BookSort sort;
  final Book? selectedBook;
  final BookStatus status;

  // Include status so sorting again still emits loading then loaded.
  @override
  List<Object?> get props => [books, sort, selectedBook, status];
}
