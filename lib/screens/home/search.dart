import 'package:flutter/material.dart';
import 'package:makequiz/components/SearchBar.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SearchBar(),
          const SizedBox(height: 15),
          const Text("Recent",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          recentItem("Industrial revolution"),
          const SizedBox(height: 8),
          recentItem("linear algebra"),
          const SizedBox(height: 8),
          recentItem("puppy anatomy"),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget recentItem(String text) {
    return Row(
      children: [
        Icon(Icons.access_time_sharp, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text,
            style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w600))
      ],
    );
  }
}
