import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_diet/components/recording_indicator.dart';
import 'package:open_diet/components/voice_button.dart';
import 'package:open_diet/components/voice_link_banner.dart';
import 'package:open_diet/models/food.dart';
import 'package:open_diet/models/food_item.dart';
import 'package:open_diet/models/voice_food_item.dart';
import 'package:open_diet/pages/food_item_form_page.dart';
import 'package:open_diet/pages/foods_page.dart';
import 'package:open_diet/pages/voice_link_page.dart';
import 'package:open_diet/theme/colors.dart';
import 'package:open_diet/utils/food_items.dart';
import 'package:open_diet/utils/toast.dart';
import 'package:record/record.dart';

class SelectFoodPage extends StatefulWidget {
  const SelectFoodPage({super.key, required this.meal});

  final String meal;

  @override
  State<SelectFoodPage> createState() => _SelectFoodPageState();
}

class _SelectFoodPageState extends State<SelectFoodPage> {
  static const _maxDuration = Duration(seconds: 15);
  static const _config = RecordConfig(
    encoder: AudioEncoder.wav,
    sampleRate: 16000,
    numChannels: 1,
  );

  final recorder = AudioRecorder();

  bool isRecording = false;
  bool isLoading = false;
  VoiceFoodItem? linking;

  Timer? _timeout;

  Future<void> startRecording() async {
    cancelLink();

    try {
      if (!await recorder.hasPermission()) {
        showError('Permita o uso do microfone para registrar por voz');
        return;
      }

      await recorder.start(
        _config,
        path: '${Directory.systemTemp.path}/voice.wav',
      );
    } catch (_) {
      showError('Não foi possível iniciar a gravação');
      return;
    }

    _timeout = Timer(_maxDuration, stopRecording);
    if (mounted) setState(() => isRecording = true);
  }

  Future<void> stopRecording() async {
    _timeout?.cancel();

    final path = await recorder.stop();
    if (!mounted) return;

    setState(() {
      isRecording = false;
      isLoading = path != null;
    });
    if (path == null) return;

    final voice = await voiceFoodItem(context, path);
    if (!mounted) return;

    setState(() => isLoading = false);
    if (voice == null) return;

    final food = voice.food;
    food == null ? askToLink(voice) : confirm(food, voice);
  }

  Future<void> askToLink(VoiceFoodItem voice) async {
    final action = await Navigator.of(context).push<VoiceLinkAction>(
      MaterialPageRoute(builder: (_) => VoiceLinkPage(voice: voice)),
    );
    if (!mounted) return;

    switch (action) {
      case VoiceLinkAction.link:
        setState(() => linking = voice);
      case VoiceLinkAction.recordAgain:
        startRecording();
      case null:
        break;
    }
  }

  Future<void> linkFood(Food food) async {
    final voice = linking!;

    final linked = await linkFoodAlias(context, voice.aliasId, food);
    if (!linked || !mounted) return;

    cancelLink();
    confirm(food, voice);
  }

  void relink(VoiceFoodItem voice) {
    Navigator.of(context).pop();
    setState(() => linking = voice);
  }

  void cancelLink() {
    setState(() => linking = null);
  }

  Future<void> confirm(Food food, VoiceFoodItem voice) async {
    final draft = await Navigator.of(context).push<FoodItemDraft>(
      MaterialPageRoute(
        builder: (_) => FoodItemFormPage(
          food: food,
          meal: widget.meal,
          amount: voice.amount,
          unit: voice.unit,
          onRelink: () => relink(voice),
        ),
      ),
    );
    if (draft != null && mounted) Navigator.of(context).pop(draft);
  }

  void showError(String message) {
    if (mounted) showToast(context, message, type: ToastType.error);
  }

  @override
  Widget build(BuildContext context) {
    final linking = this.linking;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Adicionar em ${mealNames[widget.meal]}'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.grey.shade200,
      ),
      floatingActionButton: VoiceButton(
        isRecording: isRecording,
        isLoading: isLoading,
        onPressed: isRecording ? stopRecording : startRecording,
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (isRecording)
              Padding(
                padding: .fromLTRB(16, 16, 16, 0),
                child: RecordingIndicator(),
              ),
            if (linking != null)
              Padding(
                padding: .fromLTRB(16, 16, 16, 0),
                child: VoiceLinkBanner(
                  name: linking.name,
                  onCancel: cancelLink,
                ),
              ),
            Expanded(
              child: FoodsPage(
                meal: widget.meal,
                onSelect: linking == null ? null : linkFood,
                showScanButtons: linking == null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timeout?.cancel();
    recorder.dispose();
    super.dispose();
  }
}
