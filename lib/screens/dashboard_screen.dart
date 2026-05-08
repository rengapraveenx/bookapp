import 'package:card_stack_swiper/card_stack_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'magazine_detail_screen.dart';

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
              icon: const Icon(
                CupertinoIcons.barcode_viewfinder,
                color: Colors.white,
              ),
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
              const SizedBox(height: 180),
              Transform.scale(
                scale: 1.1,
                child: SizedBox(
                  height: 300,
                  child: CardStackSwiper(
                    cardsCount: _cardImages.length,
                    onPressed: (index) {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return MagazineDetailScreen(
                              imagePath: _cardImages[index],
                              index: index,
                            );
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    cardBuilder:
                        (
                          context,
                          index,
                          horizontalOffsetPercentage,
                          verticalOffsetPercentage,
                        ) {
                      return Hero(
                        tag: 'swiper_$index',
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(_cardImages[index]),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                    allowedSwipeDirection: const AllowedSwipeDirection.only(
                      left: true,
                      right: true,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
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
    'assets/f5.jpg',
    'assets/f6.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All magazines',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _magazineImages.map((image) {
              return SizedBox(
                width: (MediaQuery.of(context).size.width - 65) / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(image, fit: BoxFit.cover),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
