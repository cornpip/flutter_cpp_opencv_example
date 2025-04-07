import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:image/image.dart' as img;
import 'package:native_test/native/native_process.dart';

class NativeControl {
  static void dartRgb_to_ptr(
      {required ffi.Pointer<ffi.Uint8> inputPtr, required img.Image dartImg}) {
    final width = dartImg.width;
    final height = dartImg.height;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        // (행 우선 방식)
        img.Pixel pixel = dartImg.getPixel(x, y);

        int index = (y * width + x) * 3;
        inputPtr[index] = pixel.r.toInt();
        inputPtr[index + 1] = pixel.g.toInt();
        inputPtr[index + 2] = pixel.b.toInt();
      }
    }
  }

  static void grayPtr_to_dartImg(
      {required ffi.Pointer<ffi.Uint8> grayPtr, required img.Image dartImg}) {
    final width = dartImg.width;
    final height = dartImg.height;

    for (int i = 0; i < width * height; i++) {
      int value = grayPtr[i];

      dartImg.setPixel(
          i % width, i ~/ width, img.ColorInt8.rgb(value, value, value));
    }
  }

  static img.Image convert_to_gray_func({required img.Image image}) {
    final width = image.width;
    final height = image.height;
    ffi.Pointer<ffi.Uint8> inputData = calloc<ffi.Uint8>(width * height * 3);
    ffi.Pointer<ffi.Uint8> outputData = calloc<ffi.Uint8>(width * height);

    try {
      dartRgb_to_ptr(
        inputPtr: inputData,
        dartImg: image,
      );

      NativeProcess.convertToGrayscale(inputData, outputData, width, height);

      final grayImage = img.Image(width: width, height: height);
      grayPtr_to_dartImg(grayPtr: outputData, dartImg: grayImage);

      return grayImage;
    } finally {
      calloc.free(inputData);
      calloc.free(outputData);
    }
  }
}
