import 'package:flutter/material.dart';

class VoiceButton extends StatelessWidget {
  const VoiceButton({
    super.key,
    required this.isRecording,
    required this.onPressed,
    this.isLoading = false,
  });

  final bool isRecording;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: isLoading ? null : onPressed,
      tooltip: isRecording ? 'Parar gravação' : 'Registrar por voz',
      backgroundColor: isRecording ? Colors.red.shade700 : Colors.blue.shade800,
      foregroundColor: Colors.grey.shade200,
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey.shade200,
              ),
            )
          : Icon(isRecording ? Icons.stop : Icons.mic),
    );
  }
}
