import 'dart:math';

import 'package:flutter/material.dart';

import '../../types/exceptions/api.dart';

class ErrorText extends StatelessWidget {
  final Object? apiException;
  final String? customText;
  final String? customDetails;
  final bool offerDetails;

  const ErrorText({
    Key? key,
    this.apiException,
    this.customText,
    this.customDetails,
    this.offerDetails = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget errorText = Text(
      this.apiException?.apiError ?? this.customText ?? 'Unknown Error!',
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Colors.red,
          ),
    );

    return this.apiException?.api != null ||
            !this.offerDetails ||
            this.customDetails == null
        ? errorText
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              errorText,
              const SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => LayoutBuilder(
                    builder: (context, constraints) => Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: min(
                            MediaQuery.of(context).size.height * 0.75,
                            750,
                          ),
                        ),
                        child: AlertDialog(
                          title: const Text('Details'),
                          content: SingleChildScrollView(
                            child: SelectableText(
                              this.apiException?.toString() ??
                                  this.customDetails!,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                child: const Text('Details'),
              ),
            ],
          );
  }
}
