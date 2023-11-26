// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'google_map.dart';

class AddNumberPage extends StatefulWidget {
  @override
  _AddNumberPageState createState() => _AddNumberPageState();
}

class _AddNumberPageState extends State<AddNumberPage> {
  final TextEditingController _geoname = TextEditingController();
  final TextEditingController _geolat = TextEditingController();
  final TextEditingController _geolong = TextEditingController();
  final TextEditingController _georad = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Geofence Coordinates.'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[


            ButtonBar(
              buttonPadding: EdgeInsets.zero,
              children: <Widget>[
                /*
                ElevatedButton.icon(
                  label: const Text('Edit'),
                  icon: Icon(
                    Icons.edit,
                  ),
                  //color: Colors.blue,
                  onPressed: () {},
                ),*/
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: ElevatedButton.icon(
                    label: const Text('PIN'),
                    icon: Icon(Icons.language),
                    //color: Colors.blue,
                    onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MapScreen(),
                      ),
                    );
                },
                  ),
                ),
              ],
            ),


            TextField(
              controller: _geoname,
              decoration: InputDecoration(labelText: 'Geofence Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _geolat,
              decoration: InputDecoration(labelText: 'Latitude'),
            ),
            TextField(
              controller: _geolong,
              decoration: InputDecoration(labelText: 'Longitude'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _georad,
              decoration: InputDecoration(labelText: 'Radius'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                saveGeofence();
              },
              child: Text('Save Geofence'),
            ),
          ],
        ),
      ),
    );
  }

  void saveGeofence() {
    final getGeoName = _geoname.text;
    final getGeoLat = _geolat.text;
    final getGeoLong = _geolong.text;
    final getGeoRad = _georad.text;

    if (getGeoName.isNotEmpty && getGeoLat.isNotEmpty && getGeoLong.isNotEmpty && getGeoRad.isNotEmpty) {
      // Access your Firestore collection and save the name and phone number.
      FirebaseFirestore.instance
          .collection('device')
          .doc('31y1sQrytWv6r8gmNSwg')
          .collection('admin')
          .doc('Ardvn3AF3sEqkz1nC5Uc')
          .collection('Geofence')
          .add({
        'geoName': getGeoName,
        'geoLatitude': getGeoLat,
        'geoLongitude': getGeoLong,
        'geoRadius': getGeoRad,
      });

      // Clear the input fields.
      _geoname.clear();
      _geolat.clear();
      _geolong.clear();
      _georad.clear();

      Navigator.of(context).pop();

      // Display a success message or navigate to another screen if needed.
      // Example: Navigator.pop(context);
    } else {
      // Handle empty input or display an error message.
    }
  }
}
