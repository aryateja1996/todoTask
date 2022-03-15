class Details {
  String email;
  String phone;
  bool complete;

  Details(this.email, this.phone, {this.complete = false});

  Details.fromMap(Map map)
      : email = map['email'],
        phone = map['phone'],
        complete = map['complete'];

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phone': phone,
      'complete': complete,
    };
  }
}
