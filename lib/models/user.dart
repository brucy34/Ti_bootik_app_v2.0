class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String avatar;
  // final bool isFavorite;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.avatar,
    // required this.isFavorite,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      avatar: json['avatar'],
    );
  }

  Map<String,dynamic> mapping(){
    return {'id':id,
      'name':name,
      'email':email,
      'password':password,
      'role':role,
      'avatar':avatar};
  }

}