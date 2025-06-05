import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {

  final VoidCallback onFinish;
  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'image': 'assets/bitcoin.png',
      'title': 'Optimize Energy Use',
      'desc': 'As a green blockchain supporter, you can help reduce energy waste by using sustainable consensus mechanisms and Eco-friendly nodes.',
      'bgColor': Color(0xF50E0F10), // Dark gray
    },
    {
      'image': 'assets/silver.png',
      'title': 'Secure with Sustainability',
      'desc': 'Join a network that prioritizes security and sustainability, ensuring a decentralized system without harming the environment.',
      'bgColor': Color(0xF50E0F10), // Deep bluish gray
    },
    {
      'image': 'assets/eco_bar.png',
      'title': 'Eco-Friendly Blockchain',
      'desc': 'Our energy-efficient blockchain model reduces carbon emissions and promotes renewable-powered mining for a greener future.',
      'bgColor': Color(0xF50E0F10), // Eco green
    },
  ];


  void _goToMain() {
    widget.onFinish();
  }

  Widget _buildPage(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            data['image']!,
            height: 250,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          Text(
            data['title']!,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          Text(
            data['desc']!,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentIndex = _controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: onboardingData[_currentIndex]['bgColor'],
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            itemBuilder: (_, index) => _buildPage(onboardingData[index]),
          ),
          Positioned(
            top: 40,
            right: 24,
            child: GestureDetector(
              onTap: _goToMain,
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: _currentIndex == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white30,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          if (_currentIndex == onboardingData.length - 1)
            Positioned(
              bottom: 30,
              right: 24,
              child: GestureDetector(
                onTap: _goToMain,
                child: const Icon(Icons.arrow_forward,
                    size: 32, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}