import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog2/progress_dialog2.dart';
import 'package:tourism_albaha/Screen/Admin/AdminBottomNavBar.dart';
import 'dart:async';

class AdminEdite extends StatefulWidget {
  const AdminEdite({super.key});

  @override
  _AdminEditeState createState() => _AdminEditeState();
}

class _AdminEditeState extends State<AdminEdite> {
  bool imageSelected = false;
  List<String> categories = [
    'اختر جدول للعرض',
    'الفنادق',
    'المواقع الأثرية',
    'المتاحف',
    'الفعاليات',
    'المقاهي والمطاعم',
    'المناطق السياحية'
  ];

  String selectedCategory = 'اختر جدول للعرض';
  String searchData = '';
  late StreamController<String> categoryStreamController;
  late ProgressDialog progressDialog;
  File? newImageFile;
  @override
  void initState() {
    super.initState();
    categoryStreamController = StreamController<String>.broadcast();
    categoryStreamController.add(selectedCategory);
    progressDialog = ProgressDialog(context);
  }

  @override
  void dispose() {
    categoryStreamController.close();
    super.dispose();
  }

  void updateSelectedCategory(String? newValue) {
    setState(() {
      selectedCategory = newValue!;
      categoryStreamController.add(newValue);
    });
  }

  void updateSearchData(String value) {
    setState(() {
      searchData = value;
    });
  }

  //length for text display on Table for descr
  String truncateString(String text, int length) {
    return (text.length > length) ? '${text.substring(0, length)}...' : text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AdminBottomNavBar(),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          'البحث',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        onChanged: updateSelectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'اختر بالتصنيف',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            selectedCategory,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        StreamBuilder(
                          stream: categoryStreamController.stream,
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection(snapshot.data!)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('حدث خطأ');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                var documents = snapshot.data?.docs ?? [];
                                return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(label: Text('العنوان')),
                                        DataColumn(label: Text('الوصف')),
                                        DataColumn(label: Text('الصورة')),
                                        DataColumn(label: Text("التقييم")),
                                        DataColumn(label: Text("السعر")),
                                        DataColumn(label: Text("الرابط")),
                                        DataColumn(label: Text('تحديث')),
                                        DataColumn(label: Text('حذف')),
                                      ],
                                      rows: List<DataRow>.generate(
                                        documents.length,
                                        (index) {
                                          var data = documents[index].data()
                                              as Map<String, dynamic>;
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                  Text(data['pTitle'] ?? '')),
                                              DataCell(Tooltip(
                                                message:
                                                    data['pDescription'] ?? '',
                                                child: Text(truncateString(
                                                    data['pDescription'] ?? '',
                                                    50)),
                                              )),
                                              DataCell(SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(
                                                    data['pImage'] ?? '',
                                                    fit: BoxFit.cover),
                                              )),
                                              DataCell(Text(
                                                  data["pRate"]?.toString() ??
                                                      "0.00")),
                                              DataCell(Text(
                                                  data["pPrice"]?.toString() ??
                                                      "0.00")),
                                              DataCell(
                                                  Text(data["pLink"] ?? '')),
                                              DataCell(IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () {
                                                  // Code to show edit dialog for updating data
                                                  showEditDialog(
                                                      context,
                                                      documents[index].id,
                                                      data);
                                                },
                                              )),
                                              DataCell(IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  // Code to delete the record from Firestore
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          selectedCategory)
                                                      .doc(documents[index].id)
                                                      .delete();
                                                },
                                              )),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}');
    final UploadTask uploadTask = storageReference.putFile(imageFile);
    final TaskSnapshot storageTaskSnapshot = await uploadTask;
    String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  void showEditDialog(
      BuildContext context, String docId, Map<String, dynamic> currentData) {
    TextEditingController titleController =
        TextEditingController(text: currentData['pTitle']);
    TextEditingController descriptionController =
        TextEditingController(text: currentData['pDescription']);
    TextEditingController imageController =
        TextEditingController(text: currentData['pImage']);
    TextEditingController rateController =
        TextEditingController(text: currentData['pRate'].toString());
    TextEditingController priceController =
        TextEditingController(text: currentData['pPrice'].toString());
    TextEditingController linkController =
        TextEditingController(text: currentData['pLink']);
    bool showImge = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تحديث البيانات'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'العنوان'),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'الوصف',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      maxLength: 1000,
                    ),
                    if (!showImge)
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.network(imageController.text),
                      ),
                    if (showImge) // This checks if there is an image file selected
                      SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.file(
                            newImageFile!,
                            fit: BoxFit.cover,
                          )),
                    ElevatedButton(
                        child: Text("اختيار صورة"),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              newImageFile = File(pickedFile.path);
                              showImge = true;
                            });
                          }
                        }),
                    TextFormField(
                      controller: rateController,
                      decoration: const InputDecoration(labelText: 'التقييم'),
                    ),
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'السعر'),
                    ),
                    TextFormField(
                      controller: linkController,
                      decoration: const InputDecoration(labelText: 'الرابط'),
                    ),
                  ],
                ),
              );
            }),
            actions: <Widget>[
              Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text(
                            'تحديث',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          onPressed: () async {
                            progressDialog.show();
                            String newImageUrl;
                            if (newImageFile != null) {
                              newImageUrl =
                                  await _uploadImageToStorage(newImageFile!);
                            } else {
                              newImageUrl = imageController
                                  .text; // Keep the existing image path
                            }

                            FirebaseFirestore.instance
                                .collection(selectedCategory)
                                .doc(docId)
                                .update({
                              'pTitle': titleController.text,
                              'pDescription': descriptionController.text,
                              'pImage': newImageUrl,
                              'pRate': double.parse(rateController.text),
                              'pPrice': double.parse(priceController.text),
                              'pLink': linkController.text,
                            }).then((_) {
                              progressDialog.hide();
                              Navigator.of(context).pop();
                            }).catchError((error) {
                              progressDialog.hide();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text(
                                          'فشل في تحديث البيانات: $error'))));
                            });
                          },
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              showImge = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
