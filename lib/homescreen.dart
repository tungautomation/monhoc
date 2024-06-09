import 'package:app/option_widget/add_sanpham.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app/option_widget/datmon.dart';
import 'package:app/option_widget/giohang.dart';
import 'package:app/option_widget/setting.dart';
bool option = false;
List<Widget> trang = [
  const Datmon(),
  const Giohang(),
  const Setting(),
];
List<String> title = ["Đặt món", "Giỏ hàng", "Setting"];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: non_constant_identifier_names
  final auth = FirebaseAuth.instance;
  // ignore: non_constant_identifier_names
  bool visiable_money = false;
  
  // ignore: non_constant_identifier_names
  int selection_slot = 0;
  // ignore: non_constant_identifier_names
  bool delete_food = false;
  @override
  void initState() {
    super.initState();
    readdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Row(
          children: [
            selection_slot == 0
                ? FilledButton.tonalIcon(
                    onPressed: logout,
                    icon: const Icon(Icons.exit_to_app_sharp),
                    label: const Text("Thoát"),
                    style: FilledButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 172, 170, 170)
                                .withOpacity(0.1)),
                  )
                : Container(),
            const SizedBox(
              width: 20,
            ),
            Text(
              title[selection_slot],
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
            ),
          ],
        ),
      ),
      body: trang[selection_slot],
      floatingActionButton: option == true
          ? FilledButton.tonalIcon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Addsanpham()));
              },
              icon: const Icon(Icons.add),
              label: const Text("Thêm sản phẩm"))
          : Container(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 30,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.red,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.checklist_rounded), label: "Đặt món"),
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank_sharp), label: "Giỏ hàng"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: "Cài đặt "),
        ],
        currentIndex: selection_slot,
        onTap: ontap_option,
      ),
    );
  }

  // ignore: non_constant_identifier_names

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

  // ignore: non_constant_identifier_names
  void ontap_option(int value) {
    setState(() {
      selection_slot = value;
      readdata();
      if (kDebugMode) {
        print(option);
      }
    });
  }

  Future<void> readdata() async {
    User? username = FirebaseAuth.instance.currentUser;
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('taikhoan')
        .doc(username?.email!)
        .get();
    if (document['option'] == "Bán hàng" && selection_slot == 0) {
      setState(() {
        option = true;
      });
    } else {
      setState(() {
        option = false;
      });
    }
  }
}
