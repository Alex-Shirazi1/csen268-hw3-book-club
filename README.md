# HW3 - Book Club (BLoC)

CSEN 268 Homework 3. A Flutter app that shows a list of books and uses a Cubit (flutter_bloc) for state management.

## Features

- Home page with a horizontal list of book covers
- Sort by Author or Title
- Tap a book to see its cover, title, author and description
- Back arrow (or the phone's back button) goes back to the list and keeps the sort you picked

## Project structure

- `lib/models/book.dart` - `Book` class (title, author, description, cover image)
- `lib/cubit/book_state.dart` - `BookState` with the list of books, the current sort and the selected book (uses Equatable)
- `lib/cubit/book_cubit.dart` - `BookCubit`. The list starts empty and `init()` loads the books. Also has `sortBooks()`, `showBook()` and `showBooks()`
- `lib/pages/home_page.dart` - `HomePage`, rebuilt with `BlocBuilder`
- `lib/widgets/book_image.dart` - reusable widget for a book cover
- `lib/widgets/book_details.dart` - reusable widget with the cover, title, author and description
- `assets/references/` - Figma screenshots, the covers are cropped from these

## Run

```sh
flutter pub get
flutter run
```

## Tests

```sh
flutter analyze
flutter test
flutter test integration_test/app_test.dart -d <device-id>
```

The integration test needs an emulator or phone connected.
