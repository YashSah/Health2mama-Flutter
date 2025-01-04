class Optionselection {
  String title;
  String value;
  bool selected;

  Optionselection({required this.title,required this.value, required this.selected});

  // Convert JSON to User object
  factory Optionselection.fromJson(Map<String, dynamic> json) {
    return Optionselection(
      title: json['title'],
      value: json['value'],
      selected: json['selected'],
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'selected': selected,
    };
  }
}