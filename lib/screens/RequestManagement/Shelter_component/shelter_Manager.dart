// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin/models/shelter.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import '../../../constants.dart';

class ShelterManagers extends StatefulWidget {
  const ShelterManagers({Key? key}) : super(key: key);

  @override
  State<ShelterManagers> createState() => _ShelterManagersState();
}

class _ShelterManagersState extends State<ShelterManagers> {
  databaseUpdate(collectionName, documentId, newData) {
    var collection = FirebaseFirestore.instance.collection(collectionName);
    collection.doc(documentId).update(newData);
  }

  Future<String> address(LatLng coordinate) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinate.latitude, coordinate.longitude);
    Placemark placeMark = placemarks[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    String address =
        "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
    return (address);
  }

  @override
  Widget build(BuildContext context) {
    final _shelters = Provider.of<List<Shelter>>(context);

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView.builder(
        itemCount: _shelters.length,
        itemBuilder: ((context, index) {
          final shelter = _shelters[index];
          return Container(
            margin: EdgeInsets.only(top: defaultPadding),
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              border:
                  Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
              borderRadius: const BorderRadius.all(
                Radius.circular(defaultPadding),
              ),
            ),
            child: ListTile(
              title: Text(
                shelter.name,
                textScaleFactor: 1.5,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  FutureBuilder<String>(
                    future: address(LatLng(
                        shelter.location.latitude, shelter.location.longitude)),
                    builder: (BuildContext context,
                        AsyncSnapshot<String> snapshots) {
                      if (snapshots.hasData) {
                        return Text('${snapshots.data}');
                      } else {
                        return Text(
                            "(" +
                                shelter.location.latitude.toString() +
                                "," +
                                shelter.location.longitude.toString() +
                                ")",
                            style: TextStyle(color: Colors.grey));
                      }
                    },
                  ),
                  if (shelter.status == true) ...[
                    Text(
                      "Open",
                      style: TextStyle(color: Colors.green),
                    ),
                  ] else ...[
                    Text("Close", style: TextStyle(color: Colors.red))
                  ]
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
