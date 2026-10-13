import 'package:flutter_test/flutter_test.dart';
import 'package:hw3_book_club/cubit/book_cubit.dart';
import 'package:hw3_book_club/cubit/book_state.dart';

void main() {
  late BookCubit cubit;
  setUp(() => cubit = BookCubit());
  tearDown(() => cubit.close());

  test('starts empty and init loads six books alphabetically by author', () {
    expect(cubit.state.books, isEmpty);
    cubit.init();
    expect(cubit.state.books.length, 6);
    expect(cubit.state.sort, BookSort.author);
    expect(cubit.state.books.map((b) => b.author), [
      'Angelina Aludo',
      'Anthony Burgess',
      'Isaac Nelson',
      'Meng Jin',
      'Roald Dahl',
      'Sarah Jean Horwitz',
    ]);
    cubit.init();
    expect(cubit.state.books.length, 6);
  });

  test('sort changes are emitted without mutating previous states', () async {
    cubit.init();
    final original = cubit.state;
    final emitted = <BookState>[];
    final subscription = cubit.stream.listen(emitted.add);
    cubit.sortBooks(BookSort.title);
    expect(cubit.state.books.map((b) => b.title), [
      'A Clockwork Orange',
      'Carmer and Grit',
      "Don't Look Back",
      'James and the Giant Peach',
      'Little Gods',
      'The Imperfections of Memory',
    ]);
    expect(original.books.first.author, 'Angelina Aludo');
    expect(() => original.books.clear(), throwsUnsupportedError);
    cubit.sortBooks(BookSort.author);
    await Future<void>.delayed(Duration.zero);
    expect(emitted.map((s) => s.sort), [BookSort.title, BookSort.author]);
    await subscription.cancel();
  });

  test('detail and back preserve the selected sort and book order', () {
    cubit.init();
    cubit.sortBooks(BookSort.title);
    final list = cubit.state.books;
    for (final book in list) {
      cubit.showBook(book);
      expect(cubit.state.selectedBook, book);
      cubit.showBooks();
      expect(cubit.state.selectedBook, isNull);
      expect(cubit.state.sort, BookSort.title);
      expect(cubit.state.books, list);
    }
  });
}
