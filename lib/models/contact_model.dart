// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Contact {
  int? id;
  String name;
  String phone;
  String? email;
  String? imagePath;
  int isFavorite;
  Contact({
    this.id,
    required this.name,
    required this.phone,
    this.email,
    this.imagePath,
    required this.isFavorite,
  });

  Contact copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? imagePath,
    int? isFavorite,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'imagePath': imagePath,
      'isFavorite': isFavorite,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      imagePath: map['imagePath'] != null ? map['imagePath'] as String : null,
      isFavorite: map['isFavorite'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source) as Map<String, dynamic>);
}
