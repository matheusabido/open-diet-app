import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_diet/components/food_card.dart';
import 'package:open_diet/components/food_list_footer.dart';
import 'package:open_diet/components/input/text_input.dart';
import 'package:open_diet/components/scan_button.dart';
import 'package:open_diet/models/food.dart';
import 'package:open_diet/models/food_draft.dart';
import 'package:open_diet/models/food_item.dart';
import 'package:open_diet/pages/barcode_scanner_page.dart';
import 'package:open_diet/pages/food_detail_page.dart';
import 'package:open_diet/pages/food_form_page.dart';
import 'package:open_diet/pages/food_item_form_page.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/utils/foods.dart';

class FoodsPage extends StatefulWidget {
  const FoodsPage({
    super.key,
    this.meal,
    this.onSelect,
    this.showScanButtons = true,
  });

  final String? meal;
  final ValueChanged<Food>? onSelect;
  final bool showScanButtons;

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> {
  final controller = TextEditingController();
  final scrollController = ScrollController();

  static const _pageSize = 20;
  static const _minHeightForScanButtons = 320;

  List<Food> foods = [];
  bool isLoading = false;
  bool hasMore = true;
  bool isReadingBarcode = false;
  bool isReadingPhoto = false;
  String? errorMessage;

  Timer? _debounce;
  int _request = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
    loadFoods(reset: true);
  }

  Future<void> loadFoods({bool reset = false}) async {
    final request = ++_request;

    setState(() {
      isLoading = true;
      errorMessage = null;
      if (reset) {
        foods = [];
        hasMore = true;
      }
    });

    String? error;
    try {
      final data = await Api.instance.get('/foods', {
        'search': controller.text.trim(),
        if (foods.isNotEmpty) 'after': '${foods.last.id}',
      });
      if (request != _request || !mounted) return;

      final page = (data as List? ?? [])
          .map((json) => Food.fromJson(json))
          .toList();

      setState(() {
        foods = [...foods, ...page];
        hasMore = page.length == _pageSize;
      });
    } on ApiException catch (e) {
      error = e.message ?? 'Não foi possível carregar os alimentos';
    } catch (_) {
      error = 'Não foi possível conectar ao servidor';
    } finally {
      if (request == _request && mounted) {
        setState(() {
          isLoading = false;
          errorMessage = error;
        });
      }
    }
  }

  void onScroll() {
    final position = scrollController.position;
    if (position.pixels < position.maxScrollExtent - 200) return;
    if (isLoading || !hasMore || errorMessage != null) return;
    loadFoods();
  }

  void onSearch(String _) {
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 400), () {
      loadFoods(reset: true);
    });
  }

  Future<void> openForm([FoodDraft? draft]) async {
    final food = await Navigator.of(
      context,
    ).push<Food>(MaterialPageRoute(builder: (_) => FoodFormPage(draft: draft)));
    if (food != null) loadFoods(reset: true);
  }

  Future<void> scanBarcode() async {
    final barcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
    );
    if (barcode == null || !mounted) return;

    setState(() => isReadingBarcode = true);
    final draft = await foodFromBarcode(context, barcode);
    if (!mounted) return;

    setState(() => isReadingBarcode = false);
    if (draft != null) openForm(draft);
  }

  Future<void> takePhoto() async {
    final path = await pickLabelPhoto();
    if (path == null || !mounted) return;

    setState(() => isReadingPhoto = true);
    final draft = await foodFromPhoto(context, path);
    if (!mounted) return;

    setState(() => isReadingPhoto = false);
    if (draft != null) openForm(draft);
  }

  void openDetail(Food food) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FoodDetailPage(
          food: food,
          onUpdated: onFoodUpdated,
          onDeleted: () => onFoodDeleted(food),
        ),
      ),
    );
  }

  Future<void> selectFood(Food food) async {
    final draft = await Navigator.of(context).push<FoodItemDraft>(
      MaterialPageRoute(
        builder: (_) => FoodItemFormPage(food: food, meal: widget.meal),
      ),
    );
    if (draft != null && mounted) Navigator.of(context).pop(draft);
  }

  void onFoodTap(Food food) {
    final onSelect = widget.onSelect;
    if (onSelect != null) return onSelect(food);

    widget.meal == null ? openDetail(food) : selectFood(food);
  }

  void onFoodUpdated(Food updated) {
    setState(() {
      foods = [for (final f in foods) f.id == updated.id ? updated : f];
    });
  }

  void onFoodDeleted(Food deleted) {
    setState(() {
      foods = foods.where((f) => f.id != deleted.id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showScanButtons =
            widget.showScanButtons &&
            constraints.maxHeight >= _minHeightForScanButtons;

        return Padding(
          padding: .all(16),
          child: Column(
            spacing: 16,
            children: [
              if (showScanButtons)
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: ScanButton(
                        icon: Icons.qr_code_scanner,
                        label: 'Código de barras',
                        onPressed: scanBarcode,
                        isLoading: isReadingBarcode,
                      ),
                    ),
                    Expanded(
                      child: ScanButton(
                        icon: Icons.photo_camera,
                        label: 'Foto da tabela',
                        onPressed: takePhoto,
                        isLoading: isReadingPhoto,
                      ),
                    ),
                  ],
                ),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: TextInput(
                        label: 'Pesquisar por nome',
                        controller: controller,
                        onChanged: onSearch,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      onPressed: () => openForm(),
                      icon: Icon(Icons.add, color: Colors.grey.shade300),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => loadFoods(reset: true),
                  child: ListView.separated(
                    controller: scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: foods.length + 1,
                    separatorBuilder: (_, _) => SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (index == foods.length) {
                        return FoodListFooter(
                          isLoading: isLoading,
                          isEmpty: foods.isEmpty,
                          errorMessage: errorMessage,
                          onRetry: loadFoods,
                        );
                      }

                      final food = foods[index];
                      return FoodCard(food: food, onTap: () => onFoodTap(food));
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }
}
