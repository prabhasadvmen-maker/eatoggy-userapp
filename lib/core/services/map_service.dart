// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sizer/sizer.dart';
// import 'package:dio/dio.dart';
// import 'package:geolocator/geolocator.dart';

// class MapService {
//   static const String geoapifyApiKey = "2ecb147800e2472eab47bbfeaf5d010a";

//   /// Main entry point for location fetching with clean UI dialogs for GPS OFF and Permission Denied
//   static Future<Position?> getCurrentLivePosition([BuildContext? context]) async {
//     try {
//       // Step 1: Check Location Services / GPS state
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         if (context != null && context.mounted) {
//           final bool turnOn = await showGpsDisabledDialog(context);
//           if (turnOn) {
//             await Geolocator.openLocationSettings();
//             // Re-check after returning from settings
//             serviceEnabled = await Geolocator.isLocationServiceEnabled();
//           }
//         } else {
//           await Geolocator.openLocationSettings();
//           serviceEnabled = await Geolocator.isLocationServiceEnabled();
//         }

//         if (!serviceEnabled) {
//           return await Geolocator.getLastKnownPosition();
//         }
//       }

//       // Step 2: Check Location Permissions
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied && context != null && context.mounted) {
//           await showPermissionDeniedDialog(context, isPermanentlyDenied: false);
//           return null;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         if (context != null && context.mounted) {
//           final bool openSettings = await showPermissionDeniedDialog(context, isPermanentlyDenied: true);
//           if (openSettings) {
//             await Geolocator.openAppSettings();
//           }
//         }
//         return null;
//       }

//       if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
//         return null;
//       }

//       // Step 3: Fetch current location with timeout and fallback to last known
//       final lastPos = await Geolocator.getLastKnownPosition();
//       try {
//         final pos = await Geolocator.getCurrentPosition(
//           locationSettings: const LocationSettings(
//             accuracy: LocationAccuracy.high,
//             timeLimit: Duration(seconds: 4),
//           ),
//         );
//         if (pos != null) return pos;
//       } catch (_) {}

//       return lastPos;
//     } catch (e) {
//       print("❌ MapService.getCurrentLivePosition Exception: $e");
//       return null;
//     }
//   }

//   /// Clean modern dialog when GPS / Location Services are OFF
//   static Future<bool> showGpsDisabledDialog(BuildContext context) async {
//     return await showDialog<bool>(
//           context: context,
//           barrierDismissible: false,
//           builder: (dialogContext) {
//             return AlertDialog(
//               backgroundColor: const Color(0xFF131A2A),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               title: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF00C88C).withValues(alpha: 0.15),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.location_off_rounded, color: Color(0xFF00C88C), size: 24),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       'Location Required',
//                       style: GoogleFonts.inter(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               content: Text(
//                 'Location is turned off. Please enable location services to continue.',
//                 style: GoogleFonts.inter(
//                   fontSize: 13.sp,
//                   color: Colors.white70,
//                   height: 1.4,
//                 ),
//               ),
//               actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(dialogContext, false),
//                   child: Text(
//                     'Cancel',
//                     style: GoogleFonts.inter(
//                       fontSize: 13.sp,
//                       color: Colors.white54,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => Navigator.pop(dialogContext, true),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF00C88C),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     elevation: 0,
//                   ),
//                   child: Text(
//                     'Turn On Location',
//                     style: GoogleFonts.inter(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ) ??
//         false;
//   }

//   /// Clean modern dialog when Location Permission is denied or permanently denied
//   static Future<bool> showPermissionDeniedDialog(
//     BuildContext context, {
//     required bool isPermanentlyDenied,
//   }) async {
//     return await showDialog<bool>(
//           context: context,
//           barrierDismissible: false,
//           builder: (dialogContext) {
//             return AlertDialog(
//               backgroundColor: const Color(0xFF131A2A),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               title: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.orangeAccent.withValues(alpha: 0.15),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.gavel_rounded, color: Colors.orangeAccent, size: 24),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       'Location Permission Required',
//                       style: GoogleFonts.inter(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               content: Text(
//                 isPermanentlyDenied
//                     ? 'Location permission is permanently denied. Please enable it from App Settings.'
//                     : 'Location access is required to find your current address for service booking.',
//                 style: GoogleFonts.inter(
//                   fontSize: 13.sp,
//                   color: Colors.white70,
//                   height: 1.4,
//                 ),
//               ),
//               actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(dialogContext, false),
//                   child: Text(
//                     'Cancel',
//                     style: GoogleFonts.inter(
//                       fontSize: 13.sp,
//                       color: Colors.white54,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => Navigator.pop(dialogContext, true),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF00C88C),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     elevation: 0,
//                   ),
//                   child: Text(
//                     isPermanentlyDenied ? 'Open Settings' : 'Retry',
//                     style: GoogleFonts.inter(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ) ??
//         false;
//   }

//   /// Reverse geocodes Latitude and Longitude into address components via Geoapify
//   static Future<Map<String, String>?> getReverseGeocodedAddress(double lat, double lng) async {
//     try {
//       final url = "https://api.geoapify.com/v1/geocode/reverse"
//           "?lat=$lat"
//           "&lon=$lng"
//           "&apiKey=$geoapifyApiKey";

//       final response = await _dio.get(url);
//       if (response.statusCode == 200 && response.data != null) {
//         final data = Map<String, dynamic>.from(response.data as Map);
//         final features = data['features'] as List<dynamic>?;
//         if (features != null && features.isNotEmpty) {
//           final props = features.first['properties'] as Map<String, dynamic>?;
//           if (props != null) {
//             final street = props['street']?.toString() ?? props['road']?.toString() ?? '';
//             final area = props['suburb']?.toString() ??
//                 props['neighbourhood']?.toString() ??
//                 props['district']?.toString() ??
//                 props['residential']?.toString() ??
//                 '';
//             final houseNumber = props['housenumber']?.toString() ?? '';

//             final rawAddressLine1 = props['address_line1']?.toString() ?? '';
//             final rawFormatted = props['formatted']?.toString() ?? '';

//             // Construct rich street & area address line
//             List<String> lineParts = [];
//             if (houseNumber.isNotEmpty) lineParts.add(houseNumber);
//             if (street.isNotEmpty) lineParts.add(street);
//             if (area.isNotEmpty && !lineParts.contains(area)) lineParts.add(area);

//             String addressLine = lineParts.isNotEmpty
//                 ? lineParts.join(', ')
//                 : (rawAddressLine1.isNotEmpty ? rawAddressLine1 : rawFormatted);

//             final city = props['city']?.toString() ??
//                 props['county']?.toString() ??
//                 props['state_district']?.toString() ??
//                 '';
//             final state = props['state']?.toString() ?? '';
//             final pincode = props['postcode']?.toString() ??
//                 props['pincode']?.toString() ??
//                 props['postal_code']?.toString() ??
//                 props['zip']?.toString() ??
//                 '';

//             return {
//               'street': street,
//               'area': area,
//               'addressLine': addressLine.isNotEmpty ? addressLine : 'Current Location',
//               'city': city,
//               'state': state,
//               'pincode': pincode,
//             };
//           }
//         }
//       }
//     } catch (e) {
//       print("MapService getReverseGeocodedAddress error: $e");
//     }
//     return null;
//   }

//   /// Returns OpenStreetMap fast tile URL template for flutter_map TileLayer
//   static String get openStreetMapTileUrl =>
//       "https://tile.openstreetmap.org/{z}/{x}/{y}.png";

//   /// Returns CartoDB Voyager tile URL template for flutter_map TileLayer
//   static String get cartoDbTileUrl =>
//       "https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png";

//   /// Returns Geoapify interactive map tile URL template for flutter_map TileLayer
//   static String get geoapifyTileUrl =>
//       "https://maps.geoapify.com/v1/tile/osm-bright/{z}/{x}/{y}.png?apiKey=$geoapifyApiKey";

//   static const double defaultLat = 28.6139;
//   static const double defaultLng = 77.2090;

//   /// Generates a Geoapify Static Map image URL with custom coordinates, zoom level & dark theme style.
//   static String getStaticMapUrl({
//     double lat = defaultLat,
//     double lng = defaultLng,
//     int width = 800,
//     int height = 360,
//     int zoom = 14,
//     String style = 'dark-matter-purple-roads',
//     String markerColor = '%2300c853',
//   }) {
//     return 'https://maps.geoapify.com/v1/staticmap'
//         '?style=$style'
//         '&width=$width'
//         '&height=$height'
//         '&center=lonlat:$lng,$lat'
//         '&zoom=$zoom'
//         '&marker=lonlat:$lng,$lat;color:$markerColor;size:medium'
//         '&apiKey=$geoapifyApiKey';
//   }

//   /// Helper to map city names to coordinates fallback
//   static Map<String, double> getCityCoordinates(String cityName) {
//     switch (cityName.toLowerCase().trim()) {
//       case 'noida':
//         return {'lat': 28.5355, 'lng': 77.3910};
//       case 'delhi':
//       case 'new delhi':
//       case 'delhi ncr':
//         return {'lat': 28.6139, 'lng': 77.2090};
//       case 'gurugram':
//       case 'gurgaon':
//         return {'lat': 28.4595, 'lng': 77.0266};
//       case 'ghaziabad':
//         return {'lat': 28.6692, 'lng': 77.4538};
//       case 'faridabad':
//         return {'lat': 28.4089, 'lng': 77.3178};
//       case 'mumbai':
//         return {'lat': 19.0760, 'lng': 72.8777};
//       case 'bengaluru':
//       case 'bangalore':
//         return {'lat': 12.9716, 'lng': 77.5946};
//       default:
//         return {'lat': defaultLat, 'lng': defaultLng};
//     }
//   }

//   /// Clean isolated Dio client for external Geoapify requests
//   static final Dio _dio = Dio();

//   /// Geocodes any city or locality name into exact Latitude and Longitude coordinates
//   static Future<Map<String, double>?> geocodeCity(String cityName) async {
//     if (cityName.trim().isEmpty) return null;
//     try {
//       final url = "https://api.geoapify.com/v1/geocode/search"
//           "?text=${Uri.encodeComponent(cityName)}"
//           "&limit=1"
//           "&apiKey=$geoapifyApiKey";

//       final response = await _dio.get(url);
//       if (response.statusCode == 200 && response.data != null) {
//         final data = Map<String, dynamic>.from(response.data as Map);
//         final features = data['features'] as List<dynamic>?;
//         if (features != null && features.isNotEmpty) {
//           final props = features.first['properties'] as Map<String, dynamic>?;
//           if (props != null) {
//             final double? lat = (props['lat'] as num?)?.toDouble();
//             final double? lon = (props['lon'] as num?)?.toDouble();
//             if (lat != null && lon != null) {
//               return {'lat': lat, 'lng': lon};
//             }
//           }
//         }
//       }
//     } catch (e) {
//       print("MapService geocodeCity error: $e");
//     }
//     return null;
//   }

//   /// Reverse geocodes Latitude and Longitude into a human-readable City / Area name
//   static Future<String?> reverseGeocodeCity(double lat, double lng) async {
//     try {
//       final url = "https://api.geoapify.com/v1/geocode/reverse"
//           "?lat=$lat"
//           "&lon=$lng"
//           "&apiKey=$geoapifyApiKey";

//       final response = await _dio.get(url);
//       if (response.statusCode == 200 && response.data != null) {
//         final data = Map<String, dynamic>.from(response.data as Map);
//         final features = data['features'] as List<dynamic>?;
//         if (features != null && features.isNotEmpty) {
//           final props = features.first['properties'] as Map<String, dynamic>?;
//           if (props != null) {
//             final String? city = props['city']?.toString() ??
//                 props['county']?.toString() ??
//                 props['state_district']?.toString() ??
//                 props['state']?.toString();
//             return city;
//           }
//         }
//       }
//     } catch (e) {
//       print("MapService reverseGeocodeCity error: $e");
//     }
//     return null;
//   }

//   /// Fetches real nearby places and localities from Geoapify within a specified radius (in km)
//   static Future<List<String>> fetchNearbyLocalities({
//     required double lat,
//     required double lng,
//     required double radiusKm,
//   }) async {
//     final Set<String> uniqueLocalities = {};
//     final int radiusMeters = (radiusKm * 1000).toInt();

//     final placesUrl = "https://api.geoapify.com/v2/places"
//         "?categories=commercial,service,office,building,tourism,catering,leisure,public_transport"
//         "&filter=circle:$lng,$lat,$radiusMeters"
//         "&limit=40"
//         "&apiKey=$geoapifyApiKey";

//     final geocodeUrl = "https://api.geoapify.com/v1/geocode/reverse"
//         "?lat=$lat"
//         "&lon=$lng"
//         "&limit=20"
//         "&apiKey=$geoapifyApiKey";

//     try {
//       final responses = await Future.wait([
//         _dio.get(placesUrl).catchError((_) => Response(requestOptions: RequestOptions(path: ''))),
//         _dio.get(geocodeUrl).catchError((_) => Response(requestOptions: RequestOptions(path: ''))),
//       ]);

//       // Parse Places API Response
//       if (responses[0].statusCode == 200 && responses[0].data != null) {
//         final data = Map<String, dynamic>.from(responses[0].data as Map);
//         final List<dynamic> features = data['features'] as List<dynamic>? ?? [];
//         for (var feature in features) {
//           if (feature is Map) {
//             final props = feature['properties'] as Map<String, dynamic>?;
//             if (props != null) {
//               final String name = props['name']?.toString() ??
//                   props['street']?.toString() ??
//                   props['district']?.toString() ??
//                   props['address_line1']?.toString() ??
//                   '';
//               if (name.isNotEmpty && name.length > 2 && !name.contains('+') && !RegExp(r'^\d+$').hasMatch(name)) {
//                 uniqueLocalities.add(name);
//               }
//             }
//           }
//         }
//       }

//       // Parse Geocode Reverse API Response
//       if (responses[1].statusCode == 200 && responses[1].data != null) {
//         final data = Map<String, dynamic>.from(responses[1].data as Map);
//         final List<dynamic> features = data['features'] as List<dynamic>? ?? [];
//         for (var feature in features) {
//           if (feature is Map) {
//             final props = feature['properties'] as Map<String, dynamic>?;
//             if (props != null) {
//               final String suburb = props['suburb']?.toString() ?? '';
//               final String district = props['district']?.toString() ?? '';
//               final String county = props['county']?.toString() ?? '';
//               final String street = props['street']?.toString() ?? '';

//               if (suburb.isNotEmpty) uniqueLocalities.add(suburb);
//               if (district.isNotEmpty) uniqueLocalities.add(district);
//               if (county.isNotEmpty) uniqueLocalities.add(county);
//               if (street.isNotEmpty) uniqueLocalities.add(street);
//             }
//           }
//         }
//       }
//     } catch (e) {
//       print("MapService fetchNearbyLocalities error: $e");
//     }

//     return uniqueLocalities.toList();
//   }

//   /// Fetches exact road navigation route coordinates between start and destination
//   // static Future<List<LatLng>> fetchRouteCoordinates(LatLng start, LatLng destination) async {
//   //   try {
//   //     final url = "https://router.project-osrm.org/route/v1/driving/"
//   //         "${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}"
//   //         "?overview=full&geometries=geojson";

//   //     final response = await _dio.get(url);
//   //     if (response.statusCode == 200 && response.data != null) {
//   //       final data = Map<String, dynamic>.from(response.data as Map);
//   //       final routes = data['routes'] as List<dynamic>?;
//   //       if (routes != null && routes.isNotEmpty) {
//   //         final geometry = routes.first['geometry'] as Map<String, dynamic>?;
//   //         final coords = geometry?['coordinates'] as List<dynamic>?;
//   //         if (coords != null && coords.isNotEmpty) {
//   //           return coords.map((c) {
//   //             final list = c as List<dynamic>;
//   //             return LatLng((list[1] as num).toDouble(), (list[0] as num).toDouble());
//   //           }).toList();
//   //         }
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print("MapService fetchRouteCoordinates error: $e");
//   //   }
//   //   return [start, destination];
//   // }


// }
