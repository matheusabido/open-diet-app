import 'package:flutter/material.dart';
import 'package:open_diet/components/input/number_input.dart';
import 'package:open_diet/components/primary_button.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/theme/colors.dart';
import 'package:open_diet/utils/errors.dart';
import 'package:open_diet/utils/toast.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final user = Api.instance.user!;

  late final kcalController = TextEditingController(text: '${user.kcalGoal}');
  late final proteinController = TextEditingController(
    text: '${user.proteinGoal}',
  );
  late final carbohydrateController = TextEditingController(
    text: '${user.carbohydrateGoal}',
  );
  late final fatController = TextEditingController(text: '${user.fatGoal}');

  bool isLoading = false;
  String? errorMessage;

  static const _fieldLabels = {
    'kcal_goal': 'Calorias',
    'protein_goal': 'Proteína',
    'carbohydrate_goal': 'Carboidrato',
    'fat_goal': 'Gordura',
  };

  Map<String, TextEditingController> get requiredFields => {
    'kcal_goal': kcalController,
    'protein_goal': proteinController,
    'carbohydrate_goal': carbohydrateController,
    'fat_goal': fatController,
  };

  Future<void> submit() async {
    final errors = {
      for (final field in requiredFields.entries)
        if (int.tryParse(field.value.text.trim()) == null)
          field.key: ['deve ser um número inteiro'],
    };
    if (errors.isNotEmpty) {
      setState(() {
        errorMessage = formatErrors(errors, _fieldLabels);
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await Api.instance.updateGoals(
        kcal: int.parse(kcalController.text.trim()),
        protein: int.parse(proteinController.text.trim()),
        carbohydrate: int.parse(carbohydrateController.text.trim()),
        fat: int.parse(fatController.text.trim()),
      );
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Metas diárias'),
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
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    label: 'Calorias (kcal) *',
                    controller: kcalController,
                    decimal: false,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    label: 'Proteína (g) *',
                    controller: proteinController,
                    decimal: false,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    label: 'Carboidrato (g) *',
                    controller: carbohydrateController,
                    decimal: false,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    label: 'Gordura (g) *',
                    controller: fatController,
                    decimal: false,
                  ),
                ),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    textAlign: .center,
                    style: TextStyle(color: Colors.red.shade300),
                  ),
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
    kcalController.dispose();
    proteinController.dispose();
    carbohydrateController.dispose();
    fatController.dispose();
    super.dispose();
  }
}
