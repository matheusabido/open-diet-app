import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_diet/models/food_draft.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/utils/requests.dart';

const _fieldLabels = {'barcode': 'Código de barras', 'image': 'Foto'};

Future<FoodDraft?> foodFromBarcode(BuildContext context, String barcode) {
  return runRequest(
    context,
    () => Api.instance.foodFromBarcode(barcode),
    fieldLabels: _fieldLabels,
  );
}

Future<FoodDraft?> foodFromPhoto(BuildContext context, String imagePath) {
  return runRequest(
    context,
    () => Api.instance.foodFromPhoto(imagePath),
    fieldLabels: _fieldLabels,
  );
}

Future<String?> pickLabelPhoto() async {
  final picker = ImagePicker();

  Future<XFile?> pick(ImageSource source) {
    return picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
  }

  try {
    return (await pick(ImageSource.camera))?.path;
  } on PlatformException {
    return (await pick(ImageSource.gallery))?.path;
  }
}
