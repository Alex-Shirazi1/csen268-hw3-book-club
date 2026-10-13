import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hw3_book_club/main.dart';
import 'package:hw3_book_club/widgets/book_details.dart';
import 'package:hw3_book_club/widgets/book_image.dart';

void main() {
  testWidgets('sort, select book, and AppBar back complete the required flow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const BookClubApp());
    await tester.pumpAndSettle();
    expect(find.text('Book Club Home'), findsOneWidget);
    expect(
      tester.widget<BookImage>(find.byType(BookImage).first).book.author,
      'Angelina Aludo',
    );
    await tester.tap(find.text('Title'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<BookImage>(find.byType(BookImage).first).book.title,
      'A Clockwork Orange',
    );
    await tester.tap(find.byKey(const ValueKey('book-clockwork')));
    await tester.pumpAndSettle();
    expect(find.text('Book Detail'), findsOneWidget);
    expect(find.text('Anthony Burgess'), findsOneWidget);
    expect(find.byType(BookDetails), findsOneWidget);
    await tester.tap(find.byTooltip('Back to books'));
    await tester.pumpAndSettle();
    expect(find.text('Book Club Home'), findsOneWidget);
    expect(
      tester.widget<BookImage>(find.byType(BookImage).first).book.title,
      'A Clockwork Orange',
    );
    await tester.tap(find.text('Author'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<BookImage>(find.byType(BookImage).first).book.author,
      'Angelina Aludo',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'system back returns from details and narrow screens do not overflow',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const BookClubApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('book-memory')));
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Book Club Home'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
