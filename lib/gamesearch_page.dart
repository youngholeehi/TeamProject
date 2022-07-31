import 'package:bordered_text/bordered_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shopping_ui/constant/json/constant.dart';
import 'package:shopping_ui/constant/theme/colors.dart';
import 'package:shopping_ui/product/components/detail.dart';
import 'package:shopping_ui/product/components/detail2.dart';
import 'package:shopping_ui/product/pages/actiongame/detailscreen.dart';
import 'package:shopping_ui/product/pages/actiongame/detailscreen2.dart';

class GameSearchPage extends StatefulWidget {
  @override
  _GameSearchPageState createState() => _GameSearchPageState();
}

class _GameSearchPageState extends State<GameSearchPage> {

  @override
  void initState() {
    super.initState();
  }
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: getBody(),
    );
  }

  Widget getBody() {
    return SafeArea(
      child: ListView(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 20, right: 20),
          //   // child: Row(
          //   //   mainAxisAlignment: MainAxisAlignment.center,
          //   //   children: [
          //   //     Text(
          //   //       "Phnom Penh",
          //   //       style: TextStyle(fontSize: 16),
          //   //     ),
          //   //     SizedBox(
          //   //       width: 10,
          //   //     ),
          //   //     Icon(
          //   //       FontAwesomeIcons.mapMarkerAlt,
          //   //       size: 20,
          //   //     )
          //   //   ],
          //   // ),
          // ),
          // SizedBox(
          //   height: 40,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20, right: 20),
          //   child: Text(
          //     "Find all \nstores here",
          //     style: TextStyle(
          //         fontSize: 30, height: 1.5, fontWeight: FontWeight.w400),
          //   ),
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20, right: 20),
          //   child: Row(
          //     children: [
          //       Flexible(
          //           child: Container(
          //         height: 45,
          //         decoration: BoxDecoration(
          //             color: grey.withOpacity(0.2),
          //             borderRadius: BorderRadius.circular(30)),
          //         child: Padding(
          //           padding: const EdgeInsets.only(left: 20),
          //           child: TextField(
          //             cursorColor: primary,
          //             decoration: InputDecoration(
          //                 border: InputBorder.none,
          //                 suffixIcon: Icon(
          //                   Feather.search,
          //                   size: 20,
          //                 ),
          //                 hintText: "게임 검색"),
          //           ),
          //         ),
          //       )),
          //       // SizedBox(
          //       //   width: 20,
          //       // ),
          //       // Container(
          //       //   height: 45,
          //       //   width: 45,
          //       //   decoration:
          //       //       BoxDecoration(color: black, shape: BoxShape.circle),
          //       //   child: Center(
          //       //     child: Icon(
          //       //       FontAwesomeIcons.mapMarkerAlt,
          //       //       color: white,
          //       //       size: 20,
          //       //     ),
          //       //   ),
          //       // )
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: 15,
          // ),
          // Divider(color: accent.withOpacity(1)),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              "인기 게임",
              style: TextStyle(fontSize: 22, color: black),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('products').orderBy('gPrice', descending: false).snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState == ConnectionState.waiting)?Center(
                      child: CircularProgressIndicator(),
                    )
                    :ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshots.data!.docs[index].data() as Map<String, dynamic>;
                        
                        if(name.isEmpty) {
                          return ListTile(
                            title: Text(
                              data['gTitle'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(
                              data['gPrice'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            leading: SizedBox(
                              width: 70,
                              height: 70,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(data['imgurl']),
                              ), 
                            ),
                            onTap: () {
                                  DetailInfo2 detailInfo2 = DetailInfo2(
                                    title: snapshots.data!.docs[index]['gTitle'],
                                    price: snapshots.data!.docs[index]['gPrice'],
                                    story: snapshots.data!.docs[index]['gStory'],
                                    ex: snapshots.data!.docs[index]['gEx'],
                                    spec: snapshots.data!.docs[index]['gSpec'], 
                                    imgurl: snapshots.data!.docs[index]['imgurl'],
                                    imgurl1: snapshots.data!.docs[index]['imgurl1'],
                                    imgurl2: snapshots.data!.docs[index]['imgurl2'],
                                    imgurl3: snapshots.data!.docs[index]['imgurl3'],
                                  );
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen2(detailInfo2: detailInfo2)));
                                },        
                          );
                        }
                        if(data['gTitle']
                            .toString()
                            .toLowerCase()
                            .contains(name.toLowerCase())) {
                              return ListTile(
                                title: Text(
                                  data['gTitle'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                subtitle: Text(
                                  data['gPrice'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(data['imgurl']),
                                ),
                                onTap: () {
                                  DetailInfo2 detailInfo2 = DetailInfo2(
                                    title: snapshots.data!.docs[index]['gTitle'],
                                    price: snapshots.data!.docs[index]['gPrice'],
                                    story: snapshots.data!.docs[index]['gStory'],
                                    ex: snapshots.data!.docs[index]['gEx'],
                                    spec: snapshots.data!.docs[index]['gSpec'], 
                                    imgurl: snapshots.data!.docs[index]['imgurl'],
                                    imgurl1: snapshots.data!.docs[index]['imgurl1'],
                                    imgurl2: snapshots.data!.docs[index]['imgurl2'],
                                    imgurl3: snapshots.data!.docs[index]['imgurl3'],
                                  );
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen2(detailInfo2: detailInfo2)));
                                },
                              );  
                            }
                            
                            return Container();
                      },
                    );
                  },
          ),
        ]
       )
    
    );
  }
}

class Card extends StatelessWidget {
  final String title, price, story, ex, spec,
        imgurl, imgurl1, imgurl2, imgurl3;
  //final int price;
  final GestureTapCallback press;

  const Card({
    Key? key,
    required this.title,
    required this.price,
    required this.story,
    required this.imgurl,
    required this.imgurl1,
    required this.imgurl2,
    required this.imgurl3,
    required this.press, 
    required this.ex, 
    required this.spec, 

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: 330,
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              children: [
                ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Image.network(
                      '$imgurl',
                      fit: BoxFit.cover,
                    ),
                    // Image.network(
                    //   '$imgurl2',
                    //   fit: BoxFit.cover,
                    // ),
                  ],
                ),
                
                // Container(
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.topCenter,
                //       end: Alignment.bottomCenter,
                //       colors: [
                //         accent,
                //         Color.fromARGB(0, 160, 160, 160),
                //       ],
                //     ),
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.only(
                    left: 10, top: 140
                  ),
                  child: BorderedText(
                    strokeWidth: 5,
                    strokeColor: accent,
                    child: Text(
                      "$title\n$price",
                      style: TextStyle(
                        fontSize: 20,
                        color: white,
                        fontWeight: FontWeight.bold
                        // decoration: TextDecoration.none,
                        // decorationColor: Colors.blue,
                      ),
                    ),
                  ),
                ),

                  // child: Text.rich(
                  //   TextSpan(
                  //     style: TextStyle(
                  //       color: Colors.white,  
                  //     ),
                  //     children: [
                  //       TextSpan(
                  //         text: "$title\n",
                  //         style: TextStyle(
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: "￦$price",
                  //         style: TextStyle(
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
