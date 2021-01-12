class UserCustomer {
  String _firstName, _lastName, _phone, _sex, _email, _pass;

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  get lastName => _lastName;

  get pass => _pass;

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

  set lastName(value) {
    _lastName = value;
  }
}
