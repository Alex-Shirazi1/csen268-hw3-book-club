import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hw3_book_club/main.dart';
import 'package:hw3_book_club/widgets/book_image.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Android: sort, open every book, and return to the list', (
    tester,
  ) async {
    await tester.pumpWidget(const BookClubApp());
    await tester.pumpAndSettle();
    expect(
      tester.widget<BookImage>(find.byType(BookImage).first).book.author,
      'Angelina Aludo',
    );

    for (final sort in ['Title', 'Author']) {
      await tester.tap(find.text(sort));
      await tester.pumpAndSettle();
      final ids = sort == 'Title'
          ? ['clockwork', 'carmer', 'back', 'james', 'little', 'memory']
          : ['memory', 'clockwork', 'back', 'little', 'james', 'carmer'];
      expect(
        tester.widget<BookImage>(find.byType(BookImage).first).book.id,
        ids.first,
      );
      for (final id in ids) {
        final card = find.byKey(ValueKey('book-$id'));
        await tester.scrollUntilVisible(
          card,
          100,
          scrollable: find.descendant(
            of: find.byType(ListView),
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
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -500),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Back to books'));
        await tester.pumpAndSettle();
        expect(find.text('Book Club Home'), findsOneWidget);
        expect(
          tester.widget<BookImage>(find.byType(BookImage).first).book.id,
          ids.first,
        );
        expect(tester.takeException(), isNull);
      }
    }
  });
}
