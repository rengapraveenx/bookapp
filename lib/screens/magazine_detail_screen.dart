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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  if (_magazines.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        _magazines[_actualIndex]['index'],
                        style: const TextStyle(
                          fontSize: 250,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
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
                  ],
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
                  imageFilter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
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
