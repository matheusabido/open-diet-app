class User {
  final int id;
  final String username;
  final String role;

  final int kcalGoal;
  final int proteinGoal;
  final int carbohydrateGoal;
  final int fatGoal;

  User({
    required this.id,
    required this.username,
    required this.role,
    required this.kcalGoal,
    required this.proteinGoal,
    required this.carbohydrateGoal,
    required this.fatGoal,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      kcalGoal: json['kcal_goal'],
      proteinGoal: json['protein_goal'],
      carbohydrateGoal: json['carbohydrate_goal'],
      fatGoal: json['fat_goal'],
    );
  }
}
