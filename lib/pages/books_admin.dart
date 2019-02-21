import 'package:flutter/material.dart';

import './book_edit.dart';
import './book_list.dart';
import '../scoped-models/main.dart';

class BooksAdmin extends StatelessWidget {
  final MainModel model;

  BooksAdmin(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Administrar Libros'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Crear Libro',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'Mi Libreria',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[BookEdit(), BookList(model)],
        ),
      ),
    );
  }
}
