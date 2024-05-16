import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog2/progress_dialog2.dart';
import 'package:tourism_albaha/Screen/Admin/AdminBottomNavBar.dart';
import 'package:tourism_albaha/model/place_info.dart';
import "package:firebase_storage/firebase_storage.dart";

class AddPlace extends StatefulWidget {
  const AddPlace({super.key});

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedCategory = 'الفنادق';
  File? _imageFile;
  bool _isImageSelected = false;
  late String _selectedType = 'مقهى';
  bool _showSecondDropdown = false;

  @override
  Widget build(BuildContext context) {
    ProgressDialog _progressDialog = ProgressDialog(context);
    @override
    void initState() {
      super.initState();
      _progressDialog = ProgressDialog(context);
    }

    void _showLoading() {
      _progressDialog.show();
    }

    void _hideLoading() {
      _progressDialog.hide();
    }

    return Scaffold(
      bottomNavigationBar: const AdminBottomNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: Text(
                      "إضافة محتوى",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.notoKufiArabic().fontFamily,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              _buildCategoryDropdown(),
              const SizedBox(height: 16.0),
              _buildPlaceNameField(),
              const SizedBox(height: 16.0),
              _buildImagePicker(),
              if (!_isImageSelected) _buildImageSelectionError(),
              const SizedBox(height: 16.0),
              _buildDescriptionField(),
              const SizedBox(height: 16.0),
              _buildRateField(),
              const SizedBox(height: 16.0),
              _buildLinkField(),
              const SizedBox(height: 16),
              _buildpriceNameField(),
              const SizedBox(height: 32.0),
              _buildAddButton(_showLoading, _hideLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          onChanged: (newValue) {
            setState(() {
              _selectedCategory = newValue!;
              _showSecondDropdown = (_selectedCategory == 'المقاهي والمطاعم');
            });
          },
          items: <String>[
            'الفنادق',
            'المواقع الأثرية',
            'المتاحف',
            'الفعاليات',
            'المقاهي والمطاعم',
            'المناطق السياحية'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 15,
        ),
        if (_showSecondDropdown == true)
          DropdownButtonFormField<String>(
            value: _selectedType,
            onChanged: (String? newValue) {
              setState(() {
                _selectedType = newValue!;
              });
            },
            items: <String>['مطعم', 'مقهى']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildPlaceNameField() {
    return TextFormField(
      controller: _placeNameController,
      decoration: const InputDecoration(
        labelText: 'اسم المكان',
      ),
    );
  }

  Widget _buildpriceNameField() {
    return TextFormField(
      controller: _priceController,
      decoration: const InputDecoration(
        labelText: 'السعر',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () async {
        // Allow image change by tapping on the image if already selected
        if (_isImageSelected) {
          await _pickImage(ImageSource.gallery);
        }
      },
      child: _imageFile != null
          ? Image.file(
              _imageFile!,
              height: 150,
              fit: BoxFit.cover,
            )
          : ElevatedButton(
              onPressed: () async {
                await _pickImage(ImageSource.gallery);
              },
              child: const Text('اختر صورة'),
            ),
    );
  }

  Widget _buildImageSelectionError() {
    return const Text(
      'الرجاء اختيار صورة',
      style: TextStyle(color: Colors.red),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'الوصف',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      maxLength: 1000,
    );
  }

  Widget _buildRateField() {
    return TextFormField(
      controller: _rateController,
      decoration: const InputDecoration(
        labelText: 'التقييم',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildLinkField() {
    return TextFormField(
      controller: _linkController,
      decoration: const InputDecoration(
        labelText: 'الرابط',
      ),
    );
  }

  Widget _buildAddButton(Function showde, Function hidede) {
    return ElevatedButton(
      onPressed: () {
        _addPlace(showde, hidede);
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      child: const Text(
        'اضافة',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _isImageSelected = true;
      }
    });
  }

  double parseOrZero(String value) {
    return double.tryParse(value) ?? 0.0;
  }

  Future<void> _addPlace(Function show, Function hide) async {
    if (!_isImageSelected || _isInputInvalid()) {
      _showSnackbar('الرجاء ملء جميع الحقول واختيار صورة');
      return;
    }
    show();
    try {
      final imageUrl = await _uploadImageToStorage();
      final placeInfo = PlaceInfo(
        pTitle: _placeNameController.text,
        pDescription: _descriptionController.text,
        pImage: imageUrl,
        pLink: _linkController.text,
        pRate: parseOrZero(_rateController.text),
        pPrice: parseOrZero(_priceController.text),
        typeCategory: _selectedCategory,
        pselectedType: _selectedType,
      );

      final collectionReference =
          FirebaseFirestore.instance.collection(_selectedCategory);
      await collectionReference.add(placeInfo.toJson());

      // Clear text fields after successful addition
      _placeNameController.clear();
      _descriptionController.clear();
      _rateController.clear();
      _linkController.clear();
      _priceController.clear();

      // Reset image selection
      setState(() {
        _imageFile = null;
        _isImageSelected = false;
      });
      hide();
      _showSnackbar('تمت إضافة المكان بنجاح');
    } catch (e) {
      hide();
      _showSnackbar('حدث خطأ أثناء إضافة المكان');
    }
  }

  bool _isInputInvalid() {
    final rate = double.tryParse(_rateController.text);
    return _placeNameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        rate == null ||
        rate < 1.00 ||
        rate > 5.00 ||
        !_linkController.text.startsWith('https://');
  }

  Future<String> _uploadImageToStorage() async {
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}');
    final UploadTask uploadTask = storageReference.putFile(_imageFile!);
    final TaskSnapshot storageTaskSnapshot = await uploadTask;
    return await storageTaskSnapshot.ref.getDownloadURL();
  }

  // ignore: unused_element
  Future<void> _storePlaceInFirestore(String imageUrl) async {
    Map<String, dynamic> data = {};

    // Conditionally adding entries if they are not empty.
    if (_linkController.text.isNotEmpty) {
      data['pLink'] = _linkController.text;
    }
    if (imageUrl.isNotEmpty) {
      data['pImage'] = imageUrl;
    }
    if (_placeNameController.text.isNotEmpty) {
      data['pTitle'] = _placeNameController.text;
    }
    if (_descriptionController.text.isNotEmpty) {
      data['pDescription'] = _descriptionController.text;
    }
    if (_rateController.text.isNotEmpty) {
      double? rate = double.tryParse(_rateController.text);
      if (rate != null) {
        data['pRate'] = rate;
      }
    }
    if (_priceController.text.isNotEmpty) {
      double? price = double.tryParse(_priceController.text);
      if (price != null) {
        data['pPrice'] = price;
      }
    }

    // Add to Firestore only if there are any fields to add.
    if (data.isNotEmpty) {
      await FirebaseFirestore.instance.collection(_selectedCategory).add(data);
    }

    if (_selectedType.isNotEmpty) {
      data['pPlaceType'] = _selectedType;
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Directionality(
            textDirection: TextDirection.rtl, child: Text(message))));
  }
}
