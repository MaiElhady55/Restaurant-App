import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/category.dart';
import 'package:resturant_app/providers/categories_list.dart';
import 'package:resturant_app/providers/meal.dart';
import 'package:resturant_app/providers/meals.dart';

class EditCatScreen extends StatefulWidget {
  const EditCatScreen({super.key});
  static const routeName = 'edit_cat_screen';

  @override
  State<EditCatScreen> createState() => _EditCatScreenState();
}

class _EditCatScreenState extends State<EditCatScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _idFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  final _symbolFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final TextEditingController _imageUrlController = TextEditingController();

  var _editingCat = Category(id: '', symbol: '', title: '', imageUrl: '');

  Map<String, dynamic> _initValue = {
    'id': '',
    'title': '',
    'symbol': '',
    'imageUrl': ''
  };

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _idFocusNode.dispose();
    _titleFocusNode.dispose();
    _symbolFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  var _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final catId = ModalRoute.of(context)!.settings.arguments as String;
      if (catId != null) {
        _editingCat = Provider.of<CategoriesList>(context, listen: false)
            .catogeriesList
            .firstWhere((catoId) => catoId.id == catId);
        _initValue = {
          'id': _editingCat.id,
          'title': _editingCat.title,
          'symbol': _editingCat.symbol,
          'imageUrl': _editingCat.imageUrl,
        };
        _imageUrlController.text = _editingCat.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editingCat.id != null) {
      Provider.of<CategoriesList>(context,listen: false)
          .updateCategory(editingCategory: _editingCat, id: _editingCat.id);
    } else {
      Provider.of<CategoriesList>(context,listen: false).addNewCategory(_editingCat);
    }
    setState(() {
      _isLoading = false;
    });
     Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //textTheme: Theme.of(context).textTheme,
          actionsIconTheme: Theme.of(context).accentIconTheme,
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Color.fromARGB(0, 0, 0, 1),
          elevation: 0.0,
          title: Text(_editingCat.id == null ? 'Add Category' : 'Edit Category',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _saveForm,
      ),
      body:_isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _initValue['id'],
                  decoration: InputDecoration(labelText: 'Id'),
                  focusNode: _idFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_titleFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter provid value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    Category(
                        id: value!,
                        symbol: _editingCat.symbol,
                        title: _editingCat.title,
                        imageUrl: _editingCat.imageUrl);
                  },
                ),
                TextFormField(
                  initialValue: _initValue['title'],
                  decoration: InputDecoration(labelText: 'Title'),
                  focusNode: _titleFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_symbolFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter provid value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    Category(
                        id: _editingCat.id,
                        symbol: _editingCat.symbol,
                        title: value!,
                        imageUrl: _editingCat.imageUrl);
                  },
                ),
                TextFormField(
                  initialValue: _initValue['symbol'],
                  decoration: InputDecoration(labelText: 'Symbol'),
                  textInputAction: TextInputAction.next,
                  focusNode: _symbolFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter provid value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    Category(
                        id: _editingCat.id,
                        symbol: value!,
                        title: _editingCat.title,
                        imageUrl: _editingCat.imageUrl);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(right: 8, top: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Center(child: Text('Enter Url'))
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        // initialValue: _initValue['imageUrl'],
                        decoration: InputDecoration(labelText: 'Image Url'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        focusNode: _imageUrlFocusNode,
                        controller: _imageUrlController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter URL';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valid UrL';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Enter a valid image Url';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          Category(
                              id: _editingCat.id,
                              title: _editingCat.title,
                              symbol: _editingCat.symbol,
                              imageUrl: value!);
                        },
                        onFieldSubmitted: (_) {
                          _saveForm;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
