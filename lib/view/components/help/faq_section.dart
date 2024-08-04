import 'package:flutter/material.dart';
import 'package:gameonconnect/model/help_M/faq_model.dart';

class FaqSection extends StatefulWidget {
  late List<FAQ> faq;
  late String title;
  FaqSection(this.faq, this.title, {super.key}) {
    super.key;
  }

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  @override
  Widget build(BuildContext context) {
    return const ExpansionTile(
      title: Text('Hello'),
    );
  }
}
