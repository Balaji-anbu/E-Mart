import 'package:e_mart/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';

class BaseStepper extends StatelessWidget {
  final int activeStep;
  final double stepSize; // New property for step size
  final double iconSize; // New property for icon size
  final double stepPadding; // New property for step padding

  const BaseStepper({super.key,
    required this.activeStep,
    this.stepSize = 21.0, // Default step size
    this.iconSize = 8.0, // Default icon size
    this.stepPadding = 20.0, // Default padding between steps
  });

  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      finishedStepBackgroundColor: GColors.secondary,
      finishedStepBorderType: BorderType.normal,
      unreachedStepBorderType: BorderType.normal,
      activeStepBackgroundColor: GColors.primary,
      finishedStepTextColor: GColors.secondary,
      activeStepTextColor: GColors.primary,
      fitWidth: true,
      activeStep: activeStep,
      stepShape: StepShape.circle,
      stepRadius: stepSize, // Use the step size here
      stepBorderRadius: 15,
      borderThickness: 5,
      padding: EdgeInsets.symmetric(horizontal: stepPadding,vertical: 0), // Adjust padding between steps using EdgeInsets
      steps: [
        EasyStep(
          icon: Icon(Icons.shopping_cart_outlined, size: iconSize, color: Colors.white), // Adjust icon size
          title: 'Cart',
        ),
        EasyStep(
          icon: Icon(Icons.location_on, size: iconSize, color: Colors.white), // Adjust icon size
          title: 'Address',
        ),
        EasyStep(
          icon: Icon(Icons.payment, size: iconSize, color: Colors.white), // Adjust icon size
          title: 'Checkout',
        ),
        EasyStep(
          icon: Icon(Icons.receipt, size: iconSize, color: Colors.white), // Adjust icon size
          title: 'Summary',
        ),
      ],
      onStepReached: (index) {
        // Handle navigation here if needed
      },
    );
  }
}
