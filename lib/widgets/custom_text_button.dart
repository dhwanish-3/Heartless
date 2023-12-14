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
      height: 40,
      width: containerWidth,
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isHighlighted
            ? Theme.of(context).primaryColor
            : Theme.of(context).canvasColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isHighlighted ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
