import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_albaha/components/nofound.dart';

class SearchbyCategory extends StatefulWidget {
  final String placename;
  final String collocation;

  const SearchbyCategory(
      {super.key, required this.placename, required this.collocation});

  @override
  State<SearchbyCategory> createState() => _SearchbyCategoryState();
}

class _SearchbyCategoryState extends State<SearchbyCategory> {
  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: firestore.collection(widget.collocation).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var filteredData = snapshot.data!.docs
              .where(
                  (doc) => doc['pTitle'].toString().contains(widget.placename))
              .toList();

          if (filteredData.isEmpty) {
            return NotFound(
                searchValue: widget
                    .placename); // Return NotFound widget when there are no search results
          }

          return ListView.builder(
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              var data = filteredData[index].data() as Map<String, dynamic>;

              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 200,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.grey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(data['pImage']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber),
                                    SizedBox(width: 4),
                                    Text("${data['pRate']}"),
                                  ],
                                ),
                                Flexible(
                                  child: Text(
                                    data['pTitle'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: GoogleFonts.notoNaskhArabic()
                                          .fontFamily,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    SizedBox(width: 4),
                                    Text('الباحة'), // Example location
                                  ],
                                ),
                                Text(
                                  "${data['pPrice']} SR",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 40,
                              width: 120,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/display_det',
                                    arguments: {
                                      'pImage': data['pImage'],
                                      'pTitle': data['pTitle'],
                                      'pRate': data['pRate'],
                                      'pPrice': data['pPrice'],
                                      'pDescription': data['pDescription'],
                                      'pLink': data['pLink'],
                                    },
                                  );
                                },
                                child: Text(
                                  'التفاصيل',
                                  style: TextStyle(
                                      fontFamily: GoogleFonts.notoNaskhArabic()
                                          .fontFamily,
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
