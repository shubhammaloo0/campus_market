import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  final String? text;
  final VoidCallback press;
  final Color color, textColor;

  RoundedButton({
    required this.text,
    required this.press,
    this.color = Colors.black87,
    this.textColor = Colors.white,
});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      width: size.width * 0.7,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 40),
          ),
          onPressed: press,
          child: Text(
            text!,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
