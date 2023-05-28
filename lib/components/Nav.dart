import 'package:flutter/material.dart';
import 'package:makequiz/screens/home/helpCenter.dart';
import 'package:makequiz/screens/library.dart';
import '../screens/home/home.dart';
import '../utils.dart';

Widget sidebar(BuildContext context) {
  var h = MediaQuery.of(context).size.height;
  return Drawer(
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 75,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          // backgroundImage: NetworkImage(user!.photoURL!),
                          ),
                      const SizedBox(width: 12),
                      Text(
                        "Ravnoor Bedi",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // SizedBox(height: 5),
                    ],
                  ),
                ],
              ), // fixed parenthesis
            ),
          ),
          ListTile(
            title: const Text('Home'),
            leading: const Padding(
              padding: EdgeInsets.only(
                  left: 13), // Adjust the left margin as needed
              child: Icon(Icons.home),
            ),
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
            leading: const Padding(
              padding: EdgeInsets.only(
                  left: 13), // Adjust the left margin as needed
              child: Icon(Icons.book),
            ),
            onTap: () {
              navigate(Library(), context);
            },
          ),
          ListTile(
            title: const Text('Help Center'),
            leading: const Padding(
              padding: EdgeInsets.only(
                  left: 13), // Adjust the left margin as needed
              child: Icon(Icons.help),
            ),
            onTap: () {
              navigate(HelpCenter(), context);
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
          //   title: const Text('Sign Out'),
          //   leading: Icon(Icons.settings),
          //   onTap: () {
          //   },
          // ),
        ],
      ),
    ),
  );
}

PreferredSizeWidget? nav(String title, BuildContext context, {bool? elevation}) {
  return AppBar(
    foregroundColor: Colors.white,
    backgroundColor: Colors.red,
    elevation: 1,
    title: Text("$title",
    textAlign: TextAlign.start,
        style:
            const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
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
