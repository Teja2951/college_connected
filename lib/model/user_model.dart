import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String userType;       
  final String? token;        
  final int ukid;                
  final String? registrationId;
  final String? sectionName;
  final String? photo;      
  final String? collegeName;
  final String? departmentName;
  final String? programmeName;
  final int? year;  
  String? f_token;          

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    required this.userType,
    this.token,
    required this.ukid,
    this.registrationId,
    this.sectionName,
    this.photo,
    this.collegeName,
    this.departmentName,
    this.programmeName,
    this.year,
    this.f_token = '',
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? password,
    String? phone,
    String? userType,
    String? token,
    int? ukid,
    String? registrationId,
    String? sectionName,
    String? photo,
    String? collegeName,
    String? departmentName,
    String? programmeName,
    int? year,
    bool? emailVerified,
    bool? phoneVerified,
    bool? active,
    String? f_token,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password?? this.password,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      token: token ?? this.token,
      ukid: ukid ?? this.ukid,
      registrationId: registrationId ?? this.registrationId,
      sectionName: sectionName ?? this.sectionName,
      photo: photo ?? this.photo,
      collegeName: collegeName ?? this.collegeName,
      departmentName: departmentName ?? this.departmentName,
      programmeName: programmeName ?? this.programmeName,
      year: year ?? this.year,
      f_token: f_token ?? this.f_token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password' : password,
      'phone': phone,
      'userType': userType,
      'token': token,
      'ukid': ukid,
      'registrationId': registrationId,
      'sectionName': sectionName,
      'photo': photo,
      'collegeName': collegeName,
      'departmentName': departmentName,
      'programmeName': programmeName,
      'year': year,
      'f_token': f_token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phone: map['phone'] != null ? map['phone'] as String : null,
      userType: map['userType'] as String,
      token: map['token'] != null ? map['token'] as String : null,
      ukid: map['ukid'] as int,
      registrationId: map['registrationId'] != null ? map['registrationId'] as String : null,
      sectionName: map['sectionName'] != null ? map['sectionName'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      collegeName: map['collegeName'] != null ? map['collegeName'] as String : null,
      departmentName: map['departmentName'] != null ? map['departmentName'] as String : null,
      programmeName: map['programmeName'] != null ? map['programmeName'] as String : null,
      year: map['year'] != null ? map['year'] as int : null,
      f_token: map['f_token'] as String? ?? '',    
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email,password:$password, phone: $phone, userType: $userType, token: $token, ukid: $ukid, registrationId: $registrationId, sectionName: $sectionName, photoUrl: $photo, collegeName: $collegeName, departmentName: $departmentName, programmeName: $programmeName, year: $year, f_token: $f_token)';
  }

}
