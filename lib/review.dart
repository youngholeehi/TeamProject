import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Review extends StatefulWidget {
  const Review({super.key});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final String colName = "review";
  final String fnName = "name";
  final String fnDescription = "description";
  final String fnDatetime = "datetime";

  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _newDescCon = TextEditingController();
  TextEditingController _undNameCon = TextEditingController();
  TextEditingController _undDescCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: getBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0.8,
        backgroundColor: Color.fromARGB(255, 212, 246, 255),
        title: Text(
          "Review",
          style: TextStyle(color: Color.fromARGB(255, 7, 201, 255), fontWeight: FontWeight.bold),
        ),
        actions: <Widget> [
              IconButton(
                  onPressed: showCreateDocDialog,
                  icon: Icon(Icons.text_fields), color: Color.fromARGB(255, 7, 201, 255),),
            ],
        // actions: <Widget> [
        //       IconButton(
        //           onPressed: () => Navigator.of(context)
        //           .push(MaterialPageRoute(builder: (_) => const SearchPage())),
        //           icon: Icon(Icons.search), color: accent,),
        //     ],
    );
  }

  Widget getBody() {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 500,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(colName)
                                                .orderBy(fnDatetime, descending: true)
                                                .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text("Error: ${snapshot.error}");
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    return ListView(
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot document) {
                        Timestamp tt = document[fnDatetime];
                        String dt = timestampToStrDateTime(tt);

                        return Container(
                          padding: EdgeInsets.all(5),
                          //elevation: 5,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 179, 238, 255),
                              borderRadius: BorderRadius.circular(100) 
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      document[fnName],
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      dt.toString(),
                                      style: TextStyle(color: Colors.grey[600]),
                                    )
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    document[fnDescription],
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void createDoc(String name, String description) {
    FirebaseFirestore.instance.collection(colName).add({
      fnName: name,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
    });
  }

  void showCreateDocDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("리뷰 작성 탭"),
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: "이름"),
                  controller: _newNameCon,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "내용"),
                  controller: _newDescCon,
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("취소"),
              onPressed: () {
                _newNameCon.clear();
                _newDescCon.clear();
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text("작성"),
              onPressed: () {
                if (_newDescCon.text.isNotEmpty &&
                    _newNameCon.text.isNotEmpty) {
                  createDoc(_newNameCon.text, _newDescCon.text);
                }
                _newNameCon.clear();
                _newDescCon.clear();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  String timestampToStrDateTime(Timestamp tt) {
    return DateTime.fromMillisecondsSinceEpoch(tt.millisecondsSinceEpoch)
        .toString();
  }
}