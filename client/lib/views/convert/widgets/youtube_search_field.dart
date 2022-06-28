import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/views/convert.dart';
import '../../../widgets/general/styled_text_field.dart';

class YoutubeSearchField extends ConsumerStatefulWidget {
  const YoutubeSearchField({Key? key}) : super(key: key);

  @override
  _VideoSearchFieldState createState() => _VideoSearchFieldState();
}

class _VideoSearchFieldState extends ConsumerState<YoutubeSearchField> {
  final TextEditingController _controller = TextEditingController();

  void _initiateSearch() {
    FocusManager.instance.primaryFocus?.unfocus();

    ref.read(youtubeVideoProvider.notifier).fetch(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: StyledTextField(
            controller: _controller..addListener(() => setState(() {})),
            label: 'YouTube link',
            onEditingComplete: _initiateSearch,
            onDeleteSuffixPressed:
                ref.read(youtubeVideoProvider.notifier).reset,
            suffix: ElevatedButton.icon(
              onPressed: _controller.text.length > 5 ? _initiateSearch : null,
              label: const Text('Search'),
              icon: const Icon(Icons.search),
            ),
          ),
        ),
      ],
    );
  }
}
