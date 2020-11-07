class CloudMessing {
  String soName;
  int soId;
  String partnerName;

  CloudMessing({this.soName, this.soId, this.partnerName});

  CloudMessing.fromJson(Map<String, dynamic> json) {
    soName = json['so_name'];
    soId = json['so_id'];
    partnerName = json['partner_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['so_name'] = this.soName;
    data['so_id'] = this.soId;
    data['partner_name'] = this.partnerName;
    return data;
  }
}
