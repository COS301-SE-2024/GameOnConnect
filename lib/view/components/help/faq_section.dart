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
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(widget.title),
          Column(children: [
            ...widget.faq.map((faqItem) {
              return ExpansionTile(
                title: Text(faqItem.faqHeading),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(faqItem.faqDetails),
                  ),
                ],
              );
            })
          ],)
        ],
      )
    );
  }
}
