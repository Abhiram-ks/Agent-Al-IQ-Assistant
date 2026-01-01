import 'package:agent_ai/core/common/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:agent_ai/src/riverpod/text_recognition_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextRecognitionScreen extends ConsumerWidget {
  const TextRecognitionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recognitionText = ref.watch(textRecognitionProvider);
    return Scaffold(
      appBar: CustomAppBar(title: 'Find Lence', isTitle: true, isleading: true,leading: 'Text Recognition',actions: [
        IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.ellipsis_circle))
      ],),
      body: Center(child: Text(recognitionText)),
    );
  }
}
