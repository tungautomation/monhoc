import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:app/chuyentien.dart';
import 'package:app/setting.dart';
import 'package:app/tangchu1.dart';
import 'package:app/thongbao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Trangchu extends StatefulWidget {
  const Trangchu({super.key});

  @override
  State<Trangchu> createState() => _TrangchuState();
}
class _TrangchuState extends State<Trangchu> {
  int _selectedIndex=0  ;
  List<Widget> trang = [Trangchu1(),Thongbao(),Chuyentien(),Setting()];
// PageController _pageController = PageController();
void _onItemtapped(int index)
{
  setState(() {
    _selectedIndex = index;
  });
  print(_selectedIndex);

}
@override

  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async {
          bool recover = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Bạn có muốn quay lại không?"),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                                if (kDebugMode) {
                                  print(false);
                                }
                              },
                              child: const Text("No")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text("Yes"))
                        ],
                      )
                    ],
                  ));
          return recover;
        },
        child: Scaffold(
            appBar: AppBar(
              title: TextButton(
                  onPressed: () {},
                  child: const Center(
                    child: Text(
                      "Trang chủ",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.lightbulb),
                  color: Colors.white,
                )
              ],
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 182, 240, 115),
                  Color.fromARGB(255, 8, 59, 9)
                ])),
              ),
            ),
            body: Container(
               height: heightScreen,
                  width: widthScreen,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 151, 179, 106),
                      Color.fromARGB(255, 91, 92, 87)
                    ]),
                  ),
              child: trang[_selectedIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor:Color.fromARGB(255, 94, 95, 94),
              selectedItemColor: Color.fromARGB(255, 62, 159, 204),

              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.notifications),label: "Thông báo"),
                BottomNavigationBarItem(icon: Icon(Icons.swap_horiz_outlined),label: "Chuyển tiền"),
                BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Cài đặt"),
              ],
                currentIndex: _selectedIndex,
                onTap: _onItemtapped,
              ),
            ),
            

            );
            
          
  }
}
