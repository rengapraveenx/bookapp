import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MagazineDetailScreen extends StatefulWidget {
  final int initialIndex;

  const MagazineDetailScreen({super.key, required this.initialIndex});

  @override
  State<MagazineDetailScreen> createState() => _MagazineDetailScreenState();
}

class _MagazineDetailScreenState extends State<MagazineDetailScreen> {
  late PageController _pageController;
  List<dynamic> _magazines = [];
  int _currentPage = 0;
  int get _actualIndex => _currentPage % _magazines.length;

  @override
  void initState() {
    super.initState();
    _loadMagazines();
    _pageController = PageController(initialPage: 1000 + widget.initialIndex);
    _currentPage = 1000 + widget.initialIndex;
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  Future<void> _loadMagazines() async {
    final data = await rootBundle.loadString('assets/magazines.json');
    setState(() {
      _magazines = jsonDecode(data);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_magazines.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF040905),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentMagazine = _magazines[_actualIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF040905),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: false,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(currentMagazine['thumbnail'], fit: BoxFit.cover),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        final actualIndex = index % _magazines.length;
                        final magazine = _magazines[actualIndex];
                        return Padding(
                          padding: const EdgeInsets.all(80),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Hero(
                              tag: 'swiper_$actualIndex',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  magazine['thumbnail'],
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: 300,
                  //   child: PageView.builder(
                  //     controller: _pageController,
                  //     itemBuilder: (context, index) {
                  //       final actualIndex = index % _magazines.length;
                  //       final magazine = _magazines[actualIndex];
                  //       return Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 8),
                  //         child: GestureDetector(
                  //           onTap: () => Navigator.of(context).pop(),
                  //           child: Hero(
                  //             tag: 'swiper_$actualIndex',
                  //             child: ClipRRect(
                  //               borderRadius: BorderRadius.circular(12),
                  //               child: Image.asset(
                  //                 magazine['thumbnail'],
                  //                 fit: BoxFit.cover,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Text(
                    currentMagazine['index'],
                    style: const TextStyle(
                      fontSize: 200,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentMagazine['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentMagazine['desc'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 600),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
