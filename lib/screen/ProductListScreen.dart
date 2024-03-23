import 'package:flutter/material.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/models/products.dart';
import 'package:flutter_api_db/screen/productItem.dart';

class ProductListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListScreen> {
  //ประกาศตัวแปรประเภท Future ส าหรับเชื่อมข้อมูลที่อ่านได้จาก api
  late Future<Map<String, dynamic>> futureProduct;
  //เหตุการณ์เริ่มตน้ ทา งานของหน้าน
  //ประกาศตัวแปรประเภท Future ส าหรับรับผลลัพธ์ได้จาก api ลบข้อมูลสินค้า
  late Future<Map<String, dynamic>> futureDeleteProduct;
  @override
  void initState() {
    super.initState();
    //เรียกใช้ฟังก์ชัน loadProduct ส าหรับดึงข้อมูล
    loadProduct();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายการสินค้า',
        ),
      ),
      //ในส่วน body ให้เรียกใช้ฟังก์ชัน buildFutureProduct
      body: buildFutureProduct(),
    );
  }

  //ฟังก์ชัน loadProduct ส าหรับเรียกใช้งาน api ดึงขอ้ มูลสินคา้ท้งัหมด
  //========================================================================
  void loadProduct() async {
    ApiBaseHelper apiBaseHelper = ApiBaseHelper();
    setState(() {
      futureProduct = apiBaseHelper.get(url: ApiBaseHelper.getProduct);
    });
  }

  //========================================================================
  //ฟังก์ชัน buildFutureProduct ส าหรับแสดงข้อมูลรายการสินค้าที่อ่านได้
  FutureBuilder<Map<String, dynamic>> buildFutureProduct() {
    return FutureBuilder<Map<String, dynamic>>(
      future: futureProduct,
      builder: (context, snapshot) {
        //ตรวจสอบว่ามีข้อมูลหรือไม่
        if (snapshot.hasData) {
          //ตรวจสอบข้อมูลในส่วน status ว่ามีค่ากับเท่ากับ ok หรือไม่
          if (snapshot.data!['status'] == 'ok') {
            //น าข้อมูลในส่วน data มาเก็บไว้ในตัวแปร productList
            List<dynamic> productList = snapshot.data!['data'];
            //-----------------------------------
            return RefreshIndicator(
              //เมื่อกดลากเลื่อน listview ลงด้่านล่างจะ refresh ข้อมูล
              onRefresh: () {
                return Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    //ให้เรียกใช้งานฟังก์ชัน loadProduct() เพื่ออ่านข้อมูลใหม่
                    loadProduct();
                  },
                );
              },
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    //จัดรูปแบบการแสดงผลแต่ละรายการ ตามที่ก าหนดไว้ใน ProductItem
                    //ซึ่งเขียนไว้ในไฟล์ ProductItem.dart
                    return ProductItem(Products.fromJson(productList[index]),
                        deleteProduct, loadProduct);
                  }),
            );
            //-----------------------------------
          } else {
            //ถ้า status ไม่เท่ากับ ok ให้แสดงข้อความ No data
            return const Text('No data');
          }
        } else if (snapshot.hasError) {
          //ถ้ามี Error จะแสดงข้อมูลแจ้ง error
          return const Text('ผิดพลาด');
        }
        // ถ้ายังไม่มีข้อมูลใดๆ จะแสดงสถานะการโหลดข้อมูล โดยใช้ CircularProgressIndicator
        return SafeArea(
            child: Center(
          child: Container(child: const CircularProgressIndicator()),
        ));
      },
    );
  }

  //ฟังก์ชัน deleteProduct ส าหรับเรียกใช้งาน api ลบข้อมูลสินค้า
  //=================================================================
  void deleteProduct(int productId) async {
    //ก าหนด url ของ api endpoint ส าหรับลบข้อมูลตามรหัสสินค้า
    String urlApi = ApiBaseHelper.deleteProduct + "/" + productId.toString();
    //เรียกใช้งานฟังก์ชัน delete ใน ApiBaseHelper() และส่ง url และรหัส status code เมื่อท างานส าเร็จ
    futureDeleteProduct = ApiBaseHelper().delete(url: urlApi, statusCode: 202);
    //เมื่อ futureDeleteProduct ได้รับผลลัพธ์จากการเรียกใช้ api endpoint แล้วให้ท างานในฟังก์ชัน then
    futureDeleteProduct.then((value) {
      String message;
      if (value['status'] == 'ok') {
        message = 'ลบข้อมูลสำเร็จ';
        //เมื่อลบข้อมูลส าเร็จให้เรียกใช้งานฟังก์ชัน loadProduct()
        loadProduct();
      } else {
        message = 'ผิดพลาด';
      }
      // แสดงกล้องข้อความโต้ตอบ
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text(message),
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
}
