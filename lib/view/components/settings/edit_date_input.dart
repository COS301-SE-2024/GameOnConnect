import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditDateInput extends StatefulWidget{
  final DateTime currentDate;
  final String label;
  final void Function(DateTime date) onChanged;

  const EditDateInput({super.key, required this.currentDate, required this.label,required this.onChanged});
   @override
  State<EditDateInput> createState() => _EditDateInput();
}

class _EditDateInput extends State<EditDateInput>{
  late DateTime currentDate ;
  late String label;

  @override
  void initState(){
    super.initState();
    currentDate = widget.currentDate;
    label = widget.label;
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.from(
                          colorScheme: Theme.of(context).colorScheme),
                      child: child!,
                    );
                  },
                );
                if (picked != null && picked != widget.currentDate) {
                 widget.onChanged(picked);
                 setState(() {
                   currentDate = picked;
                 });
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  DateFormat('d/MM/yyyy').format(currentDate),
                  style:
                  TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}