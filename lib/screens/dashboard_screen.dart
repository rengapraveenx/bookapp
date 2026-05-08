import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:card_stack_swiper/card_stack_swiper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<String> _cardImages = [
    'assets/b1.jpg',
    'assets/b2.jpg',
    'assets/b3.jpg',
    'assets/b4.jpg',
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF040905), Colors.black, Color(0xFFF9F3F9)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.book, color: Colors.white),
              SizedBox(width: 8),
              Text('magaz', style: TextStyle(color: Colors.white)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.barcode_viewfinder, color: Colors.white),
              onPressed: () {},
            ),
          ],
          bottom: const _SearchBarBottom(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 220),
              Transform.scale(
              child: Transform.scale(
                scale: 1.5,
                child: CardStackSwiper(
                  cardsCount: _cardImages.length,
                  cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(_cardImages[index]),
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                  allowedSwipeDirection: const AllowedSwipeDirection.only(left: true, right: true),
                ),
              ),
            ),
            _AllMagazines(),
          ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  CupertinoIcons.home,
                  color: _selectedIndex == 0 ? Colors.black : Colors.grey,
                ),
                onPressed: () => setState(() => _selectedIndex = 0),
              ),
              IconButton(
                icon: Icon(
                  CupertinoIcons.shopping_cart,
                  color: _selectedIndex == 1 ? Colors.black : Colors.grey,
                ),
                onPressed: () => setState(() => _selectedIndex = 1),
              ),
              IconButton(
                icon: Icon(
                  CupertinoIcons.search,
                  color: _selectedIndex == 2 ? Colors.black : Colors.grey,
                ),
                onPressed: () => setState(() => _selectedIndex = 2),
              ),
              IconButton(
                icon: Icon(
                  CupertinoIcons.person,
                  color: _selectedIndex == 3 ? Colors.black : Colors.grey,
                ),
                onPressed: () => setState(() => _selectedIndex = 3),
              ),
            ],
          ),
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
          fillColor: const Color(0xFF1A201C),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
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

class _AllMagazines extends StatelessWidget {
  final List<String> _magazineImages = [
    'assets/f1.webp',
    'assets/f2.jpg',
    'assets/f3.webp',
    'assets/f4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All magazines',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _magazineImages.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  _magazineImages[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
