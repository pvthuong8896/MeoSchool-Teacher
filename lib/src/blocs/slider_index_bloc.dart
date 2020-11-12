import 'dart:async';
import 'package:edtechteachersapp/src/blocs/bloc.dart';

class SliderIndexBloc extends Bloc {
  StreamController _updateImageIndexController = new StreamController<int>.broadcast();

  Stream get updateImageIndexController => _updateImageIndexController.stream;

  void changeCurrentIndex(index) {
    _updateImageIndexController.sink.add(index);
  }

  void dispose() {
    _updateImageIndexController.close();
  }
}