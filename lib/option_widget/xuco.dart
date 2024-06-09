import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Xuco extends StatefulWidget {
  const Xuco({super.key});
  @override
  State<Xuco> createState() => _XucoState();
}

final app = FirebaseFirestore.instance;

class _XucoState extends State<Xuco> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xử lí sự cố"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
              stream: app.collection('help').doc('help').snapshots(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return const CircularProgressIndicator();
                }
                Map<String, dynamic> data =
                    snapshots.data!.data() as Map<String, dynamic>;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      try {
                        String key = data.keys.elementAt(index);
                        Map<String, dynamic> help = data[key];
                        return dulieusuco(key, help);
                      } catch (e) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 250,
                              color: Colors.amber,
                              child: const Text("Lỗi dữ liệu")),
                        );
                      }
                    });
              }),
        ),
      ),
    );
  }

  Padding dulieusuco(String key, Map<String, dynamic> help) {
    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200,
                          color: const Color.fromARGB(255, 230, 229, 227),
                          child: Column(
                            children: [
                              Text(
                                key,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Tài khoản: "),
                                  Text(
                                    help['email'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Lí do:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(help['lido']),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              help['trangthai'] == false? option(help):const Text("Đã được xử lí",style: TextStyle(color: Color.fromARGB(255, 24, 207, 64),fontWeight: FontWeight.w700,fontSize: 25),)
                            ],
                          ),
                        ),
                      );
  }

  Row option(Map<String, dynamic> help) {
    return Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    height: 65,
                                    width: 65,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 162, 226, 212),
                                        borderRadius:
                                            BorderRadius.circular(65)),
                                    child: IconButton(
                                        onPressed: () async{
                                          String formattedDate = "";
                                          DateTime datetime = DateTime.now();
                                          formattedDate = DateFormat('yyyy-MM-dd – kk:mm:ss').format(datetime);
                                          final up  = app.collection('help').doc('help');
                                          final json = {
                                            '${help['time']}':{
                                              'time':help['time'],
                                              'email':help['email'],
                                              'lido':help['lido'],
                                              'option':help['option'],
                                              'trangthai':true,
                                              'timexl':formattedDate,
                                            },
                                          };
                                          await up.update(json); 
                                        },
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ))),
                                Container(
                                    height: 65,
                                    width: 65,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 226, 171, 171),
                                        borderRadius:
                                            BorderRadius.circular(65)),
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.not_interested_rounded,
                                          color: Colors.red,
                                        )))
                              ],
                            );
  }
}
