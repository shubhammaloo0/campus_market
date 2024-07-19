import 'dart:ui';

import 'package:campus_market/HomeScreen/home_screen.dart';
import 'package:campus_market/Widgets/global_var.dart';
import 'package:campus_market/Widgets/listview_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget{

  String sellerId;
  ProfileScreen({required this.sellerId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  _buildBackButton()
  {
    return IconButton(
      icon:const Icon(Icons.arrow_back,color:Colors.black,),
      onPressed:()
      {
        Navigator.pushReplacement(context ,
            MaterialPageRoute(builder: (context) => HomeScreen()));
      },
    );
  }

  _buildUserImage()
  {
    return Container(
      width:50,
      height:40,
      decoration:BoxDecoration(
          shape:BoxShape.circle,
          image:DecorationImage(
              image:NetworkImage(adUserImageUrl),
              fit:BoxFit.fill
          )
      ),
    );
  }

  getResult()
  {
    FirebaseFirestore.instance
        .collection('items')
        .where('id' , isEqualTo:widget.sellerId)
        .where('status',isEqualTo:'approved')
        .get().then((results)
    {
      setState((){
        items = results;
        adUserName = items!.docs[0].get('userName');
        adUserImageUrl = items!.docs[0].get('imgPro');

      });
    });
  }

  //call upon initState for getResult

  @override
  void initState(){
    super.initState();
    getResult();
  }

  QuerySnapshot? items;
  @override
  Widget build(BuildContext context){
    return Container(
      decoration:const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue, Colors.lightBlueAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
      ),

      child:Scaffold(
          backgroundColor:Colors.transparent,
          appBar:AppBar(
          leading:_buildBackButton(),
      title: Row(
        children:[
          _buildUserImage(),
          const SizedBox(width: 10,),
          Text(adUserName,
            style: const TextStyle(fontWeight: FontWeight.bold),),
        ],
      ),
      flexibleSpace:Container(
        decoration:const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.lightBlue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
      ),
    ),
        body:StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('items')
                .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .orderBy('time',descending:true)
                .snapshots(),
          builder: (context, AsyncSnapshot snapshot)
          {
            if(snapshot.connectionState == ConnectionState.waiting)
            {
              return const Center(child: CircularProgressIndicator(),);

            }
            else if(snapshot.connectionState == ConnectionState.active)
            {
              if(snapshot.data!.docs.isNotEmpty)
              {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index)
                  {
                    return ListViewWidget(
                      docId: snapshot.data!.docs[index].id,
                      itemColor: snapshot.data!.docs[index]['itemColor'],
                      img1: snapshot.data!.docs[index]['urlImage1'],
                      img2: snapshot.data!.docs[index]['urlImage2'],
                      userImg: snapshot.data!.docs[index]['imgPro'],
                      name: snapshot.data!.docs[index]['userName'],
                      date: snapshot.data!.docs[index]['time'].toDate(),
                      userId: snapshot.data!.docs[index]['id'],
                      itemModel: snapshot.data!.docs[index]['itemModel'],
                      postId: snapshot.data!.docs[index]['postId'],
                      itemPrice: snapshot.data!.docs[index]['itemPrice'],
                      description : snapshot.data!.docs[index]['description'],
                      address : snapshot.data!.docs[index]['address'],
                      userNumber : snapshot.data!.docs[index]['userNumber'],
                    );
                  },
                );
              }
              else
              {
                return const Center(
                  child: Text('There is no tasks'),
                );
              }
            }
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            );
          },

      ),

    ),
    );//Scaffold
  }
}
