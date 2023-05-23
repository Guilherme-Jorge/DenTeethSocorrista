import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'DadosContatoPage.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tire uma foto da boca')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();
            GallerySaver.saveImage(image.path);
            if (!mounted) return;

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                  controllerCamera: _controller,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final CameraController controllerCamera;

  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.controllerCamera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Display the Picture'),
            automaticallyImplyLeading: false),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 530, child: Image.file(File(imagePath))),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.repeat_rounded, color: Colors.black54),
                            SizedBox(width: 6),
                            Text(
                              'Refazer foto',
                              style: TextStyle(color: Colors.black54),
                            )
                          ],
                        )),
                    const SizedBox(width: 40),
                    ElevatedButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(20, 0, 20, 0))),
                        onPressed: () async {
                          Navigator.pushNamed(context, '/dados',
                              arguments: ScreenArguments(imagePath));

                          await controllerCamera.pausePreview();
                        },
                        child: const Text('Próximo passo')),
                  ])
            ]));
  }
}
