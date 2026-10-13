import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hw3_book_club/cubit/book_cubit.dart';
import 'package:hw3_book_club/main.dart';
import 'package:hw3_book_club/widgets/book_image.dart';

// checks that nothing outside the cover (rest of the screenshot) is visible
void expectOnlyCoverVisible(WidgetTester tester, Finder bookImage) {
  final book = tester.widget<BookImage>(bookImage).book;
  final box = tester.getRect(bookImage);
  final image = tester.getRect(
    find.descendant(of: bookImage, matching: find.byType(Image)),
  );
  final scale = image.width / book.imageWidth;
  final cover = Rect.fromLTWH(
    image.left + book.coverX * scale,
    image.top + book.coverY * scale,
    book.coverWidth * scale,
    book.coverHeight * scale,
  );
  const epsilon = 0.01;
  expect(cover.left, lessThanOrEqualTo(box.left + epsilon), reason: book.id);
  expect(cover.top, lessThanOrEqualTo(box.top + epsilon), reason: book.id);
  expect(
    cover.right,
    greaterThanOrEqualTo(box.right - epsilon),
    reason: book.id,
  );
  expect(
    cover.bottom,
    greaterThanOrEqualTo(box.bottom - epsilon),
    reason: book.id,
  );
}

void main() {
  final books = (BookCubit()..init()).state.books;

  for (final constraints in [
    const BoxConstraints(), // natural size, as on the detail page
    BoxConstraints.tight(const Size(100, 168)), // horizontal shelf item
    BoxConstraints.tight(const Size(120, 120)), // arbitrary forced size
  ]) {
    testWidgets('only cover artwork is visible under $constraints', (
      tester,
    ) async {
      for (final book in books) {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: constraints,
                child: BookImage(book: book),
              ),
            ),
          ),
        );
        expectOnlyCoverVisible(tester, find.byType(BookImage));
      }
    });
  }

  testWidgets('home shelf shows only cover artwork for every book', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const BookClubApp());
    await tester.pumpAndSettle();
    for (final book in books) {
      final card = find.byKey(ValueKey('book-${book.id}'));
      await tester.scrollUntilVisible(
        card,
        100,
        scrollable: find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.pumpAndSettle();
      expectOnlyCoverVisible(
        tester,
        find.descendant(of: card, matching: find.byType(BookImage)),
      );
    }
  });
}
