import 'package:flutter/material.dart';

class Faq_boxWidget extends StatefulWidget {
  final String question;
  final String answer;
  const Faq_boxWidget({super.key, required this.answer, required this.question});

  @override
  State<Faq_boxWidget> createState() => _Faq_boxWidgetState();
}

class _Faq_boxWidgetState extends State<Faq_boxWidget> {
  late String question;

  late String answer;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    question = widget.question;
    answer = widget.answer;
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
        child: Container(
          width: double.infinity,
          color: Theme
              .of(context)
              .colorScheme
              .primaryContainer,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child:
                Text(
                  question,
                  style: TextStyle(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),

                ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),

    );
  }
}
