import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({Key? key, required this.currentPage, required this.pageCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: currentPage == index ? 28 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: currentPage == index
                ? const Color(0xFFDC143C)
                : const Color(0xFFF7CAC9),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
