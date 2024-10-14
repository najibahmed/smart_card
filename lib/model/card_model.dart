class CardModel {
  String name;
  String job;
  String email;
  String identifier;
  String phone;
  String company;
  String websiteUrl;
  String address;
  String linkedInProfile;
  String twitterHandle;
  String profileImageUrl;

  CardModel({
    required this.name,
    required this.job,
    required this.email,
    required this.identifier,
    required this.phone,
    required this.company,
    required this.websiteUrl,
    required this.address,
    required this.linkedInProfile,
    required this.twitterHandle,
    required this.profileImageUrl,
  });

  // Convert CardModel to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'job': job,
      'email': email,
      'phone': phone,
      'company': company,
      'websiteUrl': websiteUrl,
      'address': address,
      'linkedInProfile': linkedInProfile,
      'twitterHandle': twitterHandle,
      'profileImageUrl': profileImageUrl,
      'identifier': identifier,
    };
  }

  // Create CardModel from Map
  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      name: map['name'] ?? '',
      job: map['job'] ?? '',
      email: map['email'] ?? '',
      identifier: map['identifier'] ?? '',
      phone: map['phone'] ?? '',
      company: map['company'] ?? '',
      websiteUrl: map['websiteUrl'] ?? '',
      address: map['address'] ?? '',
      linkedInProfile: map['linkedInProfile'] ?? '',
      twitterHandle: map['twitterHandle'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
    );
  }
}
