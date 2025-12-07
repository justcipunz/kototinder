import 'package:flutter/material.dart';
import '../models/cat_model.dart';
import 'home_tab.dart';
import 'breeds_screen.dart';
import 'favorites_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<CatModel> _likedCats = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addLike(CatModel cat) {
    if (!_likedCats.any((element) => element.id == cat.id)) {
      setState(() {
        _likedCats.add(cat);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Котик добавлен в избранное!'),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _removeLike(CatModel cat) {
    setState(() {
      _likedCats.removeWhere((element) => element.id == cat.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeTab(onLike: _addLike),
      FavoritesScreen(likedCats: _likedCats, onRemove: _removeLike),
      const BreedsScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Поиск'),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),

            label: _likedCats.isNotEmpty
                ? 'Любимые (${_likedCats.length})'
                : 'Любимые',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Породы',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
