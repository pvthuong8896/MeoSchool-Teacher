class LoginValidation {
  static bool isValidSchoolId(String schooldId) {
    return schooldId.trim() != null && schooldId.trim() != "";
  }

  static bool isValidUsername(String username) {
    return username.trim() != null && username.trim().length >= 6;
  }

  static bool isValidPassword(String password) {
    return password.trim() != null && password.trim().length >= 6;
  }

  static bool isValidNull(String data) {
    return data != null && data.length > 0;
  }

  static bool isValidPhone(String phone) {
    bool phoneValid = RegExp(r'(^[+0]84[0-9]{9}$)').hasMatch(phone) || RegExp(r'(^0[0-9]{9}$)').hasMatch(phone);
    return phoneValid;
  }

  static bool isValidEmail(String email) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }
}