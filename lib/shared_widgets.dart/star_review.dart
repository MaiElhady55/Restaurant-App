import 'package:flutter/material.dart';

class StarReview extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final double sizedBox;
  final Widget widget;
  final MainAxisAlignment mainAxis;

  StarReview({
    required this.widget,
    required this.iconSize,
    required this.fontSize ,
    required this.sizedBox ,
    required this.mainAxis ,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxis,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(Icons.star,
            color: Theme.of(context).colorScheme.secondary, size: iconSize),
        Icon(Icons.star,
            color: Theme.of(context).colorScheme.secondary, size: iconSize),
        Icon(Icons.star,
            color: Theme.of(context).colorScheme.secondary, size: iconSize),
        Icon(Icons.star_half,
            color: Theme.of(context).colorScheme.secondary, size: iconSize),
        Icon(Icons.star_border,
            color: Theme.of(context).colorScheme.secondary, size: iconSize),
        SizedBox(width: sizedBox),
        Text(
          '4.5',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
        widget,
        Text(
          '(35 Reviews)',
          style: TextStyle(
            color: Colors.grey,
            fontSize: fontSize,
          ),
        )
      ],
    );
  }
}
