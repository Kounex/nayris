import 'dart:ui';

class CroppedImageData {
  final List<int>? encodedPNG;
  final Rect? rect;
  final int? height;
  final int? width;

  CroppedImageData(this.encodedPNG, this.rect, this.height, this.width);
}
