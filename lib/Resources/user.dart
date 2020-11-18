
class User{
  final double key;
  final String correo;

  User({this.key,this.correo});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      key: double.parse(json['key']),
      correo: json['correo'],
    );
  }
}