// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class DirectionsModel {
//   List<GeocodedWaypoints>? geocodedWaypoints;
//   List<Routes>? routes;
//   String? status;
//
//   DirectionsModel({this.geocodedWaypoints, this.routes, this.status});
//
//   DirectionsModel.fromJson(Map<String, dynamic> json) {
//     if (json['geocoded_waypoints'] != null) {
//       geocodedWaypoints = <GeocodedWaypoints>[];
//       json['geocoded_waypoints'].forEach((v) {
//         geocodedWaypoints!.add(new GeocodedWaypoints.fromJson(v));
//       });
//     }
//     if (json['routes'] != null) {
//       routes = <Routes>[];
//       json['routes'].forEach((v) {
//         routes!.add(new Routes.fromJson(v));
//       });
//     }
//     status = json['status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.geocodedWaypoints != null) {
//       data['geocoded_waypoints'] =
//           this.geocodedWaypoints!.map((v) => v.toJson()).toList();
//     }
//     if (this.routes != null) {
//       data['routes'] = this.routes!.map((v) => v.toJson()).toList();
//     }
//     data['status'] = this.status;
//     return data;
//   }
// }
//
// class GeocodedWaypoints {
//   String? geocoderStatus;
//   String? placeId;
//   List<String>? types;
//
//   GeocodedWaypoints({this.geocoderStatus, this.placeId, this.types});
//
//   GeocodedWaypoints.fromJson(Map<String, dynamic> json) {
//     geocoderStatus = json['geocoder_status'];
//     placeId = json['place_id'];
//     types = json['types'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['geocoder_status'] = this.geocoderStatus;
//     data['place_id'] = this.placeId;
//     data['types'] = this.types;
//     return data;
//   }
// }
//
// class Routes {
//   Bounds? bounds;
//   String? copyrights;
//   List<Legs>? legs;
//   Polyline? overviewPolyline;
//   String? summary;
//   List<String>? warnings;
//   List<Null>? waypointOrder;
//
//   Routes(
//       {this.bounds,
//       this.copyrights,
//       this.legs,
//       this.overviewPolyline,
//       this.summary,
//       this.warnings,
//       this.waypointOrder});
//
//   Routes.fromJson(Map<String, dynamic> json) {
//     bounds =
//         json['bounds'] != null ? new Bounds.fromJson(json['bounds']) : null;
//     copyrights = json['copyrights'];
//     if (json['legs'] != null) {
//       legs = <Legs>[];
//       json['legs'].forEach((v) {
//         legs!.add(new Legs.fromJson(v));
//       });
//     }
//     overviewPolyline = json['overview_polyline'] != null
//         ? new Polyline.fromJson(json['overview_polyline'])
//         : null;
//     summary = json['summary'];
//     warnings = json['warnings'].cast<String>();
//     if (json['waypoint_order'] != null) {
//       waypointOrder = <Null>[];
//       json['waypoint_order'].forEach((v) {
//         waypointOrder!.add(new Null.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.bounds != null) {
//       data['bounds'] = this.bounds!.toJson();
//     }
//     data['copyrights'] = this.copyrights;
//     if (this.legs != null) {
//       data['legs'] = this.legs!.map((v) => v.toJson()).toList();
//     }
//     if (this.overviewPolyline != null) {
//       data['overview_polyline'] = this.overviewPolyline!.toJson();
//     }
//     data['summary'] = this.summary;
//     data['warnings'] = this.warnings;
//     if (this.waypointOrder != null) {
//       data['waypoint_order'] =
//           this.waypointOrder!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Bounds {
//   Northeast? northeast;
//   Northeast? southwest;
//
//   Bounds({this.northeast, this.southwest});
//
//   Bounds.fromJson(Map<String, dynamic> json) {
//     northeast = json['northeast'] != null
//         ? new Northeast.fromJson(json['northeast'])
//         : null;
//     southwest = json['southwest'] != null
//         ? new Northeast.fromJson(json['southwest'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.northeast != null) {
//       data['northeast'] = this.northeast!.toJson();
//     }
//     if (this.southwest != null) {
//       data['southwest'] = this.southwest!.toJson();
//     }
//     return data;
//   }
// }
//
// class Northeast {
//   double? lat;
//   double? lng;
//
//   Northeast({this.lat, this.lng});
//
//   Northeast.fromJson(Map<String, dynamic> json) {
//     lat = json['lat'];
//     lng = json['lng'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['lat'] = this.lat;
//     data['lng'] = this.lng;
//     return data;
//   }
// }
//
// class Legs {
//   ArrivalTime? arrivalTime;
//   ArrivalTime? departureTime;
//   Distance? distance;
//   Distance? duration;
//   String? endAddress;
//   Northeast? endLocation;
//   String? startAddress;
//   Northeast? startLocation;
//   List<Steps>? steps;
//   List<Null>? trafficSpeedEntry;
//   List<Null>? viaWaypoint;
//
//   Legs(
//       {this.arrivalTime,
//       this.departureTime,
//       this.distance,
//       this.duration,
//       this.endAddress,
//       this.endLocation,
//       this.startAddress,
//       this.startLocation,
//       this.steps,
//       this.trafficSpeedEntry,
//       this.viaWaypoint});
//
//   Legs.fromJson(Map<String, dynamic> json) {
//     arrivalTime = json['arrival_time'] != null
//         ? new ArrivalTime.fromJson(json['arrival_time'])
//         : null;
//     departureTime = json['departure_time'] != null
//         ? new ArrivalTime.fromJson(json['departure_time'])
//         : null;
//     distance = json['distance'] != null
//         ? new Distance.fromJson(json['distance'])
//         : null;
//     duration = json['duration'] != null
//         ? new Distance.fromJson(json['duration'])
//         : null;
//     endAddress = json['end_address'];
//     endLocation = json['end_location'] != null
//         ? new Northeast.fromJson(json['end_location'])
//         : null;
//     startAddress = json['start_address'];
//     startLocation = json['start_location'] != null
//         ? new Northeast.fromJson(json['start_location'])
//         : null;
//     if (json['steps'] != null) {
//       steps = <Steps>[];
//       json['steps'].forEach((v) {
//         steps!.add(new Steps.fromJson(v));
//       });
//     }
//     if (json['traffic_speed_entry'] != null) {
//       trafficSpeedEntry = <Null>[];
//       json['traffic_speed_entry'].forEach((v) {
//         trafficSpeedEntry!.add(new Null.fromJson(v));
//       });
//     }
//     if (json['via_waypoint'] != null) {
//       viaWaypoint = <Null>[];
//       json['via_waypoint'].forEach((v) {
//         viaWaypoint!.add(new Null.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.arrivalTime != null) {
//       data['arrival_time'] = this.arrivalTime!.toJson();
//     }
//     if (this.departureTime != null) {
//       data['departure_time'] = this.departureTime!.toJson();
//     }
//     if (this.distance != null) {
//       data['distance'] = this.distance!.toJson();
//     }
//     if (this.duration != null) {
//       data['duration'] = this.duration!.toJson();
//     }
//     data['end_address'] = this.endAddress;
//     if (this.endLocation != null) {
//       data['end_location'] = this.endLocation!.toJson();
//     }
//     data['start_address'] = this.startAddress;
//     if (this.startLocation != null) {
//       data['start_location'] = this.startLocation!.toJson();
//     }
//     if (this.steps != null) {
//       data['steps'] = this.steps!.map((v) => v.toJson()).toList();
//     }
//     if (this.trafficSpeedEntry != null) {
//       data['traffic_speed_entry'] =
//           this.trafficSpeedEntry!.map((v) => v.toJson()).toList();
//     }
//     if (this.viaWaypoint != null) {
//       data['via_waypoint'] = this.viaWaypoint!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ArrivalTime {
//   String? text;
//   String? timeZone;
//   int? value;
//
//   ArrivalTime({this.text, this.timeZone, this.value});
//
//   ArrivalTime.fromJson(Map<String, dynamic> json) {
//     text = json['text'];
//     timeZone = json['time_zone'];
//     value = json['value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['text'] = this.text;
//     data['time_zone'] = this.timeZone;
//     data['value'] = this.value;
//     return data;
//   }
// }
//
// class Distance {
//   String? text;
//   int? value;
//
//   Distance({this.text, this.value});
//
//   Distance.fromJson(Map<String, dynamic> json) {
//     text = json['text'];
//     value = json['value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['text'] = this.text;
//     data['value'] = this.value;
//     return data;
//   }
// }
//
// class Steps {
//   Distance? distance;
//   Distance? duration;
//   Northeast? endLocation;
//   String? htmlInstructions;
//   Polyline? polyline;
//   Northeast? startLocation;
//   List<Steps>? steps;
//   String? travelMode;
//   TransitDetails? transitDetails;
//
//   Steps(
//       {this.distance,
//       this.duration,
//       this.endLocation,
//       this.htmlInstructions,
//       this.polyline,
//       this.startLocation,
//       this.steps,
//       this.travelMode,
//       this.transitDetails});
//
//   Steps.fromJson(Map<String, dynamic> json) {
//     distance = json['distance'] != null
//         ? new Distance.fromJson(json['distance'])
//         : null;
//     duration = json['duration'] != null
//         ? new Distance.fromJson(json['duration'])
//         : null;
//     endLocation = json['end_location'] != null
//         ? new Northeast.fromJson(json['end_location'])
//         : null;
//     htmlInstructions = json['html_instructions'];
//     polyline = json['polyline'] != null
//         ? new Polyline.fromJson(json['polyline'])
//         : null;
//     startLocation = json['start_location'] != null
//         ? new Northeast.fromJson(json['start_location'])
//         : null;
//     if (json['steps'] != null) {
//       steps = <Steps>[];
//       json['steps'].forEach((v) {
//         steps!.add(new Steps.fromJson(v));
//       });
//     // }
//     travelMode = json['travel_mode'];
//     transitDetails = json['transit_details'] != null
//         ? new TransitDetails.fromJson(json['transit_details'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.distance != null) {
//       data['distance'] = this.distance!.toJson();
//     }
//     if (this.duration != null) {
//       data['duration'] = this.duration!.toJson();
//     }
//     if (this.endLocation != null) {
//       data['end_location'] = this.endLocation!.toJson();
//     }
//     data['html_instructions'] = this.htmlInstructions;
//     if (this.polyline != null) {
//       data['polyline'] = this.polyline!.toJson();
//     }
//     if (this.startLocation != null) {
//       data['start_location'] = this.startLocation!.toJson();
//     }
//     if (this.steps != null) {
//       data['steps'] = this.steps!.map((v) => v.toJson()).toList();
//     }
//     data['travel_mode'] = this.travelMode;
//     if (this.transitDetails != null) {
//       data['transit_details'] = this.transitDetails!.toJson();
//     }
//     return data;
//   }
// }
//
// class Polyline {
//   String? points;
//
//   Polyline({this.points});
//
//   Polyline.fromJson(Map<String, dynamic> json) {
//     points = json['points'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['points'] = this.points;
//     return data;
//   }
// }
//
// class Steps {
//   Distance? distance;
//   Distance? duration;
//   Northeast? endLocation;
//   String? htmlInstructions;
//   Polyline? polyline;
//   Northeast? startLocation;
//   String? travelMode;
//   String? maneuver;
//
//   Steps(
//       {this.distance,
//       this.duration,
//       this.endLocation,
//       this.htmlInstructions,
//       this.polyline,
//       this.startLocation,
//       this.travelMode,
//       this.maneuver});
//
//   Steps.fromJson(Map<String, dynamic> json) {
//     distance = json['distance'] != null
//         ? new Distance.fromJson(json['distance'])
//         : null;
//     duration = json['duration'] != null
//         ? new Distance.fromJson(json['duration'])
//         : null;
//     endLocation = json['end_location'] != null
//         ? new Northeast.fromJson(json['end_location'])
//         : null;
//     htmlInstructions = json['html_instructions'];
//     polyline = json['polyline'] != null
//         ? new Polyline.fromJson(json['polyline'])
//         : null;
//     startLocation = json['start_location'] != null
//         ? new Northeast.fromJson(json['start_location'])
//         : null;
//     travelMode = json['travel_mode'];
//     maneuver = json['maneuver'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.distance != null) {
//       data['distance'] = this.distance!.toJson();
//     }
//     if (this.duration != null) {
//       data['duration'] = this.duration!.toJson();
//     }
//     if (this.endLocation != null) {
//       data['end_location'] = this.endLocation!.toJson();
//     }
//     data['html_instructions'] = this.htmlInstructions;
//     if (this.polyline != null) {
//       data['polyline'] = this.polyline!.toJson();
//     }
//     if (this.startLocation != null) {
//       data['start_location'] = this.startLocation!.toJson();
//     }
//     data['travel_mode'] = this.travelMode;
//     data['maneuver'] = this.maneuver;
//     return data;
//   }
// }
//
// class TransitDetails {
//   ArrivalStop? arrivalStop;
//   ArrivalTime? arrivalTime;
//   ArrivalStop? departureStop;
//   ArrivalTime? departureTime;
//   String? headsign;
//   Line? line;
//   int? numStops;
//
//   TransitDetails(
//       {this.arrivalStop,
//       this.arrivalTime,
//       this.departureStop,
//       this.departureTime,
//       this.headsign,
//       this.line,
//       this.numStops});
//
//   TransitDetails.fromJson(Map<String, dynamic> json) {
//     arrivalStop = json['arrival_stop'] != null
//         ? new ArrivalStop.fromJson(json['arrival_stop'])
//         : null;
//     arrivalTime = json['arrival_time'] != null
//         ? new ArrivalTime.fromJson(json['arrival_time'])
//         : null;
//     departureStop = json['departure_stop'] != null
//         ? new ArrivalStop.fromJson(json['departure_stop'])
//         : null;
//     departureTime = json['departure_time'] != null
//         ? new ArrivalTime.fromJson(json['departure_time'])
//         : null;
//     headsign = json['headsign'];
//     line = json['line'] != null ? new Line.fromJson(json['line']) : null;
//     numStops = json['num_stops'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.arrivalStop != null) {
//       data['arrival_stop'] = this.arrivalStop!.toJson();
//     }
//     if (this.arrivalTime != null) {
//       data['arrival_time'] = this.arrivalTime!.toJson();
//     }
//     if (this.departureStop != null) {
//       data['departure_stop'] = this.departureStop!.toJson();
//     }
//     if (this.departureTime != null) {
//       data['departure_time'] = this.departureTime!.toJson();
//     }
//     data['headsign'] = this.headsign;
//     if (this.line != null) {
//       data['line'] = this.line!.toJson();
//     }
//     data['num_stops'] = this.numStops;
//     return data;
//   }
// }
//
// class ArrivalStop {
//   Northeast? location;
//   String? name;
//
//   ArrivalStop({this.location, this.name});
//
//   ArrivalStop.fromJson(Map<String, dynamic> json) {
//     location = json['location'] != null
//         ? new Northeast.fromJson(json['location'])
//         : null;
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.location != null) {
//       data['location'] = this.location!.toJson();
//     }
//     data['name'] = this.name;
//     return data;
//   }
// }
//
// class Line {
//   List<Agencies>? agencies;
//   String? color;
//   String? name;
//   String? shortName;
//   String? textColor;
//   Vehicle? vehicle;
//
//   Line(
//       {this.agencies,
//       this.color,
//       this.name,
//       this.shortName,
//       this.textColor,
//       this.vehicle});
//
//   Line.fromJson(Map<String, dynamic> json) {
//     if (json['agencies'] != null) {
//       agencies = <Agencies>[];
//       json['agencies'].forEach((v) {
//         agencies!.add(new Agencies.fromJson(v));
//       });
//     }
//     color = json['color'];
//     name = json['name'];
//     shortName = json['short_name'];
//     textColor = json['text_color'];
//     vehicle =
//         json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.agencies != null) {
//       data['agencies'] = this.agencies!.map((v) => v.toJson()).toList();
//     }
//     data['color'] = this.color;
//     data['name'] = this.name;
//     data['short_name'] = this.shortName;
//     data['text_color'] = this.textColor;
//     if (this.vehicle != null) {
//       data['vehicle'] = this.vehicle!.toJson();
//     }
//     return data;
//   }
// }
//
// class Agencies {
//   String? name;
//   String? phone;
//   String? url;
//
//   Agencies({this.name, this.phone, this.url});
//
//   Agencies.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     phone = json['phone'];
//     url = json['url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['phone'] = this.phone;
//     data['url'] = this.url;
//     return data;
//   }
// }
//
// class Vehicle {
//   String? icon;
//   String? name;
//   String? type;
//
//   Vehicle({this.icon, this.name, this.type});
//
//   Vehicle.fromJson(Map<String, dynamic> json) {
//     icon = json['icon'];
//     name = json['name'];
//     type = json['type'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['icon'] = this.icon;
//     data['name'] = this.name;
//     data['type'] = this.type;
//     return data;
//   }
// }
