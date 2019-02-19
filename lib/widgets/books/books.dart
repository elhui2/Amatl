import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './book_card.dart';
import '../../models/book.dart';
import '../../scoped-models/main.dart';

class Books extends StatelessWidget {
  Widget _buildProductList(List<Book> book) {
    Widget productCards;
    if (book.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            BookCard(book[index], index),
        itemCount: book.length,
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return  _buildProductList(model.displayedBooks);
    },);
  }
}
