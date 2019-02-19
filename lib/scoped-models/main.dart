import 'package:scoped_model/scoped_model.dart';
import './connected_books.dart';

class MainModel extends Model with ConnectedBooksModel, UserModel, BooksModel {
}
