import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';

class EditSMSPage extends StatefulWidget {
  final String geoName;
  final String geoLat;
  final String geoLong;
  final String geoRad;
  final String documentID;

  EditSMSPage(
      {required this.geoName, required this.geoLat, required this.geoLong, required this.geoRad, required this.documentID});

  @override
  _EditSMSPageState createState() => _EditSMSPageState();
}

class _EditSMSPageState extends State<EditSMSPage> {
  TextEditingController geoNamedisplay = TextEditingController();
  TextEditingController geoLatDisplay = TextEditingController();
  TextEditingController geoLongDisplay = TextEditingController();
  TextEditingController geoRadDisplay = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the provided values
    geoNamedisplay.text = widget.geoName;
    geoLatDisplay.text = widget.geoLat;
    geoLongDisplay.text = widget.geoLong;
    geoRadDisplay.text = widget.geoRad;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit SMS Entry'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: geoNamedisplay,
            decoration: InputDecoration(labelText: 'Geofence Name'),
          ),
          TextFormField(
            controller: geoLatDisplay,
            decoration: InputDecoration(labelText: 'Latitude'),
          ),
          TextFormField(
            controller: geoLongDisplay,
            decoration: InputDecoration(labelText: 'Longitude'),
          ),
          TextFormField(
            controller: geoRadDisplay,
            decoration: InputDecoration(labelText: 'Radius'),
          ),
          
          ElevatedButton(
            onPressed: () async {
              // Save the edited entry
              String editedName = geoNamedisplay.text;
              String editedLat = geoLatDisplay.text;
              String editedLong = geoLongDisplay.text;
              String editedRad = geoRadDisplay.text;

              // Implement logic to save the edited entry in the database
              // You can use the values in editedName, editedNumber, and editedStatus
              // to update the corresponding SMS entry in the database.

              /* Assuming you are using Firebase Firestore for database operations:
              /FirebaseFirestore.instance
                  .collection('device')
                  .doc('31y1sQrytWv6r8gmNSwg')
                  .collection('admin')
                  .doc('Ardvn3AF3sEqkz1nC5Uc')
                  .collection('SMS')
                  .doc(widget.smsNum)
                  .update({
                'smsName': editedName,
                'smsNum': editedNumber,
                'smsStatus': editedStatus,
              }).then((value) {
                // Update successful, you can display a success message
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Entry updated successfully'),
                ));
                Navigator.of(context)
                    .pop(); // Navigate back to the previous screen
              }).catchError((error) {
                // Handle errors, you can display an error message
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error updating entry: $error'),
                ));
              });*/
            final CollectionReference collectionRef = FirebaseFirestore.instance.collection('device')
                  .doc('31y1sQrytWv6r8gmNSwg')
                  .collection('admin')
                  .doc('Ardvn3AF3sEqkz1nC5Uc')
                  .collection('Geofence');
            final String documentID = widget.documentID; // Replace with the actual document ID

            // Get the updated data from the text controllers
            
            // Create a map with the updated data
            Map<String, dynamic> dataToUpdate = {
              'geoName': editedName,
              'geoLatitude': editedLat,
              'geoLongitude': editedLong,
              'geoRadius': editedRad,
            };

            // Update the Firestore document with the new data
            await collectionRef.doc(documentID).update(dataToUpdate).then((_) {
            // Update successful, you can display a success message
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Entry updated successfully'),
            ));
            Navigator.of(context).pop(); // Navigate back to the previous screen
            }).catchError((error) {
            // Handle errors, you can display an error message
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error updating entry: $error'),
            ));
            });


            },
            child: Text('Update'),
          ),
          /*
          ElevatedButton(
            onPressed: () async {
              /*
              // Implement logic to delete the SMS entry in the database based on widget.smsNum.
              // You can use the widget.smsNum to identify and delete the corresponding entry.
              // Assuming you are using Firebase Firestore:
              FirebaseFirestore.instance
                  .collection('device')
                  .doc('31y1sQrytWv6r8gmNSwg')
                  .collection('admin')
                  .doc('Ardvn3AF3sEqkz1nC5Uc')
                  .collection('SMS')
                  .doc(widget.smsNum)
                  .delete()
                  .then((value) {
                // Deletion successful, you can display a success message
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Entry deleted successfully'),
                ));
                Navigator.of(context)
                    .pop(); // Navigate back to the previous screen
              }).catchError((error) {
                // Handle errors, you can display an error message
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error deleting entry: $error'),
                ));
              });*/

              // To delete a Firestore document, you need to specify the document's reference.
              // Replace 'collectionName' with your Firestore collection name and 'documentID' with the ID of the document to delete.

              final CollectionReference collectionRef = FirebaseFirestore.instance.collection('device')
                  .doc('31y1sQrytWv6r8gmNSwg')
                  .collection('admin')
                  .doc('Ardvn3AF3sEqkz1nC5Uc')
                  .collection('SMS');
              final String documentID = widget.documentID; // Replace with the actual document ID
              await collectionRef.doc(documentID).delete().then((_) {
            // Update successful, you can display a success message
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Number deleted successfully'),
            ));
            Navigator.of(context).pop(); // Navigate back to the previous screen
          }).catchError((error) {
            // Handle errors, you can display an error message
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error deleting entry: $error'),
            ));
          });

            },
            child: Text('Delete'),
          ),*/
        ],
      ),
    );
  }
}
