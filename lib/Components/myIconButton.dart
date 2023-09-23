import 'package:flutter/material.dart';

myIconButoon(String image, onTap) {
  return InkWell(
    onTap: (onTap),
    child: Container(
      margin: EdgeInsets.all(10),
      height: 40,
      width: 40,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
        // color: Color.fromARGB(255, 233, 230, 230)
      ),
      child: Image.asset(
        image,
        height: 50,
      ),
    ),
  );
}
