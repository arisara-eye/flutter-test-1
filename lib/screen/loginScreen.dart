import 'dart:convert';

import 'package:flutter/material.dart';

import '../helper/ApiBaseHelper.dart';
import '../models/users.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  Future<Map<String, dynamic>>? result;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: result == null ? showForm() : buildFutureBuilder(),
    );
  }

  Widget showForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: email,
            decoration: InputDecoration(label: Text('email')),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: password,
            decoration: InputDecoration(label: Text('password')),
            obscureText: true,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
              onPressed: onLogin, icon: Icon(Icons.key), label: Text('Login'))
        ],
      )),
    );
  }

  //================================
  void onLogin() {
    //ตัวแปร productData เก็บข้อมูลสินค้าที่ผู้ใช้ป้อนบนฟอร์ม
    Map<String, String> userData = {
      "email": email.text,
      "password": password.text,
    };

    setState(() {
      //เรียกใช้งานฟังก์ชัน post เพื่อส่งข้อมูลไปยัง api
      result = ApiBaseHelper().post(
          url: ApiBaseHelper.userLogin, //url ของ api endpoint
          dataPost: userData, //ข้อมูลสินค้า
          statusCode: 200 //รหัสการตอบกลับของ api เมื่อบันทึกข้อมูลส าเร็จ
          );
    });
  }

  //================================
  FutureBuilder<Map<String, dynamic>> buildFutureBuilder() {
    return FutureBuilder<Map<String, dynamic>>(
      future: result,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        //ถ้าอยู่ระหว่างโหลดข้อมูล ให้แสดงสถานะการโหลดด้วย CircularProgressIndicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          //ถ้าข้อมูลในส่วน status มีค่าเท่ากับ ok
          if (snapshot.data!['status'] == 'ok') {
            // print("data = " + jsonDecode(snapshot.data!['data']));
            Users user = Users.fromJson(jsonDecode(snapshot.data!['data']));
            if (user.email != null) {
              // print('>>>>>' + user.toJson().toString());
              // login สำเร็จ
              Future(() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: "/HomeScreen"),
                        builder: (_) => HomeScreen(user: user)));
              });
            } else {
              // password ไม่ถูกต้อง
              Future(() {
                // แสดงกล่องข้อความโต้ตอบ
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Text('email หรือ password ไม่ถูกต้อง'),
                          actions: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  //เมื่อกดปุ่ มตกลง ให้กล่องข้อความโต้ตอบหายไป
                                  Navigator.of(context).pop();
                                },
                                child: Text('ตกลง')),
                          ],
                        ));
              });
            }
          } else {
//ถ้าผิดพลาด
            Future(() {
              // แสดงกล่องข้อความโต้ตอบ
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Text('ผิดพลาด'),
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                //เมื่อกดปุ่ มตกลง ให้กล่องข้อความโต้ตอบหายไป
                                Navigator.of(context).pop();
                              },
                              child: Text('ตกลง')),
                        ],
                      ));
            });
          }
          return showForm();
        }
      },
    );
  }
  //======================================================
}
