import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class LiveCameraScreen extends StatefulWidget {
  const LiveCameraScreen({super.key});

  @override
  State<LiveCameraScreen> createState() => _LiveCameraScreenState();
}

class _LiveCameraScreenState extends State<LiveCameraScreen> {
  List<YOLOResult> _detections = [];
  double _fps = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text('Live: ${_detections.length} Pohon'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '${_fps.toStringAsFixed(1)} FPS',
                style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: YOLOView(
        modelPath: 'assets/models/yolo_model.tflite',
        confidenceThreshold: 0.4,
        iouThreshold: 0.45,
        lensFacing: LensFacing.back,
        showOverlays: true, 
        onResult: (results) {
          setState(() => _detections = results);
        },
        onPerformanceMetrics: (metrics) {
          setState(() => _fps = metrics.fps);
        },
      ),
    );
  }
}