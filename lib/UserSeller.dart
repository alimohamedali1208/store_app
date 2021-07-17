class UserSeller {
  static String _firstName = 'temp',
      _lastName = 'temp',
      _phone,
      _sex,
      _email,
      _pass,
      _company,
      _tax;

  static int _typeMobiles = 0, _typeLaptops = 0, _typeAirConditioner = 0, _typeFridges = 0, _typeProjectors = 0, _typeOtherElectronics = 0
  , _typeTV =0, _typeOtherPC = 0, _typeOtherHome = 0, _typePrinters = 0, _typeStorageDevices = 0, _typeFashion = 0
  , _typeJewelry = 0, _typeCameras = 0, _typeCameraAccessories = 0;

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


  static get typeProjectors => _typeProjectors;

  static set typeProjectors(value) {
    _typeProjectors = value;
  }

  static get typeOtherElectronics => _typeOtherElectronics;

  static set typeOtherElectronics(value) {
    _typeOtherElectronics = value;
  }

  static get typeTV => _typeTV;

  static set typeTV(value) {
    _typeTV = value;
  }

  static get typeOtherPC => _typeOtherPC;

  static set typeOtherPC(value) {
    _typeOtherPC = value;
  }

  static get typeOtherHome => _typeOtherHome;

  static set typeOtherHome(value) {
    _typeOtherHome = value;
  }

  static get typePrinters => _typePrinters;

  static set typePrinters(value) {
    _typePrinters = value;
  }

  static get typeStorageDevices => _typeStorageDevices;

  static set typeStorageDevices(value) {
    _typeStorageDevices = value;
  }

  static get typeFashion => _typeFashion;

  static set typeFashion(value) {
    _typeFashion = value;
  }

  static get typeJewelry => _typeJewelry;

  static set typeJewelry(value) {
    _typeJewelry = value;
  }

  static get typeCameras => _typeCameras;

  static set typeCameras(value) {
    _typeCameras = value;
  }

  static get typeCameraAccessories => _typeCameraAccessories;

  static set typeCameraAccessories(value) {
    _typeCameraAccessories = value;
  }
}
