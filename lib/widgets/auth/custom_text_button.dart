import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final double containerWidth;
  final bool isHighlighted;
  final double height;
  const CustomTextButton({
    super.key,
    required this.text,
    required this.containerWidth,
    this.isHighlighted = false,
    this.height = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: containerWidth,
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isHighlighted ? Theme.of(context).primaryColor : null,
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  // color: Colors.grey,
                  color: Theme.of(context).highlightColor,
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0.5, 0.5), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FittedBox(
            // fit: BoxFit.contain,
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: isHighlighted
                    ? Colors.white
                    : Theme.of(context).shadowColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
