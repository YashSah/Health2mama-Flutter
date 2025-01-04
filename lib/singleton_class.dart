class DataManager {
  // Private constructor
  DataManager._privateConstructor();

  // Singleton instance
  static final DataManager _instance = DataManager._privateConstructor();

  // Factory constructor to return the singleton instance
  factory DataManager() {
    return _instance;
  }

  // Arrays to store selected values
  List<String> _services = [];
  List<String> _specialisations = [];

  // Getter for services
  List<String> get services => _services;

  // Setter for services
  set services(List<String> newServices) {
    _services = newServices;
  }

  // Getter for specialisations
  List<String> get specialisations => _specialisations;

  // Setter for specialisations
  set specialisations(List<String> newSpecialisations) {
    _specialisations = newSpecialisations;
  }
}
