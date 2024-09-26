import 'package:flutter/material.dart';
import 'package:gameonconnect/services/events_S/dynamic_scaling.dart';

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
        padding: EdgeInsetsDirectional.fromSTEB(12.pixelScale(context), 12.pixelScale(context), 12.pixelScale(context), 12.pixelScale(context)),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.969,
          height: 160.pixelScale(context),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8.pixelScale(context)),
          ),
          child: Padding(
            padding:  EdgeInsets.all(12.pixelScale(context)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      0, 12.pixelScale(context), 0, 4.pixelScale(context)),
                  child: Text(
                    heading,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 24.pixelScale(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                 Text(
                  followHeading,
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                    color: Colors.grey,
                    fontSize: 14.pixelScale(context),
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