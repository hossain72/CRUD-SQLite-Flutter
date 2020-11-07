class Contact {
  static const tblContact = 'contacts';
  static const colId = 'id';
  static const colName = 'name';
  static const colMobileNumber = 'mobileNumber';

  int id;
  String name, mobileNumber;

  Contact({this.id, this.name, this.mobileNumber});

  Contact.formMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    mobileNumber = map[colMobileNumber];
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    var map = <String, dynamic>{'name': name, 'mobileNumber': mobileNumber};
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}
