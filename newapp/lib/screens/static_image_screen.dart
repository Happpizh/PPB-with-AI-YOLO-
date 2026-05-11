import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class StaticImageScreen extends StatefulWidget {
  const StaticImageScreen({super.key});

  @override
  State<StaticImageScreen> createState() => _StaticImageScreenState();
}

class _StaticImageScreenState extends State<StaticImageScreen> {
  File? _image;
  Map<String, dynamic>? _results;
  bool _loading = false;
  late YOLO yolo;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initYoloModel();
  }

  Future<void> _initYoloModel() async {
    yolo = YOLO(
      modelPath: 'assets/models/yolo_model.tflite',
      task: YOLOTask.detect,
    );
    await yolo.loadModel();
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 640,
      maxHeight: 640,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() {
      _loading = true;
      _image = File(pickedFile.path);
      _results = null;
    });

    _processImage(_image!);
  }

  Future<void> _processImage(File image) async {
    try {
      Uint8List bytes = await image.readAsBytes();
      final results = await yolo.predict(bytes);
      
      setState(() {
        _results = results;
        _loading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPohon = 0;
    if (_results != null && _results!['boxes'] != null) {
      totalPohon = (_results!['boxes'] as List).length;
    }

    Uint8List? imageWithBoxes;
    if (_results != null && _results!['annotatedImage'] != null) {
      imageWithBoxes = Uint8List.fromList((_results!['annotatedImage'] as List).cast<int>());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analisis Foto Pohon"),
        backgroundColor: Colors.teal[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: _image == null
                ? const Center(child: Text("Pilih foto untuk mendeteksi pohon kelapa sawit", textAlign: TextAlign.center))
                : _loading
                    ? const Center(child: CircularProgressIndicator(color: Colors.tealAccent))
                    : Container(
                        margin: const EdgeInsets.all(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imageWithBoxes != null 
                              ? Image.memory(imageWithBoxes, fit: BoxFit.contain)
                              : Image.file(_image!, fit: BoxFit.contain),
                        ),
                      ),
          ),
          
          if (_results != null)
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.teal[800],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const Text("Hasil Deteksi AI", style: TextStyle(fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 5),
                  Text(
                    "$totalPohon Pohon Sawit Ditemukan", 
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  onPressed: () => pickImage(ImageSource.camera), 
                  icon: const Icon(Icons.camera_alt), 
                  label: const Text("Jepret")
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  onPressed: () => pickImage(ImageSource.gallery), 
                  icon: const Icon(Icons.photo_library), 
                  label: const Text("Galeri")
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}