import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/user.dart';

/**
 * ConnectedBooksModel
 * @version 0.5
 * @author Daniel Huidobro <daniel@rebootproject.mx>
 * Modelo de libros y modelo proncipal del App
 */
class ConnectedBooksModel extends Model {
  List<Book> _books = [];
  String _selBookId;
  User _authenticatedUser;
  bool _isLoading = false;

  Future<Null> addBook(String title, String description, String author,
      String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> bookData = {
      'title': title,
      'description': description,
      'author': author,
      'image':
          'https://a.1stdibscdn.com/archivesE/upload/8141/932/XXX_8141_1349205668_1.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    return http
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
      _isLoading = false;
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

  String get selectedBookId {
    return _selBookId;
  }

  Book get selectedBook {
    if (_selBookId == null) {
      return null;
    }
    return _books.firstWhere((Book book) {
      return book.id == _selBookId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  int get selectedBookIndex { 
    return _books.indexWhere((Book book) {
      return book.id == _selBookId;
    });
  }
  Future<Null> updateBook(String title, String description, String author,
      String image, double price) {
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'author': author,
      'image':
          'https://s3-us-west-1.amazonaws.com/cdn.rebootproject.mx/amatl/image_404.jpg',
      'price': price,
      'userEmail': selectedBook.userEmail,
      'userId': selectedBook.userId
    };
    return http
        .put('https://amatl-72008.firebaseio.com/books/${selectedBook.id}.json',
            body: jsonEncode(updateData))
        .then((_) {
      _isLoading = false;
      final Book updatedBook = Book(
          id: selectedBook.id,
          title: title,
          description: description,
          author: author,
          image: image,
          price: price,
          userEmail: selectedBook.userEmail,
          userId: selectedBook.userId);
      _books[selectedBookIndex] = updatedBook;
      notifyListeners();
    });
  }

  void deleteBook() {
    _isLoading = true;
    final String deletedBookId = selectedBook.id;
    _books.removeAt(selectedBookIndex);
    _selBookId = null;
    notifyListeners();
    http
        .delete(
            'https://amatl-72008.firebaseio.com/books/${deletedBookId}.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleBookFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedBook.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Book updatedProduct = Book(
        id: selectedBook.id,
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

  void selectBook(String bookId) {
    _selBookId = bookId;
    notifyListeners();
  }

  Future<Null> fetchBooks() {
    _isLoading = true;
    return http
        .get('https://amatl-72008.firebaseio.com/books.json')
        .then((http.Response response) {
      final Map<String, dynamic> bookListData = jsonDecode(response.body);
      print(bookListData);
      if (bookListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      final List<Book> fetchBookList = [];
      bookListData.forEach((String bookId, dynamic bookData) {
        final Book book = Book(
            id: bookId,
            title: bookData['title'],
            description: bookData['description'],
            author: bookData['author'],
            image: bookData['image'],
            price: bookData['price'],
            userEmail: bookData['userEmail'],
            userId: bookData['userId']);
        fetchBookList.add(book);
      });
      _books = fetchBookList;
      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UserModel extends ConnectedBooksModel {
  void login(String email, String password) {
    _authenticatedUser =
        User(id: 'fdalsdfasf', email: email, password: password);
  }
}

class UtilityModel extends ConnectedBooksModel {
  bool get isLoading {
    return _isLoading;
  }
}
