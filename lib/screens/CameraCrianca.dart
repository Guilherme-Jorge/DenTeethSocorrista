import 'dart:io';

import 'package:camera/camera.dart';
import 'package:denteeth/screens/CameraBoca.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';

import 'DadosContatoPage.dart';

class CameraCrianca extends StatefulWidget {
  const CameraCrianca({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  CameraCriancaState createState() => CameraCriancaState();
}

class CameraCriancaState extends State<CameraCrianca> {
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
    final args = ModalRoute.of(context)!.settings.arguments as CameraArgs;
    return Scaffold(
      appBar: AppBar(
          title: Text('Tirar uma foto com a criança',
              style: GoogleFonts.pacifico()),
          automaticallyImplyLeading: false),
      body: Center(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.grey,
                          width: 110,
                          height: 6,
                        ),
                        const SizedBox(width: 2),
                        Container(
                          color: Colors.grey,
                          width: 110,
                          height: 6,
                        ),
                        const SizedBox(width: 2),
                        Container(
                          color: Colors.blue,
                          width: 110,
                          height: 6,
                        ),
                      ],
                    ),
                    FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return SizedBox(
                              width: double.infinity,
                              height: 500,
                              child: CameraPreview(_controller));
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                    Text('Certifique-se de estar em um ambiente iluminado ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                                color: Colors.black38, fontSize: 16))),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blueAccent),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.fromLTRB(0, 12, 0, 12))),
                          onPressed: () async {
                            try {
                              await _initializeControllerFuture;

                              final image = await _controller.takePicture();
                              GallerySaver.saveImage(image.path);
                              if (!mounted) return;

                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CameraCriancaDisplay(
                                    imagePath: image.path,
                                    controllerCamera: _controller,
                                    args: args,
                                  ),
                                ),
                              );
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text('Tirar foto',
                              style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)))),
                    ),
                  ]))),
    );
  }
}

class CameraCriancaDisplay extends StatelessWidget {
  final String imagePath;
  final CameraController controllerCamera;
  final CameraArgs args;

  const CameraCriancaDisplay(
      {super.key,
      required this.imagePath,
      required this.controllerCamera,
      required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text('Confirme a foto tirada', style: GoogleFonts.pacifico()),
            automaticallyImplyLeading: false),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Image(
              width: double.infinity,
              height: 500,
              image: FileImage(File(imagePath))),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      children: [
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
                      args.imagesPath.add(imagePath);
                      Navigator.pushNamed(context, '/dados',
                          arguments: CameraArgs(args.imagesPath));

                      await controllerCamera.pausePreview();
                    },
                    child: Text('Próximo passo', style: GoogleFonts.inter())),
              ])
        ]));
  }
}
