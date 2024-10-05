import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingView extends StatefulWidget {
  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  var _currentPage = 0.obs;

  List<Widget> _buildPages() {
    return [
      _buildOnboardingPage(
        imagePath: 'assets/image1.png',
        title: 'Manage your tasks',
        description:
            'You can easily manage all of your daily tasks in ArcTask for free',
      ),
      _buildOnboardingPage(
        imagePath: 'assets/image2.png',
        title: 'Create daily routine',
        description:
            'In ArcTask, you can create your personalized routine to stay productive',
      ),
      _buildOnboardingPage(
        imagePath: 'assets/image3.png',
        title: 'Organize your tasks',
        description:
            'You can organize your daily tasks by adding them into separate categories',
      ),
    ];
  }

  Widget _buildOnboardingPage(
      {required String imagePath,
      required String title,
      required String description}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath, height: 250),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              _currentPage.value = page;
            },
            children: _buildPages(),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: Obx(
              () => _currentPage.value > 0
                  ? TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      child:
                          Text("BACK", style: TextStyle(color: Colors.white)),
                    )
                  : SizedBox.shrink(),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: Obx(() => TextButton(
                  onPressed: () {
                    if (_currentPage.value < 2) {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    } else {
                      Get.offNamed('/start');
                    }
                  },
                  child: Text(_currentPage.value == 2 ? "GET STARTED" : "NEXT",
                      style: TextStyle(color: Colors.purple[400])),
                )),
          ),
        ],
      ),
    );
  }
}
