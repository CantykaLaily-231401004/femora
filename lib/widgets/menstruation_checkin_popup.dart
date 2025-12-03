
import 'package:flutter/material.dart';

class MenstruationCheckinPopup extends StatelessWidget {
  const MenstruationCheckinPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 393,
        height: 476,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 393,
                height: 476,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFDEBD0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 70,
              top: 65,
              child: Text(
                'Apakah Kamu \nSedang Menstruasi?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFF75270),
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              left: 36,
              top: 367,
              child: Container(
                width: 321,
                height: 52,
                padding: const EdgeInsets.all(13),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Tidak',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFF75270),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 34,
              top: 305,
              child: Container(
                width: 321,
                height: 52,
                padding: const EdgeInsets.all(13),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF75270),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Iya',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 130,
              top: 157,
              child: Container(
                  width: 128,
                  height: 128,
                  child: Image.asset('assets/images/fase_menstruasi.png')),
            ),
          ],
        ),
      ),
    );
  }
}
