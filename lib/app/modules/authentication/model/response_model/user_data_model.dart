class CurrentUserModel {
  dynamic email;
  dynamic firstName;
  dynamic lastName;

  dynamic createdAt;

  CurrentUserModel({this.email, this.firstName, this.lastName, this.createdAt});

  CurrentUserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['createdAt'] = createdAt;
    return data;
  }
}
