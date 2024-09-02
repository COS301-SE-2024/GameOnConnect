import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/help/faq_boxes.dart';


class FaqWidget extends StatefulWidget {
  const FaqWidget({super.key});

  @override
  State<FaqWidget> createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<FaqWidget> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          top: true,
          child: Padding(
            padding:const  EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                    child: Text(
                      'Frequently Asked Questions:',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 26,
                      ),
                    ),
                  ),
                   Divider(
                    thickness: 1,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  Faq_boxWidget()



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
