bool validateEmail(String email) {
  // Regular expression pattern for email validation
  final RegExp emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$',
  );

  return emailRegex.hasMatch(email);
}

bool validatePassword(String password) {
  // Regular expression pattern for email validation
  final RegExp passwordRegex =
      RegExp(r'^(?=.?[A-Z])(?=.?[a-z])(?=.?[0-9])(?=.?[!@#\$&*~]).{8,}$');

  return passwordRegex.hasMatch(password);
}

bool validatePhoneNo(String phoneNO) {
  // Regular expression pattern for email validation
  final RegExp phoneRegex = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');

  return phoneRegex.hasMatch(phoneNO);
}

bool validateUserName(String name) {
  final RegExp userNameRegx = RegExp('[a-zA-Z]');
  return userNameRegx.hasMatch(name);
}
