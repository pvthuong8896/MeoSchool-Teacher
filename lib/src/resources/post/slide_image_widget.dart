import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class SlideImageWidget extends StatelessWidget {
  Post post;
  SlideImageWidget({Key key, this.post, this.onSelectImage}) : super(key: key);

  SliderIndexBloc sliderBloc = SliderIndexBloc();
  Function onSelectImage;

  @override
  Widget build(BuildContext context) {
    List<String> imgList = [];
    for(var i = 0; i < post.files.length; i++) {
      imgList.add(post.files[i].file_url);
    }
    List child = map<Widget>(
      imgList,
          (index, i) {
        return GestureDetector(
          onTap: () {
            this.onSelectImage(index);
          },
          child: Container(
            // margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Image.network(
                i,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 100,
                loadingBuilder: edTechImageLoader,
              ),
            ),
          ),
        );
      },
    ).toList();
    return Stack(alignment: Alignment.bottomCenter, children: [
      AspectRatio(
        aspectRatio: 1,
        child: CarouselSlider(
            options: CarouselOptions(
                height: double.infinity,
                autoPlay: true,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  sliderBloc.changeCurrentIndex(index);
                }),
            items: child),
      ),
      StreamBuilder(
          stream: sliderBloc.updateImageIndexController,
          builder: (BuildContext context, snapShot) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(
                  imgList,
                  (index, url) {
                    return Container(
                      width: snapShot.data == index ? 7.0 : 5.0,
                      height: snapShot.data == index ? 7.0 : 5.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 20.0, horizontal: 1.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: snapShot.data == index
                              ? EdTechColors.textWhiteColor
                              : EdTechColors.dividerColor),
                    );
                  },
                ),
              ))
    ]);
  }
}