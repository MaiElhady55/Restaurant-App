import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:resturant_app/models/order.dart';

class ProfileOrderItem extends StatefulWidget {
  final Order order;
  const ProfileOrderItem({super.key, required this.order});

  @override
  State<ProfileOrderItem> createState() => _ProfileOrderItemState();
}

class _ProfileOrderItemState extends State<ProfileOrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text('Total : \$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: (() {
                setState() {
                  _expanded = !_expanded;
                }

                ;
              }),
            ),
          ),
          if (_expanded)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Container(
                height: 130,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.order.meals.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 3, right: 3),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FittedBox(
                                child: Image.network(
                                  widget.order.meals[index].imageUrl,
                                  width: 130.0,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.order.meals[index].title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.order.meals[index].quantity} x ${widget.order.meals[index].price}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          )
                          /*Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.order.meals[index].title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                               Text(
                                    '${widget.order.meals[index].quantity} x ${widget.order.meals[index].price}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  )
                            ],
                          ),*/
                        ],
                      );
                    }),
              ),
            )
        ],
      ),
    );
  }
}
