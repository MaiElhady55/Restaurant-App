import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/categories_list.dart';
import 'package:resturant_app/providers/meals.dart';
import 'package:resturant_app/screens/edit_cat_screen.dart';
import 'package:resturant_app/screens/edit_meal_screen.dart';
import 'package:resturant_app/shared_widgets.dart/drawer.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});
  static const routeName = 'Manager_screen';

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  bool isCategory = true;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final myCategory = Provider.of<CategoriesList>(context);
    final myMeal = Provider.of<Meals>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: SharedDrawer(),
        appBar: AppBar(
          //textTheme: Theme.of(context).textTheme,
          actionsIconTheme: Theme.of(context).accentIconTheme,
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Color.fromARGB(0, 0, 0, 1),
          elevation: 0.0,
          title: Text(
            'Manage Meals',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          bottom: TabBar(
            onTap: ((index) {
              switch (index) {
                case 0:
                  isCategory = true;
                  break;
                case 1:
                  isCategory = false;
                  break;
                default:
                  isCategory = true;
              }
            }),
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Theme.of(context).primaryColor,
            tabs: const [
              Tab(
                text: 'Category',
                icon: Icon(
                  Icons.category,
                ),
              ),
              Tab(
                text: 'Meal',
                icon: Icon(
                  Icons.restaurant,
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (isCategory) {
              Navigator.of(context).pushNamed(EditCatScreen.routeName);
            } else {
              Navigator.of(context).pushNamed(EditMealScreen.routeName);

            Provider.of<CategoriesList>(context, listen: false).emptyMySelectedCat();
            }
          },
          child: Icon(Icons.add),
        ),
        body: TabBarView(children: [
          ManageCatItem(myCategory: myCategory),
          ManageMealItem(myMeal: myMeal),
        ]),
      ),
    );
  }
}

class ManageCatItem extends StatelessWidget {
  final CategoriesList myCategory;
  const ManageCatItem({super.key, required this.myCategory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: myCategory.catogeriesList.length,
          itemBuilder: ((context, index) {
            return Card(
              elevation: 5,
              child: ListTile(
                leading: CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.white,
                    child:
                        Image.asset(myCategory.catogeriesList[index].imageUrl)),
                title: Text(myCategory.catogeriesList[index].title,
                    style: TextStyle(
                      fontSize: 18,
                    )),
                subtitle: Text(myCategory.catogeriesList[index].symbol),
                trailing: Container(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(EditCatScreen.routeName, arguments: {
                              myCategory.catogeriesList[index].id,
                            });
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            myCategory.removeCategory(
                                id: myCategory.catogeriesList[index].id);
                          }),
                    ],
                  ),
                ),
              ),
            );
          })),
    );
  }
}

class ManageMealItem extends StatelessWidget {
  final Meals myMeal;
  const ManageMealItem({super.key, required this.myMeal});

  @override
  Future<void> _refreshMeals(BuildContext context) async {
  await  Provider.of<Meals>(context,listen: false).fetchAndSetMeals();
  }

  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>_refreshMeals(context) ,
      child: ListView.builder(
          itemCount: myMeal.meals.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1.3,
                          child: Image.network(
                            myMeal.meals[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        myMeal.meals[index].title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '\$${myMeal.meals[index].price}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Categories :',
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                height: 30,
                                                width: 130,
                                                child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: myMeal
                                                        .meals[index].categories
                                                        .map(
                                                          (mealCat) => Card(
                                                            color:
                                                                Theme.of(context)
                                                                    .accentColor,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              child:
                                                                  Text(mealCat),
                                                            ),
                                                          ),
                                                        )
                                                        .toList()),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      EditMealScreen.routeName,
                                                      arguments:
                                                          myMeal.meals[index].id,
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Expanded(
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  onPressed: () async {
                                                    try {
                                                      await myMeal.deleteMeal(
                                                          myMeal.meals[index].id);
                                                    } catch (error) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          duration: Duration(
                                                              seconds: 2),
                                                          content: Text(
                                                            'Delete faild !',
                                                            textAlign:
                                                                TextAlign.center,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              )
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          })),
    );
  }
}
