import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './book_edit.dart';
import '../scoped-models/main.dart';

class BookList extends StatefulWidget {

  final MainModel model;
  BookList(this.model);

  @override
  State<StatefulWidget> createState() {
    return _BookListState();
  }
}

class _BookListState extends State<BookList> {
  @override
  initState(){
    widget.model.fetchBooks();
    super.initState();
  }
  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectBook(model.allBooks[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return BookEdit();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.allBooks[index].title),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectBook(model.allBooks[index].id);
                  model.deleteBook();
                } else if (direction == DismissDirection.startToEnd) {
                  print('Swiped start to end');
                } else {
                  print('Other swiping');
                }
              },
              background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(model.allBooks[index].image),
                    ),
                    title: Text(model.allBooks[index].title),
                    subtitle:
                        Text('\$${model.allBooks[index].price.toString()}'),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.allBooks.length,
        );
      },
    );
  }
}
