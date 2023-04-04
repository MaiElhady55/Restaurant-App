import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/meals.dart';
import 'package:resturant_app/widgets/categories.dart';
import 'package:resturant_app/widgets/populer.dart';
import 'package:resturant_app/widgets/random_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = 'home screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSeeAll = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Provider.of<Meals>(context, listen: false).fetchAndSetMeals(),
          builder: ((context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                print( 'Errrorrr= ${snapshot.error}');
                return AlertDialog(
                  title: Text('An error occurred'),
                  content: Text('No enternet Connection !'),
                );
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Platter',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      RandomList(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Meal Type',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Categories(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Populer Items',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            TextButton(
                              child: Text(
                                isSeeAll ? 'See Less' : 'See All',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isSeeAll = !isSeeAll;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Populer(isSeeAll: isSeeAll),
                    ],
                  ),
                );
              }
            }
          })),
    );
  }
}
