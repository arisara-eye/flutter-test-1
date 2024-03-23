import 'package:json_annotation/json_annotation.dart';
part 'users.g.dart';

@JsonSerializable(explicitToJson: true)
class Users {
//ก ำหนดรำยชื่อฟิวด์ในตำรำง products พร้อมก ำหนดชนิดข้อมูล
  String? first_name, Last_name, email, created_at, updated_at;
  int? u_id;

//ก ำหนดตำมรำยชื่อฟิวด์ที่ประกำศไว้ข้ำงต้น
  Users({
    this.u_id,
    this.first_name,
    this.Last_name,
    this.email,
    this.created_at,
    this.updated_at,
  });
  factory Users.fromJson(Map<String, dynamic> data) => _$UsersFromJson(data);
  Map<String, dynamic> toJson() => _$UsersToJson(this);
}
