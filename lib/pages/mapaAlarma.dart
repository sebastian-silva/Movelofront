import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proyecto_final/Control/Singleton.dart';
import 'package:proyecto_final/Control/SingletonAlarma.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class MapaAlarmaPage extends StatefulWidget {
  MapaAlarmaPage({Key key}) : super(key: key);
  @override
  _MapaAlarmaPageState createState() => _MapaAlarmaPageState();
}

class _MapaAlarmaPageState extends State<MapaAlarmaPage> {
  final Set<Marker> _markers = Set();
  GoogleMapController _googleMapController;
  double lat;
  double lon;
  LatLng alarma,policia;

  @override
  void initState() { 
    super.initState();
    SingletonAlarma sa = SingletonAlarma();
    lat=sa.latitud;
    lon=sa.longitud;
    alarma = new LatLng(lat,lon);
    policia = new LatLng(5.026965, -74.002295);
    _markers.add(
      Marker(
        markerId: MarkerId("Alarma"),
        position: LatLng(lat,lon),
        infoWindow: InfoWindow(title: "Alerta"), 
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(13, 34, 71, 1),
        title: Text(
          "Alarmas",
          textAlign: TextAlign.center, 
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: GoogleMap(
              markers: _markers,
              rotateGesturesEnabled: true,
              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(this.lat, this.lon),
                zoom: 18.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = controller;
                String a = '[ { "elementType": "geometry", "stylers": [ { "color": "#1d2c4d" } ] }, { "elementType": "labels.text.fill", "stylers": [ { "color": "#8ec3b9" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "color": "#1a3646" } ] }, { "featureType": "administrative.country", "elementType": "geometry.stroke", "stylers": [ { "color": "#4b6878" } ] }, { "featureType": "administrative.land_parcel", "elementType": "labels", "stylers": [ { "visibility": "off" } ] }, { "featureType": "administrative.land_parcel", "elementType": "labels.text.fill", "stylers": [ { "color": "#64779e" } ] }, { "featureType": "administrative.province", "elementType": "geometry.stroke", "stylers": [ { "color": "#4b6878" } ] }, { "featureType": "landscape.man_made", "elementType": "geometry.stroke", "stylers": [ { "color": "#334e87" } ] }, { "featureType": "landscape.natural", "elementType": "geometry", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#283d6a" } ] }, { "featureType": "poi", "elementType": "labels.text", "stylers": [ { "visibility": "off" } ] }, { "featureType": "poi", "elementType": "labels.text.fill", "stylers": [ { "color": "#6f9ba5" } ] }, { "featureType": "poi", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "poi.business", "stylers": [ { "visibility": "off" } ] }, { "featureType": "poi.park", "elementType": "geometry.fill", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [ { "color": "#3C7680" } ] }, { "featureType": "road", "elementType": "geometry", "stylers": [ { "color": "#304a7d" } ] }, { "featureType": "road", "elementType": "labels.icon", "stylers": [ { "visibility": "off" } ] }, { "featureType": "road", "elementType": "labels.text.fill", "stylers": [ { "color": "#98a5be" } ] }, { "featureType": "road", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "road.highway", "elementType": "geometry", "stylers": [ { "color": "#2c6675" } ] }, { "featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [ { "color": "#255763" } ] }, { "featureType": "road.highway", "elementType": "labels.text.fill", "stylers": [ { "color": "#b0d5ce" } ] }, { "featureType": "road.highway", "elementType": "labels.text.stroke", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "road.local", "elementType": "labels", "stylers": [ { "visibility": "off" } ] }, { "featureType": "transit", "stylers": [ { "visibility": "off" } ] }, { "featureType": "transit", "elementType": "labels.text.fill", "stylers": [ { "color": "#98a5be" } ] }, { "featureType": "transit", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "transit.line", "elementType": "geometry.fill", "stylers": [ { "color": "#283d6a" } ] }, { "featureType": "transit.station", "elementType": "geometry", "stylers": [ { "color": "#3a4762" } ] }, { "featureType": "water", "elementType": "geometry", "stylers": [ { "color": "#0e1626" } ] }, { "featureType": "water", "elementType": "labels.text.fill", "stylers": [ { "color": "#4e6d70" } ] } ]';
                _googleMapController.setMapStyle(a);
                // _centerView();
              },
              zoomControlsEnabled: false,              
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: RaisedButton(
              child: Icon(Icons.check,color: Color.fromRGBO(16,200,112,1),size: 30,),
              shape: CircleBorder(),
              color: Colors.white,
              onPressed: () async{
                Future<void> a = this.peticionAlarmas();
                a.then((value) {
                  Navigator.pop(context);
                });
              },
            ),
          )
        ] 
      ),
    );
  }

  Future<void> peticionAlarmas() async{
    Singleton control = Singleton();
    SingletonAlarma controla = new SingletonAlarma();
    final respon = await http.get('https://radiant-dusk-69671.herokuapp.com/Alarmacheck?key=${ control.key }&id=${ controla.id }');
    if(respon.statusCode==200){
      final body = jsonDecode(respon.body);
      return body;
    }else{
      print('conexion con el server fallida');
      throw Exception('failed to load');
    }
  }
}

//AIzaSyCUaYYHCvRkD5q_AnlnElYt3lZuLTxRsj0