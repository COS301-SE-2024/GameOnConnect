import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/settings/tooltip.dart';
import 'package:gameonconnect/view/pages/events/invite_connections_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import '../../components/events/create_event_chips.dart';
import 'choose_my_games_page.dart';
import '../../../services/events_S/dynamic_scaling.dart';

String selectedOption = "Gaming Session";

class CreateEvents extends StatefulWidget {
  const CreateEvents({super.key});

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  final BadgeService _badgeService = BadgeService();
  String name = "";
  bool validName = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _datePicked;
  DateTime? _endDatePicked;
  XFile? filePath;
  bool isChanged = false;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  late int gameChosen = -1;
  bool validStartDate = false;
  bool validEndDate = false;
  String gameName = "";

  String? type;
  List<String> invites = [];

  Future create() async {
    await EventsService().createEvent(
        selectedOption,
        _datePicked,
        name,
        _endDatePicked,
        gameChosen,
        isChanged,
        invites,
        filePath != null
            ? filePath!.path
            : 'assets/default_images/default_image.jpg',
        descriptionController.text);
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

  @override
  void initState() {
    super.initState();
    _badgeService.unlockNightOwlBadge(DateTime.now());
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
            appBar: BackButtonAppBar(
              title: 'Create Event',
              onBackButtonPressed: () {
                Navigator.pop(context);
              },
              iconkey: const Key('Back_button_key'),
              textkey: const Key('create_event__text'),
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
                          key: const Key('createEventScroll'),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(0, -1),
                                child: Container(
                                  decoration: const BoxDecoration(),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.pixelScale(context),
                                        12.pixelScale(context),
                                        16.pixelScale(context),
                                        0.pixelScale(context)),
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
                                                          width: 359.pixelScale(
                                                              context),
                                                          height: 200
                                                              .pixelScale(
                                                                  context),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          'assets/default_images/default_image.jpg',
                                                          width: 359.pixelScale(
                                                              context),
                                                          height: 200
                                                              .pixelScale(
                                                                  context),
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                                Container(
                                                    height:
                                                        40.pixelScale(context),
                                                    width:
                                                        40.pixelScale(context),
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primaryContainer
                                                            .withOpacity(0.7),
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
                                              key: const Key('nameTextField'),
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
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize:
                                                      16.pixelScale(context),
                                                  letterSpacing: 0,
                                                ),
                                                hintStyle: TextStyle(
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
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            16.pixelScale(
                                                                context),
                                                            20.pixelScale(
                                                                context),
                                                            16.pixelScale(
                                                                context),
                                                            20.pixelScale(
                                                                context)),
                                              ),
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    16.pixelScale(context),
                                              ),
                                              cursorColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.pixelScale(context),
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
                                          SizedBox(
                                            height: 20.pixelScale(context),
                                          ),

/*
                                          ChipSelector(
                                              selectedOption: selectedOption,
                                              onSelected: (option) {
                                                (setState(() {
                                                  selectedOption = option;
                                                }));
                                              }),*/
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
                                                          ChooseGame(
                                                            chosenGame:
                                                                gameChosen,
                                                          ))).then((gameInfo) {
                                                setState(() {
                                                  if (gameInfo != null) {
                                                    gameChosen =
                                                        gameInfo['chosen'];
                                                    gameName = gameInfo['name'];
                                                  }
                                                });
                                              });
                                            },
                                            child: Container(
                                              key: const Key('gameSelector'),
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.pixelScale(context),
                                                      0,
                                                      16.pixelScale(context),
                                                      0),
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
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    gameName.isEmpty
                                                        ? 'Choose game*'
                                                        : gameName,
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      letterSpacing: 0,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontSize: 16
                                                          .pixelScale(context),
                                                    ),
                                                  ),
                                                  Icon(
                                                    gameChosen == -1
                                                        ? Icons
                                                            .add_circle_outline
                                                        : Icons
                                                            .check_circle_outline_rounded,
                                                    color: gameChosen == -1
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .secondary
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                    size:
                                                        24.pixelScale(context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.pixelScale(context),
                                          ),
                                          TextFormField(
                                            key: const Key(
                                                'descriptionTextField'),
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
                                                fontSize:
                                                    16.pixelScale(context),
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              alignLabelWithHint: true,
                                              hintStyle: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                fontSize:
                                                    14.pixelScale(context),
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
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.pixelScale(
                                                              context),
                                                          16.pixelScale(
                                                              context),
                                                          16.pixelScale(
                                                              context),
                                                          16.pixelScale(
                                                              context)),
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
                                          ),
                                          SizedBox(
                                            height: 10.pixelScale(context),
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
                                            key: const Key('start_date_picker'),
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
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.pixelScale(
                                                              context),
                                                          0,
                                                          0,
                                                          0),
                                                  child: Text(
                                                    _datePicked != null
                                                        ? DateFormat(
                                                                'd MMMM , kk:mm')
                                                            .format(
                                                                _datePicked!)
                                                        : 'Select a start date',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontSize: 14
                                                          .pixelScale(context),
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height: 20.pixelScale(context)),
                                          InkWell(
                                            key: const Key('end_date_picker'),
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
                                              height: 48.pixelScale(context),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primaryContainer,
                                                ),
                                              ),
                                              child: Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        -1, 0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.pixelScale(
                                                              context),
                                                          0,
                                                          0,
                                                          0),
                                                  child: Text(
                                                    _endDatePicked != null &&
                                                            validEndDate
                                                        ? DateFormat(
                                                                'd MMMM , kk:mm ')
                                                            .format(
                                                                _endDatePicked!)
                                                        : 'Select an end date',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontSize: 14
                                                          .pixelScale(context),
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15.pixelScale(context),
                                          ),
                                          const ToolTip(
                                              message:
                                                  "Public events are seen by all users and anyone can join it."),
                                          SizedBox(
                                            height: 3.pixelScale(context),
                                          ),
                                          Container(
                                            height: 48.pixelScale(context),
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
                                                    padding: EdgeInsets.only(
                                                      left: 15
                                                          .pixelScale(context),
                                                    ),
                                                    child: Text(
                                                      'Public',
                                                      style: TextStyle(
                                                          letterSpacing: 0,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                          fontSize: 16
                                                              .pixelScale(
                                                                  context)),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  SizedBox(
                                                    width:
                                                        43.pixelScale(context),
                                                    child: FittedBox(
                                                      fit: BoxFit.fill,
                                                      child: Switch.adaptive(
                                                        key:
                                                            const Key('switch'),
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
                                                        activeColor:
                                                            Colors.black,
                                                        value: isChanged,
                                                        onChanged:
                                                            (bool value) {
                                                          setState(() {
                                                            isChanged = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: 20
                                                          .pixelScale(context)),
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.pixelScale(context),
                                                      0,
                                                      16.pixelScale(context),
                                                      0),
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
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    invites.isEmpty
                                                        ? 'Invite connections*'
                                                        : 'Invite connections (${invites.length})',
                                                    style: TextStyle(
                                                      fontSize: 16
                                                          .pixelScale(context),
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
                                                    color: invites.isEmpty
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .secondary
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                    size:
                                                        24.pixelScale(context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height: 40.pixelScale(context)),
                                        ]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.pixelScale(context),
                                    12.pixelScale(context),
                                    16.pixelScale(context),
                                    12.pixelScale(context)),
                                child: MaterialButton(
                                  key: const Key('create_event_button'),
                                  height: 50.pixelScale(context),
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
                                      create();
                                      _badgeService
                                          .unlockEventPlannerBadge(); //added unlocking the event_planner badge
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: const Text(
                                            "Event created successfully!"),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ));
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
                                      Navigator.of(context).pop();
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
                                  child: Text(
                                    'Create event',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
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
