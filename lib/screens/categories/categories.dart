import 'package:artclub/consts/clrs.dart';
import 'package:artclub/firebase_service/firebase_functions.dart';
import 'package:artclub/screens/add_post/add_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:velocity_x/velocity_x.dart';

class Categories_Screen extends StatelessWidget {
  const Categories_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      decoration:  BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
              start_color2  ,
                end_color2])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        
          
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
                                 Get.to(()=>Selected_Category(selectedCategory: data[index]['name'].toString()));
                                });
                              }),
                            );
                          }
                        })),
                  ],
                )
              ]))
    )));
  }
}
class Selected_Category extends StatefulWidget {
final String? selectedCategory;

  Selected_Category({super.key,required this.selectedCategory});

  @override
  State<Selected_Category> createState() => _Selected_CategoryState();
}

class _Selected_CategoryState extends State<Selected_Category> {
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
          title: Text(widget.selectedCategory.toString(),style: TextStyle(color: Colors.black),),

        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(10),
           
    
          
            
              
              child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('categories').where('name',isEqualTo:widget.selectedCategory )
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
              itemCount: data[0]['posts'].length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        data[0]['posts'][index]['img'],
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
                         data[0]['posts'][index]['name'],
                         
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
                                      data[0]['posts'][index]['name'],
                                      
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
                                              "Тэги : ${data[0]['posts'][index]['tags'].join(",")}",
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                             'Автор: ' + data[0]['posts'][index]['author'],
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600),
                                                  
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              "Категория: " + data[0]['posts'][index]['category'],
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
                                            url: data[0]['posts'][index]['img'],
                                            name: data[0]['posts'][index]['name'],
                                            context: context,
                                            img: data[0]['posts'][index]['img'],
                                            tag1: data[0]['posts'][index]['tags'][0],
                                            tag2: data[0]['posts'][index]['tags'][1],
                                            tag3: data[0]['posts'][index]['tags'][2],
                                            author: data[0]['posts'][index]['author'],
                                            category: data[0]['posts'][index]['category'],
            
            
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
  }
}