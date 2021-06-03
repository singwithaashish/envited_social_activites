import 'dart:async';
import 'dart:convert';

import 'package:envited/authentication/auth.dart';
import 'package:envited/components/all_components.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapSample extends StatefulWidget {
  const MapSample({required this.tinv});

  final TemporaryInvite tinv;
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Marker _destination = Marker(
    markerId: MarkerId('Destination'),
    infoWindow: InfoWindow(title: 'Destination'),
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Long press to add location'),
      ),
      body: GoogleMap(
        zoomControlsEnabled: false,
        onLongPress: (a) {
          // print('Long Press detected');
          setState(() {
            _destination = Marker(
                markerId: MarkerId('Destination'),
                infoWindow: InfoWindow(title: 'Destination'),
                position: a);
          });
        },
        mapType: MapType.normal,
        markers: {_destination},
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        onPressed: () {
          print(_destination.position);
          widget.tinv.location = _destination.position;
          Navigator.pop(context);
        },
        label: Text('Add this Location'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
