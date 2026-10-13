import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/book_cubit.dart';
import '../cubit/book_state.dart';
import '../widgets/book_details.dart';
import '../widgets/book_image.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookCubit, BookState>(
      builder: (context, state) {
        final book = state.selectedBook;
        final cubit = context.read<BookCubit>();
        return PopScope(
          canPop: book == null,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && book != null) cubit.showBooks();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(book == null ? 'Book Club Home' : 'Book Detail'),
              leading: book == null
                  ? const Icon(Icons.menu, semanticLabel: 'Book Club')
                  : IconButton(
                      tooltip: 'Back to books',
                      icon: const Icon(Icons.arrow_back),
                      onPressed: cubit.showBooks,
                    ),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.account_circle_outlined,
                    semanticLabel: 'Profile',
                    size: 24,
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: book != null
                  ? BookDetails(book: book)
                  : _BookList(state: state),
            ),
          ),
        );
      },
    );
  }
}

class _BookList extends StatelessWidget {
  const _BookList({required this.state});
  final BookState state;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 8,
              children: [
                const Text(
                  'Sort by',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                for (final sort in BookSort.values)
                  _SortButton(sort: sort, selected: state.sort == sort),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              'Books',
              style: TextStyle(fontSize: 28, color: Color(0xFF242124)),
            ),
          ),
          SizedBox(
            height: 168,
            child: ListView.separated(
              key: ValueKey('books-${state.sort.name}'),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: state.books.length,
              separatorBuilder: (_, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final book = state.books[index];
                return Semantics(
                  button: true,
                  child: InkWell(
                    key: ValueKey('book-${book.id}'),
                    onTap: () => context.read<BookCubit>().showBook(book),
                    child: BookImage(book: book),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.sort, required this.selected});
  final BookSort sort;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      child: OutlinedButton(
        onPressed: () => context.read<BookCubit>().sortBooks(sort),
        style: OutlinedButton.styleFrom(
          backgroundColor: selected ? const Color(0xFFE8E2EB) : Colors.white,
          foregroundColor: const Color(0xFF514C57),
          side: const BorderSide(color: Color(0xFFCEC6D4)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(60, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        child: Text(sort == BookSort.author ? 'Author' : 'Title'),
      ),
    );
  }
}
