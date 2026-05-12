import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MagazineDetailScreen extends StatefulWidget {
  final int initialIndex;
  final String imagePath;

  const MagazineDetailScreen({
    super.key,
    required this.initialIndex,
    required this.imagePath,
  });

  @override
  State<MagazineDetailScreen> createState() => _MagazineDetailScreenState();
}

class _MagazineDetailScreenState extends State<MagazineDetailScreen> {
  late PageController _pageController;
  List<dynamic> _magazines = [];
  int _currentPage = 0;
  int get _actualIndex =>
      _currentPage % (_magazines.isEmpty ? 1 : _magazines.length);

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
    final headerImage = _magazines.isNotEmpty
        ? _magazines[widget.initialIndex]['thumbnail'] as String
        : widget.imagePath;

    return Scaffold(
      backgroundColor: const Color(0xFF040905),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _HeaderDelegate(
              imagePath: headerImage,
              maxExtent: 650,
              initialIndex: widget.initialIndex,
              magazineIndex: _magazines.isNotEmpty
                  ? _magazines[widget.initialIndex]['index'] as String
                  : '',
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_magazines.isNotEmpty) ...[
                    Text(
                      _magazines[_actualIndex]['title'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _magazines[_actualIndex]['desc'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                      style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.7),
                    ),
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/f1.webp',
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                      style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.7),
                    ),
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/f2.jpg',
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper.',
                      style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.7),
                    ),
                  ],
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final String imagePath;
  final double _maxExtent;
  final int initialIndex;
  final String magazineIndex;

  _HeaderDelegate({
    required this.imagePath,
    required double maxExtent,
    required this.initialIndex,
    required this.magazineIndex,
  }) : _maxExtent = maxExtent;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    final progress = (shrinkOffset / maxExtent).clamp(0.0, 1.0);
    final imageOpacity = (1 - progress * 2).clamp(0.0, 1.0);
    final blurAmount = 20 * (1 - progress);
    final imageScale = 1.0 + (progress * 0.5);
    final alignX = lerpDouble(-1.0, 0.0, progress)!;

    return Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(color: const Color(0xFF040905)),
              Opacity(
                opacity: imageOpacity,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: blurAmount,
                    sigmaY: blurAmount,
                  ),
                  child: Transform.scale(
                    scale: imageScale,
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                ),
              ),
              Opacity(
                opacity: imageOpacity,
                child: Center(
                  child: Hero(
                    tag: 'swiper_$initialIndex',
                    child: Transform.scale(
                      scale: 1 - (progress * 0.3),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.fitHeight,
                          height: 300 * (1 - progress * 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment(alignX, 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              magazineIndex,
              style: TextStyle(
                fontSize: lerpDouble(250, 40, progress),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: lerpDouble(-50, 0, progress),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return oldDelegate.imagePath != imagePath ||
        oldDelegate.magazineIndex != magazineIndex;
  }
}
