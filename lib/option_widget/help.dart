import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app/homescreen.dart';
import 'package:app/option_widget/giohang.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

final auth = FirebaseAuth.instance;

class _HelpState extends State<Help> {
  User? user = auth.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Text("Trợ giúp"),
          ],
        ),
      ),
      // body: ,

      bottomSheet: Container(
        color: const Color.fromARGB(255, 252, 246, 246),
        height: 60,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              option == true
                  ? sendMesseage(0, "Tôi muốn dừng bán hàng ")
                  : Container(),
              option == false
                  ? sendMesseage(1, "Tôi muốn chuyển sang bán hàng ")
                  : Container(),
              sendMesseage(2, "Tôi muốn tố cáo nhà bán hàng ?"),
              sendMesseage(
                  3, "Tôi muốn biết được số sản phẩm tôi đã bán được?"),
              sendMesseage(4, "Tôi muốn tạm dừng sản xuất"),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
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
                        final String key = data.keys.elementAt(index);
                        Map<String, dynamic> help = data[key];
                        return help['email'] == user!.email
                            ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 180,
                                  color: index%2==0?const Color.fromARGB(255, 211, 210, 210):const Color.fromARGB(255, 228, 227, 226),
                                  child:Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text("Thời gian xử lí:$key",style: const TextStyle(color: Colors.red),),
                                        const SizedBox(height: 10,),
                                        Text("Lỗi xử lí : ${help['lido']}",style: const TextStyle(fontSize: 16,color: Colors.green),),
                                        const SizedBox(height: 30,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const Text("Trạng thái :",style: TextStyle(fontWeight: FontWeight.w700),),
                                            Text(help['trangthai'] == true?"Đã xử lí":"Chưa xử lí",style: TextStyle(fontWeight: FontWeight.w700,color: help['trangthai'] == true?Colors.green:Colors.red),)
                                          ],
                                        ),
                                        help['trangthai']?SizedBox(
                                          height: 30,
                                          child: Text(help['timexl']), 
                                        ):const SizedBox(
                                          height: 10,
                                          child: Text(""),
                                        )

                                      ],
                                    ),
                                  ),
                                ),
                            )
                            : Container();
                      // ignore: empty_catches
                      } catch (e) {}
                      return null;
                    });
              }),
        ),
      ),
    );
  }

  TextButton sendMesseage(int lot, String label) => TextButton(
      onPressed: () async {
        String formattedDate = "";
        DateTime datetime = DateTime.now();
        formattedDate = DateFormat('yyyy-MM-dd – kk:mm:ss').format(datetime);
        final update = app.collection('help').doc('help');
        final json = {
          'time':formattedDate,
          'email': user!.email,
          'lido': label,
          'trangthai': false,
          'option': lot

        };
        final jsonk = {
          formattedDate: json,
        };
        await update.update(jsonk);
      },
      child: Text(label));
}
