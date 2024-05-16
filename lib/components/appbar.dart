import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_albaha/Screen/search_By_Selected_Cat.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar(this.placeName, {super.key});
  final String placeName;
  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late String category;
  late String title;
  @override
  void initState() {
    super.initState();
    category = widget.placeName;
    title = _searchController.text;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 15,
      title: _isSearching
          ? _buildSearchField()
          : Text(
              widget.placeName,
              style: TextStyle(
                  fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: _searchController,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.end,
        decoration: InputDecoration(
          hintText: "....بحث",
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          hintStyle:
              TextStyle(fontFamily: GoogleFonts.notoNaskhArabic().fontFamily),
        ),
        style: const TextStyle(color: Colors.black),
        onSubmitted: (value) {
          String searchtext = _searchController.text;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchbyCategory(
                  placename: searchtext, collocation: widget.placeName),
            ),
          );
        },
      ),
    );
  }
}
