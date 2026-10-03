const sexNames = {'male': 'Masculino', 'female': 'Feminino'};

const activityLevelNames = {
  'sedentary': 'Sedentário (pouco ou nenhum exercício)',
  'light': 'Leve (exercício 1 a 3 dias por semana)',
  'moderate': 'Moderado (exercício 3 a 5 dias por semana)',
  'heavy': 'Intenso (exercício 6 a 7 dias por semana)',
  'athlete': 'Atleta (exercício 2 vezes por dia)',
};

const objectiveNames = {
  'cut': 'Perder peso',
  'maintain': 'Manter peso',
  'bulk': 'Ganhar peso',
};

const _activityFactors = {
  'sedentary': 1.2,
  'light': 1.375,
  'moderate': 1.55,
  'heavy': 1.725,
  'athlete': 1.9,
};

const _objectiveKcal = {'cut': -500, 'maintain': 0, 'bulk': 500};

const _proteinShare = 0.30;
const _carbohydrateShare = 0.35;
const _fatShare = 0.35;

typedef BodyProfile = ({
  String sex,
  int age,
  double weight,
  int height,
  String activityLevel,
  String objective,
});

typedef MacroGoals = ({
  int tdee,
  int kcal,
  int protein,
  int carbohydrate,
  int fat,
});

typedef Macros = ({int protein, int carbohydrate, int fat});

Macros calculateMacros(int kcal) {
  return (
    protein: (kcal * _proteinShare / 4).round(),
    carbohydrate: (kcal * _carbohydrateShare / 4).round(),
    fat: (kcal * _fatShare / 9).round(),
  );
}

MacroGoals calculateGoals(BodyProfile profile) {
  final bmr =
      10 * profile.weight +
      6.25 * profile.height -
      5 * profile.age +
      (profile.sex == 'male' ? 5 : -161);
  final tdee = bmr * _activityFactors[profile.activityLevel]!;
  final kcal = (tdee + _objectiveKcal[profile.objective]!).round();
  final macros = calculateMacros(kcal);

  return (
    tdee: tdee.round(),
    kcal: kcal,
    protein: macros.protein,
    carbohydrate: macros.carbohydrate,
    fat: macros.fat,
  );
}
