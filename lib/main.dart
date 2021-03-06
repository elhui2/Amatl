import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/books_admin.dart';
import './pages/books.dart';
import './pages/book.dart';
import './models/book.dart';
import './scoped-models/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.blueGrey,
            buttonColor: Colors.blueGrey),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/books': (BuildContext context) => BooksPage(model),
          '/admin': (BuildContext context) => BooksAdmin(model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String bookId = pathElements[2];
            final Book book = model.allBooks.firstWhere((Book book) {
              return book.id == bookId;
            });
            model.selectBook(bookId);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => BookView(book),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => BooksPage(model));
        },
      ),
    );
  }
}
