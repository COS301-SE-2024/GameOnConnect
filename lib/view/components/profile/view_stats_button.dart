import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/stats/stats_page.dart';

class StatsButton extends StatefulWidget {

  const StatsButton({super.key});

  @override
  State<StatsButton> createState() => _StatsButtonState();
  
  }


class _StatsButtonState extends State<StatsButton> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10), // Adjust spacing as needed
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const StatsPage()),
          );
        },
        child: Container(
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            ),
            
          ),
        )
    );
    
  }
}
