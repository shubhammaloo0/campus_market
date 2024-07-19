import 'package:campus_market/Widgets/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  RoundedPasswordField({
    required this.onChanged,
  });

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

bool obscureText = true;

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextFormField(
      obscureText: !obscureText,
      onChanged: widget.onChanged,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        hintText: 'Password',
        icon: const Icon(
          Icons.lock,
          color: Colors.teal,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
        ),
        border: InputBorder.none,
      ),
    ));
  }
}
