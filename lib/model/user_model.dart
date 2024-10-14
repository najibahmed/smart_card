// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
final String? name;
final String? jobTitle;
final String? company;
final String? email;
final String? website;
final String? phoneNumber;
final String? address;
final String? linkedInProfile;
final String? twitterHandle;
  UserModel({this.jobTitle,
    this.name,
    this.company,
    this.email,
    this.website,
    this.phoneNumber,
    this.address,
    this.linkedInProfile,
    this.twitterHandle
  });

  UserModel copyWith({
    String? name,
    String? company,
    String? email,
    String? website,
    String? phoneNumber,
    String? address,
    String? linkedInProfile,
    String? twitterHandle,
  }) {
    return UserModel(
      name: name ?? this.name,
      company: company ?? this.company,
      email: email ?? this.email,
      website: website ?? this.website,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      linkedInProfile: linkedInProfile ?? this.linkedInProfile,
      twitterHandle: twitterHandle ?? this.twitterHandle,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'company': company,
      'email': email,
      'website': website,
      'phoneNumber': phoneNumber,
      'address': address,
      'linkedInProfile': linkedInProfile,
      'twitterHandle': twitterHandle,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] != null ? map['name'] as String : null,
      company: map['company'] != null ? map['company'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      website: map['website'] != null ? map['website'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      linkedInProfile: map['linkedInProfile'] != null ? map['linkedInProfile'] as String : null,
      twitterHandle: map['twitterHandle'] != null ? map['twitterHandle'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, company: $company, email: $email, website: $website, phoneNumber: $phoneNumber, address: $address, linkedInProfile: $linkedInProfile, twitterHandle: $twitterHandle)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.company == company &&
      other.email == email &&
      other.website == website &&
      other.phoneNumber == phoneNumber &&
      other.address == address &&
      other.linkedInProfile == linkedInProfile &&
      other.twitterHandle == twitterHandle;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      company.hashCode ^
      email.hashCode ^
      website.hashCode ^
      phoneNumber.hashCode ^
      address.hashCode ^
      linkedInProfile.hashCode ^
      twitterHandle.hashCode;
  }
}
