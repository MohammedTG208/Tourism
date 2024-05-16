class PlaceInfo {
  int? pID;
  String pLink;
  String pImage;
  String pTitle;
  String pDescription;
  double pRate;
  double pPrice;
  String typeCategory;
  String? pselectedType;

  PlaceInfo({
    this.pselectedType,
    this.pID,
    required this.pTitle,
    required this.pDescription,
    required this.pImage,
    required this.pLink,
    required this.pRate,
    required this.pPrice,
    required this.typeCategory,
  });
  // Method to convert PlaceInfo object to JSON
  Map<String, dynamic> toJson() {
    return {
      if (pID != null) 'pID': pID,
      'pLink': pLink,
      'pImage': pImage,
      'pTitle': pTitle,
      'pDescription': pDescription,
      'pRate': pRate,
      'pPrice': pPrice,
      'pPlaceType': pselectedType ?? "",
    };
  }
}
