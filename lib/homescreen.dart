// ignore_for_file: non_constant_identifier_names, duplicate_ignore
import 'package:app/information_firebase.dart';
import 'package:app/read_data.dart';
import 'package:app/tangchu1.dart';
import 'package:app/trangchu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app/dangki.dart';

String usernameController = "";
String passworkController = "";
List<User> user_pass = [];
String? name ;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ignore: duplicate_ignore
class _HomeScreenState extends State<HomeScreen> {
  final _keyform = GlobalKey<FormState>();
fetRecord() async {
    final doc = await FirebaseFirestore.instance.collection('dangkitk').get();
    maprecord(doc);
  }

  maprecord(QuerySnapshot<Map<String, dynamic>> doc) async {
    var list = doc.docs
        .map((thongtin) => User(
              ho: thongtin['ho'],
              ten: thongtin['ten'],
              email: thongtin['email'],
              username: thongtin['username'],
              password: thongtin['password'],
            ))
        .toList();
        trave(list);
    // setState(() {
    //   user_pass = list;
    // });
  }
  

  @override
  Widget build(BuildContext context) {
    bool onpressedSignin = false;
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    bool visiablePassword = false;

    return Scaffold(
      body: Form(
        key: _keyform,
        child: Container(
          height: heightScreen,
          width: widthScreen,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.white],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Center(
                    child: Text(
                  "Login",
                  style: TextStyle(fontSize: 50, fontStyle: FontStyle.italic),
                )),
                SizedBox(
                  height: heightScreen * 2 / 5,
                ),
                input_thongtin(
                    "Username", controller: usernameController, true),
                const SizedBox(
                  height: 15,
                ),
                input_thongtin(
                    "Password",
                    controller: passworkController,
                    visiablePassword),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Quên mật khẩu",
                          style: TextStyle(
                              color: Color.fromARGB(255, 116, 115, 115)),
                        )),
                    const SizedBox(
                      width: 5,
                      child: Text("|"),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignIn()));
                        },
                        child: const Text("Đăng kí",
                            style: TextStyle(
                                color: Color.fromARGB(255, 116, 115, 115)))),
                    const SizedBox(
                      width: 20,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: widthScreen / 2,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            onpressedSignin = true;
                            final isValueLogin =
                                _keyform.currentState?.validate() ?? false;
                            if (isValueLogin) {
                              if (kDebugMode) {
                                fetRecord();
                                
                                for (var i = 0; i < user_pass.length; i++) {
                                  if (usernameController ==
                                      user_pass[i].username){
                                    if (passworkController ==
                                        user_pass[i].password) {
                                        name = "${user_pass[i].ho} ${user_pass[i].ten}";
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                    const Trangchu()));
                                      print("Có tk");
                                      
                                      passworkController = "";
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Xin chào ${user_pass[i].ten} ${user_pass[i].ho}")));

                                      break;
                                    } else {                                 
                                      print("Sai mật khẩu");
                                      break;  
                                    }
                                  } else {
                                    print("Không có tk");
                                  }
                                  usernameController = "";
                                  passworkController = "";
                                }
                              }

                              // ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                              //     content: Text(pass)));
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 116, 199, 238),
                          shadowColor: Colors.blue,
                          foregroundColor: Colors.black,
                          elevation: onpressedSignin == true ? 50 : 0,
                        ),
                        child: const Text(
                          "Đăng nhập",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.fingerprint_rounded,
                          size: 60,
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Padding input_thongtin(String label, bool visiable_password,
      {required controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            if (label == "Username") {
              usernameController = value;
            }
            if (label == "Password") {
              passworkController = value;
            }
          });
        },
        validator: (value) {
          try {
            if (value == null || value.isEmpty) {
              return 'Chưa nhập đầy đủ thông tin ';
            }
            if (label == "Username" && value.length < 8) {
              return 'Tài khoản của bạn không tồn tại ';
            }
            if (label == "Password" && value.length < 5) {
              return 'Sai mật khẩu';
            }

            return null;
            // ignore: empty_catches
          } catch (e) {}
          return null;
        },
        obscureText:
            label == "Password" && visiable_password == false ? true : false,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w400),
          prefixIcon: Icon(
              label == "Username" ? Icons.person_outline : Icons.lock_outline),
          suffixIcon: label == "Password" && passworkController.isNotEmpty
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.remove_red_eye_outlined))
              : const SizedBox(),
          border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 232, 46, 46)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
