import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/events/invite_connections_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import '../../../model/events_M/events_model.dart';
import '../../../model/game_library_M/game_details_model.dart';
import 'choose_my_games_page.dart';
import '../../components/event/create_event_chips.dart';

String? selectedOption = "Gaming Session";

class EditEvent extends StatefulWidget {
  final Event e;
  final String imageUrl;

  const EditEvent({super.key, required this.e, required this.imageUrl});

  @override
  State<EditEvent> createState() => _EditEventsState();
}

class _EditEventsState extends State<EditEvent> {
  late Event e;
  String name = "";
  late int gameChosen = -1;
  bool validStartDate = true;
  bool validEndDate = true;
  bool validName = true;
  late List<String> gameNames = [];
  late List<String> gameImages = [];
  late List<GameDetails>? games;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _datePicked;
  DateTime? _endDatePicked;
  XFile? filePath;
  bool isChanged = true;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  late int gameID;
  late String imageUrl;

  List<String> invites = [];

  Future<void> editEvent() async {
    await EventsService().editEvent(
        selectedOption,
        _datePicked,
        name,
        _endDatePicked,
        gameID,
        isChanged,
        invites,
        filePath != null ? filePath!.path : imageUrl,
        descriptionController.text,
        e.eventID);
  }

  Future pickImage() async {
    final image = ImagePicker();
    final file = await image.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        filePath = file;
      });
    }
  }

  void getGames() async {
    gameNames = [];
    gameImages = [];
    if (games != null) {
      for (var i in games!) {
        gameNames.add(i.name);
        gameImages.add(i.backgroundImage);
      }
    }
  }

  void getGameID(String gameName) async {
    for (var i in games!) {
      if (i.name == gameName) {
        gameID = i.id;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    e = widget.e;
    nameController.text = e.name;
    _datePicked = e.startDate;
    _endDatePicked = e.endDate;
    selectedOption = e.eventType;
    gameID = e.gameID;
    descriptionController.text = e.description;
    isChanged = e.privacy;
    gameChosen = e.gameID;
    selectedOption = e.eventType;
    imageUrl = widget.imageUrl;
    invites = e.invited;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Edit Event',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 12, 16, 0),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              pickImage();
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: const FittedBox(
                                                      fit: BoxFit.cover,
                                                    )),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: filePath != null
                                                      ? Image.file(
                                                          File(filePath!.path),
                                                          width: 359,
                                                          height: 200,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          imageUrl,
                                                          width: 359,
                                                          height: 200,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                                Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primaryContainer,
                                                        shape: BoxShape.circle),
                                                    child: Icon(
                                                      Icons.camera_alt_outlined,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 70,
                                            child: TextFormField(
                                              onFieldSubmitted: (val) {
                                                name = nameController.text;
                                                if (name.isNotEmpty) {
                                                  setState(() {
                                                    validName = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    validName = false;
                                                  });
                                                }
                                              },
                                              onTapOutside: (event) {
                                                name = nameController.text;
                                                if (name.isNotEmpty) {
                                                  setState(() {
                                                    validName = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    validName = false;
                                                  });
                                                }
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              maxLength: 50,
                                              controller: nameController,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText: 'Event name*',
                                                labelStyle: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize: 16,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                hintStyle: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primaryContainer),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primaryContainer),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primaryContainer),
                                                ),
                                                filled: true,
                                                fillColor: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                contentPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        16, 20, 16, 20),
                                              ),
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                              cursorColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChooseGame(
                                                                chosenGame:
                                                                    gameChosen,
                                                              )))
                                                  .then((gameChosen) {
                                                setState(() {
                                                  if (gameChosen != null) {
                                                    this.gameChosen =
                                                        gameChosen;
                                                  }
                                                });
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(16, 0, 16, 0),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Choose game*',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      letterSpacing: 0,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.add_circle_outline,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    size: 24,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            onTapOutside: (event) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            maxLength: 100,
                                            controller: descriptionController,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Description',
                                              labelStyle: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              alignLabelWithHint: true,
                                              hintStyle: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                fontSize: 14,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer),
                                              ),
                                              filled: true,
                                              fillColor: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              contentPadding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(16, 16, 16, 16),
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontSize: 16,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 9,
                                            minLines: 5,
                                            cursorColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ChipSelector(
                                              selectedOption: e.eventType,
                                              onSelected: (option) {
                                                (setState(() {
                                                  selectedOption = option;
                                                }));
                                              }),
                                          Text(
                                            'Start*',
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
                                              validEndDate = false;
                                              final datePickedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                lastDate: DateTime(2050),
                                                firstDate: DateTime.now(),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: ThemeData.from(
                                                        colorScheme:
                                                            Theme.of(context)
                                                                .colorScheme),
                                                    child: child!,
                                                  );
                                                },
                                              );

                                              TimeOfDay? datePickedTime;
                                              if (datePickedDate != null) {
                                                datePickedTime =
                                                    await showTimePicker(
                                                        //ignore: use_build_context_synchronously
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                        builder:
                                                            (context, child) {
                                                          return Theme(
                                                            data: ThemeData.from(
                                                                colorScheme: Theme.of(
                                                                        context)
                                                                    .colorScheme),
                                                            child: child!,
                                                          );
                                                        });
                                              }

                                              if (datePickedDate != null &&
                                                  datePickedTime != null) {
                                                setState(() {
                                                  validStartDate = true;
                                                  _datePicked = DateTime(
                                                    datePickedDate.year,
                                                    datePickedDate.month,
                                                    datePickedDate.day,
                                                    datePickedTime!.hour,
                                                    datePickedTime.minute,
                                                  );
                                                  if (_datePicked!.isBefore(
                                                      _endDatePicked!)) {
                                                    validEndDate = true;
                                                  }
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer),
                                              ),
                                              child: Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        -1, 0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12, 0, 0, 0),
                                                  child: Text(
                                                    _datePicked != null
                                                        ? DateFormat(
                                                                'd MMMM , hh:mm a')
                                                            .format(
                                                                _datePicked!)
                                                        : 'Select a date',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontSize: 14,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'End*',
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
                                                        colorScheme:
                                                            Theme.of(context)
                                                                .colorScheme),
                                                    child: child!,
                                                  );
                                                },
                                              );

                                              TimeOfDay? datePickedTime2;
                                              if (datePickedDate2 != null) {
                                                datePickedTime2 =
                                                    await showTimePicker(
                                                        //ignore: use_build_context_synchronously
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                        builder:
                                                            (context, child) {
                                                          return Theme(
                                                            data: ThemeData.from(
                                                                colorScheme: Theme.of(
                                                                        context)
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
                                                  if (_datePicked!.isBefore(
                                                      _endDatePicked!)) {
                                                    validEndDate = true;
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Invalid end date/time."),
                                                                backgroundColor:
                                                                    Colors
                                                                        .red));
                                                  }
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer),
                                              ),
                                              child: Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        -1, 0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12, 0, 0, 0),
                                                  child: Text(
                                                    _endDatePicked != null &&
                                                            validEndDate
                                                        ? DateFormat(
                                                                'd MMMM , hh:mm a')
                                                            .format(
                                                                _endDatePicked!)
                                                        : 'Select a date',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontSize: 14,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                            ),
                                            child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    child: Text(
                                                      'Private',
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Switch.adaptive(
                                                    activeTrackColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                    inactiveTrackColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    inactiveThumbColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                    activeColor: Colors.black,
                                                    value: isChanged,
                                                    onChanged: (bool value) {
                                                      setState(() {
                                                        isChanged = value;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(width: 20),
                                                ]),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ConnectionsListWidget(
                                                            chosenInvites:
                                                                invites,
                                                          ))).then((invited) {
                                                setState(() {
                                                  if (invited != null) {
                                                    invites =
                                                        invited as List<String>;
                                                  }
                                                });
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(16, 0, 16, 0),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Invite connections*',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      letterSpacing: 0,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                  ),
                                                  Icon(
                                                      invites.isEmpty
                                                          ? Icons
                                                              .add_circle_outline
                                                          : Icons
                                                              .check_circle_outline_rounded,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 40),
                                        ]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 12, 16, 12),
                                child: MaterialButton(
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  minWidth: double.infinity,
                                  onPressed: () {
                                    name = nameController.text;
                                    if (name.isEmpty) {
                                      validName = false;
                                    } else {
                                      validName = true;
                                    }
                                    if (validName &&
                                        !(gameChosen == -1) &&
                                        validEndDate &&
                                        validStartDate) {
                                      editEvent();
                                      nameController.clear();
                                      descriptionController.clear();
                                      setState(() {
                                        gameChosen = -1;
                                        invites = [];
                                        validEndDate = false;
                                        validName = false;
                                        validStartDate = false;
                                        _endDatePicked = null;
                                        _datePicked = null;
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      if (!validName) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please ensure you entered an event name "),
                                                backgroundColor: Colors.red));
                                      } else if (gameChosen == -1) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please ensure you chose a game to play "),
                                                backgroundColor: Colors.red));
                                      } else if (!validStartDate) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please ensure you entered a valid start date and time "),
                                                backgroundColor: Colors.red));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please ensure you entered a valid end date and time "),
                                                backgroundColor: Colors.red));
                                      }
                                    }
                                  },
                                  color: Theme.of(context).colorScheme.primary,
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
