import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/category.dart';
import 'package:resturant_app/providers/auth.dart';
import 'package:resturant_app/providers/cart.dart';
import 'package:resturant_app/providers/categories_list.dart';
import 'package:resturant_app/providers/meal.dart';
import 'package:resturant_app/providers/meals.dart';
import 'package:resturant_app/providers/orders.dart';
import 'package:resturant_app/shared_widgets.dart/star_review.dart';

class MealDetailScreen extends StatefulWidget {
  static const routeName = 'Meal-Detail-Screen';

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Meal? currentMeal;
  var currentCategory;
  var categoryId;
  var _isInit = true;

  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routArg =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final mealId = routArg['mealId'];

      categoryId = routArg['catogoryId'];
      currentMeal =
          Provider.of<Meals>(context, listen: false).findlById(id: mealId);
      // print(catogoryId);

      if (categoryId != null) {
        currentCategory = Provider.of<CategoriesList>(context)
            .catogeriesList
            .firstWhere((catog) => catog.id == categoryId);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Carts>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30, right: 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: FloatingActionButton(
                heroTag: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    : Text(
                        'Order Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (cart.items.isNotEmpty) {
                    return;
                  }
                  cart.addItem(
                    mealId: currentMeal!.id,
                    price: currentMeal!.price,
                    title: currentMeal!.title,
                    imageUrl: currentMeal!.imageUrl,
                  );
                  try {
                    await Provider.of<Orders>(context, listen: false).addOrder(
                      cart.items.values.toList(),
                      cart.totalAmount,
                    );
                    cart.clearCart();
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.black54,
                      content: Text('You order is Done!'),
                      duration: Duration(seconds: 1),
                    ));
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.black54,
                      content: Text('You cann\'t order now Try later!'),
                      duration: Duration(seconds: 1),
                    ));
                  }
                },
              ),
            ),
            SizedBox(width: 20),
            FloatingActionButton(
              heroTag: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.add_shopping_cart,
                size: 25,
                color: Colors.white,
              ),
              onPressed: () {
                cart.addItem(
                  mealId: currentMeal!.id,
                  price: currentMeal!.price,
                  title: currentMeal!.title,
                  imageUrl: currentMeal!.imageUrl,
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.black54,
                    content: Text('Added meal to cart!'),
                    duration: Duration(seconds: 1),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(mealId: currentMeal!.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            textTheme: Theme.of(context).textTheme,
            // actionsIconTheme: Theme.of(context).accentIconTheme,
            // iconTheme: Theme.of(context).iconTheme,
            backgroundColor: Color.fromARGB(0, 0, 0, 1),
            elevation: 0.0,
            automaticallyImplyLeading: false,
            expandedHeight: 300,
            pinned: true,
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                icon: Icon(Icons.arrow_back, size: 30),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Spacer(),
              IconButton(
                padding: EdgeInsets.symmetric(
                  horizontal: 28.0,
                  vertical: 20.0,
                ),
                icon: Icon(
                  Icons.favorite,
                  size: 35,
                  color:
                      currentMeal!.isFavorite ? Colors.redAccent : Colors.white,
                ),
                onPressed: () async {
                  try {
                    currentMeal!.toogleFavoriteStatus(
                        token: authData.token!, userId: authData.userId!);
                    setState(() {
                      // currentMeal.isFavorite;
                    });
                  } catch (e) {
                    setState(() {
                      // currentMeal.isFavorite;
                    });
                    SnackBar(
                      backgroundColor: Colors.black54,
                      content: Text('Process Faild!'),
                      duration: Duration(seconds: 1),
                    );
                  }
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: currentMeal!.id,
                child: Image.network(
                  currentMeal!.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        currentMeal!.title,
                        style: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      StarReview(
                        iconSize: 20,
                        fontSize: 16,
                        widget: Spacer(),
                        mainAxis: MainAxisAlignment.spaceAround,
                        sizedBox: 2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 15.0,
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (categoryId != null)
                        _buildRow(
                          image: Image.asset(
                            currentCategory.imageUrl,
                            fit: BoxFit.cover,
                          ),
                          text: currentCategory.title,
                        ),
                      if (categoryId == null)
                        _buildRow(
                          image: Image.network(
                            currentMeal!.imageUrl,
                            fit: BoxFit.cover,
                          ),
                          text: currentMeal!.title,
                        ),
                      _buildRow(
                          icon: Icons.thumb_up, text: '150 Like', size: 2.0),
                      Text(
                        '\$${currentMeal!.price}/Person',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Divider(thickness: 2),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Introduction',
                        style: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        currentMeal!.description,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 60.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
      {Widget? image,
      IconData? icon,
      required String text,
      double size = 5.0}) {
    return Row(
      children: <Widget>[
        Container(
          height: 18.0,
          width: 18.0,
          child: image,
        ),
        if (image == null)
          Icon(
            icon,
            size: 16.0,
            color: Colors.grey,
          ),
        SizedBox(width: size),
        Text(
          text,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
