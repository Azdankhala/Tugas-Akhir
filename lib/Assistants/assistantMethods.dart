import 'package:geolocator/geolocator.dart';
import 'package:rider_app/AllWidgets/configMaps.dart';
import 'package:rider_app/Assistants/requestAssistants.dart';

class AssistantMethod
{
  static Future<String> searchCoordinateAddress(Position position) async
  {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
    
    var response = await RequestAssistant.getRequest(Uri.parse(url));

    if (response != "failed")
    {
      placeAddress = response["results"][0]["formated_address"];
    }

    return placeAddress;
  }
}