class SaleOrder {
  int id;
  String name;
  String amountUntaxed;
  String amountTax;
  String amountTotal;
  List<Lines> lines;

  SaleOrder(
      {this.id,
      this.name,
      this.amountUntaxed,
      this.amountTax,
      this.amountTotal,
      this.lines});

  SaleOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amountUntaxed = json['amount_untaxed'];
    amountTax = json['amount_tax'];
    amountTotal = json['amount_total'];
    if (json['lines'] != null) {
      lines = new List<Lines>();
      json['lines'].forEach((v) {
        lines.add(new Lines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['amount_untaxed'] = this.amountUntaxed;
    data['amount_tax'] = this.amountTax;
    data['amount_total'] = this.amountTotal;
    if (this.lines != null) {
      data['lines'] = this.lines.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lines {
  int id;
  int orderId;
  String name;
  int sequence;
  String invoiceStatus;
  String priceUnit;
  String priceSubtotal;
  int priceTax;
  String priceTotal;
  String priceReduce;
  String priceReduceTaxinc;
  String priceReduceTaxexcl;
  String discount;
  int productId;
  String productUomQty;
  int productUom;
  String qtyDeliveredMethod;
  String qtyDelivered;
  String qtyDeliveredManual;
  String qtyToInvoice;
  String qtyInvoiced;
  String untaxedAmountInvoiced;
  String untaxedAmountToInvoice;
  Null salesmanId;
  int currencyId;
  int companyId;
  int orderPartnerId;
  Null isExpense;
  Null isDownpayment;
  String state;
  int customerLead;
  Null displayType;
  int createUid;
  String createDate;
  int writeUid;
  String writeDate;
  Null linkedLineId;
  Null productPackaging;
  Null routeId;
  Null warningStock;

  Lines(
      {this.id,
      this.orderId,
      this.name,
      this.sequence,
      this.invoiceStatus,
      this.priceUnit,
      this.priceSubtotal,
      this.priceTax,
      this.priceTotal,
      this.priceReduce,
      this.priceReduceTaxinc,
      this.priceReduceTaxexcl,
      this.discount,
      this.productId,
      this.productUomQty,
      this.productUom,
      this.qtyDeliveredMethod,
      this.qtyDelivered,
      this.qtyDeliveredManual,
      this.qtyToInvoice,
      this.qtyInvoiced,
      this.untaxedAmountInvoiced,
      this.untaxedAmountToInvoice,
      this.salesmanId,
      this.currencyId,
      this.companyId,
      this.orderPartnerId,
      this.isExpense,
      this.isDownpayment,
      this.state,
      this.customerLead,
      this.displayType,
      this.createUid,
      this.createDate,
      this.writeUid,
      this.writeDate,
      this.linkedLineId,
      this.productPackaging,
      this.routeId,
      this.warningStock});

  Lines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    name = json['name'];
    sequence = json['sequence'];
    invoiceStatus = json['invoice_status'];
    priceUnit = json['price_unit'];
    priceSubtotal = json['price_subtotal'];
    priceTax = json['price_tax'];
    priceTotal = json['price_total'];
    priceReduce = json['price_reduce'];
    priceReduceTaxinc = json['price_reduce_taxinc'];
    priceReduceTaxexcl = json['price_reduce_taxexcl'];
    discount = json['discount'];
    productId = json['product_id'];
    productUomQty = json['product_uom_qty'];
    productUom = json['product_uom'];
    qtyDeliveredMethod = json['qty_delivered_method'];
    qtyDelivered = json['qty_delivered'];
    qtyDeliveredManual = json['qty_delivered_manual'];
    qtyToInvoice = json['qty_to_invoice'];
    qtyInvoiced = json['qty_invoiced'];
    untaxedAmountInvoiced = json['untaxed_amount_invoiced'];
    untaxedAmountToInvoice = json['untaxed_amount_to_invoice'];
    salesmanId = json['salesman_id'];
    currencyId = json['currency_id'];
    companyId = json['company_id'];
    orderPartnerId = json['order_partner_id'];
    isExpense = json['is_expense'];
    isDownpayment = json['is_downpayment'];
    state = json['state'];
    customerLead = json['customer_lead'];
    displayType = json['display_type'];
    createUid = json['create_uid'];
    createDate = json['create_date'];
    writeUid = json['write_uid'];
    writeDate = json['write_date'];
    linkedLineId = json['linked_line_id'];
    productPackaging = json['product_packaging'];
    routeId = json['route_id'];
    warningStock = json['warning_stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['name'] = this.name;
    data['sequence'] = this.sequence;
    data['invoice_status'] = this.invoiceStatus;
    data['price_unit'] = this.priceUnit;
    data['price_subtotal'] = this.priceSubtotal;
    data['price_tax'] = this.priceTax;
    data['price_total'] = this.priceTotal;
    data['price_reduce'] = this.priceReduce;
    data['price_reduce_taxinc'] = this.priceReduceTaxinc;
    data['price_reduce_taxexcl'] = this.priceReduceTaxexcl;
    data['discount'] = this.discount;
    data['product_id'] = this.productId;
    data['product_uom_qty'] = this.productUomQty;
    data['product_uom'] = this.productUom;
    data['qty_delivered_method'] = this.qtyDeliveredMethod;
    data['qty_delivered'] = this.qtyDelivered;
    data['qty_delivered_manual'] = this.qtyDeliveredManual;
    data['qty_to_invoice'] = this.qtyToInvoice;
    data['qty_invoiced'] = this.qtyInvoiced;
    data['untaxed_amount_invoiced'] = this.untaxedAmountInvoiced;
    data['untaxed_amount_to_invoice'] = this.untaxedAmountToInvoice;
    data['salesman_id'] = this.salesmanId;
    data['currency_id'] = this.currencyId;
    data['company_id'] = this.companyId;
    data['order_partner_id'] = this.orderPartnerId;
    data['is_expense'] = this.isExpense;
    data['is_downpayment'] = this.isDownpayment;
    data['state'] = this.state;
    data['customer_lead'] = this.customerLead;
    data['display_type'] = this.displayType;
    data['create_uid'] = this.createUid;
    data['create_date'] = this.createDate;
    data['write_uid'] = this.writeUid;
    data['write_date'] = this.writeDate;
    data['linked_line_id'] = this.linkedLineId;
    data['product_packaging'] = this.productPackaging;
    data['route_id'] = this.routeId;
    data['warning_stock'] = this.warningStock;
    return data;
  }
}
