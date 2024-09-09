import 'package:flutter/material.dart';

class HelpCard extends StatelessWidget{
  final String heading;
  final String followHeading;
  final Icon icon;
  final String navigation;

  const HelpCard({super.key, required this.heading, required this.followHeading,
  required this.icon,required this.navigation});

  @override
  Widget build (BuildContext context){
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, navigation);
      },
      child:
    Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.969,
          height: 160,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0, 12, 0, 4),
                  child: Text(
                    heading,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                 Text(
                  followHeading,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        )),
    );
  }
}