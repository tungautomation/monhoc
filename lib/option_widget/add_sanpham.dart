import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Addsanpham extends StatefulWidget {
  const Addsanpham({super.key});

  @override
  State<Addsanpham> createState() => _AddsanphamState();
}

class _AddsanphamState extends State<Addsanpham> {
  File? file;
  final storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;

  // ignore: non_constant_identifier_names
  final name_sanpham = TextEditingController();
  final cost = TextEditingController();
  final motasp = TextEditingController();
  final formkey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  List<File> image_food = [];
  // ignore: non_constant_identifier_names
  List<String> name_imagefood = [];
  // ignore: non_constant_identifier_names
  final List<String> image_foodURl = [];
  int giathanh = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Thêm sản phẩm")),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  if (kDebugMode) {
                    print(name_sanpham.text.trim());
                  }
                });
              },
              child: const Text("Lưu"))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                    width: double.infinity,
                    child: Text("Nhập tên sản phẩm:",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15))),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.name,
                  controller: name_sanpham,
                  decoration: InputDecoration(
                      focusColor: Colors.amber,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.5))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Chưa có tên ";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                    width: double.infinity,
                    child: Text("Giá thành",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15))),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.5)),
                  ),
                  onChanged: (value) {
                    try {
                      giathanh = int.parse(value);
                    } catch (e) {
                      giathanh = 0;
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty || giathanh <= 1000) {
                      return "Chưa nhập giá thành";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Text("Ảnh món ăn",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                ),
                FilledButton.tonalIcon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                                children: <Widget>[
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      upload_image(ImageSource.camera);
                                    },
                                    child: const Text('Chụp ảnh'),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      upload_image(ImageSource.gallery);
                                    },
                                    child: const Text('Album'),
                                  ),
                                ],
                              ));
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text("Thêm ảnh sản phẩm")),
                Container(
                  height: 350,
                  width: width,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 201, 232, 247)
                        .withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListView.builder(
                      itemCount: image_food.length,
                      itemBuilder: ((context, index) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: index % 2 == 0
                              ? const Color.fromRGBO(209, 199, 169, 1)
                              : const Color.fromARGB(255, 188, 210, 228),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                  onTap: () {},
                                  child: GestureDetector(
                                      onTap: () {
                                        if (kDebugMode) {
                                          print(index);
                                        }
                                      },
                                      child: Image.file(image_food[index]))),
                              Text(name_imagefood[index]),
                            ],
                          ),
                        );
                      })),
                ),
                const SizedBox(
                  height: 25,
                ),
                const SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Mô tả về sản phẩm",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          fontStyle: FontStyle.italic),
                    )),
                TextFormField(
                  validator: (value) {
                    if(value!.isEmpty)
                    {
                      return"Chưa có mô tả về sản phẩm ";
                    }
                    return null;
                  },
                  controller:  motasp,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              if (image_food.isNotEmpty) {
                                Navigator.pop(context);
                                for (var i = 0; i < image_food.length; i++) {
                                  uploadimage_to_firebase(i);
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Chưa nhập đầy đủ thông tin")));
                            }
                          },
                          child: const Text(
                            "Tải lên",
                            style: TextStyle(fontSize: 25),
                          ))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> upload_image(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        file = File(image.path);
        final String name = DateTime.now().millisecondsSinceEpoch.toString();
        image_food.add(file!);
        name_imagefood.add(name);
      });
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> uploadimage_to_firebase(int i) async {
    final image = storage.ref().child('monan').child(name_imagefood[i]);
    await image.putFile(image_food[i]);
    final download = await image.getDownloadURL();
    image_foodURl.add(download);
    if (kDebugMode) {
      print(download);
    }
    if (i == image_food.length - 1) {
      User? tk = auth.currentUser;
      final app =
          FirebaseFirestore.instance;
      final Map<String, dynamic> myMap = {
        'name': name_sanpham.text.trim(),
        'cost': giathanh,
        'image': image_foodURl,
        'mota': motasp.text.trim(),
        'emailnsx':tk!.email,
      };
      final json = {
        name_sanpham.text.trim(): myMap,
      };
      await app.collection('sanpham').doc(tk?.email).update(json);
      if (kDebugMode) {
        print(image_foodURl);
      }
      final shopping = {
        'cost':giathanh,
        'email':tk?.email,
        'name': name_sanpham.text.trim(),
        'image': image_foodURl,
        'mota': motasp.text.trim(),
        'giamgia':0,
      };
      await app.collection('shop').doc(name_sanpham.text.trim()).set(shopping);
    }
  }
}