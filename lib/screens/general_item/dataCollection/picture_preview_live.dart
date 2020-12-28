import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

Widget takePictureButton(Function takePicture) {
  return Padding(
      padding: EdgeInsets.all(8.0),
      child: FloatingActionButton(
          elevation: 2.0,
          child: Icon(Icons.camera_alt),
          onPressed: () {
            print("picture taken");
            takePicture();
          }));
}

Widget cancelButton(Function cancel) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: FloatingActionButton(
        child: Icon(Icons.cancel),
        onPressed: () {
          cancel();
        }),
  );
}

Widget cameraPreviewWidget(
    CameraController controller, Function takePicture, Function cancel, BuildContext context) {
  if (controller == null || !controller.value.isInitialized) {
    return const Text(
      'Initializing camera',
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w900,
      ),
    );
  } else {
//    print("aspect ratio");
    final size = MediaQuery.of(context).size;
    return NativeDeviceOrientationReader(
      builder: (context) {
        // print('orientation ${orientation.}');
        final orientation =
        NativeDeviceOrientationReader.orientation(context);
        print('Received new orientation: $orientation');

        if (orientation == NativeDeviceOrientation.portraitDown || orientation == NativeDeviceOrientation.portraitUp) {
          return Stack(
            alignment: const Alignment(0, 0.9),
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(controller),
                ),
              ),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[takePictureButton(takePicture), cancelButton(cancel)],
              )),
            ],
          );
        } else {

          return Stack(
            alignment: const Alignment(0.9, 0),
            children: [
              RotatedBox(
                quarterTurns: orientation == NativeDeviceOrientation.landscapeLeft? 3 : 1,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
                ),
              ),
              Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[takePictureButton(takePicture), cancelButton(cancel)],
                  )),
            ],
          );
        }
      },
    );
  }
}
