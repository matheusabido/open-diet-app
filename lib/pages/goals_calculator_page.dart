import 'package:flutter/material.dart';
import 'package:open_diet/components/input/number_input.dart';
import 'package:open_diet/components/input/option_select.dart';
import 'package:open_diet/components/nutrient_row.dart';
import 'package:open_diet/components/primary_button.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/theme/colors.dart';
import 'package:open_diet/utils/errors.dart';
import 'package:open_diet/utils/numbers.dart';
import 'package:open_diet/utils/tdee.dart';
import 'package:open_diet/utils/toast.dart';

class GoalsCalculatorPage extends StatefulWidget {
  const GoalsCalculatorPage({super.key});

  @override
  State<GoalsCalculatorPage> createState() => _GoalsCalculatorPageState();
}

class _GoalsCalculatorPageState extends State<GoalsCalculatorPage> {
  final user = Api.instance.user!;

  late final ageController = TextEditingController(text: '${user.age ?? ''}');
  late final weightController = TextEditingController(
    text: user.weight == null ? '' : formatAmount(user.weight!),
  );
  late final heightController = TextEditingController(
    text: '${user.height ?? ''}',
  );

  late String sex = user.sex ?? sexNames.keys.first;
  late String activityLevel =
      user.activityLevel ?? activityLevelNames.keys.first;
  late String objective = user.objective ?? 'maintain';

  bool isLoading = false;
  String? errorMessage;

  static const _fieldLabels = {
    'sex': 'Sexo',
    'age': 'Idade',
    'weight': 'Peso',
    'height': 'Altura',
    'activity_level': 'Nível de atividade',
    'objective': 'Objetivo',
    'kcal_goal': 'Calorias',
    'protein_goal': 'Proteína',
    'carbohydrate_goal': 'Carboidrato',
    'fat_goal': 'Gordura',
  };

  @override
  void initState() {
    super.initState();
    ageController.addListener(onInputChanged);
    weightController.addListener(onInputChanged);
    heightController.addListener(onInputChanged);
  }

  void onInputChanged() {
    setState(() {});
  }

  BodyProfile? get profile {
    final age = int.tryParse(ageController.text.trim());
    final weight = double.tryParse(
      weightController.text.trim().replaceAll(',', '.'),
    );
    final height = int.tryParse(heightController.text.trim());
    if (age == null || weight == null || height == null) return null;
    if (age <= 0 || weight <= 0 || height <= 0) return null;

    return (
      sex: sex,
      age: age,
      weight: weight,
      height: height,
      activityLevel: activityLevel,
      objective: objective,
    );
  }

  Future<void> submit() async {
    final profile = this.profile;
    if (profile == null) {
      setState(() {
        errorMessage = 'Preencha idade, peso e altura com valores válidos';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await Api.instance.updateBodyProfile(profile, calculateGoals(profile));
      if (mounted) {
        showToast(context, 'Metas salvas');
        Navigator.of(context).pop();
      }
    } on ApiException catch (e) {
      setState(() {
        errorMessage = e.message ?? formatErrors(e.errors, _fieldLabels);
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Não foi possível conectar ao servidor';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = this.profile;
    final goals = profile == null ? null : calculateGoals(profile);
    const labelStyle = TextStyle(color: AppColors.textSecondary);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Calcular metas'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.grey.shade200,
      ),
      body: SafeArea(
        child: ListView(
          padding: .all(16),
          children: [
            Column(
              crossAxisAlignment: .stretch,
              spacing: 12,
              children: [
                Text('Sexo *', style: labelStyle),
                SizedBox(
                  height: 48,
                  child: OptionSelect(
                    value: sex,
                    options: sexNames,
                    onChanged: (value) => setState(() => sex = value),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    label: 'Idade (anos) *',
                    controller: ageController,
                    decimal: false,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    label: 'Peso (kg) *',
                    controller: weightController,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    label: 'Altura (cm) *',
                    controller: heightController,
                    decimal: false,
                  ),
                ),
                Text('Nível de atividade *', style: labelStyle),
                SizedBox(
                  height: 48,
                  child: OptionSelect(
                    value: activityLevel,
                    options: activityLevelNames,
                    onChanged: (value) => setState(() => activityLevel = value),
                  ),
                ),
                Text('Objetivo *', style: labelStyle),
                SizedBox(
                  height: 48,
                  child: OptionSelect(
                    value: objective,
                    options: objectiveNames,
                    onChanged: (value) => setState(() => objective = value),
                  ),
                ),
                if (goals != null) ...[
                  SizedBox(height: 4),
                  Text('Metas diárias calculadas', style: labelStyle),
                  NutrientRow(
                    label: 'Gasto diário',
                    value: goals.tdee.toDouble(),
                    unit: 'kcal',
                  ),
                  NutrientRow(
                    label: 'Calorias',
                    value: goals.kcal.toDouble(),
                    unit: 'kcal',
                  ),
                  NutrientRow(
                    label: 'Proteína',
                    value: goals.protein.toDouble(),
                    unit: 'g',
                    color: Colors.red,
                  ),
                  NutrientRow(
                    label: 'Carboidrato',
                    value: goals.carbohydrate.toDouble(),
                    unit: 'g',
                    color: Colors.blue,
                  ),
                  NutrientRow(
                    label: 'Gordura',
                    value: goals.fat.toDouble(),
                    unit: 'g',
                    color: Colors.amber,
                  ),
                ],
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    textAlign: .center,
                    style: TextStyle(color: Colors.red.shade300),
                  ),
                SizedBox(height: 4),
                PrimaryButton(
                  label: 'Salvar metas',
                  onPressed: submit,
                  isLoading: isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }
}
