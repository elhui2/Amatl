import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String description;
  final String author;
  final double price;
  final String image;
  final bool isFavorite;
  final String userEmail;
  final String userId;

  Book(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.author,
      @required this.price,
      @required this.image,
      @required this.userEmail,
      @required this.userId,
      this.isFavorite = false});
}
