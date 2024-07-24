import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/events/invite_connections_page.dart';
import 'package:gameonconnect/view/pages/events/view_events_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import '../../../model/game_library_M/game_details_model.dart';
import 'choose_my_games_page.dart';

String? selectedOption = "Gaming Session";

class CreateEvents extends StatefulWidget {
  const CreateEvents({super.key});

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  String name="";
  bool validName = false;
  late List<String> gameNames = [];
  late List<String> gameImages = [];
  late List<GameDetails> games;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _datePicked;
  DateTime? _endDatePicked;
  XFile? filePath;
  bool isChanged = false;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  late int gameID;
  late String gameChosen = "";
  bool validStartDate = false;
  bool validEndDate = false;

  String? type;
  List<String>? invites = [];

  Future create() async {
    await Events().createEvent(
        selectedOption,
        _datePicked,
        name,
        _endDatePicked,
        gameID,
        isChanged,
        invites!,
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

  void getGames() async {
    games = await Events().getMyGames();
    for (var i in games) {
      gameNames.add(i.name);
      gameImages.add(i.backgroundImage);
    }
  }

  void getGameID(String gameName) async {
    games = await Events().getMyGames();
    for (var i in games) {
      if (i.name == gameName) {
        gameID = i.id;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getGames();
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
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
              top: true,
              child: FutureBuilder<List<GameDetails>>(
                future: Events().getMyGames(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    //getGames();
                    return Form(
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
                                    alignment:
                                        const AlignmentDirectional(0, -1),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 770,
                                      ),
                                      decoration: const BoxDecoration(),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16, 12, 16, 0),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: InkWell(
                                                    onTap: () {
                                                      pickImage();
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: filePath != null
                                                          ? Image.file(
                                                              File(filePath!
                                                                  .path),
                                                              width: 359,
                                                              height: 200,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.asset(
                                                              'assets/default_images/default_image.jpg',
                                                              width: 359,
                                                              height: 200,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                onTapOutside: (event) {
                                                  name = nameController.text;
                                                  if( name.isNotEmpty){
                                                    setState(() {
                                                      validName = true;
                                                    });
                                                  }else
                                                    {
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
                                                  labelText: 'Event name...',
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
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: validName?
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary: Colors.red,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  filled: true,
                                                  fillColor: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
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
                                                ),
                                                cursorColor: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChooseGame(
                                                                myGames:
                                                                    gameNames,
                                                                chosenGame:
                                                                    gameChosen,
                                                                images: gameImages,
                                                              ))).then(
                                                      (gameChosen) {
                                                    setState(() {
                                                      this.gameChosen =
                                                          gameChosen;
                                                      getGameID(gameChosen);
                                                    });
                                                  });
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Icon(
                                                      gameChosen.isEmpty
                                                          ? Icons.add
                                                          : Icons.check,
                                                      color: gameChosen.isEmpty
                                                          ? Colors.red
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                      size: 24,
                                                    ),
                                                    Text(
                                                      'Choose a game to play...',
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
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                maxLength: 100,
                                                controller:
                                                    descriptionController,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: 'Description...',
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
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  filled: true,
                                                  fillColor: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  contentPadding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          16, 16, 16, 16),
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
                                                highlightColor:
                                                    Colors.transparent,
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
                                                            colorScheme: Theme
                                                                    .of(context)
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
                                                            builder: (context,
                                                                child) {
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
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                      color: validStartDate ?Theme.of(context)
                                                          .colorScheme
                                                          .primary: Colors.red,
                                                      width: 2,
                                                    ),
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
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                          fontSize: 14,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                                highlightColor:
                                                    Colors.transparent,
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
                                                            colorScheme: Theme
                                                                    .of(context)
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
                                                            builder: (context,
                                                                child) {
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
                                                      if (_datePicked!.isBefore(
                                                          _endDatePicked!)) {
                                                        validEndDate = true;
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                            context)
                                                            .showSnackBar(
                                                            const SnackBar(
                                                                content:  Text(
                                                                    "Invalid end date/time."),
                                                                backgroundColor: Colors
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
                                                        .surface,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                      color: validEndDate ?Theme.of(context)
                                                          .colorScheme
                                                          .primary: Colors.red,
                                                      width: 2,
                                                    ),
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
                                                        _endDatePicked != null && validEndDate
                                                            ? DateFormat(
                                                                    'd MMMM , hh:mm a')
                                                                .format(
                                                                    _endDatePicked!)
                                                            : 'Select a date',
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                          fontSize: 14,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    const Text(
                                                      'Private',
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0,
                                                      ),
                                                    ),
                                                    Switch.adaptive(
                                                      activeTrackColor:
                                                          Theme.of(context)
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
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ConnectionsListWidget(
                                                                chosenInvites:
                                                                    invites!,
                                                              ))).then(
                                                      (invited) {
                                                    setState(() {
                                                      invites = invited
                                                          as List<String>?;
                                                    });
                                                  });
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Icon(
                                                      invites!.isEmpty || invites == null
                                                          ? Icons.add
                                                          : Icons.check,
                                                      color: invites!.isEmpty || invites == null
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .secondary
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .primary,
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
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 12, 16, 12),
                              child: MaterialButton(
                                onPressed: () {
                                  // TODO: error handling here
                                  if(validName && gameChosen.isNotEmpty && validEndDate && validStartDate) {
                                    create();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text(
                                          "Event created successfully!"),
                                      backgroundColor:
                                      Theme
                                          .of(context)
                                          .colorScheme
                                          .primary,
                                    ));
                                    nameController.clear();
                                    descriptionController.clear();
                                    gameChosen = "";
                                    invites = [];
                                    validEndDate = false;
                                    validName = false;
                                    validStartDate = false;
                                  }else{
                                    if(!validName) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Please ensure you entered an event name "),
                                          backgroundColor:
                                          Colors.red
                                      ));
                                    }else if (gameChosen.isEmpty){
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Please ensure you chose a game to play "),
                                          backgroundColor:
                                          Colors.red
                                      ));
                                    } else if( !validStartDate){
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Please ensure you entered a valid start date and time "),
                                          backgroundColor:
                                          Colors.red
                                      ));
                                    }else{
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Please ensure you entered a valid end date and time "),
                                          backgroundColor:
                                          Colors.red
                                      ));
                                    }
                                  }
                                },
                                color: Theme.of(context).colorScheme.primary,
                                child: const Text('Create'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            )));
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
