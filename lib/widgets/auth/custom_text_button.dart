import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final double containerWidth;
  final bool isHighlighted;
  const CustomTextButton({
    super.key,
    required this.text,
    required this.containerWidth,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: containerWidth,
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isHighlighted ? Theme.of(context).primaryColor : null,
        boxShadow: isHighlighted
            ? [
                const BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(1, 1), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isHighlighted ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
