import 'package:flutter/material.dart';
// import 'package:amap_base/amap_base.dart';

class Position extends StatefulWidget {
  @override
  _PositionState createState() => _PositionState();
}

class _PositionState extends State<Position> {
  // AMapController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('高德地图'),
        ),
        body: Text('kk')
        // AMapView(
        //   onAMapViewCreated: (controller) {
        //     _controller = controller;
        //   },
        //   amapOptions: AMapOptions(
        //       compassEnabled: false,
        //       zoomControlsEnabled: true,
        //       logoPosition: LOGO_POSITION_BOTTOM_CENTER,
        //       camera:
        //           CameraPosition(target: LatLng(41.851827, 112.801637), zoom: 4)),
        // ),
        );
  }
}

// class Position extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('高德地图'),),
//       body: AMapView(
//         onAMapViewCreated: (controller){
//           _controller = controller;
//         },
//         amapOptions: AMapOptions(
//           compassEnabled: false,
//           zoomControlsEnabled: true,
//           logoPosition: LOGO_POSITION_BOTTOM_CENTER,
//           camera: CameraPosition(
//             target:LatLng(41.851827, 112.801637),
//             zoom: 4
//           )

//         ),
//       ),
//     );
//   }
// }
