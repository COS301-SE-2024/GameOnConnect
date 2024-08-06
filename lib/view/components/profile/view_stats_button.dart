import 'package:flutter/material.dart';

class StatsButton extends StatefulWidget {

  const StatsButton({super.key});

  @override
  State<StatsButton> createState() => _StatsButtonState();
  
  }


class _StatsButtonState extends State<StatsButton> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10), // Adjust spacing as needed
      child:Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                //size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),

              Text(
                'View Stats',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  //fontSize: 12,
                  letterSpacing: 0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          ),
          
        ),
    );
    
  }
}
