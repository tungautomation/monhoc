import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

// ignore: non_constant_identifier_names
bool switch_sign = false;
// ignore: non_constant_identifier_names
bool save_infinity = false;
// ignore: non_constant_identifier_names
String background_image = "";

class _SignInState extends State<SignIn> {
  // ignore: non_constant_identifier_names
  final username_controller = TextEditingController();
  // ignore: non_constant_identifier_names
  final password_controller = TextEditingController();
  // ignore: non_constant_identifier_names
  final hoandten_controller = TextEditingController();
  // ignore: non_constant_identifier_names
  final newpassword_controller = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  bool visiable_icon = false;
  // ignore: non_constant_identifier_names
  bool visiable_password = true;
  final auth = FirebaseAuth.instance;
  final app = FirebaseFirestore.instance;
  // ignore: non_constant_identifier_names
  String? option_value = "Lựa chọn" ;
  // ignore: non_constant_identifier_names
  @override
   @override
  void initState() {
    super.initState();
    readdata_Localstorage();
  }
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
            child: Text(!switch_sign ? "Đăng nhập" : "Đăng kí",
                style: const TextStyle(
                    fontSize: 35, fontWeight: FontWeight.w600))),
        backgroundColor: Colors.green.withOpacity(0.5),
      ),
      body: Form(
        key: keyForm,
        // child: SignIn_pas(widthScreen),
        child: switch_sign ? sign_up(widthScreen) : SignIn_pas(widthScreen),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Padding sign_up(double widthScreen) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 80,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Chưa nhập đủ thông tin";
              }
              return null;
            },
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
            controller: hoandten_controller,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.mail_outline),
                label: const Text("Họ và Tên"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18))),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (!isValidEmail(value!)) {
                return "Nhập sai địa chỉ email !";
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            controller: username_controller,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.mail_outline),
                label: const Text("Email"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18))),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Chưa nhập mật khẩu";
              }
              if (value.length < 5) {
                return "Mật khẩu không đủ an toàn ";
              }
              if (password_controller.text != newpassword_controller.text) {
                return "Mật khẩu không khớp";
              }
              return null;
            },
            controller: password_controller,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.mail_outline),
                label: const Text("New Password"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18))),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Chưa nhập mật khẩu";
              }
              if (value.length < 5) {
                return "Mật khẩu không đủ an toàn ";
              }
              if (password_controller.text != newpassword_controller.text) {
                return "Mật khẩu không khớp";
              }
              return null;
            },
            controller: newpassword_controller,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.mail_outline),
                label: const Text("Check New Password"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18))),
          ),
          const SizedBox(height: 10,),
          Container(
            height:65,
            decoration: BoxDecoration(border: Border.all(
              color: Colors.black.withOpacity(0.3),
              width: 1.5
              
            ),
            borderRadius: BorderRadius.circular(15),
            ),
            width: double.maxFinite,
            child: DropdownButton<String>(
            value: option_value,
            onChanged: (String? newValue) {
               setState(() {
                  option_value = newValue!;
                  if (kDebugMode) {
                    print(option_value);
                  }
                 });
            },
              items: <String>["Lựa chọn","Mua hàng","Bán hàng"]
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(value,style: const TextStyle(fontSize: 18),),
                    ),
                  );
                }).toList(),
                icon: const Icon(Icons.arrow_drop_down_sharp,color: Colors.green,),
                isExpanded: true,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              height: 50,
              width: widthScreen - 100,
              child: ElevatedButton(
                onPressed: dangki,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent),
                child: const Text("Đăng kí"),
              )),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bạn đã có tài khoản",
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      switch_sign = false;
                    });
                  },
                  child: const Text("Đăng nhập"))
            ],
          )
        ]),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Padding SignIn_pas(double widthScreen) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            SizedBox(
              height: 300,
              width: 300,
              child:  background_image!=""?Image.network(background_image):Image.asset('image/images.png',fit: BoxFit.cover,),
              
            ),
            const SizedBox(
              height: 80,
            ),
            TextFormField(
              validator: (value) {
                if (!isValidEmail(value!)) {
                  return "Vui lòng nhập lại địa chỉ email";
                }
                return null;
              },
              controller: username_controller,
              decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  label: const Text("Username"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: TextFormField(
                validator: (value) {
                  if (value!.length < 5) {
                    return "Sai mật khẩu ";
                  }
                  return null;
                },
                controller: password_controller,
                obscureText: visiable_password,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      visiable_icon = true;
                    } else {
                      visiable_icon = false;
                    }
                  });
                },
                decoration: InputDecoration(
                    icon: const Icon(Icons.lock_outline),
                    suffixIcon: visiable_icon == true
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                visiable_password = !visiable_password;
                              });
                            },
                            icon: Icon(visiable_password
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off_outlined))
                        : const SizedBox(),
                    label: const Text("Password"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18))),
              ),
            ),
            
            Row(
              children: [
                Checkbox(value:save_infinity , onChanged: ((value) {
                 setState(() {
                    save_infinity = value!;

                 });
                })),
                const Text("Remember Login"),
              ],
            ),
            SizedBox(
                width: widthScreen - 150,
                height: 50,
                child: ElevatedButton(
                    onPressed: dangnhap, child: const Text("Đăng nhập"))),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Bạn chưa có tài khoản?"),
                TextButton(
                    onPressed: () {
                      setState(() {
                        switch_sign = true;
                      });
                    },
                    child: const Text("Đăng kí"))
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> dangnhap() async {
    if (keyForm.currentState!.validate()) {
      setState(() {});
    }
    try {
      
      final email = username_controller.text.trim();
      final password = password_controller.text.trim();
      await auth.signInWithEmailAndPassword(email: email, password: password);
      if(save_infinity == true)
      {
        final save = await SharedPreferences.getInstance();
        await save.setString('username', username_controller.text.trim());
        await save.setString('password', password_controller.text.trim());
        await save.setBool('save_infinity',save_infinity );
        readdata_Localstorage();

      }
      else
      {
        final save = await SharedPreferences.getInstance();
        await save.setString('username', "");
        await save.setString('password', "");
        await save.setBool('save_infinity',false );
        readdata_Localstorage();
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Xin chào: $email")));
    }
    // ignore: empty_catches
    catch (e) {}
  }

  bool isValidEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  Future<void> dangki() async {
    if (keyForm.currentState!.validate()) {
      
        try {
      final email = username_controller.text.trim();
      final password = password_controller.text.trim();
      if(password==newpassword_controller.text.trim())
      {
        await auth.createUserWithEmailAndPassword(
          email: email, password: password);
        final updateThongtin = app.collection('taikhoan');
        final json = 
        {
          'email':email,
          'hoten':hoandten_controller.text.trim(),
          'sodu':10000,
          'option':option_value
        };
        await updateThongtin.doc(email).set(json);
        await app.collection('dathang').doc(email).set({}) ;  
        await app.collection('sanpham').doc(email).set({}) ;    
        await app.collection('help').doc(email).set({}) ; 
            // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đăng kí thành công")));
      }
    } 
    // ignore: empty_catches
    catch (e) {}
    }
    
  }
  // ignore: non_constant_identifier_names
  Future <void> readdata_Localstorage()
  async{
    final save = await SharedPreferences.getInstance();
    
      // ignore: await_only_futures
      username_controller.text = await save.getString('username')?? "";
      // ignore: await_only_futures
      password_controller.text = await save.getString('password')??"";
      // ignore: await_only_futures
      save_infinity = (await save.getBool('save_infinity'))??false;
      // ignore: await_only_futures
      background_image = await save.getString('background_image')?? "";
      
  }
}
