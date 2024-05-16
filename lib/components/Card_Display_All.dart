import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_albaha/components/nodata.dart';

class Card_Diplay_Cat_Selected extends StatefulWidget {
  final String cat;
  const Card_Diplay_Cat_Selected(this.cat, {super.key});

  @override
  _Card_Display_AllState createState() => _Card_Display_AllState();
}

class _Card_Display_AllState extends State<Card_Diplay_Cat_Selected> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<List<DocumentSnapshot>> cardsStream;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    cardsStream = getCardsStream(widget.cat);
    _searchController = TextEditingController();
  }

  Stream<List<DocumentSnapshot>> getCardsStream(String collectionName) {
    return firestore
        .collection(collectionName)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: cardsStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
              child: Text(
            "يوجد خطاء الرجاء المحاولة في وقت لاحق",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return NoData(searchValue: widget.cat);
        }

        var filteredData = snapshot.data!
            .where((doc) =>
                doc['pTitle'].toString().contains(_searchController.text))
            .toList();

        return SingleChildScrollView(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
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
                                    const Icon(Icons.star, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    Text("${data['pRate']}"),
                                  ],
                                ),
                                Flexible(
                                    child: data['pPlaceType'] == 'مقهى'
                                        ? Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Row(children: [
                                              Text(
                                                "${data["pTitle"]} ",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: GoogleFonts
                                                          .notoNaskhArabic()
                                                      .fontFamily,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const Icon(
                                                Icons.coffee_outlined,
                                                size: 15,
                                              ),
                                            ]),
                                          )
                                        : data['pPlaceType'] == "مطعم"
                                            ? Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${data["pTitle"]} ",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: GoogleFonts
                                                                .notoNaskhArabic()
                                                            .fontFamily,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const Icon(
                                                      Icons.restaurant_outlined,
                                                      size: 15,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Text(
                                                data['pTitle'],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: GoogleFonts
                                                          .notoNaskhArabic()
                                                      .fontFamily,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              )),
                              ],
                            ),
                            const SizedBox(height: 4),
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
                                  "${data['pPrice']} SAR",
                                  style:
                                      const TextStyle(color: Colors.redAccent),
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
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
