import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ToolTip extends StatelessWidget{
  final String message;

  const ToolTip({super.key, required this.message});

  Widget build(BuildContext context){
    final tooltipkey =SuperTooltipController();

    return SuperTooltip(
        controller: tooltipkey,
        content: Text(
         this.message,style:
        TextStyle(color: Colors.black),
          softWrap: true,),
        verticalOffset: 13,
        popupDirection: TooltipDirection.up,
        backgroundColor: Colors.grey,
        child:Container(child: const Icon(Icons.info)
    ),
    );
}
}