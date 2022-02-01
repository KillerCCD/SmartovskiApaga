class Company {
  final String fullname;
  final String phoneNumber;
  final String password;
  final String name;
  final String taxCode;
  final String legalAddress;
  final String signingDirector;
  final String email;

  Company(
      {this.fullname,
      this.phoneNumber,
      this.password,
      this.name,
      this.taxCode,
      this.legalAddress,
      this.signingDirector,
      this.email});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
        fullname: json['fullName'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        password: json['password'] ?? '',
        name: json['name'] ?? '',
        taxCode: json['taxCode'] ?? '',
        legalAddress: json['legalAddress'] ?? '',
        signingDirector: json['signingDirector'] ?? '',
        email: json['email'] ?? '');
  }

  Map toMap() {
    return {
      'fullName': fullname ?? '',
      'phoneNumber': phoneNumber ?? '',
      'password': password ?? '',
      'name': name ?? '',
      'taxCode': taxCode ?? '',
      'legalAddress': legalAddress ?? '',
      'signingDirector': signingDirector ?? '',
      'email': email ?? '',
    };
  }
}
