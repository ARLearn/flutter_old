import 'dart:io';

import 'package:youplay/screens/general_item/dataCollection/picture_preview_file.dart';
import 'package:youplay/screens/general_item/dataCollection/picture_preview_live.dart';
import 'package:youplay/screens/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class TakePictureWidget extends StatefulWidget {
  dynamic takePictureCallBack;
  Function cancelCallBack;
  TakePictureWidget({this.takePictureCallBack, this.cancelCallBack});

  @override
  _TakePictureWidgetState createState() {
    return _TakePictureWidgetState(
      );
  }
}

class _TakePictureWidgetState extends State<TakePictureWidget> {

  CameraController controller;
  _TakePictureWidgetState();

  List<CameraDescription> cameras = [];
  CameraLensDirection _direction = CameraLensDirection.back;

  bool pictureTaken = false;
  String imagePath;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // Fetch the available cameras before initializing the app.
    _loadCameras().then((cameras) {
      setState(() {
        this.cameras = cameras;
        print("cameras loaded ${this.cameras.length}");
      });
    });

    _initializeCamera();

    super.initState();
  }

  void _initializeCamera() async {
    controller = CameraController(
      await getCamera(_direction),
      ResolutionPreset.high,
    );
    await controller.initialize().then((_) {
      setState(() {
        this.cameras = this.cameras;
        print("exec set state");
      });
    });
  }

  Future<List<CameraDescription>> _loadCameras() async {
    // Fetch the available cameras before initializing the app.
    print('hallo');
    try {
      if (cameras == null || cameras.isEmpty) return await availableCameras();
    } on CameraException catch (e) {
//      logError(e.code, e.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return pictureTaken
          ? pictureFilePreviewWidget(imagePath, () {
        setState(() {
          pictureTaken = false;
        });
        widget.takePictureCallBack(imagePath);

      }, widget.cancelCallBack)
          : cameraPreviewWidget(controller, _takePicture, widget.cancelCallBack, context);
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      print("in init");
      return const Text(
        'Initializing camera',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      print("aspect ratio");
      return Stack(
        alignment: const Alignment(0, 0.9),
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
          Container(
              child: FloatingActionButton(
                  elevation: 2.0,
                  child: Icon(Icons.camera_alt),
                  onPressed: () {
                    print("picture taken");
                    _takePicture();
                  })
//              Text(
//                'Mia B',
//                style: TextStyle(
//                  fontSize: 20,
//                  fontWeight: FontWeight.bold,
//                  color: Colors.white,
//                ),
//              ),
              ),
        ],
      );
//      AspectRatio(
//        aspectRatio: controller.value.aspectRatio,
//        child: CameraPreview(controller),
//      )
    }
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> _takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
//      _showCameraException(e);
      print("exception e");
      return null;
    }
    setState(() {
      pictureTaken = true;
      imagePath = filePath;
    });
    return filePath;
  }
}
