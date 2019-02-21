import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
// import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/books_admin.dart';
import './pages/books.dart';
import './pages/book.dart';
import './scoped-models/main.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
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
        // debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.blueGrey,
            buttonColor: Colors.blueGrey),
        // home: AuthPage(),
        routes: {
          // '/': (BuildContext context) => AuthPage(),
          // '/products': (BuildContext context) => ProductsPage(),
          // '/admin': (BuildContext context) => ProductsAdminPage(),
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
            final int index = int.parse(pathElements[2]);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => BookView(index),
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
