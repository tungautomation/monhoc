import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

// ignore: non_constant_identifier_names
int int_year = year;
// ignore: non_constant_identifier_names
String new_password_Controller = "";
// ignore: non_constant_identifier_names
String check_new_password_Controller = "";
// ignore: non_constant_identifier_names
String new_ho_Controller = "";
// ignore: non_constant_identifier_names
String new_ten_Controller = "";
String emailController = "";
// ignore: non_constant_identifier_names
String new_username_Controller = "";
// ignore: non_constant_identifier_names
int new_year_controller = 0;
int year = DateTime.now().year;

class _SignInState extends State<SignIn> {
  // ignore: non_constant_identifier_names
  final form_key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Đăng kí"),
        ),
        body: Form(
          key: form_key,
          child: Container(
            height: heightScreen,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 186, 181, 181), Colors.blue],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  input_new_infinity("Họ", value_input: new_ho_Controller),
                  input_new_infinity("Tên", value_input: new_ten_Controller),
                  input_new_infinity("Email", value_input: emailController),
                  input_new_infinity("Username",
                      value_input: new_username_Controller),
                  input_new_infinity("New Password",
                      value_input: new_password_Controller),
                  input_new_infinity("Check New Password",
                      value_input: check_new_password_Controller),
                  input_new_infinity("Year", value_input: new_year_controller),
                  SizedBox(
                    height: 45,
                    width: widthScreen / 1.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: check_thongtin,
                      child: const Text("Đăng kí"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  // ignore: non_constant_identifier_names
  Padding input_new_infinity(String label, {required value_input}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: TextFormField(
        textCapitalization: label == "Họ" || label == "Tên"
            ? TextCapitalization.words
            : TextCapitalization.none,
        keyboardType:
            label == "Year" ? TextInputType.number : TextInputType.name,
        // controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(
            Icons.library_books_sharp,
          ),
          labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 231, 202, 202)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 226, 185, 185)),
          ),
        ),
        onChanged: (value) {
          if (label == "Họ") {
            new_ho_Controller = value;
          }
          if (label == "Tên") {
            new_ten_Controller = value;
          }
          if (label == "Email") {
            emailController = value;
          }
          if (label == "Username") {
            new_username_Controller = value;
          }
          if (label == "New Password") {
            new_password_Controller = value;
          }
          if (label == "Check New Password") {
            check_new_password_Controller = value;
          }
          if (label == "Year") {
            try {
              int_year = int.tryParse(value)!;
              new_year_controller = int_year;
              // ignore: empty_catches
            } catch (e) {}
          }
        },
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Chưa nhập thông tin ';
          }
          if (label == "Họ" && value.length < 2) {
            return 'Vui lòng nhập lại';
          }

          if (label == "Tên" && value.length < 2) {
            return 'Vui lòng nhập lại';
          }
          if (label == "Email") {
            if (checkemail(emailController) == false) {
              return "Địa chỉ Email không phù hợp";
            }
          }
          if (label == "Username" && value.length < 8) {
            return 'Username không hợp lệ';
          }
          if (label == "New Password" && value.length < 5) {
            return 'Password chưa đủ tính bảo mật';
          }
          if (label == "Check New Password" &&
              check_new_password_Controller != new_password_Controller) {
            return "Mật khẩu nhập vào không khớp ";
          }
          if (label == "Year") {
            if (int_year < 1930 || int_year >= year) {
              return 'Vui lòng nhập lại thông tin ';
            }
            if (year - int_year < 18) {
              return 'Người dùng chưa đủ độ tuổi';
            }
          }

          return null;
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> check_thongtin() async {
    final isValue = form_key.currentState?.validate() ?? false;
    if (isValue) {
      final docs = FirebaseFirestore.instance
          .collection('dangkitk')
          .doc(new_username_Controller);
      final json = {
        'ho': new_ho_Controller,
        'ten': new_ten_Controller,
        'email': emailController,
        'username': new_username_Controller,
        'password': new_password_Controller,
        'year_birthday': new_year_controller,
        'data_signin': DateTime.now(),
      };
      await docs.set(json);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Đăng kí thành công")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Chưa nhập đầy đủ dữ liệu")));
    }
  }

  bool checkemail(String email) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(email)) {
      return false;
    }
    return true;
  }
}
