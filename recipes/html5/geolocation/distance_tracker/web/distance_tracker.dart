import 'dart:html';
import 'dart:math';

// This uses the Haversine formula for calculating the distance between 
// 2 points on the globe (http://en.wikipedia.org/wiki/Haversine_formula)
num _calculateDistance(lat1, long1, lat2, long2) {
  const num EARTH_RADIUS = 6371; // in km
  const num MILES_PER_KM = .6;
  var LatDiff = _toRad((lat2-lat1));
  var LongDiff = _toRad((long2-long1));
  var a = pow(sin(LatDiff/2), 2) +
          cos(_toRad(lat1)) * cos(_toRad(lat2)) *
          pow(sin(LongDiff/2), 2);
  var c = 2 * atan2(sqrt(a), sqrt(1-a));
  var distance = EARTH_RADIUS * c;
  return distance * MILES_PER_KM;
}

num _toRad(num x) => x * PI / 180;

String _getTime(timestamp) {
  Date date = new Date.fromMillisecondsSinceEpoch(timestamp);
  return date.toString().split(" ").last.split(".")[0];
}

String _displayData(String subject, Geoposition position) {
  return """<td><b>$subject</b></td>
  <td>${position.coords.latitude}&deg;</td>
  <td>${position.coords.longitude}&deg;</td>
  <td>${_getTime(position.timestamp)}</td>
  <td class=${position.coords.accuracy > 100 ? "red" : "green"}>${position.coords.accuracy} feet</td>""";
}

void _displayErrorMessage(String error_message) {
  var error_div = query("#error");
  error_div.text = error_message; 
}

void displayCurrentPositionData(Geoposition position) {
  var elem = new TableRowElement();
  elem.innerHtml = _displayData("Starting", position);
  query("#geo-data").elements.add(elem);
}

void displayWatchPositionData(Geoposition startPosition, Geoposition currentPosition) {
  var elem = new TableRowElement();
  elem.innerHtml = _displayData("Current", currentPosition);
  query("#geo-data").elements.add(elem);
  
  num distance = _calculateDistance(
    startPosition.coords.latitude,
    startPosition.coords.longitude,
    currentPosition.coords.latitude,
    currentPosition.coords.longitude);
  
  query("#distance").text = "${distance.toStringAsFixed(4)} miles";
  query("#duration").text = "${((currentPosition.timestamp - startPosition.timestamp) / 1000).toStringAsFixed(4)} sec";
}

void handleError(PositionError error) {
  var error_div = query("#error");
  switch (error.code) {
    case PositionError.PERMISSION_DENIED:
      _displayErrorMessage("The user did not grant permission to access location data."); break;
    case PositionError.POSITION_UNAVAILABLE:
      _displayErrorMessage("The browser could not determine your location"); break;
    case PositionError.TIMEOUT:
      _displayErrorMessage("The browser timed out before fetching your location"); break;
    default:
      _displayErrorMessage("There was an error in retreiving your location: ${error.message}");
  }
}

void main(){
  
  Geoposition startPosition;
  
  window.navigator.geolocation.getCurrentPosition(
    (Geoposition position) {
      startPosition = position;
      displayCurrentPositionData(position);
    },
    (error) => handleError(error)
  );
 
  window.navigator.geolocation.watchPosition((Geoposition position) {
    displayWatchPositionData(startPosition, position);
    },
    (error) => handleError(error)
  );
}