import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/books/books.dart';
import '../scoped-models/main.dart';

class BooksPage extends StatefulWidget {
  final MainModel model;

  BooksPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _BooksPageState();
  }
}

class _BooksPageState extends State<BooksPage> {
  @override
  initState() {
    widget.model.fetchBooks();
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Seleccionar'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Administrar Libros'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('Todas las librerias'),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            },
          )
        ],
      ),
      body: _buildBookList(),
    );
  }

  Widget _buildBookList() {
    return ScopedModelDescendant(
      builder: (BuildContext contest, Widget child, MainModel model) {
        print(model.isLoading);
        Widget content =
            Center(child: Text("¡No has agregado libros todavía!"));
        if (model.displayedBooks.length >= 0 && !model.isLoading) {
          content = Books();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchBooks, child: content);
      },
    );
  }
}
