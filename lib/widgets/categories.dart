import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/categories_list.dart';
import 'package:resturant_app/widgets/categories_item.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoriesList>(context).catogeriesList;
    return Container(
      height: 150,//MediaQuery.of(context).size.height*0.20,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: ((context, index) {
            return ChangeNotifierProvider.value(
                value: categories[index],
                child:CategoriesItem());
          })),
    );
  }
}
