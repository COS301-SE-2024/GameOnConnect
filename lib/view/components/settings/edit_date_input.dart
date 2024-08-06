import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditDateInput extends StatefulWidget {
  final DateTime currentDate;
  final String label;
  final void Function(DateTime value) onChanged;
  const EditDateInput(
      {super.key,
      required this.currentDate,
      required this.label,
      required this.onChanged});

  @override
  State<EditDateInput> createState() => _EditDateInput();
}

class _EditDateInput extends State<EditDateInput> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.currentDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate!,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.label,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.primaryContainer,
                  enabledBorder: OutlineInputBorder(
                    // borderSide: BorderSide(
                    //     color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                initialValue: DateFormat('yyyy-MM-dd').format(_selectedDate!),
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}










// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class EditDateInput extends StatefulWidget{
//   final DateTime currentDate;
//   final String label;
//   final void Function(DateTime date) onChanged;

//   const EditDateInput({super.key, required this.currentDate, required this.label,required this.onChanged});
//    @override
//   State<EditDateInput> createState() => _EditDateInput();
// }

// class _EditDateInput extends State<EditDateInput>{
//   late DateTime currentDate ;
//   late String label;

//   @override
//   void initState(){
//     super.initState();
//     currentDate = widget.currentDate;
//     label = widget.label;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }


//   @override
//   Widget build (BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: TextStyle(color: Theme.of(context).colorScheme.secondary),
//             ),
//           ),
//           Expanded(
//             flex: 4,
//             child: InkWell(
//               onTap: () async {
//                 DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(1900),
//                   lastDate: DateTime(2100),
//                   builder: (context, child) {
//                     return Theme(
//                       data: ThemeData.from(
//                           colorScheme: Theme.of(context).colorScheme),
//                       child: child!,
//                     );
//                   },
//                 );
//                 if (picked != null && picked != widget.currentDate) {
//                  widget.onChanged(picked);
//                  setState(() {
//                    currentDate = picked;
//                  });
//                 }
//               },
//               child: InputDecorator(
//                 decoration: InputDecoration(
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Theme.of(context).colorScheme.primary),
//                     borderRadius: BorderRadius.circular(20.0),
//                   ),
//                 ),
//                 child: Text(
//                   DateFormat('d/MM/yyyy').format(currentDate),
//                   style:
//                   TextStyle(color: Theme.of(context).colorScheme.secondary),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// }