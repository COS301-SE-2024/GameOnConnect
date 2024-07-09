import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateEvents extends StatefulWidget {
  const CreateEvents({super.key});

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _datePicked;
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          top: true,
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, -1),
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 770,
                            ),
                            decoration: const BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 12, 16, 0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      textCapitalization:
                                          TextCapitalization.words,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                          hintText: 'Event name...',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 24,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 24,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ChipSelector(),
                                    Text(
                                      'Date and Time',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        final datePickedDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        lastDate: DateTime(2050),
                                        firstDate: DateTime.now(),
                                        builder: (context, child) {
                                          return Theme(
                                            data: ThemeData.from(colorScheme: Theme.of(context).colorScheme),
                                            child: child!,
                                          );
                                        },
                                      );

                                         TimeOfDay? datePickedTime;
                                      if (datePickedDate != null) {
                                        datePickedTime = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData.from(colorScheme: Theme.of(context).colorScheme),
                                              child: child!,
                                        );
                                      });
                                      }

                                        if (datePickedDate != null && datePickedTime != null) {
                                        setState(() {
                                          _datePicked = DateTime(
                                            datePickedDate.year,
                                            datePickedDate.month,
                                            datePickedDate.day,
                                            datePickedTime!.hour,
                                            datePickedTime.minute,
                                          );
                                        });
                                      }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surface,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 2,
                                          ),
                                        ),
                                        child: Align(
                                          alignment:
                                              const AlignmentDirectional(-1, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 0, 0, 0),
                                            child: Text(
                                              _datePicked != null
                                                  ? DateFormat('d MMMM , hh:mm a').format(_datePicked!)
                                                  :'Select a date',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                fontSize: 14,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const Text(
                                            'Private',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0,
                                            ),
                                          ),
                                          Switch.adaptive(
                                            activeTrackColor :Theme.of(context).colorScheme.primary ,
                                            inactiveTrackColor: Theme.of(context).colorScheme.surface,
                                            inactiveThumbColor: Theme.of(context).colorScheme.secondary,
                                            value: isChanged,
                                            onChanged: (bool value) {
                                              setState((){
                                                isChanged = value;
                                              });
                                            },
                                          ),
                                          const SizedBox(width: 20),
                                        ]),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        Navigator.pop(context);
                                      },
                                      child:  Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Theme.of(context).colorScheme.secondary,
                                            size: 24,
                                          ),
                                          Text(
                                            'Invite connections to join...',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0,
                                              color: Theme.of(context).colorScheme.secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const SizedBox(height: 32)
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 770,
                  ),
                  decoration: const BoxDecoration(),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                    child: MaterialButton(
                      onPressed: () {
                        print('Button pressed ...');
                      },
                      color: Theme.of(context).colorScheme.primary,
                      child: const Text('Create'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
// TODO : look into making this a component
class ChipData {
  final String label;
  final IconData icon;

  ChipData(this.label, this.icon);
}

class ChipSelector extends StatefulWidget {
  const ChipSelector({super.key});

  @override
  _ChipSelectorState createState() => _ChipSelectorState();
}

class _ChipSelectorState extends State<ChipSelector> {
  List<ChipData> options = [
    ChipData('Gaming Session', Icons.videogame_asset_outlined),
    ChipData('Tournament', Icons.emoji_events_sharp),
  ];
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        alignment: WrapAlignment.spaceEvenly,
        children: options.map((option) {
          return ChoiceChip(
            showCheckmark: false,
            label: Text(
              option.label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: selectedOption == option.label ? Colors.black : Theme.of(context).colorScheme.secondary,
              ),
            ),
            avatar: Icon(
              option.icon,
              color: selectedOption == option.label ?  Colors.black:Theme.of(context).colorScheme.secondary,
              size: 18,
            ),
            selected: selectedOption == option.label,
            onSelected: (bool selected) {
              setState(() {
                selectedOption = selected ? option.label : null;
              });
            },
            backgroundColor: selectedOption == option.label ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
            selectedColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: selectedOption == option.label ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            elevation: 0,
          );
        }).toList(),
      ),
    );
  }
}