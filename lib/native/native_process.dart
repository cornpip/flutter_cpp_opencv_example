import 'dart:ffi';

typedef ConvertToGrayscaleC = Int32 Function(
    Pointer<Uint8> inputData, Pointer<Uint8> outputData, Int32 width, Int32 height);
typedef ConvertToGrayscaleDart = int Function(
    Pointer<Uint8> inputData, Pointer<Uint8> outputData, int width, int height);

class NativeProcess {
  static final DynamicLibrary _dylib = DynamicLibrary.open('libnative_process.so');

  static void convertToGrayscale(Pointer<Uint8> inputData,
      Pointer<Uint8> outputData, int width, int height) {
    final ConvertToGrayscaleDart convertToGrayscale =
    _dylib.lookupFunction<ConvertToGrayscaleC, ConvertToGrayscaleDart>(
        'convert_to_grayscale');

    final result = convertToGrayscale(inputData, outputData, width, height);
    if (result != 0) {
      throw Exception("Err convertToGrayscale");
    }
  }
}