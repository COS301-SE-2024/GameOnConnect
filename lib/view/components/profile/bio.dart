import 'package:flutter/material.dart';

class Bio extends StatefulWidget {

  const Bio({
    super.key,
    required this. bio,
  });

  final String bio;

  @override
  State<Bio> createState() => _BioState();
  
  }


class _BioState extends State<Bio> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0), // Adjust spacing as needed
      child:Container(
        width: double.infinity,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
              'My bio',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10),
            Container(
              child: Text(
                widget.bio,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  //fontSize: 12,

                ),
              ),
            ),
            ],
          ),
          
        ),
    );
    
  }
}

