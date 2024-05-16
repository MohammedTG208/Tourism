import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_albaha/components/nofound.dart';

class SearchUser extends StatefulWidget {
  final String searchValue;

  const SearchUser(this.searchValue, {super.key});

  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  List<Map<String, dynamic>> searchData = [];
  bool loading = true;

  Future<void> searchValueInCollections(String searchValue) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List<String> collectionNames = [
      'المواقع الأثرية',
      'الفنادق',
      'المتاحف',
      'الفعاليات',
      'المقاهي والمطاعم',
      'المناطق السياحية'
    ];

    // ignore: unused_local_variable
    bool searchFound = false;
    try {
      for (String name in collectionNames) {
        CollectionReference collection = _firestore.collection(name);
        QuerySnapshot snapshot = await collection
            .where('pTitle', isGreaterThanOrEqualTo: searchValue)
            .where('pTitle', isLessThan: searchValue + '\uf8ff')
            .get();

        for (QueryDocumentSnapshot doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (!searchData.any((map) => mapEquals(map, data))) {
            searchData.add(data);
          }
        }
      }
    } catch (e) {
      NotFound(
        searchValue: searchValue,
      );
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    searchValueInCollections(widget.searchValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : searchData.isNotEmpty
              ? ListView.builder(
                  itemCount: searchData.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> searchItem = searchData[index];
                    return Card(
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
                                image: NetworkImage(searchItem['pImage']),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.amber),
                                        const SizedBox(width: 4),
                                        Text("${searchItem['pRate']}"),
                                      ],
                                    ),
                                    Flexible(
                                      child: Text(
                                        searchItem['pTitle'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily:
                                              GoogleFonts.notoNaskhArabic()
                                                  .fontFamily,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.location_on),
                                        SizedBox(width: 4),
                                        Text('الباحة'), // Example location
                                      ],
                                    ),
                                    Text(
                                      "${searchItem['pPrice']} SR",
                                      style: const TextStyle(
                                          color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
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
                                          'pImage': searchItem['pImage'],
                                          'pTitle': searchItem['pTitle'],
                                          'pRate': searchItem['pRate'],
                                          'pPrice': searchItem['pPrice'],
                                          'pDescription':
                                              searchItem['pDescription'],
                                          'pLink': searchItem['pLink'],
                                        },
                                      );
                                    },
                                    child: Text(
                                      'التفاصيل',
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.notoNaskhArabic()
                                                .fontFamily,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : NotFound(searchValue: widget.searchValue),
    );
  }
}
