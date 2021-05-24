import 'package:flutter/cupertino.dart';
import 'package:rider_app/Models/address.dart';

class AppData extends ChangeNotifier
{
  Address PickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpAddress)
  {
    PickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updatedropOffLocationAddress(Address dropOffAddress)
  {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}