// import 'package:flutter/material.dart';
// import 'package:calm_mind/home.dart';

// class NavDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             child: Text(
//               'Side menu',
//               style: TextStyle(color: Colors.white, fontSize: 25),
//             ),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.input),
//             title: Text('Profile'),
//             onTap: () {
//               // Handle the 'Profile' navigation
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.input),
//             title: Text('Filter'),
//             onTap: () {
//               // Handle the 'Filter' navigation
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.input),
//             title: Text('Rooms'),
//               onTap: () {
//               // Create an instance of _BottomNavigationBarExampleState
//               _BottomNavigationBarExampleState bottomNavigationBarExampleState =
//                   _BottomNavigationBarExampleState();

//               // Use Navigator to navigate to the Rooms page
//               Navigator.push(context, MaterialPageRoute(builder: (context) {
//                 return bottomNavigationBarExampleState.buildRoomsPage();
//               }));
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.input),
//             title: Text('Chats'),
//             onTap: () {
//               // Handle the 'Chats' navigation
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.input),
//             title: Text('Treatment Plan'),
//             onTap: () {
//               // Handle the 'Treatment Plan' navigation
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.input),
//             title: Text('Calendar'),
//             onTap: () {
//               // Handle the 'Calendar' navigation
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
