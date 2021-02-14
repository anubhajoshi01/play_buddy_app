import 'package:geolocator/geolocator.dart';

class Geolocate{

  static Future<Position> getLatLong(String address) async {
    List<Placemark> placemark = await Geolocator().placemarkFromAddress(address);
    Position result = placemark[0].position;
    print(result);
    return result;
  }

}