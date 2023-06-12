import 'package:artclub/consts/clrs.dart';
import 'package:artclub/firebase_service/firebase_functions.dart';
import 'package:artclub/home_screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart';
import 'package:velocity_x/velocity_x.dart';

class Home_Page_Screen extends StatefulWidget {

   Home_Page_Screen({super.key});

  @override
  State<Home_Page_Screen> createState() => _Home_Page_ScreenState();
}

class _Home_Page_ScreenState extends State<Home_Page_Screen> {
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
          actions: [IconButton(onPressed: ()=> Get.to(()=>Search()), icon: Icon(Icons.search))],
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(10),
           
    
          
            
              
              child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Posts')
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
                              var reverse = data[0]['posts'].reversed.toList();
                              return 
                    
                    MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount:reverse.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        reverse[index]['img'],
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
                        reverse[index]['name'],
                         
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
                                      reverse[index]['name'],
                                      
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
                                              "Тэги : ${reverse[index]['tags'].join(",")}",
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                             'Автор: ' + reverse[index]['author'],
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600),
                                                  
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              "Категория: " + reverse[index]['category'],
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          
                                          Navigator.pop(context);
                                          controller.save(
                                            url: reverse[index]['img'],
                                            name: reverse[index]['name'],
                                            context: context,
                                            img: reverse[index]['img'],
                                            tag1: reverse[index]['tags'][0],
                                            tag2: reverse[index]['tags'][1],
                                            tag3: reverse[index]['tags'][2],
                                            author: reverse[index]['author'],
                                            category: reverse[index]['category'],
            
            
                                      );
                                           VxToast.show(context, msg: 'Изображение ' + data[0]['posts'][index]['name'] + ' было успешно сохранено');
                                        
                                        },
                                      
                                          
                                      
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Colors.grey.shade300),
                                          child: Center(
                                            child: const Text("Сохранить",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600)),
                                          ),
                                        ),
                                      )
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
  }}


