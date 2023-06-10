


import 'dart:io';
import 'dart:typed_data';

import 'package:artclub/firebase_service/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class AuthController extends GetxController{
    Future<String?> signUpMethoud({email,password,context})    async {
        try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    }
    

    Future<String?> logInMethod({email,password,context})    async {
       try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    
    }

    getUserInfo(email){
      
        final  response =   FirebaseFirestore.instance.collection('users').where("email",isEqualTo: email.toString()).snapshots();
        return response;
    }

 Future <String> uploadImage(context,name) async {
        late String imageUrl;
        ImagePicker imagePicker = ImagePicker();
       
        XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
        Reference referenceRoot = FirebaseStorage.instance.ref();
        if (file == null) return '';
        Reference referenceDirImage =referenceRoot.child('Avatars/$name');
      

        
         await  referenceDirImage.putFile(File(file.path));

         imageUrl = await  referenceDirImage.getDownloadURL();
          return imageUrl;
        

       
    }
    Future <String> uploadPostImage(context,name) async {
        late String imageUrl;
        ImagePicker imagePicker = ImagePicker();
       
        XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
        Reference referenceRoot = FirebaseStorage.instance.ref();
        if (file == null) return '';
        Reference referenceDirImage =referenceRoot.child('Posts/$name');
      

        
         await  referenceDirImage.putFile(File(file.path));

         imageUrl = await  referenceDirImage.getDownloadURL();
          return imageUrl;
        

       
    }
     Future <String> uploadCategoryImage(context,name) async {
        late String imageUrl;
        ImagePicker imagePicker = ImagePicker();
       
        XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
        Reference referenceRoot = FirebaseStorage.instance.ref();
        if (file == null) return '';
        Reference referenceDirImage =referenceRoot.child('Categories/$name');
      

        
         await  referenceDirImage.putFile(File(file.path));

         imageUrl = await  referenceDirImage.getDownloadURL();
          return imageUrl;
        

       
    }
    addPostToCategory(
        
        { String ? post_name,
       String? img,
         String? tag1,String? tag2,String? tag3,
        String ? author,
        String? category,
        
        }) {
  Map<String, dynamic> post = {
  'img':  img ,
  'name' :post_name,
  'author' : author,
  'category':category,
  'tags' :[
    tag1,
    tag2,
    tag3,
  ],
};
  DocumentReference store =   firestore.collection('Posts').doc('Posts');
                                        store.update(
                                        {  'posts' :FieldValue.arrayUnion([post])
                                          });
  DocumentReference store_2 =   firestore.collection('categories').doc(category);
                                        store_2.update(
                                        {  'posts' :FieldValue.arrayUnion([post])
                                          });
  DocumentReference store_3 =   firestore.collection('users').doc(auth.currentUser!.email);
                                        store_3.update(
                                        {  'my_posted_posts' :FieldValue.arrayUnion([post])
                                          });
  DocumentReference store_4 = firestore.collection('posts').doc(post_name);
                    store_4.set({
                     'img':  img ,
  'name' :post_name,
  'author' : author,
  'category':category,
  'tags' :[
    tag1,
    tag2,
    tag3,
  ],
                    });
    
                                   
     }
 save({url ,name,context, String? img,
         String? tag1,String? tag2,String? tag3,
        String ? author,
        String? category,}) async {
   Map<String, dynamic> post = {
  'img':  img ,
  'name' :name,
  'category':category,
  'tags' :[
    tag1,
    tag2,
    tag3,
  ],
};
  var status = await Permission.storage.request();
  if (status.isGranted){
   var response = await Dio().get(
           url,
           options: Options(responseType: ResponseType.bytes));
   await ImageGallerySaver.saveImage(
           Uint8List.fromList(response.data),
           quality: 80,
           name: name);
          


    FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.email).update({
      'my_saved_posts' : FieldValue.arrayUnion([post])
    });

   }

    

  }



  
}
  


    

