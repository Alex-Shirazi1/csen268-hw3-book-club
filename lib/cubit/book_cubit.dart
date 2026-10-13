import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/book.dart';
import 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  BookCubit() : super(BookState());

  // list starts empty, init() fills it
  void init() {
    if (state.books.isNotEmpty) return;
    const books = [
      Book(
        id: 'carmer',
        title: 'Carmer and Grit',
        author: 'Sarah Jean Horwitz',
        description: "A young magician's apprentice and a one-winged fairy form an unlikely partnership. Together they investigate a mystery involving disappearing fairies, mechanical inventions, and a city where magic and science collide.",
        imageAsset: 'assets/references/author.png',
        imageWidth: 1092,
        coverX: 205,
        coverY: 410,
        coverWidth: 173,
        coverHeight: 287,
      ),
      Book(
        id: 'memory',
        title: 'The Imperfections of Memory',
        author: 'Angelina Aludo',
        description: 'In purgatory, he has to piece together his jumbled memories. Each fragment raises another question about the life he remembers and the truths he has forgotten.',
        imageAsset: 'assets/references/author.png',
        imageWidth: 1092,
        coverX: 395,
        coverY: 410,
        coverWidth: 172,
        coverHeight: 287,
      ),
      Book(
        id: 'james',
        title: 'James and the Giant Peach',
        author: 'Roald Dahl',
        description: 'James discovers an enormous peach and a remarkable group of insect friends. Their extraordinary journey carries them across the ocean in a story of courage, friendship, and finding a place to belong.',
        imageAsset: 'assets/references/author.png',
        imageWidth: 1092,
        coverX: 584,
        coverY: 410,
        coverWidth: 172,
        coverHeight: 287,
      ),
      Book(
        id: 'little',
        title: 'Little Gods',
        author: 'Meng Jin',
        description: 'A daughter searches for the story of her mother, a brilliant physicist whose past remains elusive. Memory, family, and the passage of time shape this exploration of identity and belonging.',
        imageAsset: 'assets/references/title.png',
        imageWidth: 962,
        coverX: 339,
        coverY: 471,
        coverWidth: 173,
        coverHeight: 285,
      ),
      Book(
        id: 'clockwork',
        title: 'A Clockwork Orange',
        author: 'Anthony Burgess',
        description: "In a dystopian future, a young offender undergoes a controversial experiment intended to change his behavior. The story examines free will, morality, and the consequences of removing a person's ability to choose.",
        imageAsset: 'assets/references/title.png',
        imageWidth: 962,
        coverX: 529,
        coverY: 471,
        coverWidth: 172,
        coverHeight: 285,
      ),
      Book(
        id: 'back',
        title: "Don't Look Back",
        author: 'Isaac Nelson',
        description: 'Lorem ipsum dolor sit amet consectetur. Id tincidunt tristique vitae at pharetra. Commodo volutpat lacus adipiscing at elit semper eget turpis ut. Gravida faucibus faucibus ornare consectetur enim cursus tellus. Est varius vel egestas velit orci. Neque nam ultricies augue nunc vel pulvinar sed massa. Pellentesque netus pellentesque egestas aliquam maecenas amet libero integer. Ut eleifend platea massa diam ut. Egestas odio massa aliquet pellentesque quis laoreet sed. Sodales rhoncus nisi sit vel non leo ultricies ut facilisi. Adipiscing augue id volutpat rhoncus in nec enim. In dictum egestas at dui. Quam quis consectetur nec id accumsan et fusce. Diam amet morbi lorem massa risus libero ac.',
        imageAsset: 'assets/references/detail.png',
        imageWidth: 1054,
        coverX: 150,
        coverY: 295,
        coverWidth: 345,
        coverHeight: 575,
      ),
    ];
    emit(BookState(books: _sorted(books, BookSort.author)));
  }

  void sortBooks(BookSort sort) {
    emit(BookState(books: _sorted(state.books, sort), sort: sort));
  }

  void showBook(Book book) {
    if (!state.books.contains(book)) return;
    emit(BookState(books: state.books, sort: state.sort, selectedBook: book));
  }

  void showBooks() {
    emit(BookState(books: state.books, sort: state.sort));
  }

  List<Book> _sorted(List<Book> books, BookSort sort) {
    // sort a copy so the old state's list isn't changed
    return List<Book>.of(books)..sort((a, b) {
      final first = sort == BookSort.author ? a.author : a.title;
      final second = sort == BookSort.author ? b.author : b.title;
      final result = first.toLowerCase().compareTo(second.toLowerCase());
      return result != 0 ? result : a.title.compareTo(b.title);
    });
  }
}
