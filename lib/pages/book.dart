import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/ui_elements/title_default.dart';
import '../models/book.dart';
import '../scoped-models/main.dart';

class BookView extends StatelessWidget {
  final int bookIndex;

  BookView(this.bookIndex);

  Widget _buildAddressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Union Square, San Francisco',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$' + price.toString(),
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      print('Back button pressed!');
      Navigator.pop(context, false);
      return Future.value(false);
    }, child: ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Book book = model.allBooks[bookIndex];
        return Scaffold(
          appBar: AppBar(
            title: Text(book.title),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(book.image),
              Container(
                padding: EdgeInsets.all(10.0),
                child: TitleDefault(book.title),
              ),
              _buildAddressPriceRow(book.price),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  book.description,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
      },
    ));
  }
}
