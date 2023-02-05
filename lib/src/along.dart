import '../bearing.dart';
import '../destination.dart';
import '../distance.dart' as turf_distance;
import '../helpers.dart';

Point along(LineString lineString, num distance, [Unit unit = Unit.kilometers]) {
  final coords = lineString.coordinates;
  num travelled = 0;
  for (int i = 0; i < coords.length; i++) {
    if (distance >= travelled && i == coords.length - 1) {
      break;
    } else if (travelled >= distance) {
      final overshot = distance - travelled;
      if (overshot == 0) {
        return Point(coordinates: coords[i]);
      } else {
        final direction = bearingRaw(coords[i], coords[i - 1]) - 180;
        final interpolated = destinationRaw(coords[i], overshot, direction, unit);
        return Point(coordinates: interpolated);
      }
    } else {
      travelled += turf_distance.distance(Point(coordinates: coords[i]), Point(coordinates: coords[i + 1]), unit);
    }
  }
  return Point(coordinates: coords[coords.length - 1]);
}
