class User {
  final int id;
  final String username;
  final String role;

  final int kcalGoal;
  final int proteinGoal;
  final int carbohydrateGoal;
  final int fatGoal;

  final String? sex;
  final int? age;
  final double? weight;
  final int? height;
  final String? activityLevel;
  final String? objective;

  bool get isAdmin => role == 'admin';

  User({
    required this.id,
    required this.username,
    required this.role,
    required this.kcalGoal,
    required this.proteinGoal,
    required this.carbohydrateGoal,
    required this.fatGoal,
    this.sex,
    this.age,
    this.weight,
    this.height,
    this.activityLevel,
    this.objective,
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
      sex: json['sex'],
      age: json['age'],
      weight: (json['weight'] as num?)?.toDouble(),
      height: json['height'],
      activityLevel: json['activity_level'],
      objective: json['objective'],
    );
  }
}
