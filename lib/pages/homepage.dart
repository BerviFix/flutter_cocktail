import 'package:flutter/material.dart';
import 'package:flutter_cocktail/components/theme_switch.dart';
import 'package:flutter_cocktail/pages/cocktail_home.dart';
import 'package:flutter_cocktail/pages/cocktail_search_page.dart';

class HomePage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onThemeToggle;
  const HomePage({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Cocktail'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ThemeSwitch(
              isDark: widget.themeMode == ThemeMode.dark,
              onTap: widget.onThemeToggle,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [CocktailHome(), CocktailSearchPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Cerca',
          ),
        ],
      ),
    );
  }
}
