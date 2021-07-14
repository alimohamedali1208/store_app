class UserSeller {
  static String _firstName = 'temp',
      _lastName = 'temp',
      _phone,
      _sex,
      _email,
      _pass,
      _company,
      _tax;

  static int _typeMobiles = 0, _typeLaptops = 0, _typeAirConditioner = 0, _typeFridges = 0, _typeElectronics = 0, _typeOtherElectronics = 0;

  static var typeList = [];


  static int get typeMobiles => _typeMobiles;

  static set typeMobiles(int value) {
    _typeMobiles = value;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  get lastName => _lastName;

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

  set lastName(value) {
    _lastName = value;
  }

  get tax => _tax;

  set tax(value) {
    _tax = value;
  }

  get company => _company;

  set company(value) {
    _company = value;
  }

  UserSeller();

  static get typeLaptops => _typeLaptops;

  static set typeLaptops(value) {
    _typeLaptops = value;
  }

  static get typeAirConditioner => _typeAirConditioner;

  static set typeAirConditioner(value) {
    _typeAirConditioner = value;
  }

  static get typeFridges => _typeFridges;

  static set typeFridges(value) {
    _typeFridges = value;
  }

  static get typeElectronics => _typeElectronics;

  static set typeElectronics(value) {
    _typeElectronics = value;
  }

  static get typeOtherElectronics => _typeOtherElectronics;

  static set typeOtherElectronics(value) {
    _typeOtherElectronics = value;
  }
}
