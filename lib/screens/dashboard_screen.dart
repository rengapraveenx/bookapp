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
      appBar: AppBar(
        leading: const Icon(Icons.book),
        title: const Text('magaz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.scanner),
            onPressed: () {},
          ),
        ],
        bottom: _DashboardBottom(
          selectedIndex: _selectedIndex,
          onIndexChanged: (index) => setState(() => _selectedIndex = index),
        ),
      ),
      body: Center(
        child: Text('Dashboard Content $_selectedIndex'),
      ),
    );
  }
}

class _DashboardBottom extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  const _DashboardBottom({
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
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
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: selectedIndex == 0 ? Theme.of(context).colorScheme.primary : Colors.grey,
              ),
              onPressed: () => onIndexChanged(0),
            ),
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: selectedIndex == 1 ? Theme.of(context).colorScheme.primary : Colors.grey,
              ),
              onPressed: () => onIndexChanged(1),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: selectedIndex == 2 ? Theme.of(context).colorScheme.primary : Colors.grey,
              ),
              onPressed: () => onIndexChanged(2),
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: selectedIndex == 3 ? Theme.of(context).colorScheme.primary : Colors.grey,
              ),
              onPressed: () => onIndexChanged(3),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
