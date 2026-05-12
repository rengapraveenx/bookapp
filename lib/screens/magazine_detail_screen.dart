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

class _MagazineDetailScreenState extends State<MagazineDetailScreen>
    with SingleTickerProviderStateMixin {
  late PageController _sliderController;
  late ScrollController _scrollController;
  late AnimationController _btnAnim;
  late Animation<double> _btnProgress;
  List<dynamic> _magazines = [];
  int _currentSliderIndex = 0;
  int get _actualIndex => _currentSliderIndex;

  static const double _headerMax = 650;

  @override
  void initState() {
    super.initState();
    _loadMagazines();
    _sliderController = PageController(initialPage: 1000 + widget.initialIndex);
    _currentSliderIndex = widget.initialIndex;
    _sliderController.addListener(() {
      if (_sliderController.page != null && _magazines.isNotEmpty) {
        final idx = _sliderController.page!.round() % _magazines.length;
        if (idx != _currentSliderIndex) setState(() => _currentSliderIndex = idx);
      }
    });
    _scrollController = ScrollController();
    _btnAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _btnProgress = CurvedAnimation(parent: _btnAnim, curve: Curves.easeOut);
    _btnAnim.forward();
  }

  Future<void> _loadMagazines() async {
    final data = await rootBundle.loadString('assets/magazines.json');
    setState(() {
      _magazines = jsonDecode(data);
    });
  }

  @override
  void dispose() {
    _sliderController.dispose();
    _scrollController.dispose();
    _btnAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerImage = _magazines.isNotEmpty
        ? _magazines[_currentSliderIndex]['thumbnail'] as String
        : widget.imagePath;

    return Scaffold(
      backgroundColor: const Color(0xFF040905),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _HeaderDelegate(
                  imagePath: headerImage,
                  maxExtent: _headerMax,
                  initialIndex: widget.initialIndex,
                  magazineIndex: _magazines.isNotEmpty
                      ? _magazines[_currentSliderIndex]['index'] as String
                      : '',
                  sContorller: _scrollController,
                  magazines: _magazines,
                  sliderController: _sliderController,
                  initialSliderIndex: widget.initialIndex,
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
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.7,
                          ),
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
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.7,
                          ),
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
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.7,
                          ),
                        ),
                      ],
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
          AnimatedBuilder(
            animation: _btnProgress,
            builder: (context, _) {
              final v = _btnProgress.value;
              final top = MediaQuery.of(context).padding.top + 4;
              return Padding(
                padding: const EdgeInsets.only(top: 10, right: 16, left: 16),
                child: Stack(
                  children: [
                    Positioned(
                      top: top,
                      left: 8,
                      child: Transform.translate(
                        offset: Offset(lerpDouble(-60, 0, v)!, 0),
                        child: Opacity(
                          opacity: v,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                                size: 18,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: top,
                      right: 8,
                      child: Transform.translate(
                        offset: Offset(lerpDouble(60, 0, v)!, 0),
                        child: Opacity(
                          opacity: v,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.share_outlined,
                                color: Colors.black,
                                size: 18,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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
  final int initialSliderIndex;
  final String magazineIndex;
  final ScrollController sContorller;
  final List<dynamic> magazines;
  final PageController sliderController;

  _HeaderDelegate({
    required this.imagePath,
    required double maxExtent,
    required this.initialIndex,
    required this.initialSliderIndex,
    required this.magazineIndex,
    required this.sContorller,
    required this.magazines,
    required this.sliderController,
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: magazines.isEmpty
                      ? Center(
                          child: Hero(
                            tag: 'swiper_$initialIndex',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.fitHeight,
                                height: 300 * (1 - progress * 0.5),
                              ),
                            ),
                          ),
                        )
                      : PageView.builder(
                          controller: sliderController,
                          itemBuilder: (context, index) {
                            final mag = magazines[index % magazines.length];
                            final thumb = mag['thumbnail'] as String;
                            final isInitial =
                                (index % magazines.length) == initialSliderIndex;
                            return Center(
                              child: Transform.scale(
                                scale: 1 - (progress * 0.3),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: isInitial
                                      ? Hero(
                                          tag: 'swiper_$initialIndex',
                                          child: Image.asset(
                                            thumb,
                                            fit: BoxFit.fitHeight,
                                            height: 300 * (1 - progress * 0.5),
                                          ),
                                        )
                                      : Image.asset(
                                          thumb,
                                          fit: BoxFit.fitHeight,
                                          height: 300 * (1 - progress * 0.5),
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              //todo
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: sContorller,
                  builder: (context, _) {
                    final progress = sContorller.hasClients
                        ? (sContorller.offset / maxExtent).clamp(0.0, 1.0)
                        : 0.0;
                    final maxHeight =
                        MediaQuery.of(context).padding.top +
                        kToolbarHeight +
                        20;
                    final colorProgress = ((progress - 0.7) / 0.3).clamp(
                      0.0,
                      1.0,
                    );
                    return Container(
                      height: maxHeight * progress,
                      color: Color.fromRGBO(4, 9, 5, colorProgress),
                    );
                  },
                ),
              ),
              //todo
              Align(
                alignment: Alignment(alignX, 0),
                child: Padding(
                  padding: EdgeInsets.only(left: lerpDouble(60, 0, progress)!),
                  child: Text(
                    magazineIndex,
                    overflow: TextOverflow.visible,
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
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => 110;

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return oldDelegate.imagePath != imagePath ||
        oldDelegate.magazineIndex != magazineIndex ||
        oldDelegate.magazines != magazines;
  }
}
