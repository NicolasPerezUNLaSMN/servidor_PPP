import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarousel extends StatelessWidget {
  ImageCarousel(this.images);
  final CarouselController buttonCarouselController = CarouselController();
  final List<FittedBox> images;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: images,
        options: CarouselOptions(
          initialPage: 0,
          enableInfiniteScroll: true,
          aspectRatio: 2.3,
          disableCenter: true,
          enlargeCenterPage: false,
          reverse: false,
          scrollDirection: Axis.horizontal,
        ));
  }
}
