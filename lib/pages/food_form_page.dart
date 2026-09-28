import 'package:flutter/material.dart';
import 'package:open_diet/components/input/number_input.dart';
import 'package:open_diet/components/input/text_input.dart';
import 'package:open_diet/components/input/unit_select.dart';
import 'package:open_diet/models/food.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/theme/colors.dart';

class FoodFormPage extends StatefulWidget {
  const FoodFormPage({super.key});

  @override
  State<FoodFormPage> createState() => _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {
  final nameController = TextEditingController();
  final brandController = TextEditingController();
  final amountController = TextEditingController(text: '100');
  final kcalController = TextEditingController();
  final proteinController = TextEditingController();
  final carbohydrateController = TextEditingController();
  final fatController = TextEditingController();

  String unit = 'g';
  bool isLoading = false;
  String? errorMessage;

  static const _fieldLabels = {
    'name': 'Nome',
    'brand': 'Marca',
    'amount': 'Porção',
    'unit': 'Unidade',
    'kcal': 'Calorias',
    'protein': 'Proteína',
    'carbohydrate': 'Carboidrato',
    'fat': 'Gordura',
  };

  double? parseNumber(TextEditingController controller) {
    return double.tryParse(controller.text.trim().replaceAll(',', '.'));
  }

  Map<String, TextEditingController> get requiredFields => {
    'name': nameController,
    'amount': amountController,
    'kcal': kcalController,
    'protein': proteinController,
    'carbohydrate': carbohydrateController,
    'fat': fatController,
  };

  Future<void> submit() async {
    final errors = {
      for (final field in requiredFields.entries)
        if (field.value.text.trim().isEmpty) field.key: ['é obrigatório'],
    };
    if (errors.isNotEmpty) {
      setState(() {
        errorMessage = formatErrors(errors);
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final brand = brandController.text.trim();

    try {
      final data = await Api.instance.post('/foods', {
        'name': nameController.text.trim(),
        'brand': brand.isEmpty ? null : brand,
        'amount': parseNumber(amountController),
        'unit': unit,
        'kcal': parseNumber(kcalController),
        'protein': parseNumber(proteinController),
        'carbohydrate': parseNumber(carbohydrateController),
        'fat': parseNumber(fatController),
      });

      if (mounted) Navigator.of(context).pop(Food.fromJson(data));
    } on ApiException catch (e) {
      setState(() {
        errorMessage = e.message ?? formatErrors(e.errors);
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

  String formatErrors(Map<String, List<String>> errors) {
    return errors.entries
        .map((entry) {
          final label = _fieldLabels[entry.key] ?? entry.key;
          return '$label ${entry.value.join(', ')}';
        })
        .join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Novo alimento'),
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
                  child: TextInput(hint: 'Nome *', controller: nameController),
                ),
                SizedBox(
                  height: 48,
                  child: TextInput(hint: 'Marca', controller: brandController),
                ),
                SizedBox(height: 4),
                Text(
                  'Valores nutricionais por porção',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: NumberInput(
                          hint: 'Porção *',
                          controller: amountController,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      child: UnitSelect(
                        value: unit,
                        onChanged: (value) => setState(() => unit = value),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    hint: 'Calorias (kcal) *',
                    controller: kcalController,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    hint: 'Proteína (g) *',
                    controller: proteinController,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    hint: 'Carboidrato (g) *',
                    controller: carbohydrateController,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    hint: 'Gordura (g) *',
                    controller: fatController,
                  ),
                ),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    textAlign: .center,
                    style: TextStyle(color: Colors.red.shade300),
                  ),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.grey.shade200,
                            ),
                          )
                        : Text('Salvar'),
                  ),
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
    nameController.dispose();
    brandController.dispose();
    amountController.dispose();
    kcalController.dispose();
    proteinController.dispose();
    carbohydrateController.dispose();
    fatController.dispose();
    super.dispose();
  }
}
