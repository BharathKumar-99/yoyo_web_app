class UserActivationModel {
  final String username;
  final String activationCode;
  final String? firstName;
  final String? surname;

  UserActivationModel({
    required this.username,
    required this.activationCode,
    this.firstName,
    this.surname,
  });
}
