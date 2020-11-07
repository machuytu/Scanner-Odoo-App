class SaleOrderId {
  String soId;

  SaleOrderId({this.soId});

  SaleOrderId.fromJson(Map<String, dynamic> json) {
    soId = json['so_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['so_id'] = this.soId;
    return data;
  }
}
