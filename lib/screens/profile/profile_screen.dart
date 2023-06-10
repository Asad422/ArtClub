import 'package:artclub/auth/signup_screen.dart';
import 'package:artclub/common_widgets/our_button.dart';
import 'package:artclub/common_widgets/textfield.dart';
import 'package:artclub/consts/clrs.dart';
import 'package:artclub/firebase_service/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:artclub/firebase_service/firebase_functions.dart';

class Profile_Screen extends StatefulWidget {
  const Profile_Screen({super.key});

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
  var controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
       
        actions: [
        
          IconButton(onPressed: (){
            Get.to(()=> Change_Profile_Screen());
          }, icon: Icon(Icons.edit,color:  Colors.white,)
          ),
          IconButton(onPressed: ()async {
             auth.signOut().then((value) => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpScreen()))});
          
          }, icon: Icon(Icons.exit_to_app,color:  Colors.white,)
          )
        ],
      ),
      body:  
      
           StreamBuilder(stream:controller.getUserInfo(auth.currentUser!.email.toString()),
           
            
             builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
               
               if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
      
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
      
              return Container(
                height: context.screenHeight,
                color:   Colors.black,
              
                  child: ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return  Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                             ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                               child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                       color: white,
                                     
                                    ),
                                width: 100,
                                height: 100,
                                                   child: Image.network(
                                                    
                                data['image_avatar'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text('Нет аватара',style: TextStyle(
                                      color: white,
                                      fontSize: 20,
                                    ),
                                    ),
                                  );
                                },
                                
                                ),
                                       
                                
                                                   ),
                             ),
                            data['name'].toString().text.color(white).size(25).make(),
                            data['email'].toString().text.color(white).size(20).make(),
                            10.heightBox,
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               
                                Container(
                            width: 150,
                            height: 150,
                            child: Card(color: Colors.white,
                            child: Center(child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(data['my_posted_posts'].length.toString(),),
                              Text('Созданные'),
                              Icon(Icons.account_box,color: Colors.purple,)
                            ],)),
                            )).onTap(() {
                              Get.to(()=>Posted_Posts());
                            }),
                            Container(
                            width: 150,
                            height: 150,
                            child: Card(color: Colors.white,
                            child: Center(child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                              
                              children: [
                                Text(data['my_saved_posts'].length.toString(),),
                              Text('Сохраненные'),
                              Icon(Icons.save,color: Colors.purple,)
                            ],)),
                            )).onTap(() {
                              Get.to(()=>Saved_Posts());
                            })


                           
                             ],
                           ),
                           
                           

                           
                            ],
                          );
                        })
                        .toList()
                        .cast(),
                  ),
                
              );
  }),
      ),
         
       );}
    
  }



  class Change_Profile_Screen extends StatefulWidget {
    const Change_Profile_Screen({super.key});
  
    @override
    State<Change_Profile_Screen> createState() => _Change_Profile_ScreenState();
  }
  
  class _Change_Profile_ScreenState extends State<Change_Profile_Screen> {
    TextEditingController username = TextEditingController();
     var controller = Get.put(AuthController());
     String changeImg = '';
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(color: Colors.black,
child :
                 Padding(
                   padding:  EdgeInsets.only(top: context.height /14),
                   child: Column(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.start,
                             
                             
                             children: [
                               Stack(
                                 children: [
                     Center(
                       child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                          child: Container(
                            width: 100,
                            height: 100,
                            color: Colors.white,
                            child: Image.network(
                              
                              changeImg,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return  Image.asset(
                            'assets/images/avatar.png',
                            fit: BoxFit.contain,
                            );
                              },
                              
                              ),
                          ),
                             
                            
                          ),
                     ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Icon(Icons.edit,color: Colors.grey,),
                        )
                                 ],
                               ).onTap(() {
                                 controller.uploadImage(context,auth.currentUser!.email).then((value) {
                      if(value ==  '') {
                        return;
                      }else{
                        setState(() {
                          changeImg = value;
                        });
                      }
                                 });
                               })
                                ,
                         
                             
                        
                         
                         
                             customTextField(
                               title: 'Новое имя аккаунта',
                               hint: 'New G-Man',
                               controller: username,
                             ),
                         
                             Container(
                               width: double.infinity,
                               child: ourButton(
                                 color: white,
                                 title: 'Изменить',
                                 textColor: Colors.black,
                                 onPress: (){
                    if(changeImg != '' &&  username.text != ''){
                        firestore.collection('users').doc(auth.currentUser!.email).update({
                        'image_avatar' : changeImg,
                        'name' : username.text
                    }).then((value) => Get.back());
                    }
                    if(changeImg == ''  && username.text != ''){
                         firestore.collection('users').doc(auth.currentUser!.email).update({
                        'name' : username.text
                    }).then((value) => Get.back());
                    }
                     if(changeImg != ''  && username.text == ''){
                         firestore.collection('users').doc(auth.currentUser!.email).update({
                       'image_avatar' : changeImg,
                    }).then((value) => Get.back());
                    }
                  
                    
                                 }
                               ),
                             )
                         
                         
                         
                         
                           ]
                   ),
                 )));
    }
  }


class Saved_Posts extends StatefulWidget {
  const Saved_Posts({super.key});

  @override
  State<Saved_Posts> createState() => _Saved_PostsState();
}

class _Saved_PostsState extends State<Saved_Posts> {
     var controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return   Container(
      decoration:  BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
              start_color2  ,
                end_color2])),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Сохраненные',style: TextStyle(color: Colors.black),),

        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(10),
           
    
          
            
              
              child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users').where('email',isEqualTo:auth.currentUser!.email )
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
                              return 
                    
                    MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: data[0]['my_saved_posts'].length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        data[0]['my_saved_posts'][index]['img'],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return CircularProgressIndicator(color: white,);
                        }
                      ),
                    
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                         data[0]['my_saved_posts'][index]['name'],
                         
                          style: const TextStyle(
                          color: white,     fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 30),
                                  height: MediaQuery.of(context).size.height / 2,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                      data[0]['my_saved_posts'][index]['name'],
                                      
                                        style: TextStyle(
                                        
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 17,
                                      ),
                                     
              
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 7, horizontal: 15),
                                        child: Divider(
                                          color: Colors.grey,
                                          height: 5,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:  [
                                            Text(
                                              "Тэги : ${data[0]['my_posted_posts'][index]['tags'].join(",")}",
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                             'Автор: ' + data[0]['my_posted_posts'][index]['author'],
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600),
                                                  
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              "Категория: " + data[0]['my_posted_posts'][index]['category'],
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                     
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Icon(Icons.more_horiz),
                        ),
                      ],
                    )
                  ],
                );
                            });}
              })),
            )),
    );
  }
}

class Posted_Posts extends StatefulWidget {
  const Posted_Posts({super.key});

  @override
  State<Posted_Posts> createState() => _Posted_PostsState();
}

class _Posted_PostsState extends State<Posted_Posts> {
   var controller = Get.put(AuthController());
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Созданные',style: TextStyle(color: Colors.black),),

        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(10),
           
    
          
            
              
              child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users').where('email',isEqualTo:auth.currentUser!.email )
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
                              return 
                    
                    MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: data[0]['my_posted_posts'].length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        data[0]['my_posted_posts'][index]['img'],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return CircularProgressIndicator(color: white,);
                        }
                      ),
                    
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                         data[0]['my_posted_posts'][index]['name'],
                         
                          style: const TextStyle(
                          color: white,     fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 30),
                                  height: MediaQuery.of(context).size.height / 2,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                      data[0]['my_posted_posts'][index]['name'],
                                      
                                        style: TextStyle(
                                        
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 17,
                                      ),
                                     
              
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 7, horizontal: 15),
                                        child: Divider(
                                          color: Colors.grey,
                                          height: 5,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:  [
                                            Text(
                                              "Тэги : ${data[0]['my_posted_posts'][index]['tags'].join(",")}",
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                             'Автор: ' + data[0]['my_posted_posts'][index]['author'],
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600),
                                                  
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              "Категория: " + data[0]['my_posted_posts'][index]['category'],
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                     
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Icon(Icons.more_horiz),
                        ),
                      ],
                    )
                  ],
                );
                            });}
              })),
            )),
    );
  }
}