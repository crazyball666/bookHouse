import 'package:bookApp/util/QRCodeScanUtil.dart';
import 'package:flutter/material.dart';
import 'package:r_scan/r_scan.dart';

class ScanCameraPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScanCameraPageState();
}

class _ScanCameraPageState extends State<ScanCameraPage> {
  static List<RScanCameraDescription> rScanCameras;
  RScanCameraController _controller;
  bool _isFirst = true;

  _listener() {
    if (_controller?.result != null && _isFirst) {
      Navigator.of(context).pop(_controller?.result?.message);
      _isFirst = false;
    }
  }

  _setup() async {
    if (rScanCameras == null || rScanCameras.isEmpty) {
      rScanCameras = await availableRScanCameras();
    }
    bool canOpenCamera = await QRCodeScanUtil.canOpenCamera();
    if (!canOpenCamera) {
      return;
    }
    if (rScanCameras != null && rScanCameras.length > 0) {
      _controller = RScanCameraController(
          rScanCameras[0], RScanCameraResolutionPreset.max)
        ..addListener(_listener);
      await _controller.initialize();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller?.removeListener(_listener);
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (rScanCameras == null || rScanCameras.length == 0) {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Text('not have available camera'),
        ),
      );
    }
    if (_controller == null || !_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          RScanCamera(_controller),
          Align(
            alignment: Alignment.center,
            child: Text(
              "扫描二维码",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              color: Colors.white,
              iconSize: 30,
              icon: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
