import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/models/products.dart';
import 'package:image_picker/image_picker.dart';

class ProductAddScreen extends StatefulWidget {
  ProductAddScreen({Key? key}) : super(key: key);

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  //ตัวแปร result สำหรับจัดเก็บผลลัพธ์ที่ได้จากการเพิ่มข้อมูลใหม่
  Future<Map<String, dynamic>>? result;
  //ตัวแปรจัดเก็บค่าที่กรอกในช่องชื่อสินค้า
  final p_name = TextEditingController();
  //ตัวแปรจัดเก็บค่าที่กรอกในช่องราคาสินค้า
  final p_price = TextEditingController();
  //ตัวแปรจัดเก็บข้อมูลไฟล์ที่ผู้ใช้เลือก
  File? uploadImage;

  @override
  void dispose() {
    //เมื่อปิดหน้ากรอกข้อมูลให้ล้างตัวแปรออก
    p_name.dispose();
    p_price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มข้อมูลสินค้า')),
      body: result == null ? showForm() : buildFutureBuilder(),
    );
  }

  //======================================================
  //ฟังก์ชันฟอร์มสำหรับกรอกข้อมูล
  Widget showForm() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: p_name,
                decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
              ),
              TextFormField(
                controller: p_price,
                decoration: InputDecoration(labelText: 'ราคา'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                //เมนูเลือกรูปภาพ
                child: PopupMenuButton<ImageSource>(
                  child: SizedBox(
                    width: 150,
                    height: 120,
                    //ถ้าผู้ใช้เลือกรูปภาพแล้วให้แสดงภาพที่เลือก ถ้าไม่ใช่ให้แสดงไอคอน image
                    child: uploadImage != null
                        ? Image.file(uploadImage!)
                        : Icon(
                            Icons.image,
                            size: 100,
                          ),
                  ),
                  //รายการเมนูสำหรับเลือกรูปภาพ
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<ImageSource>>[
                    //เลือกรูปภาพจาก Image Gallery
                    const PopupMenuItem<ImageSource>(
                      value: ImageSource.gallery,
                      child: Icon(Icons.image_search_rounded),
                    ),
                    //เลือกรูปภาพจากกล้องถ่ายรูป
                    const PopupMenuItem<ImageSource>(
                      value: ImageSource.camera,
                      child: Icon(Icons.camera_alt_rounded),
                    ),
                  ],
                  //เมื่อเลือกเมนูแล้วจะไปเรียกใช้ฟังก์ชัน chooseImage
                  onSelected: (ImageSource imageSource) {
                    chooseImage(imageSource);
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //ปุ่มเพิ่มข้อมูลสินค้า
              ElevatedButton.icon(
                  icon: Icon(Icons.add_circle),
                  label: Text('เพิ่มข้อมูล'),
                  onPressed: () {
                    //ตัวแปร productData เก็บข้อมูลสินค้าที่ผู้ใช้ป้อนบนฟอร์ม
                    Map<String, String> productData = {
                      "p_name": p_name.text,
                      "p_price": p_price.text,
                    };
                    Map<String, String>? fileUploadData;
                    //ตรวจสอบตัวแปร uploadImage ว่ามีข้อมูลหรือไม่
                    if (uploadImage != null) {
                      //ตัวแปร fileUploadData เก็บข้อมูลไฟล์รูปภาพที่ผู้เลือก
                      fileUploadData = {
                        "fieldName": "p_img", //ฟิวด์ใน api
                        "filePath":
                            uploadImage!.path, //ที่อยู่ (path) ของไฟล์รูปภาพ
                      };
                    }

                    setState(() {
                      //เรียกใช้งานฟังก์ชัน postFile เพื่อส่งข้อมูลไปยัง api
                      result = ApiBaseHelper().post(
                          url: ApiBaseHelper
                              .addNewProduct, //url ของ api endpoint
                          dataPost: productData, //ข้อมูลสินค้า
                          fileUpload: fileUploadData, //ข้อมูลไฟล์
                          statusCode:
                              201 //รหัสการตอบกลับของ api เมื่อบันทึกข้อมูลสำเร็จ
                          );
                    });
                    //ล้างค่าตัวแปรออก
                    p_name.clear();
                    p_price.clear();
                    uploadImage = null;
                  })
            ],
          ),
        )),
      ),
    );
  }

  //======================================================
  //ฟังก์ชันสำหรับเลือกรูปภาพ
  Future<void> chooseImage(ImageSource source) async {
    //เรียกใช้งาน ImagePicker
    var choosedimage = await ImagePicker().pickImage(source: source);
    setState(() {
      //นำข้อมูลไฟล์รูปภาพที่เลือก มาเก็บไว้ในตัวแปร uploadImage
      uploadImage = File(choosedimage!.path);
    });
  }

  //======================================================
  //ฟังก์ชันสำหรับตรวจสอบการตอบกลับจากการเพิ่มข้อมูลใหม่
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
            Future(() {
              // แสดงกล้องข้อความโต้ตอบ
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Text('เพิ่มข้อมูลสำเร็จ'),
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                //เมื่อกดปุ่มตกลง ให้กล่องข้อความโต้ตอบหายไป
                                Navigator.of(context).pop();
                              },
                              child: Text('ตกลง')),
                        ],
                      ));
            });
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
                                //เมื่อกดปุ่มตกลง ให้กล่องข้อความโต้ตอบหายไป
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
