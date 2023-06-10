
import 'package:artclub/consts/clrs.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

Widget ourButton({onPress,color,String? title,textColor}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(247, 37, 133 ,1),
            Color.fromRGBO(86, 11, 173, 1)
          ]),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
          ),
            
         
          onPressed: onPress
          , child: title!.text.color(white).size(20).make()),
      ),
    ),
  );
}