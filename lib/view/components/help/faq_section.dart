import 'package:flutter/material.dart';
import 'package:gameonconnect/model/help_M/faq_model.dart';
import 'package:gameonconnect/view/components/help/video_widget.dart';

class FaqSection extends StatefulWidget {
  late final List<FAQ> faq;
  late final String title;
  late final IconData icon;
  FaqSection(this.faq, this.title, this.icon, {super.key}) {
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
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Icon(widget.icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Text(widget.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Column(
              children: [
                ...widget.faq.map((faqItem) {
                  return Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      dense: true,
                      title: Text(
                        faqItem.faqHeading,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(faqItem.faqDetails),
                        ),
                        TutorialVideo(videoPath: faqItem.videoPath),
                      ],
                    ),
                  );
                })
              ],
            )
          ],
        ));
  }
}
