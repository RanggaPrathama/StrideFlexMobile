import 'package:flutter/material.dart';

class ShoesModel {
  late int? idShoes;
  late String? nameShoes;
  late int? price;
  late String? description;
  late List<String> image;
  late List<Color> colors;
  late String? kategoriUmur;
  bool isLiked;

  ShoesModel(
      {this.idShoes,
      this.nameShoes,
      this.price,
      this.description,
      required this.image,
      required this.colors,
      required this.kategoriUmur,
      this.isLiked = false});
}

List<ShoesModel> shoes = [
  ShoesModel(
      idShoes: 1,
      nameShoes: 'Nike Air One',
      price: 13000000,
      kategoriUmur: "Men",
      description:
          'Sepatu Nike Air One hadir dengan desain yang sporty dan nyaman untuk digunakan sehari-hari. Dibuat dengan teknologi terkini untuk memberikan kenyamanan dan performa maksimal bagi penggunanya. Cocok untuk berbagai aktivitas, dari berlari hingga berjalan santai.',
      image: [
        'assets/shoes/imageedit_10_6829801789.png'
      ],
      colors: [
        Colors.black,
        Colors.red,
        Colors.white,
        Colors.yellow,
      ]),
  ShoesModel(
      idShoes: 2,
      nameShoes: 'Nike Air Two',
      price: 13000000,
      kategoriUmur: "Men",
      description:
          'Sepatu Nike Air Two hadir dengan desain yang sporty dan nyaman untuk digunakan sehari-hari. Dibuat dengan teknologi terkini untuk memberikan kenyamanan dan performa maksimal bagi penggunanya. Cocok untuk berbagai aktivitas, dari berlari hingga berjalan santai.',
      image: [
        'assets/shoes/nike1.png'
      ],
      colors: [
        Colors.black,
        Colors.red,
        Colors.white,
        Colors.yellow,
      ]),
  ShoesModel(
      idShoes: 3,
      nameShoes: 'Nike Air Three',
      kategoriUmur: "Men",
      price: 12000000,
      description:
          'Sepatu Nike Air Three hadir dengan desain yang sporty dan nyaman untuk digunakan sehari-hari. Dibuat dengan teknologi terkini untuk memberikan kenyamanan dan performa maksimal bagi penggunanya. Cocok untuk berbagai aktivitas, dari berlari hingga berjalan santai.',
      image: [
        'assets/shoes/nike2.png'
      ],
      colors: [
        Colors.black,
        Colors.red,
        Colors.white,
        Colors.yellow,
      ]),
  ShoesModel(
      idShoes: 4,
      nameShoes: 'Adidas Flow',
      kategoriUmur: "Men",
      price: 1100000,
      description:
          'Sepatu Adidas Flow hadir dengan desain yang sporty dan nyaman untuk digunakan sehari-hari. Dibuat dengan teknologi terkini untuk memberikan kenyamanan dan performa maksimal bagi penggunanya. Cocok untuk berbagai aktivitas, dari berlari hingga berjalan santai.',
      image: [
        'assets/shoes/nike3.png',
        'assets/shoes/imageedit_4_2300774502.png'
      ],
      colors: [
        Colors.black,
        Colors.red,
        Colors.white,
        Colors.yellow,
      ]),
  ShoesModel(
      idShoes: 5,
      nameShoes: 'Nike White',
      kategoriUmur: "Men",
      price: 1200000,
      description:
          'Sepatu Nike White hadir dengan desain yang sporty dan nyaman untuk digunakan sehari-hari. Dibuat dengan teknologi terkini untuk memberikan kenyamanan dan performa maksimal bagi penggunanya. Cocok untuk berbagai aktivitas, dari berlari hingga berjalan santai.',
      image: [
        'assets/shoes/nike4.png'
      ],
      colors: [
        Colors.black,
        Colors.red,
        Colors.white,
        Colors.yellow,
      ]),
  ShoesModel(
      idShoes: 6,
      nameShoes: 'Nike Purple',
      kategoriUmur: "Men",
      price: 1200000,
      description:
          'Sepatu Nike Air Purple hadir dengan desain yang sporty dan nyaman untuk digunakan sehari-hari. Dibuat dengan teknologi terkini untuk memberikan kenyamanan dan performa maksimal bagi penggunanya. Cocok untuk berbagai aktivitas, dari berlari hingga berjalan santai.',
      image: [
        'assets/shoes/nike5.png'
      ],
      colors: [
        Colors.black,
        Colors.red,
        Colors.white,
        Colors.yellow,
      ]),
  ShoesModel(
      idShoes: 7,
      nameShoes: 'Nike New Women',
      price: 13000000,
      kategoriUmur: "Women",
      description:
          'Sepatu Nike Air One hadir dengan desain yang sporty dan nyaman untuk digunakan sehari-hari. Dibuat dengan teknologi terkini untuk memberikan kenyamanan dan performa maksimal bagi penggunanya. Cocok untuk berbagai aktivitas, dari berlari hingga berjalan santai.',
      image: [
        'assets/shoes/download.png'
      ],
      colors: [
        Colors.black,
        Colors.red,
        Colors.white,
        Colors.yellow,
      ]),
  ShoesModel(
      idShoes: 8,
      nameShoes: 'Nike One Women',
      price: 13000000,
      kategoriUmur: "Women",
      description:
          'Sepatu Nike Air One hadir dengan desain yang sporty dan nyaman untuk digunakan sehari-hari. Dibuat dengan teknologi terkini untuk memberikan kenyamanan dan performa maksimal bagi penggunanya. Cocok untuk berbagai aktivitas, dari berlari hingga berjalan santai.',
      image: [
        'assets/shoes/download.png'
      ],
      colors: [
        Colors.black,
        Colors.red,
        Colors.white,
        Colors.yellow,
      ]),
  ShoesModel(
      idShoes: 9,
      nameShoes: 'Adidas Flow',
      kategoriUmur: "Child",
      price: 1100000,
      description:
          'Sepatu Adidas Flow hadir dengan desain yang sporty dan nyaman untuk digunakan sehari-hari. Dibuat dengan teknologi terkini untuk memberikan kenyamanan dan performa maksimal bagi penggunanya. Cocok untuk berbagai aktivitas, dari berlari hingga berjalan santai.',
      image: [
        'assets/shoes/nike3.png',
        'assets/shoes/imageedit_4_2300774502.png'
      ],
      colors: [
        Colors.black,
        Colors.red,
        Colors.white,
        Colors.yellow,
      ]),
  ShoesModel(
      idShoes: 10,
      nameShoes: 'Nike White',
      kategoriUmur: "Child",
      price: 1200000,
      description:
          'Sepatu Nike White hadir dengan desain yang sporty dan nyaman untuk digunakan sehari-hari. Dibuat dengan teknologi terkini untuk memberikan kenyamanan dan performa maksimal bagi penggunanya. Cocok untuk berbagai aktivitas, dari berlari hingga berjalan santai.',
      image: [
        'assets/shoes/nike4.png'
      ],
      colors: [
        Colors.black,
        Colors.red,
        Colors.white,
        Colors.yellow,
      ]),
  ShoesModel(
      idShoes: 11,
      nameShoes: 'Nike Air Two',
      price: 13000000,
      kategoriUmur: "Child",
      description:
          'Sepatu Nike Air Two hadir dengan desain yang sporty dan nyaman untuk digunakan sehari-hari. Dibuat dengan teknologi terkini untuk memberikan kenyamanan dan performa maksimal bagi penggunanya. Cocok untuk berbagai aktivitas, dari berlari hingga berjalan santai.',
      image: [
        'assets/shoes/nike1.png'
      ],
      colors: [
        Colors.black,
        Colors.red,
        Colors.white,
        Colors.yellow,
      ]),
  ShoesModel(
      idShoes: 12,
      nameShoes: 'Nike Air One',
      price: 13000000,
      kategoriUmur: "Child",
      description:
          'Sepatu Nike Air One hadir dengan desain yang sporty dan nyaman untuk digunakan sehari-hari. Dibuat dengan teknologi terkini untuk memberikan kenyamanan dan performa maksimal bagi penggunanya. Cocok untuk berbagai aktivitas, dari berlari hingga berjalan santai.',
      image: [
        'assets/shoes/imageedit_10_6829801789.png'
      ],
      colors: [
        Colors.black,
        Colors.red,
        Colors.white,
        Colors.yellow,
      ]),
  ShoesModel(
      idShoes: 13,
      nameShoes: 'Nike Air One',
      price: 13000000,
      kategoriUmur: "Child",
      description:
          'Sepatu Nike Air One hadir dengan desain yang sporty dan nyaman untuk digunakan sehari-hari. Dibuat dengan teknologi terkini untuk memberikan kenyamanan dan performa maksimal bagi penggunanya. Cocok untuk berbagai aktivitas, dari berlari hingga berjalan santai.',
      image: [
        'assets/shoes/adidas-Yeezy-Boost-350-V2-Cinder-Product.png'
      ],
      colors: [
        Colors.black,
        Colors.red,
        Colors.white,
        Colors.yellow,
      ])
];
