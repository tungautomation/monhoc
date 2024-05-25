import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Trangchu1 extends StatefulWidget {
  const Trangchu1({super.key});

  @override
  State<Trangchu1> createState() => _Trangchu1State();
}

class _Trangchu1State extends State<Trangchu1> {
  
  @override

  
  Widget build(BuildContext context) {
    double heihgtScreen = MediaQuery.of(context).size.height;
    double WidthScreen = MediaQuery.of(context).size.width;
    PageController _pageView = PageController();
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
           Container(
            height: heihgtScreen*2/9,
            width: WidthScreen,
             child: PageView(
              children: [
                image_quangcao('image/MyIC_Inline_74590.jpg'),
                image_quangcao('image/quang-cao.png'),
                image_quangcao('image/Subiz-cac-hinh-thuc-quang-cao-pho-bien.png')
              ],
             ),
           ),
           SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:<Widget> [
                icon_option(context,Icons.shopping_cart,"Shopping"),
                icon_option(context,Icons.local_taxi,"Taxi"),
                icon_option(context,Icons.lock_clock,"Tạm khóa"),
                icon_option(context,Icons.phone_iphone_sharp,"Nạp thẻ điện thoại"),
                icon_option(context,Icons.tv,"Cước truyền hình"),
                icon_option(context,Icons.attach_money,"Nạp tiền"),
                icon_option(context,Icons.settings,"Cài đặt"),
                icon_option(context,Icons.star_border,"Lựa chọn"),

              ],
            ),
           ),
           
          ],
        ),
      ),
    );
  }

  Padding icon_option(BuildContext context,icon,String label_text) {
    return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: (){
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Chức năng đang được phát triển")));
                    switch (label_text) {
                      case "Shopping":
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label_text)));
                        break;
                      case "Taxi":
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label_text)));
                        break;
                      case "Tạm khóa":
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label_text)));
                        break;
                      case "Nạp thẻ điện thoại":
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label_text)));
                        break;
                      case "Cước truyền hình":
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label_text)));
                        break;
                      case "Nạp tiền":
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label_text)));
                        break;
                      case "Cài đặt":
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label_text)));
                        break;
                      case "Lựa chọn":
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label_text)));
                        break;
                      default:
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Colors.green ,),
                        height: 60,
                        width: 60,
                        child: Icon(icon,size: 26,color: Color.fromARGB(255, 228, 224, 224),),
                            
                        )
                        ,Text(label_text,style: TextStyle(color: Colors.black,fontSize: 12),),
                          
                    ],
                  ),
                  ),
                );
  }

  Padding image_quangcao(String url_image) {
    return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Image.asset(
                    url_image,
                    fit: BoxFit.cover,),
                  
                ),
              );
  }
}