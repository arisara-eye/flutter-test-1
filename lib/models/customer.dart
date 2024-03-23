import 'package:json_annotation/json_annotation.dart';
part 'customer.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer {
//ก ำหนดรำยชื่อฟิวด์ในตำรำง products พร้อมก ำหนดชนิดข้อมูล
  String? c_name, created_at, updated_at, c_img, c_address;
  int? c_id;
//ก ำหนดตำมรำยชื่อฟิวด์ที่ประกำศไว้ข้ำงต้น
  Customer({
    this.c_id,
    this.c_name,
    this.c_img,
    this.c_address,
    this.created_at,
    this.updated_at,
  });
  factory Customer.fromJson(Map<String, dynamic> data) =>
      _$CustomerFromJson(data);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
