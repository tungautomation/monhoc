import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:app/option_widget/giohang.dart';
import 'package:app/option_widget/map_food.dart';

// ignore: must_be_immutable
class ThongtinFood extends StatefulWidget {
  String? namefood;
  
  // ignore: use_key_in_widget_constructors
  ThongtinFood({required this.namefood});

  @override
  State<ThongtinFood> createState() => _ThongtinFoodState();
}
final auth = FirebaseAuth.instance;
class _ThongtinFoodState extends State<ThongtinFood> {
  String? tong;
  
  User? user = auth.currentUser;

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("${widget.namefood}")),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('shop')
                .doc(widget.namefood)
                .snapshots(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final data = snapshot.data!.data() as Map<String, dynamic>;
              MapFood mapfood = MapFood.fromMap(data);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 300,
                      child: PageView.builder(
                          itemCount: mapfood.image.length,
                          itemBuilder: (context, index) {
                            return Image.network(mapfood.image[index],
                                fit: BoxFit.cover);
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blue,
                      child: Center(
                          child: Text(
                        mapfood.name,
                        style: const TextStyle(fontSize: 30),
                      )),
                    ),
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Giá thành: ${mapfood.cost}",
                                style: const TextStyle(fontSize: 18),
                              ),
                              mapfood.giamgia>0 ?Text("(-${mapfood.giamgia}%)"):Container(),
                            ],
                          ),
                          
                          mapfood.giamgia > 0
                              ? Text(
                                  "Giá :${(100 - mapfood.giamgia) / 100 * mapfood.cost} VND",
                                  style: const TextStyle(color: Colors.red),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 122, 122, 121),
              child: Text(mapfood.mota,style:const TextStyle(fontSize: 20,color: Colors.white ),),

            ),
            const SizedBox(
              height:70,
            )
                  ],
                ),
              );
            })),
      ),
      bottomSheet: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 30,),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('shop').doc(widget.namefood).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(!snapshot.hasData)
                    {
                      return const CircularProgressIndicator();
                    }
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    MapFood mapfood = MapFood.fromMap(data);
                    return Text("${mapfood.cost*(100-mapfood.giamgia)/100} VND",style: const TextStyle(color: Colors.red,fontSize: 20),);
                  },
                ),
              ],
            ),
            Row(
              
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('shop').doc(widget.namefood).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(!snapshot.hasData)
                    {
                      return const CircularProgressIndicator();
                    }
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    MapFood mapfood = MapFood.fromMap(data);
                    return 
                GestureDetector(
                  onTap: ()
                  async{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã thêm vào thư mục ")));
                    final jsonk = {
                      'cost':mapfood.cost,
                      'image':mapfood.image,
                      'nhasx':"(${mapfood.email})",
                      'giamgia':mapfood.giamgia,
                      'name':mapfood.name,
                      'trangthai':false,
                    };
                    final json = {
                      "${widget.namefood}":jsonk,
                    };
                    await app.collection('dathang').doc(user!.email).update(json);
                  },
              child: Container(
                height: 60,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 139, 138, 138).withOpacity(0.2),
                ),
                child: const Column(
                  children: [
                    Center(child: Icon(Icons.shopping_bag_rounded,size: 30,)),
                    Text("Thêm vào giỏ hàng ",style: TextStyle(fontSize: 8),),
                  ],
                ),
                
              ));
                  }
                
                ),
            GestureDetector(
              onTap: (){
                if (kDebugMode) {
                  print(1);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                 color: Colors.red, 
                 borderRadius: BorderRadius.circular(20),
                ),
                
                height: 50,
                width: 120,
                child: const Center(child: Text("Đặt món",style: TextStyle(fontWeight:FontWeight.w700,fontSize: 18, ),)),
              ),
            ),
              ],
            )
            ],
        ),
      ),
    );
  }
}
