import 'package:flutter/material.dart';

Widget defaultButton(
        {double button_width = double.maxFinite,
        Color button_color = Colors.teal,
        double button_height = 40,
        double radius = 10,
        required VoidCallback button_onPressed,
        required String text}) =>
    Container(
      width: button_width,
      height: button_height,
      decoration: BoxDecoration(
          color: button_color,
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      child: MaterialButton(
        onPressed: button_onPressed,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );

Widget defaultTextFeild({
  required ValueChanged<String?> onSubmitted,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isPassword = false,
  VoidCallback? onpressedicon,
  required TextEditingController controller,
  required TextInputType type,
  String? Function(String?)? validator,
  VoidCallback? onTap,
  VoidCallback? onPress,
  String? Function(String?)? onChanged,
  String? initialValue,
  bool keyboardeanabled = true,
}) =>
    TextFormField(
        initialValue: initialValue,
        controller: controller,
        onTap: onTap,
        enabled: keyboardeanabled,
        onChanged: onChanged,
        validator: validator,
        obscureText: isPassword ? true : false,
        onFieldSubmitted: onSubmitted,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(
            prefix,
          ),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: onpressedicon,
                  icon: Icon(
                    suffix,
                  ),
                )
              : null,
        ));

Widget TheText({required String text}) => Text(
      text,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
