import 'dart:async';
import 'dart:collection';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:location/location.dart';
import 'package:youplay/models/game.dart';
import 'package:youplay/models/general_item.dart';
import 'package:youplay/screens/game/game_screens_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:youplay/screens/ui_models/message_view_model.dart';
import 'package:youplay/screens/util/location/context2.dart';
import 'package:youplay/store/state/app_state.dart';

class MessagesMapView extends StatefulWidget {
  MessagesMapView({game : Game}) :
  _kInitialPosition = CameraPosition(
  target: (game == null || game.lat == null) ? LatLng(50.886959, 5.973426) :LatLng(game.lat, game.lng),
  zoom: 14.0,
  );


   CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(50.886959, 5.973426),
    zoom: 14.0,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  _MessagesMapViewState createState() => _MessagesMapViewState();
}

class _MessagesMapViewState extends State<MessagesMapView> {
  StreamSubscription<LocationData> _locationChangedSubscription;

  Completer<GoogleMapController> _controller = Completer();

  LocationData _locationData;

  @override
  void initState() {
    super.initState();
    // initLoc();
  }

  void initLoc(GoogleMapController controller) async {
    bool _serviceEnabled;
    Location location = new Location();
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    LocationData locationData = await location.getLocation();
    if (locationData != null) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(locationData.latitude, locationData.longitude), 17));
    }

  }

  @override
  Widget build(BuildContext context) {
    // LocationData data = LocationContext.of(context).lastLocation;
    // print("data is ${data.latitude}");
    return new StoreConnector<AppState, MessageViewModel>(
        converter: (store) => MessageViewModel.fromStore(store),
        builder: (context, MessageViewModel messageViewModel) {
          List<Marker> markers = [];
          for (int i = 0; i < messageViewModel.mapItems.length; i++) {
            if (messageViewModel.mapItems[i].generalItem.lat != null) {
              markers.add(buildMarker(messageViewModel.mapItems[i].generalItem, () {
                messageViewModel.giItemTapAction(
                    messageViewModel.mapItems[i].generalItem, context)();
              }));
            }
          }
          Set<Marker> _markers = Set<Marker>.of(markers);
          return GoogleMap(
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            ].toSet(),
            mapType: MapType.normal,
            markers: _markers,
            initialCameraPosition: widget._kInitialPosition,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              initLoc(controller);
            },
          );
        });
  }

  Marker buildMarker(GeneralItem generalItem, Function onTap) {
    return Marker(
      markerId: MarkerId("${generalItem.itemId}"),
      position: LatLng(generalItem.lat, generalItem.lng),
      infoWindow: InfoWindow(
          title: "${generalItem.title}",
//              snippet: '*',
          onTap: () {
            print("tap ${generalItem.title}");
            if (generalItem != null) {
              print("tap ${generalItem.title}");
              onTap();
            }
            ;
          }),
      onTap: () {},
    );
  }
}
