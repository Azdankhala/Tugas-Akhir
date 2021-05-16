import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_app/AllWidgets/Divider.dart';
import 'package:rider_app/Assistants/assistantMethods.dart';



class MainScreen extends StatefulWidget
{
  static const String idScreen = "mainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
{
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latlatposition = LatLng(position.latitude, position.longitude);
    
    CameraPosition cameraPosition = new CameraPosition(target: latlatposition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String addres = await AssistantMethod.searchCoordinateAddress(position);
    print("This is your current location :: " + addres);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
           children: [
             //drawer header
             Container(
               height: 165.0,
                 child: DrawerHeader(
                   decoration: BoxDecoration(color: Colors.white),
                   child: Row(
                     children: [
                       Image.asset("images/user_icon.png", height: 65.0, width: 65.0,),
                       SizedBox(width: 16.0,),
                       Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text("Profile Name", style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold"),),
                           SizedBox(height: 6.0,),
                           Text("Visit Profile"),
                         ],
                       )
                     ],
                   ),
                 ),
             ),

             DividerWidget(),

             SizedBox(height: 12.0,),

             //Drawer Body
             ListTile(
               leading: Icon(Icons.history),
               title: Text("History", style: TextStyle(fontSize: 15.0),),
             ),
             ListTile(
               leading: Icon(Icons.person),
               title: Text("Visit Profile", style: TextStyle(fontSize: 15.0),),
             ),
             ListTile(
               leading: Icon(Icons.info),
               title: Text("About", style: TextStyle(fontSize: 15.0),),
             ),

           ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 300.0;
              });

              locatePosition();
            },
          ),

          //hamburger button
          Positioned(
            top: 45.0,
            left: 22.0,
            child: GestureDetector(
              onTap: ()
              {
                scaffoldkey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu, color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                )
              ]
            ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.0),
                    Text("Hi There, ", style: TextStyle(fontSize: 10.0),),
                    Text("Where to?, ", style: TextStyle(fontSize: 20.0, fontFamily: "Brand-Bold"),),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.qr_code_scanner, color: Colors.blueAccent,),
                            SizedBox(width: 10.0,),
                            Text("Scan Barcode")
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 15.0),

                    DividerWidget(),

                    SizedBox(height: 16.0),

                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.grey,),
                        SizedBox(width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Current Location"),
                            SizedBox(height: 4.0,),
                            Text("Your Current Location", style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],

      ),
    );
  }
}
