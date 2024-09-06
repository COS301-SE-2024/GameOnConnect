import 'package:flutter/material.dart';
import 'package:gameonconnect/model/help_M/faq_model.dart';
import 'package:gameonconnect/view/components/help/video_widget.dart';

class FaqSection extends StatefulWidget {
  late final List<FAQ> faq;
  late final String title;
  late final IconData icon;
  final Key? subKey;
  FaqSection(this.faq, this.title, this.icon,this.subKey, {super.key}) {
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
          key: widget.subKey,
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
                             const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(faqItem.faqDetails,style: const TextStyle(fontSize: 12,color: Colors.grey,)),
                        ),
                        faqItem.videoPath.isNotEmpty? TutorialVideo(videoPath: faqItem.videoPath): const SizedBox(height: 5,),
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
