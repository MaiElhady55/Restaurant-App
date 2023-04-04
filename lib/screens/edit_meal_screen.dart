import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/category.dart';
import 'package:resturant_app/providers/categories_list.dart';
import 'package:resturant_app/providers/meal.dart';
import 'package:resturant_app/providers/meals.dart';
import 'package:resturant_app/widgets/CategoryChoice.dart';

class EditMealScreen extends StatefulWidget {
  const EditMealScreen({super.key});
  static const routeName = 'Edit_Meal_screen';

  @override
  State<EditMealScreen> createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  final _imageUrlController = TextEditingController();

  final _titleFocusNode = FocusNode();
  final _pricFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  //to add New Meal  / should Write _addingMeal Not _editedMeal .. i well change it later :)
  var _editedMeal = Meal(
      id: '',
      title: '',
      price: 0.0,
      description: '',
      imageUrl: '',
      categories: [],
      isFavorite: false);

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _titleFocusNode.dispose();
    _pricFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

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

  bool _isLoading = false;

  ///////[Updating] Meal [Start] ////////////////////////////////////////////////////
  var _initMealValue = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var mealId;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      mealId = ModalRoute.of(context)!.settings.arguments as String;
      if (mealId != null) {
        _editedMeal =
            Provider.of<Meals>(context, listen: false).findlById(id: mealId);
        Provider.of<CategoriesList>(context)
            .addSymoblList(_editedMeal.categories);

        _initMealValue = {
          'title': _editedMeal.title,
          'price': _editedMeal.price.toString(),
          'description': _editedMeal.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedMeal.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveMealForme() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedMeal.id != null) {
      //to add [list of category] to [meal]
      _editedMeal.categories =
          Provider.of<CategoriesList>(context, listen: false).mySelectedCat;
      // [Update] existing [Meal]
      try {
        await Provider.of<Meals>(context)
            .updateMeal(_editedMeal.id, _editedMeal);
      } catch (e) {
        await showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                title: Text('An error occurred'),
                content: Text('Something went wrong !'),
                actions: [
                  TextButton(
                    child: Text('Okay'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            }));
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    } else {
      //to add [list of category] to [meal]
      _editedMeal.categories =
          Provider.of<CategoriesList>(context, listen: false).mySelectedCat;
      //Add [New Meal]
      try {
        await Provider.of<Meals>(context, listen: false)
            .addNewMeal(_editedMeal);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An error occurred'),
            content: Text('Something went wrong !'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List currentCategory = Provider.of<CategoriesList>(context).catogeriesList;
    return Scaffold(
      appBar: AppBar(
        //textTheme: Theme.of(context).textTheme,
        automaticallyImplyLeading: true,
        actionsIconTheme: Theme.of(context).accentIconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Color.fromARGB(0, 0, 0, 1),
        elevation: 0.0,
        title: Text(
          _editedMeal.id != null ? 'Edit Meal':'Add Meal' ,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveMealForme,
        child: Icon(Icons.done),
      ),
      body:_isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initMealValue['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_pricFocusNode);
                        },
                        onSaved: (value) {
                          Meal(
                              id:_editedMeal.id,
                              title:value!,
                              price:_editedMeal. price,
                              description:_editedMeal. description,
                              imageUrl:_editedMeal. imageUrl,
                              categories:_editedMeal. categories);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter provid title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initMealValue['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _pricFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                           Meal(
                              id:_editedMeal.id,
                              title:_editedMeal.title,
                              price:double.parse(value!),
                              description:_editedMeal. description,
                              imageUrl:_editedMeal. imageUrl,
                              categories:_editedMeal. categories);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter provid price ';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'The price should be greater than ZERO';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      //${Provider.of<CategoriesList>(context, listen: false).mySelectedCat}
                      Text(
                        'Category List : ${Provider.of<CategoriesList>(context, listen: false).mySelectedCat}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 130,
                        margin: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: Theme.of(context).accentColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                            itemCount: currentCategory.length,
                            itemBuilder: (ctx, i) {
                              return CategoryChoice(
                                cat: currentCategory[i],
                                mealCategories: _editedMeal.id != null
                                    ? _editedMeal.categories
                                    : null,
                              );
                            }),
                      ),

                      TextFormField(
                        initialValue: _initMealValue['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_imageUrlFocusNode);
                        },
                        onSaved: (value) {
                          Meal(
                              id:_editedMeal.id,
                              title:_editedMeal.title,
                              price:_editedMeal.price,
                              description:value!,
                              imageUrl:_editedMeal. imageUrl,
                              categories:_editedMeal. categories);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter provid value';
                          }
                          if (value.length < 10) {
                            return 'The description should be at least 10 character';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
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
                              // initialValue: _initMealValue['imageUrl'],
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (value) {
                                Meal(
                              id:_editedMeal.id,
                              title:_editedMeal.title,
                              price:_editedMeal.price,
                              description:_editedMeal. description,
                              imageUrl:value!,
                              categories:_editedMeal. categories);
                              },
                              onFieldSubmitted: (_) {
                                _saveMealForme();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter URL';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Enter a valid image Url';
                                }
                                return null;
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
