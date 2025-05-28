import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Uint8List> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final finalBytes = await File(pickedFile!.path).readAsBytes();
    return finalBytes;
  }

  
class StorageMethods {
  Future<String> getUploadedImage(Uint8List file) async {
    final String bucketName = 'peers';
    final String fileName = 'peers${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      final response = await Supabase.instance.client.storage.from(bucketName).uploadBinary(
        fileName,
        file,
      );

      if (response.isEmpty) {
        print("Upload failed: Empty response");
        return 'null';
      }

      final String publicUrl = Supabase.instance.client.storage.from(bucketName).getPublicUrl(fileName);
      print("Uploaded Image URL: $publicUrl");

      return publicUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return 'null';
    }
  }
}
