import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_geofence.dart';
import 'edit_geofence.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBWNWbmCjVFX1GEQel6LQ7F8cIL-gDGcs',
      appId: '1:418950512097:android:7b1fd64c0c6e67985166a0',
      messagingSenderId: '418950512097',
      projectId: 'demension-v1-database',
      databaseURL:
          'https://demension-v1-database-default-rtdb.asia-southeast1.firebasedatabase.app',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

// Function to fetch medication data from Firestore
Stream<QuerySnapshot> fetchSMS() {
  return FirebaseFirestore.instance
      .collection('device')
      .doc('31y1sQrytWv6r8gmNSwg')
      .collection('admin')
      .doc('Ardvn3AF3sEqkz1nC5Uc')
      .collection('Geofence') // Access the 'geofence' subcollection
      .snapshots();
}

showDeleteConfirmationDialog(BuildContext context, String documentID) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Confirmation'),
        content: Text('Are you sure you want to delete this item?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () async {
              // Handle item deletion here
              // You can use the provided 'documentID' to delete the item
              // Implement your delete logic here

              final CollectionReference collectionRef = FirebaseFirestore.instance.collection('device')
                  .doc('31y1sQrytWv6r8gmNSwg')
                  .collection('admin')
                  .doc('Ardvn3AF3sEqkz1nC5Uc')
                  .collection('Geofence');
              
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
/*
              // After deleting, you might want to show a success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item deleted successfully'),
                ),
              );

              Navigator.of(context).pop(); // Close the dialog*/
            },
          ),
        ],
      );
    },
  );
}


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geofence Settings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fetchSMS(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final geodoc = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: geodoc.length,
                    itemBuilder: (context, index) {
                      final data =
                          geodoc[index].data() as Map<String, dynamic>;
                      final geoName = data['geoName'];
                      final geoLat = data['geoLatitude'];
                      final geoLong = data['geoLongitude'];
                      final geoRad = data['geoRadius'];
                      final documentID = geodoc[index].id; // Capture the document ID

                      return Card(
                        elevation: 3, // Add a shadow to the card
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(
                            geoName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            'Latitude: $geoLat\nLongitude: $geoLong\nRadius: $geoRad',
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Handle edit button click
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditSMSPage(
                                        geoName: geoName,
                                        geoLat: geoLat,
                                        geoLong: geoLong,
                                        geoRad: geoRad,
                                        documentID: documentID,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Handle delete button click
                                  // You can display a confirmation dialog here
                                  showDeleteConfirmationDialog(context, documentID);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddNumberPage(),
                  ),
                );
              },
              child: Text('Add Geofence'),
            ),
          ),
        ],
      ),
    );
  }
}
