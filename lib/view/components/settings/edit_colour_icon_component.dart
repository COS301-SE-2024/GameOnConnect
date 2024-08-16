//import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gameonconnect/view/theme/theme_provider.dart';

class ColourIconContainer extends StatefulWidget {

  final Function(Color,int) updateTheme;
  final bool isDarkMode;
  final Function(bool) onDarkModeChanged;
  final Color currentColor;
  final int currentIndex;

  const ColourIconContainer({
    super.key,
    required this.updateTheme,
    required this.isDarkMode,
    required this.onDarkModeChanged,
    required this.currentColor,
    required this.currentIndex,
  });

  @override
  State<ColourIconContainer> createState() => _ColourIconContainerState();
  
  }


class _ColourIconContainerState extends State<ColourIconContainer> {
  
  int _selectedIconIndex = 0;

  void _onIconPressed(int index, Color color) {
    widget.updateTheme(color,index);
    setState(() {
      _selectedIconIndex = index;

    });

  }
@override
  void initState() {
    super.initState();
    _selectedIconIndex= widget.currentIndex;
    }

  @override
  Widget build(BuildContext context) {
    //_selectedIconIndex= widget.currentIndex;
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(context, const Color.fromRGBO(0, 255, 117, 1.0),0),
                _buildIconButton(context, const Color.fromRGBO(173, 0, 255, 1.0),1),
                _buildIconButton(context, const Color.fromRGBO(0, 10, 255, 1.0),2),
                _buildIconButton(context, const Color.fromRGBO(235, 255, 0, 1.0),3),
                _buildIconButton(context, const Color.fromRGBO(255, 0, 199, 1.0),4),
              ],
            ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.isDarkMode ? 'Light mode:' : 'Dark mode:',
                    style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.secondary, // dark green in dark mode
                  ),
                  ),
                ),
                //const Spacer(),
                Transform.scale(
  scale: 0.8, // Adjust this value to change the size
  child:Switch(
                    value: widget.isDarkMode,
                    onChanged: (newValue) {
                      widget.onDarkModeChanged(newValue);
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                    activeColor: Theme.of(context).colorScheme.surface,
                    inactiveThumbColor: Theme.of(context).colorScheme.primary,
                    activeTrackColor: Theme.of(context).colorScheme.primary,
                    inactiveTrackColor: Theme.of(context).colorScheme.secondary,
                  ),
                )
                
              ],
            ),
              ),
                                
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, Color color, int index) {
    return GestureDetector(
          onTap: () => _onIconPressed(index,color),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: _selectedIconIndex == index
                  ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.game_controller,
              color: color,
            ),
          ),
        );
        
  }
}


