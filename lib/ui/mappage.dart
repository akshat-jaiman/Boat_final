import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  Position position;
  Widget _mapchild;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    _mapchild = Center(
      child: CircularProgressIndicator(
        semanticsLabel: "Loading",
      ),
    );
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      _mapchild = mapWidget();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Map'),
          centerTitle: true,
        ),
        body: _mapchild,
      ),
    );
  }

  Widget mapWidget() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      markers: _defaultMarker(),
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15.0,
      ),
    );
  }

  Set<Marker> _defaultMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('Home'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarker,
      )
    ].toSet();
  }
}
