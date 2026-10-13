import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/book_cubit.dart';
import 'pages/home_page.dart';

void main() => runApp(const BookClubApp());

class BookClubApp extends StatelessWidget {
  const BookClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Club',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF675078)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF7FF),
          foregroundColor: Color(0xFF242124),
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          toolbarHeight: 64,
          titleTextStyle: TextStyle(fontSize: 22, color: Color(0xFF242124)),
        ),
      ),
      home: BlocProvider(
        create: (_) => BookCubit()..init(),
        child: const HomePage(),
      ),
    );
  }
}
