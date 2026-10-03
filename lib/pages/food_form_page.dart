import 'package:flutter/material.dart';
import 'package:open_diet/components/input/number_input.dart';
import 'package:open_diet/components/input/text_input.dart';
import 'package:open_diet/components/primary_button.dart';
import 'package:open_diet/components/input/unit_select.dart';
import 'package:open_diet/models/food.dart';
import 'package:open_diet/models/food_draft.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/theme/colors.dart';
import 'package:open_diet/utils/errors.dart';
import 'package:open_diet/utils/numbers.dart';

class FoodFormPage extends StatefulWidget {
  const FoodFormPage({super.key, this.food, this.draft});

  final Food? food;
  final FoodDraft? draft;

  @override
  State<FoodFormPage> createState() => _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {
  late final nameController = TextEditingController(
    text: widget.food?.name ?? widget.draft?.name,
  );
  late final brandController = TextEditingController(
    text: widget.food?.brand ?? widget.draft?.brand,
  );
  late final amountController = numberController(
    widget.food?.amount ?? widget.draft?.amount ?? 100,
  );
  late final kcalController = numberController(
    widget.food?.kcal ?? widget.draft?.kcal,
  );
  late final proteinController = numberController(
    widget.food?.protein ?? widget.draft?.protein,
  );
  late final carbohydrateController = numberController(
    widget.food?.carbohydrate ?? widget.draft?.carbohydrate,
  );
  late final fatController = numberController(
    widget.food?.fat ?? widget.draft?.fat,
  );

  late String unit = widget.food?.unit ?? widget.draft?.unit ?? 'g';
  bool isLoading = false;
  String? errorMessage;

  static const _fieldLabels = {
    'name': 'Nome',
    'brand': 'Marca',
    'barcode': 'Código de barras',
    'amount': 'Porção',
    'unit': 'Unidade',
    'kcal': 'Calorias',
    'protein': 'Proteína',
    'carbohydrate': 'Carboidrato',
    'fat': 'Gordura',
  };

  TextEditingController numberController(double? value) {
    return TextEditingController(
      text: value == null ? null : formatAmount(value),
    );
  }

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
        errorMessage = formatErrors(errors, _fieldLabels);
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final brand = brandController.text.trim();
    final food = widget.food;

    try {
      final body = {
        'name': nameController.text.trim(),
        'brand': brand.isEmpty ? null : brand,
        'barcode': widget.draft?.barcode,
        'amount': parseNumber(amountController),
        'unit': unit,
        'kcal': parseNumber(kcalController),
        'protein': parseNumber(proteinController),
        'carbohydrate': parseNumber(carbohydrateController),
        'fat': parseNumber(fatController),
      };
      final data = food == null
          ? await Api.instance.post('/foods', body)
          : await Api.instance.put('/foods/${food.id}', body);

      if (mounted) Navigator.of(context).pop(Food.fromJson(data));
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
        title: Text(widget.food == null ? 'Novo alimento' : 'Editar alimento'),
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
                  child: TextInput(label: 'Nome *', controller: nameController),
                ),
                SizedBox(
                  height: 48,
                  child: TextInput(label: 'Marca', controller: brandController),
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
                          label: 'Porção *',
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
                    label: 'Calorias (kcal) *',
                    controller: kcalController,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    label: 'Proteína (g) *',
                    controller: proteinController,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    label: 'Carboidrato (g) *',
                    controller: carbohydrateController,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: NumberInput(
                    label: 'Gordura (g) *',
                    controller: fatController,
                  ),
                ),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    textAlign: .center,
                    style: TextStyle(color: Colors.red.shade300),
                  ),
                PrimaryButton(
                  label: 'Salvar',
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
