class BrandModel {
  late String? namebrand;
  late String? image;
  late int? valueproduct;

  BrandModel({this.namebrand, this.image, this.valueproduct});
}

List<BrandModel> brands = [
  BrandModel(
    namebrand: "Adidas",
    image: "assets/brand/adidas.svg",
    valueproduct: 255,
  ),
  BrandModel(
      namebrand: "Converse",
      image: "assets/brand/converse.svg",
      valueproduct: 300),
  // BrandModel(
  //     namebrand: "New Balance",
  //     image: "assets/brand/new_balance.svg",
  //     valueproduct: 400),
  BrandModel(
      namebrand: "Nike", image: "assets/brand/nike.svg", valueproduct: 300),
  BrandModel(
      namebrand: "Under Armour",
      image: "assets/brand/under_armour.svg",
      valueproduct: 300),
];
