import 'package:artclub/consts/clrs.dart';
import 'package:artclub/firebase_service/firebase_functions.dart';
import 'package:artclub/screens/add_post/add_post.dart';
import 'package:artclub/screens/categories/categories.dart';
import 'package:artclub/screens/home/home_screen.dart';
import 'package:artclub/screens/profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:velocity_x/velocity_x.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  int _selectedIndex = 0;
  List  <Widget> options = [
    Home_Page_Screen(),
    Categories_Screen(),
    Add_Post_Screen(),
    Profile_Screen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
  

        body:  options.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
showUnselectedLabels: false,
          items: [
          BottomNavigationBarItem(
            
            
            icon: Icon(Icons.home),
            label: 'f'
            ),
          BottomNavigationBarItem(label: 'f',icon: Icon(
            Icons.category)),

          BottomNavigationBarItem(label: 'f',
            icon: Icon(Icons.add
          )),
          BottomNavigationBarItem(label: 'f',
            icon: Icon(Icons.person)),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap:_onItemTapped ,
        ),
    );
  }
}


class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
   String name = "";
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Card(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                  prefixIcon: Icon(Icons.search), hintText: 'Найти...'),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: StreamBuilder<QuerySnapshot>(
            stream: (name != "" && name != null)
                ? FirebaseFirestore.instance
                    .collection('posts')
                    .where("tags", arrayContains: name)
                    .snapshots()
                : FirebaseFirestore.instance.collection("posts").snapshots(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(child: CircularProgressIndicator())
                  :   MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data =  snapshot.data!.docs[index];
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            data['img'],
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
                             data['name'],
                             
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
                                          data['name'],
                                          
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
                                                  "Тэги : ${data['tags'].join(",")}",
                                                  style: TextStyle(fontSize: 14),
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                 'Автор: ' + data['author'],
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight: FontWeight.w600),
                                                      
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Text(
                                                  "Категория: " + data['category'],
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
                                                url: data['img'],
                                                name: data['name'],
                                                context: context,
                                                img: data['img'],
                                                tag1: data['tags'][0],
                                                tag2: data['tags'][1],
                                                tag3: data['tags'][2],
                                                author: data['author'],
                                                category: data['category'],
                
                
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
                                });
            },
          ),
        ),
      ),
    );
  }
}
