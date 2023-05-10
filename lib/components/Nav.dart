import 'package:flutter/material.dart';
import 'package:makequiz/screens/generate_notes.dart';
import 'package:makequiz/screens/library.dart';
import '../screens/home.dart';
import '../screens/note_image.dart';
import '../screens/profile.dart';
import '../utils.dart';
import '../screens/note_image.dart';
import '../screens/library.dart';

Widget sidebar(BuildContext context) {
  var h = MediaQuery.of(context).size.height;
  return Drawer(
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Ravnoor Bedi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ],
              ), // fixed parenthesis
            ),
          ),
          ListTile(
            title: const Text('Home'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Library'),
            leading: Icon(Icons.book),
            onTap: () {
              navigate(context, Library());
            },
          ),
          ListTile(
            title: const Text('Help Center'),
            leading: Icon(Icons.help),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 10),
          //   child: const Divider(
          //     color: Colors.grey,
          //     thickness: 0.5,
          //   ),
          // ),
          // ListTile(
          //   title: const Text('Settings'),
          //   leading: Icon(Icons.settings),
          //   onTap: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => Text("Settings"),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    ),
  );
}

PreferredSizeWidget? nav(String title, BuildContext context) {
  return AppBar(
    foregroundColor: Colors.grey[700],
    backgroundColor: bgColor,
    elevation: 0,
    title: Text("$title",
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    centerTitle: true,
    // actions: [
    //   Padding(
    //     padding:
    //         const EdgeInsets.only(right: 8.0), // Change the value as needed
    //     child: IconButton(
    //       icon: const Icon(Icons.edit, color: Colors.black, size: 30),
    //       onPressed: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(builder: (context) => const GenerateNotes()),
    //         );
    //       },
    //     ),
    //   ),
    // ],
  );
}

Widget bottomNavBar(List<BottomNavigationBarItem> navs) {
  return BottomNavigationBar(
    currentIndex: 0,
    selectedItemColor: Colors.grey,
    items: navs,
  );
}
