import 'dart:convert';

// Parsing function to handle incoming JSON data
FindModel findModelFromJson(String str) => FindModel.fromJson(json.decode(str));

String findModelToJson(FindModel data) => json.encode(data.toJson());

class FindModel {
  Result result;
  String responseMessage;
  int responseCode;

  FindModel({
    required this.result,
    required this.responseMessage,
    required this.responseCode,
  });

  factory FindModel.fromJson(Map<String, dynamic> json) => FindModel(
    result: Result.fromJson(json["result"]),
    responseMessage: json["responseMessage"],
    responseCode: json["responseCode"],
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
    "responseMessage": responseMessage,
    "responseCode": responseCode,
  };
}

class Result {
  List<Specialization> specializations;  // Now this holds the specialization list
  int totalDocs;
  int limit;
  int totalPages;
  int page;
  int pagingCounter;
  bool hasPrevPage;
  bool hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  Result({
    required this.specializations,  // Change the docs to specializations
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
    required this.prevPage,
    required this.nextPage,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    specializations: List<Specialization>.from(json["docs"].map((x) => Specialization.fromJson(x))), // Now parsing specializations
    totalDocs: json["totalDocs"],
    limit: json["limit"],
    totalPages: json["totalPages"],
    page: json["page"],
    pagingCounter: json["pagingCounter"],
    hasPrevPage: json["hasPrevPage"],
    hasNextPage: json["hasNextPage"],
    prevPage: json["prevPage"],
    nextPage: json["nextPage"],
  );

  Map<String, dynamic> toJson() => {
    "docs": List<dynamic>.from(specializations.map((x) => x.toJson())),
    "totalDocs": totalDocs,
    "limit": limit,
    "totalPages": totalPages,
    "page": page,
    "pagingCounter": pagingCounter,
    "hasPrevPage": hasPrevPage,
    "hasNextPage": hasNextPage,
    "prevPage": prevPage,
    "nextPage": nextPage,
  };
}

class Specialization {
  String id;
  String name;
  String status;
  String createdAt;
  String updatedAt;

  Specialization({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) => Specialization(
    id: json["_id"] ?? '',
    name: json["name"] ?? '',
    status: json["status"] ?? '',
    createdAt: json["createdAt"] ?? '',
    updatedAt: json["updatedAt"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "status": status,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

class Doc {
  String id;
  String type;
  String name;
  String status;
  String createdAt;
  String updatedAt;
  String docId;
  bool isSelected = false;

  Doc({
    required this.id,
    required this.type,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.docId,
    required this.isSelected,
  });

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
    id: json["_id"] ?? '',
    type: json["type"] ?? '',
    name: json["name"] ?? '',
    status: json["status"] ?? '',
    createdAt: json["createdAt"] ?? '',
    updatedAt: json["updatedAt"] ?? '',
    docId: json["id"] ?? '',
    isSelected: json["isSelected"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "name": name,
    "status": status,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "id": docId,
    "isSelected": isSelected,
  };
}
