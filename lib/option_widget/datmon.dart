import 'package:app/thongtinfood.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/option_widget/map_food.dart';

class Datmon extends StatefulWidget {
  const Datmon({super.key});

  @override
  State<Datmon> createState() => _DatmonState();
}

class _DatmonState extends State<Datmon> {
  @override
  void initState() {
    super.initState();
    laydulieu();
  }

  // ignore: non_constant_identifier_names
  final auth = FirebaseAuth.instance;
  int sodu = 0;
  // ignore: non_constant_identifier_names
  String email_signin = "";
  String hovaten = "";
  String hi = " *** ";
  // ignore: non_constant_identifier_names
  String background_image = "";
  final app = FirebaseFirestore.instance;

  Future<void> laydulieu() async {
    User? username = auth.currentUser;
    if (kDebugMode) {
      email_signin = username!.email!;
    }
    DocumentSnapshot document =
        await app.collection('taikhoan').doc(email_signin).get();
    if (document.exists) {
      setState(() {
        sodu = document['sodu'];
        hovaten = document['hoten'];
        // background_image = document['backgroud'];
      });
      final save = await SharedPreferences.getInstance();
      await save.setString('background_image', background_image);
    } else {
      if (kDebugMode) {
        print('Document does not exist');
      }
    }
  }

  // ignore: non_constant_identifier_names
  bool visiable_money = false;
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        bool exis = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Bạn có muốn thoát không?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("No")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          auth.signOut();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Bạn đã đăng xuất ")));
                        },
                        child: const Text("Yes"))
                  ],
                ));
        return exis;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 209, 198, 132)
                        .withOpacity(0.3)),
                height: 122,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.green),
                        )),
                    Positioned(
                        top: 18,
                        left: 140,
                        child: Row(
                          children: [
                            const Text(
                              "Name:  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                            Text(
                              hovaten,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 14, 161, 63),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                          ],
                        )),
                    Positioned(
                      top: 55,
                      left: 140,
                      child: Row(
                        children: [
                          const Text(
                            "Số dư:   ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                          // ignore: dead_code
                          Text(
                            visiable_money ? "$sodu" : hi,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 14, 161, 63),
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  visiable_money = !visiable_money;
                                });
                              },
                              icon: const Icon(Icons.remove_red_eye_outlined))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: heightScreen -
                  kBottomNavigationBarHeight -
                  AppBar().preferredSize.height -
                  180,
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                height: heightScreen -
                    kBottomNavigationBarHeight -
                    AppBar().preferredSize.height -
                    180,
                child: StreamBuilder(
                    stream: app.collection('shop').snapshots(),
                    builder: (context, snapshots) {
                      if (!snapshots.hasData) {
                        return const CircularProgressIndicator();
                      }
                      // ignore: unused_local_variable
                      List<QueryDocumentSnapshot> document =
                          snapshots.data!.docs;
                      return ListView.builder(
                          itemCount: document.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> data =
                                document[index].data() as Map<String, dynamic>;
                            MapFood mapFood = MapFood.fromMap(data);
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                child: GestureDetector(
                                  onTap: (){
                                    if (kDebugMode) {
                                      print(index);
                                    }
                                    if (kDebugMode) {
                                      print(mapFood.name);
                                    }
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ThongtinFood(namefood:mapFood.name ,)));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.green.withOpacity(0.3)),
                                      height: 200,
                                      width: widthScreen,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: 200,
                                                height: 184,
                                                child:
                                                    Image.network(mapFood.image[0],fit: BoxFit.cover,),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              top: 0,
                                              left: 220,
                                              child: Text(
                                                mapFood.name,
                                                style: const TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white),
                                              )),
                                          Positioned(
                                              top: 150,
                                              left: 220,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text("Giá cả:  ${mapFood.cost} ",style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.red),),
                                                      mapFood.giamgia >0?Text("(-${mapFood.giamgia}%)"):Container()
                                                    ],
                                                  
                                                  ),
                                                  mapFood.giamgia >0?Text(" ${(100-mapFood.giamgia)/100*mapFood.cost} VND"):Container()
                                                ],
                                              )),
                                  
                                  
                                        ],
                                      )),
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ),
            const SizedBox(
              height: kBottomNavigationBarHeight,
            )
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Padding switch_food(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black.withOpacity(0.2)),
          height: 38,
          child: TextButton(onPressed: () {}, child: Text(label))),
    );
  }
}
