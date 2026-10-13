import 'package:equatable/equatable.dart';

// coverX/coverY/coverWidth/coverHeight = where the cover is in the screenshot
class Book extends Equatable {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageAsset,
    required this.imageWidth,
    required this.coverX,
    required this.coverY,
    required this.coverWidth,
    required this.coverHeight,
  });

  final String id;
  final String title;
  final String author;
  final String description;
  final String imageAsset;
  final double imageWidth;
  final double coverX;
  final double coverY;
  final double coverWidth;
  final double coverHeight;

  @override
  List<Object> get props => [
    id,
    title,
    author,
    description,
    imageAsset,
    imageWidth,
    coverX,
    coverY,
    coverWidth,
    coverHeight,
  ];
}
