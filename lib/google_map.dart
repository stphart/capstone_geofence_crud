import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = Set<Marker>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps with Copy Coordinates'),
      ),
      body: GoogleMap(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        onMapCreated: (controller) {
          mapController = controller;
        },
        onTap: (LatLng position) {
          // Add a marker on each tap
          _addMarker(position);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12.0,
        ),
        markers: markers,
      ),
    );
  }

  void _addMarker1(LatLng position) {
    // Clear existing markers
    markers.clear();

    // Add the new marker
    markers.add(
      Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(title: 'Pinned Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        //icon: BitmapDescriptor.fromAsset('assets/pin_icon.png'),
      ),
    );

    // Move the camera to the tapped position
    mapController?.animateCamera(CameraUpdate.newLatLng(position));

    // Copy coordinates to clipboard
    _copyToClipboard(position);
  }

  void _copyToClipboard(LatLng position) {
    String coordinates = '${position.latitude}, ${position.longitude}';
    Clipboard.setData(ClipboardData(text: coordinates));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coordinates copied to clipboard: $coordinates'),
      ),
    );
  }
  void _addMarker(LatLng position) {
    // Clear existing markers
    markers.clear();

    // Load the custom image bytes
    rootBundle.load('assets/pin_icon.png').then((byteData){
      Uint8List imageData = byteData.buffer.asUint8List();

      // Add the new marker with a custom icon
      markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(title: 'Pinned Location'),
          icon: BitmapDescriptor.fromBytes(imageData),
          zIndex: 1,
        ),
      );
      print('Image bytes length: ${byteData.lengthInBytes}');
      // Move the camera to the tapped position
      mapController?.animateCamera(CameraUpdate.newLatLng(position));

      // Copy coordinates to clipboard
      _copyToClipboard(position);
    }
  );
}
}