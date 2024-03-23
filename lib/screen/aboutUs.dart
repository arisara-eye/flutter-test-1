import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('(ผู้จัดทำ)'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('อริสรา สัตย์ซื่อ'),
            Text('คณะบัญชีและการจัดการ'),
            Text('มหาวิทยาลัยมหาสารคาม'),
            Image.network(
                'https://scontent.fbkk20-1.fna.fbcdn.net/v/t39.30808-6/428153668_2193964850807793_308891037659948058_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeGKR1jC4enUJKOuqAtt9Hz3DzYMDZrQ6NcPNgwNmtDo15a0ZYzkqskAYHYiSmASA9nZ52epKXWjtDOvT14bX23a&_nc_ohc=PiN-is5kz98AX9xiKHY&_nc_ht=scontent.fbkk20-1.fna&oh=00_AfBaRAoZQAmklqs5ImWSWvhQUVXEn88gt_XjANyp_vR9IA&oe=6602A959')
          ],
        ),
      ),
    );
  }
}
