import 'package:geolocator/geolocator.dart';

class Geolocate{

  static final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  static Position currLocation;
  static Map<int, double> distancesM = new Map<int,double>();

  //gets the latitude and longitude from address
  static Future<Position> getLatLong(String address) async {
    List<Placemark> placemark = await Geolocator().placemarkFromAddress(address);
    Position result = placemark[0].position;
    print(result);
    return result;
  }

  //gets the current location of user
    static Future<void> getCurrentLocation() async{
      Position p = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currLocation = p;
    }

    //initializes a map of distances between each address of each post and current location
    static Future<void> getDistance(int id, List<double> src) async{
      double distance = await Geolocator().distanceBetween(src[0],src[1],currLocation.latitude,currLocation.longitude);
      distancesM[id]=distance;
    }


}