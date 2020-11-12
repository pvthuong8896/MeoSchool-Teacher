import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class VideoWidget extends StatelessWidget {
  Post post;

  VideoWidget({Key key, this.post}) : super(key: key);

  SliderIndexBloc sliderBloc = SliderIndexBloc();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Container(
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  post.videoThumbnail != null ? post.videoThumbnail : "",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Center(
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 60,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
