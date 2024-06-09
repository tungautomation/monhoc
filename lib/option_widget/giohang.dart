
import 'package:app/option_widget/maporderfood.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Giohang extends StatefulWidget {
  const Giohang({super.key});

  @override
  State<Giohang> createState() => _GiohangState();
}

final app = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
List<bool> luachon = [];
// ignore: non_constant_identifier_names
List<double> cost_luachon = [];
 double tong =0;
class _GiohangState extends State<Giohang> {
 
  bool values = false;
  User? user = auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  120 -
                  kBottomNavigationBarHeight,
              child: StreamBuilder(
                stream: app.collection('dathang').doc(user!.email).snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text("Không có dữ liệu về đơn hàng");
                  }

                  try {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;

                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          String key = data.keys.elementAt(index);
                          Map<String, dynamic> donhangfood = data[key];
                          MapOrderFood oder = MapOrderFood.fromMap(donhangfood);
                          try {
                            for (var i = luachon.length - 1;
                                i < data.length - 1;
                                i++) {
                              luachon.add(false);
                              cost_luachon.add(0);
                            }
                            // ignore: empty_catches
                          } catch (e) {}

                          cost_luachon[index] = (oder.cost)*(100-oder.giamgia)/100;

                          return SingleChildScrollView(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Checkbox(
                                        value: luachon[index],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            luachon[index] = value!;
                                            if (kDebugMode) {
                                              print(luachon);
                                              print(cost_luachon);
                                              tong = tinhtong(data.length);
                                              print(tong);
                                            }
                                          });
                                        }),
                                        const SizedBox(height: 40,),
                                    IconButton(onPressed: ()
                                    async{
                                      if (kDebugMode) {
                                        print(index);
                                      }
                                      update(index, data.length);
                                      if(luachon.isEmpty)
                                      {
                                        setState(() {
                                          tong = 0;
                                        });
                                      }
                                      await app.collection('dathang').doc(user!.email).update({oder.name:FieldValue.delete()});
                                    }, icon: const Icon(Icons.delete,))
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 150,
                                      color: Colors.amber,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 160,
                                            child: Image.network(
                                              oder.image[0],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                oder.name,
                                                style: const TextStyle(fontSize: 23),
                                              ),
                                              Text(oder.nhasx),
                                              const SizedBox(height: 12,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Giá gốc: ${oder.cost}",style: const TextStyle(fontSize: 18),),
                                                  Text("(-${oder.giamgia}%)",style: const TextStyle(fontSize: 12,color: Colors.red),),
                                                ],
                                              ),
                                              Text("Giá: ${oder.cost/100*(100-oder.giamgia)} VND",style: const TextStyle(fontWeight: FontWeight.w600),)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  } catch (e) {
                    return const Center(
                        child: Text('Bạn chưa có đơn hàng nào'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 35,
                ),
                Text(
                  "$tong VND",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            GestureDetector(
              onTap: (){
                if (kDebugMode) {
                  print(luachon);
                }
              },
              child: Container(
                width: 150,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25), color: Colors.red),
                child: const Center(child: Text("Thanh toán ")),
              ),
            )
          ],
        ),
      ),
    );
  }
  void update(int k,gioihan,)
  {
    for (var i = 0; i < gioihan-1; i++) {
        if(i>=k)
        {
          luachon[i] = luachon[i+1];
          cost_luachon[i] = cost_luachon[i+1];
        }
    }
    luachon.removeAt(gioihan-1);
    cost_luachon.removeAt(gioihan-1);
  }
  double tinhtong(int gioihan,)
  {
    double tongk = 0;
    for (var i = 0; i < gioihan; i++) {
      if(luachon[i] == true)
      {
        tongk+=cost_luachon[i];
      }
    }
    return tongk;
  }
}
