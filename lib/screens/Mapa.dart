import 'package:denteeth/screens/InicioPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key, required this.title});

  final String title;

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MapaArgs;

    final marker = Marker(
      markerId: MarkerId(args.titulo),
      position: LatLng(args.lat, args.lng),
      infoWindow: InfoWindow(
        title: args.titulo,
        snippet: args.endereco,
      ),
    );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: GoogleFonts.pacifico()),
        ),
        body: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(args.lat, args.lng),
            zoom: 11.0,
          ),
          markers: {marker}.toSet(),
        ),
      ),
    );
  }
}
