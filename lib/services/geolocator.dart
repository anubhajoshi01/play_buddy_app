import 'package:geolocator/geolocator.dart';

class Geolocate{

  static final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  static Position currLocation;

  static Future<Position> getLatLong(String address) async {
    List<Placemark> placemark = await Geolocator().placemarkFromAddress(address);
    Position result = placemark[0].position;
    print(result);
    return result;
  }

    static Future<void> getCurrentLocation() async{
      Position p = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currLocation = p;
    }

}