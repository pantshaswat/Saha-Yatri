import 'package:flutter/material.dart';

SuffixIconButton({IconData? icon, Function? onTap}) {
  return GestureDetector(
    onTap: onTap as void Function()?,
    child: Icon(
      icon,
      color: Colors.grey,
    ),
  );
}

Container reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller,
    {IconData? suffixIcon, onTap}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: TextField(
      obscuringCharacter: '*',
      controller: controller,
      obscureText: isPasswordType,
      decoration: InputDecoration(
          suffixIcon: SuffixIconButton(
              icon: suffixIcon,
              onTap: () {
                onTap();
              }),
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
          ),
          hintText: text,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    ),
  );
}

SizedBox elevatedButtons(
    dynamic Onpressed, String text, double height, double width) {
  return SizedBox(
    height: height,
    width: width,
    child: ElevatedButton(
      onPressed: (Onpressed),
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 23, 17, 17),
          side: const BorderSide(
              width: 1, color: Color.fromARGB(255, 72, 71, 71)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: Text(text),
    ),
  );
}
