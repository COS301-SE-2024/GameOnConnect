import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';

String? selectedOption = "Gaming Session";

class CreateEvents extends StatefulWidget {
  const CreateEvents({super.key});

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _datePicked;
  DateTime? _endDatePicked;

  bool isChanged = false;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  int gameID = 1; // hard coding this for now
  String? type;
  List<String>? invites = [];

  Future create() async {
    await Events().createEvent(selectedOption, _datePicked, nameController.text,
        _endDatePicked, gameID, isChanged, invites!,"",descriptionController.text);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.clear;
    descriptionController.clear();
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
                                    /*ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        'Logo_dark.png',
                                        width: 359,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),*/
                                    TextFormField(
                                      controller: nameController,
                                      textCapitalization: TextCapitalization.words,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Event name...',
                                        labelStyle:TextStyle(
                                          fontFamily: 'Inter',
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        hintStyle: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Theme.of(context).colorScheme.secondary,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.primary,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.primary,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),

                                        filled: true,
                                        fillColor: Theme.of(context).colorScheme.surface,
                                        contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 20),
                                      ),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context).colorScheme.secondary,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      cursorColor: Theme.of(context).colorScheme.primary,
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Theme.of(context).colorScheme.secondary,
                                            size: 24,
                                          ),
                                          Text(
                                            'Choose a game to play...',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0,
                                              color: Theme.of(context).colorScheme.secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: descriptionController,
                                      textCapitalization: TextCapitalization.words,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Description...',
                                        labelStyle: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Theme.of(context).colorScheme.secondary,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        alignLabelWithHint: true,
                                        hintStyle: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontSize: 14,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.primary,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.primary,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: Theme.of(context).colorScheme.surface,
                                        contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                      ),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontSize: 16,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 9,
                                      minLines: 5,
                                      cursorColor: Theme.of(context).colorScheme.primary,
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const ChipSelector(),
                                    Text(
                                      'Start date and time',
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
                                              data: ThemeData.from(
                                                  colorScheme: Theme.of(context)
                                                      .colorScheme),
                                              child: child!,
                                            );
                                          },
                                        );

                                        TimeOfDay? datePickedTime;
                                        if (datePickedDate != null) {
                                          datePickedTime = await showTimePicker(
                                              //ignore: use_build_context_synchronously
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                              builder: (context, child) {
                                                return Theme(
                                                  data: ThemeData.from(
                                                      colorScheme:
                                                          Theme.of(context)
                                                              .colorScheme),
                                                  child: child!,
                                                );
                                              });
                                        }

                                        if (datePickedDate != null &&
                                            datePickedTime != null) {
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
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
                                                  ? DateFormat(
                                                          'd MMMM , hh:mm a')
                                                      .format(_datePicked!)
                                                  : 'Select a date',
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
                                    Text(
                                      'End date and time',
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
                                        final datePickedDate2 =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          lastDate: DateTime(2050),
                                          firstDate: DateTime.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData.from(
                                                  colorScheme: Theme.of(context)
                                                      .colorScheme),
                                              child: child!,
                                            );
                                          },
                                        );

                                        TimeOfDay? datePickedTime2;
                                        if (datePickedDate2 != null) {
                                          datePickedTime2 = await showTimePicker(
                                              //ignore: use_build_context_synchronously
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                              builder: (context, child) {
                                                return Theme(
                                                  data: ThemeData.from(
                                                      colorScheme:
                                                          Theme.of(context)
                                                              .colorScheme),
                                                  child: child!,
                                                );
                                              });
                                        }

                                        if (datePickedDate2 != null &&
                                            datePickedTime2 != null) {
                                          setState(() {
                                            _endDatePicked = DateTime(
                                              datePickedDate2.year,
                                              datePickedDate2.month,
                                              datePickedDate2.day,
                                              datePickedTime2!.hour,
                                              datePickedTime2.minute,
                                            );
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
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
                                              _endDatePicked != null
                                                  ? DateFormat(
                                                          'd MMMM , hh:mm a')
                                                      .format(_endDatePicked!)
                                                  : 'Select a date',
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
                                            activeTrackColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            inactiveTrackColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                            inactiveThumbColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            value: isChanged,
                                            onChanged: (bool value) {
                                              setState(() {
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
                                        Navigator.pushNamed(
                                                context, '/invite_connections')
                                            .then((invited) {
                                          invites = invited as List<String>?;
                                        });
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            size: 24,
                                          ),
                                          Text(
                                            'Invite connections to join...',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
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
                        nameController.clear;
                        create();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text("Event created successfully!"),

                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ));
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
  ChipSelectorState createState() => ChipSelectorState();
}

class ChipSelectorState extends State<ChipSelector> {
  List<ChipData> options = [
    ChipData('Gaming Session', Icons.videogame_asset_outlined),
    ChipData('Tournament', Icons.emoji_events_sharp),
  ];

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
                color: selectedOption == option.label
                    ? Colors.black
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
            avatar: Icon(
              option.icon,
              color: selectedOption == option.label
                  ? Colors.black
                  : Theme.of(context).colorScheme.secondary,
              size: 18,
            ),
            selected: selectedOption == option.label,
            onSelected: (bool selected) {
              setState(() {
                selectedOption = selected ? option.label : null;
              });
            },
            backgroundColor: selectedOption == option.label
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
            selectedColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: selectedOption == option.label
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.primary,
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
