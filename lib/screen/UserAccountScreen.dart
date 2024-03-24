import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'dart:convert';
import 'package:flutter_api_db/models/users.dart';
import 'package:flutter_api_db/screen/HomeScreen.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class UserAccountScreen extends StatefulWidget {
  final Users data;
  UserAccountScreen({super.key, required this.data});
  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController Last_name = TextEditingController();
  TextEditingController email = TextEditingController();

  late bool loadingStatus;
  late bool isFinish;
  @override
  void initState() {
    super.initState();
    loadingStatus = false;
    isFinish = false;
  }

  void setLoading(bool currentLoadingStatus) {
    setState(() {
      loadingStatus = currentLoadingStatus;
    });
  }

  void updateUser() async {
    logger.d("updating....");
    setLoading(true);
    //name.text = "testtttt";
    Map<String, String> userData = {
      "email": email.text,
      "first_name": name.text,
      "last_name": Last_name.text
    };

    Future<Map<String, dynamic>> result = ApiBaseHelper().manualPut(
        url: ApiBaseHelper.userUpdate +
        widget.data.u_id.toString(), //url ของ api endpoint
        dataPut: userData,
        statusCode: 202 //รหัสการตอบกลับของ api เมื่อบันทึกข้อมูลส าเร็จ
        );
    result.then((data) {
      //name.text = data.toString();
      name.text = userData["first_name"].toString();
      Last_name.text = userData["last_name"].toString();
      email.text = userData["email"].toString();

      var user = Users();

      user.u_id = widget.data.u_id;
      user.Last_name = userData["Last_name"].toString();
      user.first_name = userData["first_name"].toString();
      user.email = userData["email"].toString();

      print("ok");

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              settings: RouteSettings(name: "/HomeScreen"),
              builder: (_) => HomeScreen(user: user)));
    }, onError: (e) {
      print(e);
    });
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    name.text = widget.data.first_name ?? "";
    Last_name.text = widget.data.Last_name ?? "";
    email.text = widget.data.email ?? "";

    print("ID--------->" + widget.data.u_id!.toString());

    double inputWidth = 250;

    return Scaffold(
        appBar: AppBar(title: Text('แก้ไขข้อมูลผู้ใช้')),
        //body: result == null ? showForm() : buildFutureBuilder(),
        body:Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10),
          child: Column(children: [
          Text(
              "หน้าแก้ไขข้อมูลบัญชีผู้ใช้งาน  ${widget.data.first_name!} [ID : ${widget.data.u_id!}]"),
          SizedBox(
            width: inputWidth,
            child:TextFormField(
              controller: name,
              decoration: InputDecoration(label: Text('ชื่อ'))) ,
          )
          ,
          SizedBox(
            width: inputWidth,
            child:TextFormField(
              controller: Last_name,
              decoration: InputDecoration(label: Text('นามสกุล'))),
          )
          ,
          SizedBox(
            width: inputWidth,
            child:TextFormField(
              controller: email,
              decoration: InputDecoration(label: Text('email'))),
          ),
          (loadingStatus)
              ? Text("กำลังโหลด.....",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ))
              : Text(""),
          ElevatedButton(
              onPressed: () {
                this.updateUser();
              },
              child: Text("บันทึก")),
        ]),
        )
         );
  }
}
