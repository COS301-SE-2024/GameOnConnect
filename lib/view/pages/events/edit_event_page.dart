import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gameonconnect/services/events_S/dynamic_scaling.dart';
import 'package:gameonconnect/view/pages/events/invite_connections_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import '../../../model/events_M/events_model.dart';
import '../../../model/game_library_M/game_details_model.dart';
import '../../components/settings/tooltip.dart';
import 'choose_my_games_page.dart';
import '../../components/events/create_event_chips.dart';

class EditEvent extends StatefulWidget {
  final Event e;
  final String imageUrl;
  final void Function(Event updatedEvent) edited;

  const EditEvent(
      {super.key,
      required this.e,
      required this.imageUrl,
      required this.edited});

  @override
  State<EditEvent> createState() => _EditEventsState();
}

class _EditEventsState extends State<EditEvent> {
  late Event e;
  String name = "";
  String description = "";
  bool validStartDate = true;
  bool validEndDate = true;
  bool validName = true;
  late List<String> gameNames = [];
  late List<String> gameImages = [];
  late List<GameDetails>? games;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late DateTime _datePicked;
  late DateTime _endDatePicked;
  XFile? filePath;
  bool isChanged = true;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  late int gameID;
  late String imageUrl;
  bool imageChanged = false;
  late String selectedOption;

  List<String> invites = [];

  Future<void> editEvent() async {
    Event updated = Event(
        creatorID: e.creatorID,
        startDate: _datePicked,
        endDate: _endDatePicked,
        gameID: gameID,
        name: name,
        eventID: e.eventID,
        subscribed: e.subscribed,
        participants: e.participants,
        description: description,
        privacy: isChanged,
        invited: invites,
        creatorName: e.creatorName,
        eventType: selectedOption);
    widget.edited(updated);
    await EventsService().editEvent(
        imageChanged,
        selectedOption,
        _datePicked,
        name,
        _endDatePicked,
        gameID,
        isChanged,
        invites,
        filePath != null ? filePath!.path : imageUrl,
        description,
        e.eventID);
  }

  Future pickImage() async {
    final image = ImagePicker();
    final file = await image.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        filePath = file;
        imageChanged = true;
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
    description = e.description;
    isChanged = e.privacy;
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
              title:  Text(
                'Edit Event',
                style: TextStyle(fontSize: 32.pixelScale(context), fontWeight: FontWeight.bold),
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
                                         EdgeInsetsDirectional.fromSTEB(
                                            16.pixelScale(context), 12.pixelScale(context), 16.pixelScale(context), 0),
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
                                                      BorderRadius.circular(8.pixelScale(context)),
                                                  child: filePath != null
                                                      ? Image.file(
                                                          File(filePath!.path),
                                                          width: 359.pixelScale(context),
                                                          height: 200.pixelScale(context),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          imageUrl,
                                                          width: 359.pixelScale(context),
                                                          height: 200.pixelScale(context),
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                                Container(
                                                    height: 40.pixelScale(context),
                                                    width: 40.pixelScale(context),
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
                                           SizedBox(
                                            height: 10.pixelScale(context),
                                          ),
                                          SizedBox(
                                            height: 70.pixelScale(context),
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
                                                  fontSize: 16.pixelScale(context),
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
                                                      BorderRadius.circular(10.pixelScale(context)),
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primaryContainer),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10.pixelScale(context)),
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primaryContainer),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10.pixelScale(context)),
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
                                                     EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        16.pixelScale(context), 20.pixelScale(context), 16.pixelScale(context), 20.pixelScale(context)),
                                              ),
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.pixelScale(context),
                                              ),
                                              cursorColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const ToolTip(
                                              message:
                                                  "Tournaments are competitive, "
                                                  "whereas gaming sessions "
                                                  "are more relaxed with "
                                                  "people you know "),
                                          ChipSelector(
                                              selectedOption: selectedOption,
                                              onSelected: (option) {
                                                (setState(() {
                                                  selectedOption = option;
                                                }));
                                              }),
                                          const SizedBox(
                                            height: 10,
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
                                                            chosenGame: gameID,
                                                          ))).then(
                                                  (gameChosen) {
                                                setState(() {
                                                  if (gameChosen != null) {
                                                    gameID = gameChosen;
                                                  }
                                                });
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                   EdgeInsetsDirectional
                                                      .fromSTEB(16.pixelScale(context), 0, 16.pixelScale(context), 0),
                                              height: 50.pixelScale(context),
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
                                                    BorderRadius.circular(10.pixelScale(context)),
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
                                                      fontSize: 16.pixelScale(context),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .check_circle_outline_rounded,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    size: 24.pixelScale(context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                           SizedBox(
                                            height: 20.pixelScale(context),
                                          ),
                                          TextFormField(
                                            onTapOutside: (event) {
                                              description =
                                                  descriptionController.text;
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
                                                fontSize: 14.pixelScale(context),
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.pixelScale(context)),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.pixelScale(context)),
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
                                                   EdgeInsetsDirectional
                                                      .fromSTEB(16.pixelScale(context), 16.pixelScale(context), 16.pixelScale(context), 16.pixelScale(context)),
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontSize: 16.pixelScale(context),
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 9,
                                            minLines: 5,
                                            cursorColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            onFieldSubmitted: (val) => {
                                              description =
                                                  descriptionController.text
                                            },
                                          ),
                                           SizedBox(
                                            height: 10.pixelScale(context),
                                          ),
                                          Text(
                                            'Start*',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontSize: 14.pixelScale(context),
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
                                                initialDate: _datePicked,
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
                                                        initialTime: TimeOfDay(
                                                            hour: _datePicked
                                                                .hour,
                                                            minute: _datePicked
                                                                .minute),
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
                                                  if (_datePicked.isBefore(
                                                      _endDatePicked)) {
                                                    validEndDate = true;
                                                  }
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 48.pixelScale(context),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                borderRadius:
                                                    BorderRadius.circular(12.pixelScale(context)),
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
                                                       EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12.pixelScale(context), 0, 0, 0),
                                                  child: Text(
                                                    DateFormat(
                                                            'd MMMM , kk:mm ')
                                                        .format(_datePicked),
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontSize: 14.pixelScale(context),
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                           SizedBox(height: 10.pixelScale(context)),
                                          Text(
                                            'End*',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontSize: 14.pixelScale(context),
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
                                                initialDate: _endDatePicked,
                                                lastDate: DateTime(2050),
                                                firstDate: _datePicked,
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
                                                        initialTime: TimeOfDay(
                                                            hour: _endDatePicked
                                                                .hour,
                                                            minute:
                                                                _endDatePicked
                                                                    .minute),
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
                                                  if (_datePicked.isBefore(
                                                      _endDatePicked)) {
                                                    validEndDate = true;
                                                  } else {
                                                    _endDatePicked = e.endDate;
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
                                              height: 48.pixelScale(context),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                borderRadius:
                                                    BorderRadius.circular(12.pixelScale(context)),
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
                                                       EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12.pixelScale(context), 0, 0, 0),
                                                  child: Text(
                                                    validEndDate
                                                        ? DateFormat(
                                                                'd MMMM , kk:mm')
                                                            .format(
                                                                _endDatePicked)
                                                        : 'Select a date',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontSize: 14.pixelScale(context),
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
                                                  BorderRadius.circular(10.pixelScale(context)),
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
                                                         EdgeInsets.only(
                                                            left: 15.pixelScale(context)),
                                                    child: Text(
                                                      'Public',
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
                                                  SizedBox(
                                                    width:
                                                    43.pixelScale(context),
                                                    child: FittedBox(
                                                        fit: BoxFit.fill,
                                                        child:
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
                                                    ),
                                                  ),
                                                   SizedBox(width: 20.pixelScale(context)),
                                                ]),
                                          ),
                                           SizedBox(
                                            height: 20.pixelScale(context),
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
                                                   EdgeInsetsDirectional
                                                      .fromSTEB(16.pixelScale(context), 0, 16.pixelScale(context), 0),
                                              height: 50.pixelScale(context),
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
                                                    BorderRadius.circular(10.pixelScale(context)),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(invites.isEmpty?'Invite connections*':
                                                  'Invite connections (${invites.length})',
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
                                                      color:  invites.isEmpty?Theme.of(context)
                                                          .colorScheme
                                                          .secondary:Theme.of(context).colorScheme.primary,)
                                                ],
                                              ),
                                            ),
                                          ),
                                           SizedBox(height: 40.pixelScale(context)),
                                        ]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsetsDirectional.fromSTEB(
                                    16.pixelScale(context), 12.pixelScale(context), 16.pixelScale(context), 12.pixelScale(context)),
                                child: MaterialButton(
                                  height: 50.pixelScale(context),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.pixelScale(context))),
                                  minWidth: double.infinity,
                                  onPressed: () {
                                    name = nameController.text;
                                    if (name.isEmpty) {
                                      validName = false;
                                    } else {
                                      validName = true;
                                    }
                                    if (validName &&
                                        !(gameID == -1) &&
                                        validEndDate &&
                                        validStartDate) {
                                      editEvent();
                                      nameController.clear();
                                      descriptionController.clear();
                                      setState(() {
                                        gameID = -1;
                                        invites = [];
                                        validEndDate = false;
                                        validName = false;
                                        validStartDate = false;
                                        _endDatePicked = DateTime.now();
                                        _datePicked = DateTime.now();
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      if (!validName) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please ensure you entered an event name "),
                                                backgroundColor: Colors.red));
                                      } else if (gameID == -1) {
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
