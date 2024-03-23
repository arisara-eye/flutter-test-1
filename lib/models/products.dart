import 'package:json_annotation/json_annotation.dart';
part 'products.g.dart';

@JsonSerializable(explicitToJson: true)
class Products {
//ก ำหนดรำยชื่อฟิวด์ในตำรำง products พร้อมก ำหนดชนิดข้อมูล
  String? p_name, created_at, updated_at, p_img;
  int? p_id;
  double? p_price;
//ก ำหนดตำมรำยชื่อฟิวด์ที่ประกำศไว้ข้ำงต้น
  Products({
    this.p_id,
    this.p_name,
    this.p_price,
    this.created_at,
    this.updated_at,
    this.p_img,
  });
  factory Products.fromJson(Map<String, dynamic> data) =>
      _$ProductsFromJson(data);
  Map<String, dynamic> toJson() => _$ProductsToJson(this);
}
