import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import './address_tag.dart';
import '../ui_elements/title_default.dart';
import '../../models/book.dart';
import '../../scoped-models/main.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final int productIndex;

  BookCard(this.book, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(book.title),
          SizedBox(
            width: 8.0,
          ),
          PriceTag(book.price.toString())
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.pushNamed<bool>(
              context, '/product/' + productIndex.toString()),
        ),
        ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return IconButton(
              icon: Icon(model.allBooks[productIndex].isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                model.selectBook(productIndex);
                model.toggleProductFavoriteStatus();
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.network(book.image),
          _buildTitlePriceRow(),
          AddressTag(book.author),
          Text(book.userEmail),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
