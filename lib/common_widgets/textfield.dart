import 'package:artclub/consts/clrs.dart';
import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

Widget customTextField({String? title ,String? hint,controller}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title!.text.color(white).size(16).make(),
        5.heightBox,
        TextFormField(
          controller: controller,
    style: TextStyle(color: Colors.white),
          decoration:   InputDecoration(
            
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            
            hintText: hint,
            isDense: true,
            fillColor:Colors.transparent,
            filled: true,
            enabledBorder:OutlineInputBorder(
              borderSide: BorderSide(color:Colors.white)
            ) ,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Colors.white)
            )
          ),
        ),
      ],
    ),
  );
}