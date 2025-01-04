class Result {
  String? id;
  String? isoCode;
  String? name;
  String? flag;
  String? currency;
  String? status;
  int? v;
  String? countryCode;
  String? createdAt;
  String? updatedAt;
  bool? selected = false;

  Result({this.id, this.isoCode, this.name, this.flag, this.currency, this.status, this.v, this.createdAt, this.updatedAt ,this.countryCode});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    isoCode = json['isoCode'];
    name = json['name'];
    flag = json['flag'];
    countryCode = json['countryCode'];
    currency = json['currency'];
    status = json['status'];
    v = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = id;
    data['isoCode'] = isoCode;
    data['name'] = name;
    data['flag'] = flag;
    data['currency'] = currency;
    data['status'] = status;
    data['__v'] = v;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['selected'] = selected;
    return data;
  }
}

class Root {
  List<Result?>? result;
  String? responseMessage;
  int? responseCode;

  Root({this.result, this.responseMessage, this.responseCode});

  Root.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['result'] = result != null ? result!.map((v) => v?.toJson()).toList() : null;
    data['responseMessage'] = responseMessage;
    data['responseCode'] = responseCode;
    return data;
  }
}