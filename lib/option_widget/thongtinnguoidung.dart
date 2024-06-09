import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

class ThongtinUser extends StatefulWidget {
  const ThongtinUser({super.key});

  @override
  State<ThongtinUser> createState() => _ThongtinUserState();
}

// ignore: non_constant_identifier_names
final form_key = GlobalKey<FormState>();
final auth = FirebaseAuth.instance;
final hovatenController = TextEditingController();
final _dateController = TextEditingController();
final _emailController = TextEditingController();
// ignore: non_constant_identifier_names
final CCCDController = TextEditingController();

class _ThongtinUserState extends State<ThongtinUser> {
  User? user = auth.currentUser;
  final app = FirebaseFirestore.instance;
  String hovaten = "";
  int cccd = 0;
  String email = "";
  // String password = "";

  Future<void> laydulieu() async {
    DocumentSnapshot document =
        await app.collection('taikhoan').doc(user!.email).get();
    if (document.exists) {
      setState(() {
        hovaten = document['hoten'];
        email = document['email'];
        _emailController.text = email;
        hovatenController.text = hovaten;
        try {
          CCCDController.text = "${document['cccd']}";
        // ignore: empty_catches
        } catch (e) {
          
        }
        if (kDebugMode) {
          print(CCCDController.text);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    laydulieu();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cập nhật thông tin",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Form(
        key: form_key,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  enabled: false,
                  decoration: const InputDecoration(
                      hintText: "Email",
                      labelText: "Email",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: hovatenController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      hintText: "Họ và tên",
                      labelText: "Họ và tên",
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if(value!.isEmpty)
                    {
                      return "Chưa nhập đầy đủ họ và tên";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _dateController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your birth date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      setState(() {
                        _dateController.text = formattedDate;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: CCCDController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: "CMND / CCCD",
                      labelText: "CMND / CCCD",
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vui lòng nhập số căn cước công dân ";
                    }
                    if (value.length != 12) {
                      return "Số căn cước không đúng";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  height: 65,
                  width: 300,
                    child: OutlinedButton(
                        onPressed: () async{
                          
                            if(form_key.currentState!.validate())
                            {
                              try {
                                cccd = int.parse(CCCDController.text.trim());
                              // ignore: empty_catches
                              } catch (e) {
                                
                              }
                              final up =  app.collection('taikhoan').doc(user!.email);
                              final json = {
                                'hoten':hovaten,
                                'birthday':_dateController.text,
                                'cccd':cccd,
                              };
                              await up.update(json);
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            }

                          
                        }, child: const Text("Cập nhật thông tin"))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
