import 'package:flutter/material.dart';


Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required Function()? function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Widget defaultTextButton({
  required Function()? function,
  required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        text.toUpperCase(),
      ),
    );




Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  final Function(String)? onSubmit,
  final Function(String)? onChange,
  final Function()? onTap,
  bool isPassword = false,
  required final String? Function(String?)? validator,
  required String label,
  required IconData prefix,
  IconData? suffix,
  final Function()? suffixPressed,
}) => TextFormField(
  controller: controller,
  keyboardType: type,

  obscureText: isPassword,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  onTap: onTap,
  validator: validator,

  decoration: InputDecoration(
    disabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,


    labelText: label,
    prefixIcon: Icon(
      prefix,
    ),

    suffixIcon: suffix != null ? IconButton(

      onPressed: suffixPressed,

      icon: Icon(

        suffix,

      ),

    ) : null,

    border: OutlineInputBorder(),

  ),

);

Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);





void navigateTo({context, widget}) => Navigator.push(
  context,

  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish({
  context,
  widget,
}) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
          (route) {
        return false;
      },
    );





