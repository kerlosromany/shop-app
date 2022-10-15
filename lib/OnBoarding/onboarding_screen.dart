import 'package:flutter/material.dart';
import 'package:shop_app/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Login/login_screen.dart';

class OnBoardingModel {
  final String image;
  final String title;
  final String body;

  OnBoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoarding extends StatefulWidget {
  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<OnBoardingModel> boardingList = [
    OnBoardingModel(
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZRa6st4N_q23lCMeIOn6hFEmopvBNv6ZCCg&usqp=CAU",
      title: "OnBoarding Title 1",
      body: "OnBoarding Body 1",
    ),
    OnBoardingModel(
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZRa6st4N_q23lCMeIOn6hFEmopvBNv6ZCCg&usqp=CAU",
      title: "OnBoarding Title 2",
      body: "OnBoarding Body 2",
    ),
    OnBoardingModel(
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZRa6st4N_q23lCMeIOn6hFEmopvBNv6ZCCg&usqp=CAU",
      title: "OnBoarding Title 3",
      body: "OnBoarding Body 3",
    ),
  ];

  PageController pageController = PageController();

  bool isLast = false;
  void submit() {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: const Text(
              "SKIP",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              submit();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) =>
                    buildPageViewItem(boardingList[index]),
                itemCount: boardingList.length,
                controller: pageController,
                onPageChanged: (index) {
                  if (index == boardingList.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: boardingList.length,
                  effect: const ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    dotWidth: 10,
                    expansionFactor: 3,
                    radius: 4,
                    spacing: 5,
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPageViewItem(OnBoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: NetworkImage(
                model.image,
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Text(
            model.title,
            style: const TextStyle(fontSize: 25.0),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            model.body,
            style: const TextStyle(fontSize: 25.0),
          ),
          const SizedBox(
            height: 15.0,
          ),
        ],
      );
}
