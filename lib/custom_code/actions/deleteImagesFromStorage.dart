import 'package:firebase_storage/firebase_storage.dart';

Future<void> deleteImagesFromStorage(List<String> imageList) async {
  for(var image in imageList){
    print('excluindo imagem $image...');
    await FirebaseStorage.instance
        .refFromURL(image)
        .delete();
  }
}