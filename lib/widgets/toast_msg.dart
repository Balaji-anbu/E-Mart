import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: GColors.primaryBackground,
      textColor: GColors.textSecondary,
      fontSize: GSizes.fontSizeMd
  );
}