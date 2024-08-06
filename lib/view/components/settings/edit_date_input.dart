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