class User {
  int id;
  int partnerId;

  User({this.id, this.partnerId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    partnerId = json['partner_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['partner_id'] = this.partnerId;
    return data;
  }
}
