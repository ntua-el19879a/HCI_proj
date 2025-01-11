import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prioritize_it/widgets/styled_app_bar.dart';

class GoogleMapScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final Function(LatLng)? onLocationSelected;

  const GoogleMapScreen(
      {Key? key, this.initialLocation, this.onLocationSelected})
      : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController _mapController;
  LatLng _currentPosition =
      const LatLng(37.7749, -122.4194); // Default to San Francisco
  LatLng? _selectedLocation;
  bool _locationFetched = false; // Flag to track if location has been fetched

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // Request permissions on initialization
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _getCurrentLocation();
    } else {
      // Handle the case where permission is not granted
      setState(() {
        _locationFetched =
            true; // Still update the flag to avoid infinite loading
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _locationFetched = true; // Update flag after successful fetch
      });
    } catch (e) {
      debugPrint('Error fetching location: $e');
      setState(() {
        _locationFetched = true; // Update flag even if there's an error
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // If the current location has already been fetched, update the camera position
    if (_locationFetched) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 14.0),
      );
    }

    // If an initial location is provided, add a marker and move the camera
    if (widget.initialLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(widget.initialLocation!, 14.0),
      );
      setState(() {
        _selectedLocation = widget.initialLocation;
      });
    }
  }

  void _onTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyledAppBar(
        title: 'Select Location',
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_selectedLocation != null) {
                widget.onLocationSelected?.call(_selectedLocation!);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a location')),
                );
              }
            },
          )
        ],
      ),
      body: _locationFetched
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 14.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: _onTap,
              markers: _selectedLocation != null
                  ? {
                      Marker(
                        markerId: const MarkerId('selected_location'),
                        position: _selectedLocation!,
                      ),
                    }
                  : {},
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
