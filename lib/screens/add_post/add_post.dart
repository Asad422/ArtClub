import 'package:artclub/common_widgets/our_button.dart';
import 'package:artclub/common_widgets/textfield.dart';
import 'package:artclub/consts/clrs.dart';
import 'package:artclub/firebase_service/consts.dart';
import 'package:artclub/firebase_service/firebase_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:velocity_x/velocity_x.dart';

class Add_Post_Screen extends StatelessWidget {
  const Add_Post_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
              start_color2  ,
                end_color2])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            title: Text(
              'Добавить категорию ',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(() => Add_Category_Screen());
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ))
            ],
          ),
          body: Container(
              height: context.screenHeight,
              child: ListView(children: [
                Column(
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('categories')
                            .snapshots(),
                        builder:
                            ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black)),
                            );
                          } else {
                            var data = snapshot.data!.docs;
                            return GridView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1.49,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: ((context, index) {
                                return 
                                  Stack(children: <Widget>[
                                    Center(
                                      child: Image.network(
                                        
                                        data[index]['img'],
                                      
                                        fit: BoxFit.fitWidth,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                           return Image.network(
                                              'https://cdn1.ozone.ru/s3/multimedia-i/6313246674.jpg',
                                              fit: BoxFit.contain,
                                            
                                          );
                                        },
                                      ),
                                    ),
                                    Center(
                                        child: Text(data[index]['name'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ))),
                                  ],
                                ).onTap(() {
                                 Get.to(()=>Add_Post_to_Categories(selectedCategory: data[index]['name'].toString()));
                                });
                              }),
                            );
                          }
                        })),
                  ],
                )
              ]))),
    );
  }
}

class Add_Category_Screen extends StatefulWidget {
  Add_Category_Screen({super.key});

  @override
  State<Add_Category_Screen> createState() => _Add_Category_ScreenState();
}

class _Add_Category_ScreenState extends State<Add_Category_Screen> {
  var controller = Get.put(AuthController());
  String setImg = '';
  TextEditingController categoryName = TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.only(top: context.height / 14),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Center(
                          
                            child: Card(
                              child: Container(
                                width: 100,
                                height: 100,
                              
                                child: Image.network(
                                  setImg,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/photo.png',
                                      fit: BoxFit.contain,
                                    );
                                  },
                                ),
                              ),
                            ),
                          
                        ),
                      ],
                    ).onTap(() {
                      if(categoryName.text !=''){
                      controller
                          .uploadCategoryImage(context, categoryName.text)
                          .then((value) {
                        if (value == '') {
                          return;
                        } else {
                          setState(() {
                            setImg = value;
                          });
                        }
                      });
  }
    else{
      VxToast.show(context, msg: 'Для начала введите название категории');
    }
  
  
  }),
                    customTextField(
                      title: 'Название категории',
                      hint: 'Food',
                      controller: categoryName,
                    ),
                    Container(
                      width: double.infinity,
                      child: ourButton(
                          color: white,
                          title: 'Добавить категорию',
                          textColor: Colors.black,
                          onPress: () {
                            if (setImg != '' && categoryName.text != '') {
                              firestore
                                  .collection('categories')
                                  .doc(categoryName.text)
                                  .set({
                                'img': setImg,
                                'name': categoryName.text,
                                'posts': [],
                              }).then((value) => VxToast.show(context, msg: 'Категория успешно добавлена'))
                              
                              .then((value) => Get.back());
                            } else {
                              VxToast.show(context,
                                  msg:
                                      'Вы не выбрали фотого категории или не добавили название категории');
                            }
                          }),
                    )
                  ]),
            )));
  }
}

class Add_Post_to_Categories extends StatefulWidget {
  final String? selectedCategory;
  const Add_Post_to_Categories({super.key, required this.selectedCategory});

  @override
  State<Add_Post_to_Categories> createState() => _Add_Post_to_CategoriesState();
}

class _Add_Post_to_CategoriesState extends State<Add_Post_to_Categories> {
  var controller = Get.put(AuthController());
  String setImg = '';
  TextEditingController postName = TextEditingController();
  TextEditingController postTag1 = TextEditingController();
  TextEditingController postTag2 = TextEditingController();
  TextEditingController postTag3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: context.screenHeight,
            color: Colors.black,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: context.height / 14),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                     
                      customTextField(
                        title: 'Название Поста',
                        hint: 'Half-life',
                        controller: postName,
                      ),
                       Stack(
                        children: [
                          Center(
                            child: Card(
                              elevation: 5,
                              child: Container(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  setImg,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/photo.png',
                                      fit: BoxFit.contain,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                         
                        ],
                      ).onTap(() {
                        if(postName.text == ''){
                          VxToast.show(context, msg: 'Для начала введите название поста');

                        }
                        else{
                        controller
                            .uploadPostImage(context, postName.text )
                            .then((value) {
                          if (value == '') {
                            return;
                          } else {
                            setState(() {
                              setImg = value;
                            });
                          }
                        });}
                      }),
                      customTextField(
                        title: 'Тэг 1',
                        hint: 'игры',
                        controller: postTag1,
                      ),
                      customTextField(
                        title: 'Тэг 2',
                        hint: 'half-life 3',
                        controller: postTag2,
                      ),
                      customTextField(
                        title: 'Тэг 3',
                        hint: 'Alyx',
                        controller: postTag3,
                      ),
                      Container(
                        width: double.infinity,
                        child: ourButton(
                            color: white,
                            title: 'Добавить Пост',
                            textColor: Colors.black,
                            onPress: () {
                              if (setImg != '' &&
                                  postName.text != '' &&
                                  postTag1.text != '' &&
                                  postTag2.text != '' &&
                                  postTag3.text != '') {
                                controller.addPostToCategory(
                                  post_name: postName.text,
                                  img: setImg,
                                  category: widget.selectedCategory,
                                  author: auth.currentUser!.email,
                                  tag1: postTag1.text,
                                  tag2: postTag2.text,
                                  tag3: postTag3.text
                                );
                               VxToast.show(context, msg: 'Пост успешно добавлен в ${widget.selectedCategory}');
                               Get.back();
                                
                              }
                              else{
                                VxToast.show(context, msg: 'Проверьте ,все ли вы заполнили');
                              }
                            }),
                      )
                    ]),
              ),
            )));
  }
}
