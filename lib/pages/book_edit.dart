import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/helpers/ensure_visible.dart';
import '../models/book.dart';
import '../scoped-models/main.dart';

class BookEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BookEditState();
  }
}

class _BookEditState extends State<BookEdit> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'author': null,
    'price': null,
    'image': 'assets/food.jpg'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _authorFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextField(Book book) {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(labelText: 'Título del libro'),
        initialValue: book == null ? '' : book.title,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length < 4) {
            return 'El título es requerido y debe tener 4+ caracteres';
          }
        },
        onSaved: (String value) {
          _formData['title'] = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField(Book book) {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        maxLines: 4,
        decoration: InputDecoration(labelText: 'Descripción'),
        initialValue: book == null ? '' : book.description,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length < 20) {
            return 'La descripción es requerida y debe tener 20+ caracteres';
          }
        },
        onSaved: (String value) {
          _formData['description'] = value;
        },
      ),
    );
  }

  Widget _buildAuthorTextField(Book book) {
    return EnsureVisibleWhenFocused(
      focusNode: _authorFocusNode,
      child: TextFormField(
        focusNode: _authorFocusNode,
        decoration: InputDecoration(labelText: 'Autor del libro'),
        initialValue: book == null ? '' : book.author,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length < 4) {
            return 'El autor es requerido y debe tener 4+ caracteres';
          }
        },
        onSaved: (String value) {
          _formData['author'] = value;
        },
      ),
    );
  }

  Widget _buildPriceTextField(Book book) {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        focusNode: _priceFocusNode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Precio del libro'),
        initialValue: book == null ? '' : book.price.toString(),
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return 'El precio es requerido y debe ser numero.';
          }
        },
        onSaved: (String value) {
          _formData['price'] = double.parse(value);
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                child: Text('Save'),
                textColor: Colors.white,
                onPressed: () => _submitForm(model.addBook, model.updateBook,
                    model.selectBook, model.selectedBookIndex),
              );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Book book) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(book),
              _buildDescriptionTextField(book),
              _buildAuthorTextField(book),
              _buildPriceTextField(book),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(
      Function addBook, Function updateBook, Function setSelectedBook,
      [int selectedBookIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedBookIndex == null) {
      addBook(
        _formData['title'],
        _formData['description'],
        _formData['author'],
        _formData['image'],
        _formData['price'],
      ).then((_) {
        Navigator.pushReplacementNamed(context, '/books')
            .then((_) => setSelectedBook(null));
      });
    } else {
      updateBook(
        _formData['title'],
        _formData['description'],
        _formData['author'],
        _formData['image'],
        _formData['price'],
      ).then((_) {
        Navigator.pushReplacementNamed(context, '/books')
            .then((_) => setSelectedBook(null));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedBook);
        return model.selectedBookIndex == null
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Editar Libro'),
                ),
                body: pageContent,
              );
      },
    );
  }
}
