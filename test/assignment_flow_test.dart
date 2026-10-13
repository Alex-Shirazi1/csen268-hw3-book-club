import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hw3_book_club/main.dart';
import 'package:hw3_book_club/widgets/book_details.dart';
import 'package:hw3_book_club/widgets/book_image.dart';

void main() {
  const authorOrder = [
    'memory',
    'clockwork',
    'back',
    'little',
    'james',
    'carmer',
  ];
  const titleOrder = [
    'clockwork',
    'carmer',
    'back',
    'james',
    'little',
    'memory',
  ];

  for (final size in [
    const Size(393, 852),
    const Size(320, 568),
    const Size(852, 393),
  ]) {
    testWidgets('every book, both sorts, and back at $size', (tester) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const BookClubApp());
      await tester.pumpAndSettle();

      for (final sort in ['Author', 'Title', 'Author', 'Title']) {
        await tester.tap(find.text(sort));
        await tester.pumpAndSettle();
        // tap the same sort twice to make sure nothing breaks
        await tester.tap(find.text(sort));
        await tester.pumpAndSettle();
        final order = sort == 'Author' ? authorOrder : titleOrder;
        expect(
          tester.widget<BookImage>(find.byType(BookImage).first).book.id,
          order.first,
        );

        for (final id in order) {
          final shelf = find.byType(ListView);
          final card = find.byKey(ValueKey('book-$id'));
          await tester.scrollUntilVisible(
            card,
            100,
            scrollable: find.descendant(
              of: shelf,
              matching: find.byType(Scrollable),
            ),
          );
          await tester.pumpAndSettle();
          final book = tester
              .widget<BookImage>(
                find.descendant(of: card, matching: find.byType(BookImage)),
              )
              .book;
          await tester.tap(card);
          await tester.pumpAndSettle();
          expect(find.text('Book Detail'), findsOneWidget);
          expect(find.text(book.title), findsOneWidget);
          expect(find.text(book.author), findsOneWidget);
          expect(find.text(book.description), findsOneWidget);
          expect(
            tester.widget<BookDetails>(find.byType(BookDetails)).book,
            book,
          );
          await tester.drag(
            find.byType(SingleChildScrollView),
            const Offset(0, -600),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          if (order.indexOf(id).isEven) {
            await tester.tap(find.byTooltip('Back to books'));
          } else {
            await tester.binding.handlePopRoute();
          }
          await tester.pumpAndSettle();
          expect(find.text('Book Club Home'), findsOneWidget);
          expect(
            tester.widget<BookImage>(find.byType(BookImage).first).book.id,
            order.first,
          );
          expect(tester.takeException(), isNull);
        }
      }
    });
  }

  testWidgets('large text remains scrollable on a narrow screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(() async {
      tester.platformDispatcher.clearTextScaleFactorTestValue();
      await tester.binding.setSurfaceSize(null);
    });
    await tester.pumpWidget(const BookClubApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('book-back')));
    await tester.pumpAndSettle();
    final description = tester
        .widget<BookDetails>(find.byType(BookDetails))
        .book
        .description;
    await tester.ensureVisible(find.text(description));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Back to books'));
    await tester.pumpAndSettle();
    expect(find.text('Book Club Home'), findsOneWidget);
  });
}
