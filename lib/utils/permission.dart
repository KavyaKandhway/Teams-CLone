import 'package:permission_handler/permission_handler.dart';

Future<void> handleCameraAndMic(Permission permission) async {
  final status = await permission.request();
  print(status);
}
