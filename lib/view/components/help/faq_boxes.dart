import 'package:flutter/material.dart';

class Faq_boxWidget extends StatefulWidget {
  final String question;
  final String answer;
  const Faq_boxWidget(
      {super.key, required this.answer, required this.question});

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
    return GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
          child: Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Theme(data: Theme.of(context).copyWith(dividerColor: Theme.of(context).colorScheme.primaryContainer), child: ExpansionTile(
                      title: Text(
                        question,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Padding(padding: const EdgeInsets.all(13.0), child:Text(
                          answer,
                          
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        ),
                      ],
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
