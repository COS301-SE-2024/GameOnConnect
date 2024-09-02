import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../model/events_M/chip_model.dart';

class ChipSelector extends StatefulWidget {
  final String selectedOption;
  final void Function(String selectedOption) onSelected;

  const ChipSelector({super.key, required this.selectedOption, required this.onSelected});

  @override
  State<ChipSelector> createState() => _ChipSelectorState();
}

class _ChipSelectorState extends State<ChipSelector> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedOption;
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    List<ChipData> options = [
      ChipData(
          'Gaming Session',
          Icon(
            CupertinoIcons.game_controller,
            color: selectedOption == 'Gaming Session'
                ? Colors.black
                : Theme.of(context).colorScheme.secondary,
            size: 18,
          )),
      ChipData(
          'Tournament',
          Icon(
            Icons.emoji_events_outlined,
            color: selectedOption == "Tournament"
                ? Colors.black
                : Theme.of(context).colorScheme.secondary,
            size: 18,
          )),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((option) {
        return ChoiceChip(
          showCheckmark: false,
          label: Center(
            child: Container(
              height: 25,
              alignment: Alignment.center,
              child: Row(children: [
                option.icon,
                const SizedBox(
                  width: 5,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    option.label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: selectedOption == option.label
                          ? Colors.black
                          : Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ]),
            ),
          ),
          selected: selectedOption == option.label,
          onSelected: (bool selected) {
            setState(() {
              selectedOption = (selected ? option.label : null)!;
              widget.onSelected(selectedOption);
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
            ),
          ),
          elevation: 0,
        );
      }).toList(),
    );
  }
}