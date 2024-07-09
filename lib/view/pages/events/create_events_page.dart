import 'package:flutter/material.dart';

class CreateEvents extends StatefulWidget {
  const CreateEvents({super.key});

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
    bool isChanged = false;
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
                                      autofocus: true,
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
                                        /*final datePickedDate =
                                      await showDatePicker(
                                        context: context,
                                        lastDate: DateTime(2050),
                                        builder: (context, child) {
                                          return DatePickerTheme(
                                            context,
                                            child!,
                                            data:
                                            headerBackgroundColor:
                                            Color(0xFF00DF68),
                                            headerForegroundColor:
                                            Color(0xFF030303),
                                            headerTextStyle:
                                            FlutterFlowTheme.of(context)
                                                .headlineLarge
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: Color(0xFF15161E),
                                              fontSize: 32,
                                              letterSpacing: 0,
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                            pickerBackgroundColor: Colors.white,
                                            pickerForegroundColor:
                                            Color(0xFF15161E),
                                            selectedDateTimeBackgroundColor:
                                            Color(0xFF00DF68),
                                            selectedDateTimeForegroundColor:
                                            Color(0xFF030303),
                                            actionButtonForegroundColor:
                                            Color(0xFF15161E),
                                            iconSize: 24,
                                          );
                                        }, firstDate: DateTime.now(),
                                      );*/

                                        /* TimeOfDay? _datePickedTime;
                                      if (_datePickedDate != null) {
                                        _datePickedTime = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          builder: (context, child) {
                                            return wrapInMaterialTimePickerTheme(
                                              context,
                                              child!,
                                              headerBackgroundColor:
                                              Color(0xFF00DF68),
                                              headerForegroundColor:
                                              Color(0xFF030303),
                                              headerTextStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineLarge
                                                  .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                Color(0xFF15161E),
                                                fontSize: 32,
                                                letterSpacing: 0,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                              pickerBackgroundColor:
                                              Colors.white,
                                              pickerForegroundColor:
                                              Color(0xFF15161E),
                                              selectedDateTimeBackgroundColor:
                                              Color(0xFF00DF68),
                                              selectedDateTimeForegroundColor:
                                              Color(0xFF030303),
                                              actionButtonForegroundColor:
                                              Color(0xFF15161E),
                                              iconSize: 24,
                                            );
                                          },
                                        );
                                      }*/

                                        /*if (_datePickedDate != null &&
                                          _datePickedTime != null) {
                                        safeSetState(() {
                                          _model.datePicked = DateTime(
                                            _datePickedDate.year,
                                            _datePickedDate.month,
                                            _datePickedDate.day,
                                            _datePickedTime!.hour,
                                            _datePickedTime.minute,
                                          );
                                        });
                                      }*/
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
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
                                              'Select a date',
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
                                          Switch(
                                            activeColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            activeTrackColor: Colors.black,
                                            inactiveTrackColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            inactiveThumbColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            value: isChanged,
                                            onChanged: (bool value) {
                                              isChanged = value;
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
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.black,
                                            size: 24,
                                          ),
                                          Text(
                                            'Invite connections to join...',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0,
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
