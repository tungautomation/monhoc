import 'package:app/information_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homescreen.dart';

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
  List<dynamic> trave(list)
  {
    return list;
  }