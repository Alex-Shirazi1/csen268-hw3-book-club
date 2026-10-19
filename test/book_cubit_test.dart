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
    await cubit.sortBooks(BookSort.title);
    expect(cubit.state.status, BookStatus.loaded);
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
    await cubit.sortBooks(BookSort.author);
    await Future<void>.delayed(Duration.zero);
    expect(emitted.map((s) => s.status), [
      BookStatus.loading,
      BookStatus.loaded,
      BookStatus.loading,
      BookStatus.loaded,
    ]);
    expect(emitted.last.sort, BookSort.author);
    await subscription.cancel();
  });

  test('active sort still emits loading then loaded', () async {
    cubit.init();
    final original = cubit.state;
    final emitted = <BookState>[];
    final subscription = cubit.stream.listen(emitted.add);
    final sorting = cubit.sortBooks(BookSort.author);
    expect(cubit.state.status, BookStatus.loading);
    expect(cubit.state.books, original.books);
    await sorting;
    await Future<void>.delayed(Duration.zero);
    expect(emitted.map((s) => s.status), [
      BookStatus.loading,
      BookStatus.loaded,
    ]);
    expect(cubit.state, original);
    await subscription.cancel();
  });

  test('closing during loading safely completes the pending sort', () async {
    cubit.init();
    final sorting = cubit.sortBooks(BookSort.title);
    await cubit.close();
    await expectLater(sorting, completes);
  });

  test('detail and back preserve the selected sort and book order', () async {
    cubit.init();
    await cubit.sortBooks(BookSort.title);
    expect(cubit.state.status, BookStatus.loaded);
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
