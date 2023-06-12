import 'package:artclub/auth/login_screen.dart';
import 'package:artclub/common_widgets/our_button.dart';
import 'package:artclub/common_widgets/textfield.dart';
import 'package:artclub/consts/clrs.dart';
import 'package:artclub/firebase_service/consts.dart';
import 'package:artclub/firebase_service/firebase_functions.dart';
import 'package:artclub/home_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController forget = TextEditingController();
  TextEditingController password = TextEditingController();
   var controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
              start_color  ,
                end_color])),
      child:  Scaffold(
        
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Stack(
              children : [ Padding(
                padding:  EdgeInsets.only(top: context.screenHeight / 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [    
                      
                       Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue
                        ),
                    width: 200,
                    height: 200,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    ),
                  ),
                  Text('A r t   C l u b',style: GoogleFonts.abel(
                    wordSpacing: 5,
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold             ),),
              
                  customTextField(title: 'Почта',controller: email,hint:'exapmle@mail.ru'),
                  10.heightBox,
                  customTextField(title: 'Пароль',controller: password,hint: '********'),
                  Container(
                    width: double.infinity,
                    child: ourButton(color: white,textColor: Colors.black,title: 'Войти',onPress:(){
                      controller.signUpMethoud(
                        email: email.text,
                        password: password.text,
                        context: context,
                      ).then((value) {
                        if(value == null){
                         Navigator.pushReplacement(context, MaterialPageRoute(builder:   (context) => const Home_Screen()));
                        }
                        else{
                          VxToast.show(context, msg:value);
                        }
                      });
                    } ),
                  ),
                  RichText(text: 
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Нет аккаунта?',
                        style: TextStyle(
                          color: white,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text : ' Зарегистрироваться',
                        style: TextStyle(
                           decoration: TextDecoration.underline,
                           color: white,
                           fontSize: 20
                        )
                      )
                    ]
                  )).onTap(() {
                    Get.to(()=>Login_Screen());
                  }),
                  10.heightBox,
                    Text('Забыли пароль?').onTap(() { 
                    
                      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Сброс пароля'),
          content: Container(
            width: context.screenWidth/9,
            height: context.screenHeight/6,
            child:  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        'Забыли пароль?'.text.color(Colors.black).size(16).make(),
        5.heightBox,
        TextFormField(
          controller: forget,
    style: TextStyle(color: Colors.black),
          decoration:   InputDecoration(
            
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            
            hintText: 'example@mail.ru',
            isDense: true,
            fillColor:Colors.transparent,
            filled: true,
            enabledBorder:OutlineInputBorder(
              borderSide: BorderSide(color:Colors.blue)
            ) ,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Colors.blue)
            )
          ),
        ),
      ],
    ),
  )),
          actions: <Widget>[
           
            TextButton(
              onPressed: (){
                if(forget.text != ''){
                  auth.sendPasswordResetEmail(email: forget.text);
                Navigator.pop(context);
               VxToast.show(context, msg: 'Письмо с переустановкой пароля было отправлено на ' + forget.text);
              
                }
                
              },
              child: const Text('Ок'),
            ),
          ],
        ),
                  );
                  })
              
              
                  ],
                ),
              )],
            ),
          )
    ));
  }
}