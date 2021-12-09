import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'store.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPagePageState createState() => _MapPagePageState();
}

class _MapPagePageState extends State<MapPage> {

  List<Marker> _markers = [];

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final args = ModalRoute.of(context)!.settings.arguments as Store_id;


    _markers.add(Marker(
        markerId: MarkerId("1"),
        draggable: true,
        onTap: () {
          var  bottomSheetController=scaffoldKey.currentState!.showBottomSheet((context) => Container(
            child: getBottomSheet(args.name, args.review_count, args.address_gu, args.address, args.phone, args.image),
            height: 250,
            color: Colors.transparent,
          ));
        },
        position: LatLng(args.latitude, args.longitude)));

    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(args.latitude, args.longitude),
      zoom: 17.9746,
    );

    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(args.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: Set.from(_markers),
        initialCameraPosition: _kGooglePlex,
        myLocationEnabled :true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Widget getBottomSheet(String name, int review_count, String address_gu, String address, String phone, String image)
  {
    return Stack(
      children: <Widget>[
        Container(

          margin: EdgeInsets.only(top: 32),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Image.network(
                        '$image',
                        width: 80,
                        height: 60,
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('$name',style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                          ),),
                          SizedBox(height: 5,),
                          Row(children: <Widget>[
                            Icon(Icons.reviews,color: Colors.yellow,),
                            SizedBox(width: 10,),
                            Text('$review_count' + ' reviews',style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ))
                          ],),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[SizedBox(width: 20,),Icon(Icons.map,color: Colors.blue,),SizedBox(width: 20,),Text("$address_gu" + " " +"$address")],
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[SizedBox(width: 20,),Icon(Icons.call,color: Colors.blue,),SizedBox(width: 20,),Text("$phone")],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topRight,

            child: FloatingActionButton(
                child: Icon(Icons.exit_to_app),
                onPressed: (){
                  Navigator.pop(context);
                }),
          ),
        )
      ],

    );
  }

}