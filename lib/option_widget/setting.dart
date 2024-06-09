import 'package:app/homescreen.dart';
import 'package:app/option_widget/help.dart';
import 'package:app/option_widget/thongtinnguoidung.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final auth = FirebaseAuth.instance;
  final app = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: [

             const SizedBox(
              height: 10,
            ),
            switch_setting(0,"Thông tin cá nhân"),
            switch_setting(1, "Bảo mật"),
            switch_setting(2, "Trợ giúp"),
            option?switch_setting(3, "Sửa sản phẩm"):Container(),
            switch_setting(4, "Thời gian đăng nhập"),
            switch_setting(5, "Lịch sử đặt hàng"),
            switch_setting(6, "Đăng xuất"),
          ],   
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container switch_setting(slot,String label) {
    return Container(
            height: 70,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: slot%2==1?const Color.fromARGB(255, 71, 70, 70).withOpacity(0.3):Colors.white,border: Border.all(width: 1,color: Colors.black.withOpacity(0.3))),
            width: double.infinity,
            child: TextButton(onPressed: (){
              switch (slot) {
                case 2: Navigator.push(context, MaterialPageRoute(builder: (context)=> const Help()));
                case 0: Navigator.push(context, MaterialPageRoute(builder: (context)=> const ThongtinUser()));
                case 6:
                  logout();
                  break;
                default:
              }
            }, child: Text(label)),
          );
  }
  Future<void> logout() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Bạn có chắc muốn thoát"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("No")),
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await auth.signOut();
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Bạn vừa đăng xuất ")));
                    },
                    child: const Text("Yes")),
              ],
            ));
  }
}