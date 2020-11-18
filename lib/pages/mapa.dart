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
import 'package:http/http.dart' as http;

class MapaPage extends StatefulWidget {
  MapaPage({Key key}) : super(key: key);
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  bool start=false;
  StreamSubscription _ss;
  Location _tracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _googleMapController;
  var lon,lat;
  ProgressDialog pr;
  
  //polyline
  List<LatLng> points;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  List<LatLng> latlngSegment1 = List();
  List<LatLng> latlngSegment2 = List();
  static LatLng _lat1 = LatLng(5.0227212,-73.9828338);
  
  LatLng current;

  CameraPosition initialLocation;
  Future _getInitialLocation() async {
    Future<LocationData> location =  _tracker.getLocation();
    location.then((value) {
      setState(() {
        lon=value.longitude;
        lat=value.latitude;
      });
    });
  }

  Future<Uint8List> getMarkerCar() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/bike.png");
    return byteData.buffer.asUint8List();
  }

  void getCurrentLocationCar() async {
    try {
      Uint8List imageData = await getMarkerCar();
      var location = await _tracker.getLocation();
      updateMarker(location, imageData);
      if (_ss != null) {
        _ss.cancel();
      }
      _ss = _tracker.onLocationChanged.listen((newLocalData) {
        this.current= LatLng(newLocalData.latitude, newLocalData.longitude);
        if (_googleMapController != null) {
          _googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
                bearing: 100,
                target: LatLng(newLocalData.latitude, newLocalData.longitude),
                tilt: 0,
                zoom: 19.00
                ))
              );
          updateMarker(newLocalData, imageData);
        }
      });
      
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void updateMarker(LocationData newLocalData, Uint8List imageData) {
    print("Latitud: ${ newLocalData.latitude }, Longitud: ${newLocalData.longitude}");
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      latlngSegment1.add(latlng);
      marker = Marker(
          markerId: MarkerId("marcador"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(.5, .5),
          icon: BitmapDescriptor.fromBytes(imageData)
      );
      circle = Circle(
          circleId: CircleId("carro"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          strokeWidth: 2,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  @override
  void initState() { 
    super.initState();
    _getInitialLocation();
  }

  @override
  void dispose() { 
    _googleMapController.dispose();
    if (_ss != null) {
      _ss.cancel();
    }
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(   
      textAlign: TextAlign.center,
      messageTextStyle: TextStyle(
        color: Color.fromRGBO(16,200,112,1),
      ),
      message: 'Cargando...',
      progressWidgetAlignment: Alignment.center,
      borderRadius: 10.0,
      backgroundColor: Color.fromRGBO(13, 34, 71, 1),  
      progressWidget: CircularProgressIndicator(
        backgroundColor: Color.fromRGBO(16,200,112,1),
        strokeWidth: 1,
      ),
      progress: 0.0,
      maxProgress: 1000.0,
    );

    return Stack(
      children: <Widget>[
        Container(
          child: this.lat==null ? Container(): GoogleMap(
            rotateGesturesEnabled: false,
            zoomGesturesEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, lon),
              zoom: 18.0,
            ),
            polylines: _polyline,
            markers: Set.of((marker != null) ? [marker] : []),
            circles: Set.of((circle != null) ? [circle] : []),
            onMapCreated: (GoogleMapController controller) {
              _googleMapController = controller;
              String a = '[ { "elementType": "geometry", "stylers": [ { "color": "#1d2c4d" } ] }, { "elementType": "labels.text.fill", "stylers": [ { "color": "#8ec3b9" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "color": "#1a3646" } ] }, { "featureType": "administrative.country", "elementType": "geometry.stroke", "stylers": [ { "color": "#4b6878" } ] }, { "featureType": "administrative.land_parcel", "elementType": "labels", "stylers": [ { "visibility": "off" } ] }, { "featureType": "administrative.land_parcel", "elementType": "labels.text.fill", "stylers": [ { "color": "#64779e" } ] }, { "featureType": "administrative.province", "elementType": "geometry.stroke", "stylers": [ { "color": "#4b6878" } ] }, { "featureType": "landscape.man_made", "elementType": "geometry.stroke", "stylers": [ { "color": "#334e87" } ] }, { "featureType": "landscape.natural", "elementType": "geometry", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#283d6a" } ] }, { "featureType": "poi", "elementType": "labels.text", "stylers": [ { "visibility": "off" } ] }, { "featureType": "poi", "elementType": "labels.text.fill", "stylers": [ { "color": "#6f9ba5" } ] }, { "featureType": "poi", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "poi.business", "stylers": [ { "visibility": "off" } ] }, { "featureType": "poi.park", "elementType": "geometry.fill", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [ { "color": "#3C7680" } ] }, { "featureType": "road", "elementType": "geometry", "stylers": [ { "color": "#304a7d" } ] }, { "featureType": "road", "elementType": "labels.icon", "stylers": [ { "visibility": "off" } ] }, { "featureType": "road", "elementType": "labels.text.fill", "stylers": [ { "color": "#98a5be" } ] }, { "featureType": "road", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "road.highway", "elementType": "geometry", "stylers": [ { "color": "#2c6675" } ] }, { "featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [ { "color": "#255763" } ] }, { "featureType": "road.highway", "elementType": "labels.text.fill", "stylers": [ { "color": "#b0d5ce" } ] }, { "featureType": "road.highway", "elementType": "labels.text.stroke", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "road.local", "elementType": "labels", "stylers": [ { "visibility": "off" } ] }, { "featureType": "transit", "stylers": [ { "visibility": "off" } ] }, { "featureType": "transit", "elementType": "labels.text.fill", "stylers": [ { "color": "#98a5be" } ] }, { "featureType": "transit", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "transit.line", "elementType": "geometry.fill", "stylers": [ { "color": "#283d6a" } ] }, { "featureType": "transit.station", "elementType": "geometry", "stylers": [ { "color": "#3a4762" } ] }, { "featureType": "water", "elementType": "geometry", "stylers": [ { "color": "#0e1626" } ] }, { "featureType": "water", "elementType": "labels.text.fill", "stylers": [ { "color": "#4e6d70" } ] } ]';
              _googleMapController.setMapStyle(a);
              setState(() {
                _polyline.add(Polyline(
                  polylineId: PolylineId('line1'),
                  visible: true,
                  //latlng is List<LatLng>
                  points: latlngSegment1,
                  width: 4,
                  color: Color.fromRGBO(16,200,112,1),
                ));
              });
            },
            zoomControlsEnabled: false,
          ),
        ),
          Visibility(
            visible: true,
            child: Container(
              margin: EdgeInsets.only(top: 80, right: 10),
              alignment: Alignment.bottomRight,
              color: Color.fromRGBO(13, 34, 71, .5),
              height: 190,
              width: 70,
              child: Column(
                children: <Widget>[
                  SizedBox(width: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 15,bottom: 0,left: 15,right: 15),
                    child: FloatingActionButton(
                        child: Icon(Icons.play_arrow,color: start==false ? Color.fromRGBO(13, 34, 71, 1) : Color.fromRGBO(16,200,112,1),size: 30,),
                        elevation: 5,
                        backgroundColor: Color.fromRGBO(255, 255, 255, .8),
                        onPressed: () {
                          setState(() {
                            if(this.start==false){
                              this.start=true;
                              getCurrentLocationCar();
                            }else{
                              this.start=false;
                              _ss.cancel();
                            }
                          });
                        }),
                  ),
                  SizedBox(width: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                    child: FloatingActionButton(
                        child: Icon(Icons.local_hospital,color: Color.fromRGBO(250,0,43,1),size: 30,),
                        elevation: 5,
                        backgroundColor: Color.fromRGBO(255, 255, 255, .8),
                        onPressed: () async {
                          pr.show();
                          Future<void> actual = alarmaSeguridad();
                          actual.then((a) {
                            pr.hide();
                            _alertaVerde(context);
                            print("alarma lista");
                          });
                        },
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                    child: FloatingActionButton(
                        child: Icon(Icons.local_police,color: Color.fromRGBO(43,132,10,1),size: 30,),
                        elevation: 5,
                        backgroundColor: Color.fromRGBO(255, 255, 255, .8),
                        onPressed: () async {
                          pr.show();
                          Future<void> actual = alarmaPolicia();
                          actual.then((a) {
                            pr.hide();
                            _alertaRoja(context);
                            print("alarma lista");
                          });
                        },
                    ),
                  ),
                ],
              ),
            ),
          )
      ] 
    );
  }

  Future<void> alarmaSeguridad() async{
    Singleton control = Singleton();
    final respon = await http.get('https://radiant-dusk-69671.herokuapp.com/Alarma?key=${ control.key }&latitud=${ this.current.latitude }&longitud=${ this.current.longitude }&tipo=hospital&correo=${control.correoll}');
    if(respon.statusCode==200){
      final body = jsonDecode(respon.body);
      print(body['Tipo']);
      print(body['Mensaje']);
    }else{
      print('conexion con el server fallida');
      throw Exception('failed to load');
    }
  }

  Future<void> alarmaPolicia() async{
    Singleton control = Singleton();
    final respon = await http.get('https://radiant-dusk-69671.herokuapp.com/Alarma?key=${ control.key }&latitud=${ this.current.latitude }&longitud=${ this.current.longitude }&tipo=policia&correo=${control.correoll}');
    if(respon.statusCode==200){
      final body = jsonDecode(respon.body);
      print(body['Tipo']);
      print(body['Mensaje']);
    }else{
      print('conexion con el server fallida');
      throw Exception('failed to load');
    }
  }

  void _alertaVerde(BuildContext context) {
    showDialog(
      // barrierColor: Colors.black,
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(13, 34, 71, 1),
          title: Text(
            "Alerta enviada con exito",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(16,200,112,1),
            ),
          ),
          content: Text(
            "La asistencia medica se encuentra en camino a tu ubicacion actual.",
            style: TextStyle(
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
          
          actions: [
            FlatButton(
              // color: Color.fromRGBO(13, 34, 71, 1),
              onPressed: (){
                 Navigator.of(context).pop(); 
              }, 
              child: Text(
                "Volver",
                style: TextStyle(
                  color:  Color.fromRGBO(16,200,112,1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _alertaRoja(BuildContext context) {
    showDialog(
      // barrierColor: Colors.black,
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(13, 34, 71, 1),
          title: Text(
            "Alerta enviada con exito",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(16,200,112,1),
            ),
          ),
          content: Text(
            "La asistencia policial se encuentra en camino a tu ubicacion actual.",
            style: TextStyle(
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
          
          actions: [
            FlatButton(
              // color: Color.fromRGBO(13, 34, 71, 1),
              onPressed: (){
                 Navigator.of(context).pop(); 
              }, 
              child: Text(
                "Volver",
                style: TextStyle(
                  color:  Color.fromRGBO(16,200,112,1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

//AIzaSyCUaYYHCvRkD5q_AnlnElYt3lZuLTxRsj0