import 'package:flutter/material.dart';
import 'package:flutter_api_db/screen/UserAccountScreen.dart';
import 'package:flutter_api_db/screen/aboutUs.dart';
import 'package:flutter_api_db/screen/loginScreen.dart';
import 'package:flutter_api_db/screen/productAddScreen.dart';
import 'package:flutter_api_db/screen/productListScreen.dart';

import '../models/users.dart';

class HomeScreen extends StatefulWidget {
  Users user;
  HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //ตัวแปร _selectedIndex สำหรับจัดเก็บลำดับตำแหน่งเมนูบน bottomNavigationBar
  int _selectedIndex = 0; //ค่า 0 คือลำดับแรก
  //กำหนดรายการของหน้าทั้งหมดไว้ในตัวแปร _pages
  static List<Widget> _pages = <Widget>[
    ProductListScreen(), //หน้าแสดงรายการสินค้า
    ProductAddScreen(), //หน้าเพิ่มข้อมูลสินค้า
    AboutUs(), //หน้าเกี่ยวกับเรา
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //หน้าจะเปลี่ยนตามการกดเลือกเมนู
      body: _pages.elementAt(_selectedIndex),
      drawer: showDrawer(context),
      //รายการเมนูอยู่ด้านล่างจอ
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            _selectedIndex, //แสดงตำแหน่งปัจจุบันตามค่าตัวแปร _selectedIndex
        onTap:
            _onItemTapped, //เมื่อกดเลือกเมนูให้ไปทำงานที่ฟังก์ชัน _onItemTapped
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'รายการสินค้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'เพิ่มสินค้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert_sharp),
            label: 'เกี่ยวกับเรา',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      //กำหนดให้ตัวแปร _selectedIndex มีค่าเท่ากับตำแหน่งเมนูที่เลือกใน bottomNavigationBar
      _selectedIndex = index;
    });
  }

//ฟังก์ชัน showDrawer สำหรับแสดงเมนูด้านซ้าย
  Widget showDrawer(BuildContext context) {
    // UsersData usersData = UsersData();
    // Users user = usersData.usersData;

    Users user = Users();

    user.first_name = widget.user.first_name;
    user.Last_name = widget.user.Last_name;
    user.email = widget.user.email;
    user.u_id = widget.user.u_id;

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.first_name! + " " + user.Last_name!),
            accountEmail: Text(user.email!),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://www.seekpng.com/png/full/245-2454602_tanni-chand-default-user-image-png.png"),
            ),
          ),
          //รายการเมนู
          //////////////////////////////////////////////////////////////////////////////////////////////////////
          ListTile(
            title: const Text('แก้ไขข้อมูลบัญชีผู้ใช้'),
            onTap: () {
              Navigator.pop(context);
              //เปิดหน้า UserAccountPage
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserAccountScreen(data: user)),
              );
///////////////////////////////////////////////////////////////////////////////////////////////////////
            },
          ),
          ListTile(
            title: const Text('ออกจากระบบ'),
            onTap: () {
              Navigator.pop(context);
              //ออกจากหน้าทั้งหมด แล้วไปเปิดหน้า login ใหม่
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()),
                  ModalRoute.withName('/'));
              // );
            },
          ),
        ],
      ),
    );
  }
}
