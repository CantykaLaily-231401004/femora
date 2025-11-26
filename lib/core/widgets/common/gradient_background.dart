import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/core/utils/size_config.dart';

/// Reusable Gradient Background Widget
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  const GradientBackground({
    Key? key,
    required this.child,
    this.colors,
    this.begin,
    this.end,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Container(
      width: double.infinity,
      height: height ?? SizeConfig.getHeight(60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin ?? Alignment.topCenter,
          end: end ?? Alignment.bottomCenter,
          colors: colors ?? [
            AppColors.primary,
            AppColors.cream,
            AppColors.white,
          ],
        ),
        borderRadius: borderRadius ?? const BorderRadius.only(
          bottomLeft: Radius.circular(AppBorderRadius.xl),
          bottomRight: Radius.circular(AppBorderRadius.xl),
        ),
      ),
      child: child,
    );
  }
}

/// Variasi lain untuk full gradient background
class FullGradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;

  const FullGradientBackground({
    Key? key,
    required this.child,
    this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors ?? [
            AppColors.primaryLight,
            AppColors.primary,
          ],
        ),
      ),
      child: child,
    );
  }
}
