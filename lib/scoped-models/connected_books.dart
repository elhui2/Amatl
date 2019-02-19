import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/user.dart';

class ConnectedBooksModel extends Model {
  List<Book> _books = [];
  int _selBookIndex;
  User _authenticatedUser;

  void addBook(String title, String description, String author, String image,
      double price) {
    final Map<String, dynamic> bookData = {
      'title': title,
      'description': description,
      'author': author,
      'image':
          'https://a.1stdibscdn.com/archivesE/upload/8141/932/XXX_8141_1349205668_1.jpg',
      'price': price
    };
    http
        .post('https://amatl-72008.firebaseio.com/books.json',
            body: json.encode(bookData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Book newProduct = Book(
          id: responseData['name'],
          title: title,
          description: description,
          author: author,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _books.add(newProduct);
      notifyListeners();
    });
  }
}

mixin BooksModel on ConnectedBooksModel {
  bool _showFavorites = false;

  List<Book> get allBooks {
    return List.from(_books);
  }

  List<Book> get displayedBooks {
    if (_showFavorites) {
      return _books.where((Book book) => book.isFavorite).toList();
    }
    return List.from(_books);
  }

  int get selectedBookIndex {
    return _selBookIndex;
  }

  Book get selectedBook {
    if (selectedBookIndex == null) {
      return null;
    }
    return _books[selectedBookIndex];
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void updateBook(String title, String description, String author, String image,
      double price) {
    final Book updatedBook = Book(
        title: title,
        description: description,
        author: author,
        image: image,
        price: price,
        userEmail: selectedBook.userEmail,
        userId: selectedBook.userId);
    _books[selectedBookIndex] = updatedBook;
    notifyListeners();
  }

  void deleteBook() {
    _books.removeAt(selectedBookIndex);
    notifyListeners();
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedBook.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Book updatedProduct = Book(
        title: selectedBook.title,
        description: selectedBook.description,
        author: selectedBook.author,
        price: selectedBook.price,
        image: selectedBook.image,
        userEmail: selectedBook.userEmail,
        userId: selectedBook.userId,
        isFavorite: newFavoriteStatus);
    _books[selectedBookIndex] = updatedProduct;
    notifyListeners();
  }

  void selectBook(int index) {
    _selBookIndex = index;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedBooksModel {
  void login(String email, String password) {
    _authenticatedUser =
        User(id: 'fdalsdfasf', email: email, password: password);
  }
}
