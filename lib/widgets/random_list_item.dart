import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/auth.dart';
import 'package:resturant_app/providers/meal.dart';
import 'package:resturant_app/providers/meals.dart';
import 'package:resturant_app/screens/meal_detail_screen.dart';
import 'package:resturant_app/shared_widgets.dart/star_review.dart';

class RandomListItem extends StatefulWidget {
  final Meal meal;
  RandomListItem({required this.meal});

  @override
  State<RandomListItem> createState() => _RandomListItemState();
}

class _RandomListItemState extends State<RandomListItem> {
  @override
  Widget build(BuildContext context) {
    final randomMeal = Provider.of<Meals>(context, listen: false)
        .findlById(id: widget.meal.id);
    final authData = Provider.of<Auth>(context);
    // ignore: no_leading_underscores_for_local_identifiers
    _selectRandomMeal(BuildContext context) {
      Navigator.of(context)
          .pushNamed(MealDetailScreen.routeName, arguments:{'mealId': randomMeal.id});
    }

    return GestureDetector(
        onTap: ()=>_selectRandomMeal(context),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: EdgeInsets.all(5),
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 8),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  randomMeal.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
                right: 5,
                top: -5,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  child: IconButton(
                      onPressed: () async {
                        try {
                          randomMeal.toogleFavoriteStatus(
                              token: authData.token!, userId: authData.userId!);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.black54,
                            content: Text('Process Faild!'),
                            duration: Duration(seconds: 1),
                          ));
                        }
                      },
                      icon: Icon(
                        size: 30,
                        Icons.favorite,
                        color: randomMeal.isFavorite
                            ? Colors.redAccent
                            : Colors.white,
                      )),
                )),
            Positioned(
                bottom: 0,
                left: 10,
                right: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              randomMeal.title,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: StarReview(
                              mainAxis: MainAxisAlignment.spaceBetween,
                              iconSize: 15.0,
                              fontSize: 14.0,
                              sizedBox: 2.0,
                              widget: Spacer(),
                            ),
                          ),
                          Row(
                            children: [
                              _buildRow(
                                  icon: Icons.thumb_up,
                                  text: '150 Like',
                                  fontSize: 14,
                                  iconSize: 14),
                              Spacer(),
                              FittedBox(
                                child: Text(
                                  '\$${randomMeal.price}/Person',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ));
  }

  Widget _buildRow(
      {required IconData icon,
      required String text,
      required double fontSize,
      required double iconSize}) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: iconSize,
          color: Colors.grey,
        ),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
