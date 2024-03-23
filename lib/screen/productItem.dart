import 'package:flutter/material.dart';
import 'package:flutter_api_db/models/products.dart';
import 'package:flutter_api_db/screen/productUpdateScreen.dart';

class ProductItem extends StatefulWidget {
  //object ข้อมูลสินค้าแต่ละรายการ
  Products data;
  //รับค่าข้อมูลสินค้าแต่ละรายการเข้ามาในคลาสนี้
  Function DeleteFunction;
  Function loadProduct;
  ProductItem(this.data, this.DeleteFunction, this.loadProduct);
  @override
  State<StatefulWidget> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {},
      //กล่องแบบ Card
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          //ก าหนดช่องว่างจากขอบกล่อง
          padding: const EdgeInsets.all(8.0),
          child: Row(
            //จัดวางในแนวนอนเป็นแถว
            children: [
              //แสดงรูปภาพ
              Expanded(
                  child: Image.network(
                Uri.decodeFull(widget.data.p_img!),
              )),
              //กล่องว่างๆ
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //แสดงชื่อสินค้า
                    Text(
                      widget.data.p_name!,
                      style: TextStyle(fontSize: 18, color: Colors.orange),
                    ),
                    //แสดงราคา
                    Text(
                      'ราคา: ' + widget.data.p_price.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //ปุ่ มไอคอนส าหรับลบสินค้า
                        IconButton(
                            onPressed: () {
                              //เมื่อถูกกดให้เรียกใช้ฟังก์ชัน deleteFuction และส่งค่ารหัสสินค้าไปด้วย
                              widget.DeleteFunction(widget.data.p_id);
                            },
                            icon: Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              //เมื่อถูกกดให้เปิ ดหน้า ProductAddScreen และส่งข้อมูลสินค้าไปด้วย
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductUpdateScreen(
                                            data: widget.data,
                                            loadProduct: widget.loadProduct,
                                          )));
                            },
                            icon: Icon(Icons.edit_note_outlined))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
