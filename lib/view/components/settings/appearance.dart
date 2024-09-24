import 'package:flutter/material.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/services/settings/customize_service.dart';
import 'package:gameonconnect/view/components/settings/edit_colour_icon_component.dart';
import 'package:gameonconnect/view/theme/theme_provider.dart';
import 'package:gameonconnect/view/theme/themes.dart';
import 'package:provider/provider.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => __AppearancePagState();
}

class __AppearancePagState extends State<AppearancePage> {
  final BadgeService _badgeService = BadgeService();
  bool isDarkMode = false;
  bool _isMounted = false;
  Color selectedColor = const Color.fromRGBO(0, 255, 117, 1.0);
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _badgeService.unlockExplorerComponent("changed_theme");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedIndex = CustomizeService()
        .getCurrentIndex(Theme.of(context).colorScheme.primary);
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    ThemeData currentTheme = themeProvider.themeData;

    // Check if the current theme is a dark theme
    isDarkMode = currentTheme == darkGreenTheme ||
        currentTheme == darkPurpleTheme ||
        currentTheme == darkBlueTheme ||
        currentTheme == darkOrangeTheme ||
        currentTheme == darkPinkTheme;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _updateTheme(Color color, int index) {
    if (!_isMounted) {
      return;
    }
    setState(() {
      selectedColor = color;
    });
    CustomizeService().updateTheme(
        color, Provider.of<ThemeProvider>(context, listen: false), isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            
            ColourIconContainer(
                updateTheme: _updateTheme,
                isDarkMode: isDarkMode,
                onDarkModeChanged: (newValue) {
                  setState(() {
                    isDarkMode = newValue;
                  });
                },
                currentColor: selectedColor,
                currentIndex: selectedIndex,
              ),
        
        ]),
    );
  }
}