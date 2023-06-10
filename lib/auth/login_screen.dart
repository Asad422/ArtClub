import 'package:artclub/common_widgets/our_button.dart';
import 'package:artclub/common_widgets/textfield.dart';
import 'package:artclub/consts/clrs.dart';
import 'package:artclub/firebase_service/firebase_functions.dart';
import 'package:artclub/home_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:artclub/firebase_service/consts.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {

    TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  
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
                      
                       ClipRRect(
                         borderRadius: BorderRadius.circular(100),
                         child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                           
                          ),
                                           width: 200,
                                           height: 200,
                                         child: Image.asset(
                                           'assets/images/avatar.png',
                                           fit: BoxFit.cover,
                                           ),
                                         ),
                       ),
                  Text('A r t   C l u b',style: GoogleFonts.abel(
                    wordSpacing: 5,
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold             ),),
                     customTextField(title: 'Имя аккаунта',controller: username,hint: 'G-MAN'),
                     10.heightBox,

                  customTextField(title: 'Почта',controller: email,hint:'exapmle@mail.ru'),
                  10.heightBox,
                  customTextField(title: 'Пароль',controller: password,hint: '********'),
                  10.heightBox,
                 
                  Container(
                    width: double.infinity,
                    child: ourButton(color: white,textColor: Colors.black,title: 'Зарегистрироваться',onPress:(){
                      controller.logInMethod(
                        email: email.text,
                        password: password.text,
                        context: context,
                      ).then((value) {
                        if(value == null){
                        firestore.collection('users').doc(auth.currentUser!.email).set({
                          'email':   auth.currentUser!.email,
                          'image_avatar' : '',
                          'name' : username.text,
                          'my_saved_posts' : [],
                          'my_posted_posts' : []
                        }).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder:   (context) => const Home_Screen())));
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
                        text: 'Уже есть аккаунт?',
                        style: TextStyle(
                          color: white,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text : 'Войти',
                        style: TextStyle(
                           decoration: TextDecoration.underline,
                           color: white,
                           fontSize: 25
                        )
                      )
                    ]
                  )).onTap(() {
                    Get.back();
                  }),
                
                  ],
                ),
              )],
            ),
          )
    ));
  }
}