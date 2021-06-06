class UserCustomer {
  static String _firstName = 'temp',
      _lastName = 'temp',
      _phone,
      _sex,
      _email,
      _pass,
      _userID;

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  get userID => _userID;

  set userID(String value){
    _userID = value;
  }

  get lastName => _lastName;

  set lastName(value) {
    _lastName = value;
  }

  get getPass => _pass;

  set pass(value) {
    _pass = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  get sex => _sex;

  set sex(value) {
    _sex = value;
  }

  get phone => _phone;

  set phone(value) {
    _phone = value;
  }
}
