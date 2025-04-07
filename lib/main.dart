import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:native_test/native/native_control.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImageComparisonPage(),
    );
  }
}

class ImageComparisonPage extends StatefulWidget {
  @override
  _ImageComparisonPageState createState() => _ImageComparisonPageState();
}

img.Image _convert_to_gray_func(Map<String, dynamic> params) {
  img.Image image = params["image"];
  return NativeControl.convert_to_gray_func(image: image);
}

class _ImageComparisonPageState extends State<ImageComparisonPage> {
  Uint8List? _imageBytes;

  Future<void> _toggleImage() async {
    ByteData data = await rootBundle.load("assets/bird-4728857_1280.jpg");
    Uint8List bytes = data.buffer.asUint8List();
    img.Image? image = img.decodeImage(bytes);
    image!;

    img.Image grayImage = await compute(_convert_to_gray_func, {
      "image": image,
    });

    setState(() {
      _imageBytes = Uint8List.fromList(img.encodePng(grayImage));
    });
  }

  Future<void> _loadImage() async {
    ByteData data = await rootBundle.load('assets/bird-4728857_1280.jpg');
    Uint8List bytes = data.buffer.asUint8List();

    // img.Image 객체로 변환 후 다시 Uint8List로 변환
    img.Image? image = img.decodeImage(bytes);
    if (image != null) {
      setState(() {
        _imageBytes = Uint8List.fromList(img.encodePng(image));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Before & After Comparison')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _imageBytes != null
              ? Image.memory(_imageBytes!)
              : CircularProgressIndicator(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _toggleImage,
            child: Text('변환'),
          ),
        ],
      ),
    );
  }
}
