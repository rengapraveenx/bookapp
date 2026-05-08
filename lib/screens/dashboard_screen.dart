import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const Icon(Icons.book),
        title: const Text('magaz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.scanner),
            onPressed: () {},
          ),
        ],
        bottom: const _SearchBarBottom(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.white],
          ),
        ),
        child: Center(
          child: Text('Dashboard Content $_selectedIndex'),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              onPressed: () => setState(() => _selectedIndex = 0),
            ),
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: _selectedIndex == 1
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              onPressed: () => setState(() => _selectedIndex = 1),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: _selectedIndex == 2
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              onPressed: () => setState(() => _selectedIndex = 2),
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: _selectedIndex == 3
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              onPressed: () => setState(() => _selectedIndex = 3),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBarBottom extends StatelessWidget implements PreferredSizeWidget {
  const _SearchBarBottom();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
