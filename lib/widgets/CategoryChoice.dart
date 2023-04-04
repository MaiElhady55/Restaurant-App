import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/category.dart';
import 'package:resturant_app/providers/categories_list.dart';

class CategoryChoice extends StatefulWidget {
  final Category cat;
  final List<dynamic>? mealCategories;

  CategoryChoice({required this.cat, required this.mealCategories});
  @override
  State<CategoryChoice> createState() => _CategoryChoiceState();
}

class _CategoryChoiceState extends State<CategoryChoice> {
  bool isSelected = true;
  var isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      if (widget.mealCategories != null) {
        isSelected = widget.mealCategories!.contains(widget.cat.symbol);
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Consumer<CategoriesList>(
        builder: (context, cat, _) {
          return CheckboxListTile(
              title: Text(widget.cat.title),
              value: isSelected,
              onChanged: (value) {
                if (!isSelected) {
                  cat.addSymobl(widget.cat.symbol);
                } else {
                  cat.removeSymobl(widget.cat.symbol);
                }
                setState(() {
                  isSelected = !isSelected;
                });
              });
        },
      ),
    );
  }
}
