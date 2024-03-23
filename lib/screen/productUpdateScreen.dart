import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/models/products.dart';
import 'package:image_picker/image_picker.dart';

class ProductUpdateScreen extends StatefulWidget {
  //ตัวแปร data ส าหรับจัดเก็บข้อมูลสินค้าที่จะถูกส่งเข้ามาแก้ไขในหน้านี้
  Products data;
  //ฟังก์ชัน loadProduct ส าหรับเชื่อมโยงฟังก์ชันการโหลดข้อมูลสินค้าที่จะถูกส่งเข้ามาในหน้านี้
  Function loadProduct;
  ProductUpdateScreen({Key? key, required this.data, required this.loadProduct})
      : super(key: key);
  @override
  State<ProductUpdateScreen> createState() => _ProductUpdateScreenState();
}

class _ProductUpdateScreenState extends State<ProductUpdateScreen> {
  //ตัวแปร result ส าหรับจดัเก็บผลลพัธ์ที่ไดจ้ากการเพิ่มขอ้มูลใหม่
  Future<Map<String, dynamic>>? result;
  //ตัวแปรจัดเก็บค่าที่กรอกในช่องชื่อสินค้า
  late TextEditingController p_name;
  //ตัวแปรจัดเก็บค่าที่กรอกในช่องราคาสินค้า
  late TextEditingController p_price;
  //ตัวแปรจัดเก็บข้อมูลไฟล์ที่ผู้ใช้เลือก
  File? uploadImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //ให้น าข้อมูลสินค้ามาแสดงในแต่ละช่อง TextFormField
    p_name = TextEditingController(text: widget.data.p_name!);
    p_price = TextEditingController(text: widget.data.p_price!.toString());
  }

  @override
  void dispose() {
    //เมื่อปิ ดหน้ากรอกข้อมูลให้ล้างตัวแปรออก
    p_name.dispose();
    p_price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('แก้ไขข้อมูลสินค้า')),
      body: result == null ? showForm() : buildFutureBuilder(),
    );
  }

  //======================================================
  //ฟังก์ชันฟอร์มส าหรับกรอกข้อมูล
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
                    //ถ้าผู้ใช้เลือกรูปภาพแล้วให้แสดงภาพที่เลือก
                    child: uploadImage != null
                        ? Image.file(uploadImage!)
                        : widget.data !=
                                null //ถ้าข้อมูลเดิมมีรูปภาพให้แสดงรูปภาพ
                            ? Image.network(Uri.decodeFull(widget.data.p_img!))
                            : Icon(
                                Icons.image,
                                size: 100,
                              ),
                  ),
                  //รายการเมนูส าหรับเลือกรูปภาพ
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
              //ป่มุ เพิ่มขอ้มูลสินคา้
              ElevatedButton.icon(
                  icon: Icon(Icons.add_circle),
                  label: Text('แก้ไขข้อมูล'),
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
                        "fieldName": "p_img", //ฟิ วด์ใน api
                        "filePath":
                            uploadImage!.path, //ที่อยู่ (path) ของไฟล์รูปภาพ
                      };
                    }
                    setState(() {
                      //ก าหนด url ส าหรับเรียกใช้งาน api endpoint ส าหรับแก้ไขข้อมูลสินค้าตามรหัส p_id
                      String urlApi = ApiBaseHelper.updateProduct +
                          '/' +
                          widget.data.p_id!.toString();
                      //เรียกใช้งานฟังก์ชัน put เพื่อส่งข้อมูลไปยัง api
                      result = ApiBaseHelper().put(
                          url: urlApi, //url ของ api endpoint
                          dataPut: productData, //ข้อมูลสินค้า
                          fileUpload: fileUploadData, //ข้อมูลไฟล์
                          statusCode:
                              202 //รหัสการตอบกลับของ api เมื่อบันทึกข้อมูลส าเร็จ
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
  //ฟังก์ชันส าหรับเลือกรูปภาพ
  Future<void> chooseImage(ImageSource source) async {
    //เรียกใช้งาน ImagePicker
    var choosedimage = await ImagePicker().pickImage(source: source);
    setState(() {
      //น าข้อมูลไฟล์รูปภาพที่เลือก มาเก็บไว้ในตัวแปร uploadImage
      uploadImage = File(choosedimage!.path);
    });
  }

  //======================================================
  //ฟังก์ชันส าหรับตรวจสอบการตอบกลับจากการแก้ไขข้อมูลสินค้า
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
              //ให้เรียกใช้งานฟังก์ชัน loadProduct ที่ถูกส่งเข้ามาในหน้านี้
              widget.loadProduct();
              // แสดงกล้องข้อความโต้ตอบ
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Text('แก้ไขข้อมูลส าเร็จ'),
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                //เมื่อกดปุ่ มตกลง ให้กล่องข้อความโต้ตอบหายไป
                                Navigator.of(context).pop();
                                //ถอยกลับไปยังหน้าก่อนหน้านี้ คือหน้าแสดงรายการสินค้า
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
