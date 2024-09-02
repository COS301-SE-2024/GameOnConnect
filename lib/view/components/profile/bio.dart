import 'package:flutter/material.dart';

class Bio extends StatefulWidget {

  const Bio({
    super.key,
    required this. bio,
    required this.isOwnProfile,

  });

  final String bio;
   final bool isOwnProfile;

  @override
  State<Bio> createState() => _BioState();
  
  }


class _BioState extends State<Bio> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0), // Adjust spacing as needed
      child:SizedBox(
        width: double.infinity,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (widget.isOwnProfile)
              ? const Text(
              'My bio',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                
              ),
              textAlign: TextAlign.left,
            )
            : const Text(
              'Bio',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            Text(
              widget.bio,
              //'Lorem ipsum dolor sit amet consectetur. Pellentesque amet et pellentesque risus tortor at senectus porta. Donec id convallis faucibus a porttitor viverra eleifend sed dignissim. In dui maecenas venenatis fermentum dolor turpis ut. Elementum venenatis neque at mi facilisi at donec in. Ac lacus facilisis lorem elit proin euismod.',
            
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                //fontSize: 12,
            
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Color(0xFF2A2A2A),//Dark grey,
              thickness: 0.5,
            ),
                    
            ],
          ),
          
        ),
    );
    
  }
}

//            'Lorem ipsum dolor sit amet consectetur. Pellentesque amet et pellentesque risus tortor at senectus porta. Donec id convallis faucibus a porttitor viverra eleifend sed dignissim. In dui maecenas venenatis fermentum dolor turpis ut. Elementum venenatis neque at mi facilisi at donec in. Ac lacus facilisis lorem elit proin euismod.',

