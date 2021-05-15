class Expenses {
  int id;
  String date;
  String title;
  String type;
  int amount;
  String details;

  taskMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['details'] = details;
    map['type'] = type;
    map['amount'] = amount;
    map['date'] = date;
    return map;
  }
}
