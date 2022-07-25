import 'package:flutter/material.dart';
import 'package:shopping_ui/constant/theme/colors.dart';
import 'package:shopping_ui/product/pages/actiongame/detailscreen.dart';
import 'package:shopping_ui/product/pages/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class ActionGameList extends StatefulWidget {
  const ActionGameList({Key? key}) : super(key: key);

  @override
  State<ActionGameList> createState() => _ActionGameListState();
}

class _ActionGameListState extends State<ActionGameList> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }
  //_ActionGameListState(this.documentId);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      elevation: 0.8,
        backgroundColor: Color.fromARGB(255, 212, 246, 255),
        title: Text(
          "Action Game",
          style: TextStyle(color: accent),
        ),
        actions: <Widget> [
              IconButton(
                  onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchPage())),
                  icon: Icon(Icons.search), color: accent,),
            ],
      ),
      
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("action").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return SizedBox(
            height: 700,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      title: snapshot.data!.docs[index]['gTitle'],
                      price: snapshot.data!.docs[index]['gPrice'],
                      imgurl: snapshot.data!.docs[index]['imgurl'],
                      press: () {
                       
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen([index])));
                      }, 
                    ) 
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }
}

class Card extends StatelessWidget {
  final String title, price, imgurl;
  //final int price;
  final GestureTapCallback press;

  const Card({
    Key? key,
    required this.title,
    required this.price,
    required this.imgurl,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: press,
        child: Container(
          color: bar,
          width: 350,
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    child: Image.network(
                      '$imgurl',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(
                      // horizontal: 15,
                      // vertical: 10,
                    ),
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "$title\n",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "￦$price",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}