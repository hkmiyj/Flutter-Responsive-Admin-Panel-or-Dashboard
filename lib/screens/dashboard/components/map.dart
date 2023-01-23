import 'dart:developer';

import 'package:admin/constants.dart';
import 'package:admin/models/shelter.dart';
import 'package:admin/models/victim.dart';
import 'package:admin/screens/dashboard/components/mapZoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class mapViews extends StatefulWidget {
  const mapViews({Key? key}) : super(key: key);

  @override
  State<mapViews> createState() => _mapViewsState();
}

class _mapViewsState extends State<mapViews> with TickerProviderStateMixin {
  bool mapScroll = true;
  late List<Marker> mapmark = [];
  late MapController mapController;
  TextEditingController tbPhone = TextEditingController();

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  void _onMapController(MapController controller) async {
    this.mapController = controller;
  }

  void animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _addMarker() {
    final _shelters = Provider.of<List<Shelter>>(context);
    for (var i = 0; i < _shelters.length; i++) {
      final shelter = _shelters[i];
      mapmark.add(
        new Marker(
          point: LatLng(shelter.location.latitude, shelter.location.longitude),
          height: 30,
          width: 30,
          builder: (context) => new IconButton(
              onPressed: () {
                animatedMapMove(
                    LatLng(
                        shelter.location.latitude, shelter.location.longitude),
                    18);
                _cardDescription(
                    context,
                    LatLng(
                        shelter.location.latitude, shelter.location.longitude),
                    shelter);
              },
              icon: Icon(
                Icons.home,
                color: Colors.red,
              )),
        ),
      );
    }
    final _victim = Provider.of<List<Victim>>(context);
    for (var i = 0; i < _victim.length; i++) {
      final victim = _victim[i];
      mapmark.add(
        new Marker(
          point: LatLng(victim.location.latitude, victim.location.longitude),
          height: 30,
          width: 30,
          builder: (context) => IconButton(
              onPressed: () {
                animatedMapMove(
                    LatLng(victim.location.latitude, victim.location.longitude),
                    18);
                _cardDescriptionVictim(
                    context,
                    LatLng(victim.location.latitude, victim.location.longitude),
                    victim);
              },
              icon: Icon(
                Icons.flag,
                color: Colors.red,
              )),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _addMarker();
    return Container(
        child: Stack(
      children: [
        Text(
          "Map",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Container(
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          height: 800,
          width: double.infinity,
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              enableScrollWheel: false,
              center: LatLng(3.95, 108.13),
              zoom: 6.5,
              minZoom: 1,
              slideOnBoundaries: true,
              interactiveFlags:
                  InteractiveFlag.drag | InteractiveFlag.doubleTapZoom,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/damfud/cl7n4wktc001v16lnqcz7i2z8/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGFtZnVkIiwiYSI6ImNsN2s3dHNoMzBmOWIzb3F6OWkyMnM0ZWoifQ.N022hvg6-KtFSQ7NqetikQ",
                additionalOptions: {"access_token": mapPk_AccessToken},
              ),
              MarkerLayer(
                markers: mapmark,
              ),
            ],
            nonRotatedChildren: [FlutterMapZoomButtons()],
          ),
        ),
      ],
    ));
  }

  Future _cardDescriptionVictim(BuildContext context, marker, Victim victim) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(victim.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Location"),
                Text("(" +
                    victim.location.latitude.toString() +
                    "," +
                    victim.location.longitude.toString() +
                    ")"),
                Text(" "),
                Text("Description",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(victim.description),
                Text(" "),
                Text("Phone Number",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(victim.phoneNumb),
                Text(" "),
                Text("Help Status",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                if (victim.status == false) ...[
                  Text(
                    "Need Help",
                    style: TextStyle(color: Colors.red),
                  ),
                ] else ...[
                  Text("Done", style: TextStyle(color: Colors.green))
                ]
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future _cardDescription(BuildContext context, marker, Shelter shelter) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        tbPhone.text = shelter.phone;
        return AlertDialog(
          title: Text(shelter.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Location"),
                Text("(" +
                    shelter.location.latitude.toString() +
                    "," +
                    shelter.location.longitude.toString() +
                    ")"),
                Text(" "),
                Text("Description",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(shelter.description),
                Text(" "),
                Text("Phone Number",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: tbPhone,
                ),
                Text(" "),
                Text("Shelter Status",
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
          actions: <Widget>[
            if (shelter.status == true) ...[
              TextButton(
                child: const Text('Close Shelter'),
                onPressed: () {
                  updateShelterToFalse(shelter);
                  Navigator.of(context).pop();
                },
              ),
            ] else ...[
              TextButton(
                child: const Text('Open Shelter'),
                onPressed: () {
                  updateShelterToTrue(shelter);
                  Navigator.of(context).pop();
                },
              ),
            ],
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> address(LatLng coordinate) async {
    final coordinates =
        new Coordinates(coordinate.latitude, coordinate.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    return ("${first.featureName} : ${first.addressLine}");
  }

  void updateShelterToFalse(Shelter shelter) {
    //Set updated data for selected appointment
    FirebaseFirestore.instance
        .collection('shelters')
        .doc(shelter.shelterId.trim())
        .update({"status": false}).then(
            (value) => log("Shelter Successfully update"),
            onError: (e) => log("Error updating appointment: $e"));
  }

  void updateShelterToTrue(Shelter shelter) {
    //Set updated data for selected appointment
    FirebaseFirestore.instance
        .collection('shelters')
        .doc(shelter.shelterId.trim())
        .update({"status": true}).then(
            (value) => log("Shelter Successfully update"),
            onError: (e) => log("Error updating appointment: $e"));
  }

  void verified(Shelter shelter) {
    FirebaseFirestore.instance
        .collection('shelters')
        .doc(shelter.shelterId.trim())
        .update({"verified": true}).then(
            (value) => log("Shelter Successfully update"),
            onError: (e) => log("Error updating appointment: $e"));
  }
}
