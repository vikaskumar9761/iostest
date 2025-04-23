class PaymentTriggerResp {
  String? gpay;
  String? phonepe;
  String? amount;
  String? transid;
  String? androidUpi;
  String? paytm;
  String? message;

  PaymentTriggerResp(
      {this.gpay,
      this.phonepe,
      this.amount,
      this.transid,
      this.androidUpi,
      this.paytm,
      this.message});

  PaymentTriggerResp.fromJson(Map<String, dynamic> json) {
    gpay = json['gpay'];
    phonepe = json['phonepe'];
    amount = json['amount'];
    transid = json['transid'];
    androidUpi = json['androidUpi'];
    paytm = json['paytm'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gpay'] = gpay;
    data['phonepe'] = phonepe;
    data['amount'] = amount;
    data['transid'] = transid;
    data['androidUpi'] = androidUpi;
    data['paytm'] = paytm;
    data['message'] = message;
    return data;
  }
}