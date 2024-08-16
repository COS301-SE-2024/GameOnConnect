import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gameonconnect/view/theme/theme_provider.dart';

class ColourIconContainer extends StatelessWidget {
  final Function(Color) updateTheme;
  final bool isDarkMode;
  final Function(bool) onDarkModeChanged;
  final Color currentColor;

  const ColourIconContainer({
    super.key,
    required this.updateTheme,
    required this.isDarkMode,
    required this.onDarkModeChanged,
    required this.currentColor,
  });

  @override
  Widget build(BuildContext context) {
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
                _buildIconButton(context, const Color.fromRGBO(0, 255, 117, 1.0)),
                _buildIconButton(context, const Color.fromRGBO(173, 0, 255, 1.0)),
                _buildIconButton(context, const Color.fromRGBO(0, 10, 255, 1.0)),
                _buildIconButton(context, const Color.fromRGBO(235, 255, 0, 1.0)),
                _buildIconButton(context, const Color.fromRGBO(255, 0, 199, 1.0)),
              ],
            ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isDarkMode ? 'Light mode:' : 'Dark mode:',
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
                    value: isDarkMode,
                    onChanged: (newValue) {
                      onDarkModeChanged(newValue);
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

  Widget _buildIconButton(BuildContext context, Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.transparent,
          width: 0.5,
        ),
      ),
      child: IconButton(
        color: Theme.of(context).colorScheme.primary,
        icon: Icon(
          CupertinoIcons.game_controller,
          color: color,
        ),
        onPressed: () {
          updateTheme(color);
        },
      ),
    );
  }
}


