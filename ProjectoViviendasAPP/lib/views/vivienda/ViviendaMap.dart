import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:viviendas/widgets/Dragmarker.dart';

class ViviendaMap extends StatefulWidget {
  final latitud;
  final longitud;
  final int ?interaccion;
  final bool dragable;
  final DragMarker ?dragMarker;
  final MapController mapController;
  const ViviendaMap({ this.latitud, this.longitud, this.interaccion, 
    this.dragable = false, this.dragMarker, required this.mapController});

  @override
  State<ViviendaMap> createState() => _ViviendaMapState();
}

class _ViviendaMapState extends State<ViviendaMap> {
  @override
  void  initState(){
    if(widget.dragable){
      widget.dragMarker!.point.latitude = widget.latitud;
      widget.dragMarker!.point.longitude = widget.longitud;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        center: LatLng(widget.latitud, widget.longitud),
        interactiveFlags: widget.interaccion != null 
          ? widget.interaccion!
          : InteractiveFlag.all,
        plugins: widget.dragable ? [
          DragMarkerPlugin(),
        ] : [],
        onTap: widget.dragable 
          ? (pos, point) { 
            setState(() {
              widget.dragMarker!.point = point; 
            });
          } 
          : (pos, point) {},
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
          attributionBuilder: (_) {
            return Text("");
          },
        ),
        widget.dragable 
        ? DragMarkerPluginOptions(
            markers: [
              widget.dragMarker!
            ],
          )
        : MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(widget.latitud, widget.longitud),
                builder: (ctx) => Container(
                  child:
                      Icon(Icons.location_pin, color: Colors.red[900], size: 64.0),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
