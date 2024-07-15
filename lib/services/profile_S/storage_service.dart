import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> _getImageUrl(String imageType,String path) async {
    try {
      return await _storage.ref(path).getDownloadURL();
    } catch (e) {
      if(imageType=='banner')
      {
        return await _storage.ref('banners/default_banner.jpg').getDownloadURL();
      }
      else//profile picture 
      {
        return await _storage.ref('profile_pictures/default_image.jpg').getDownloadURL();
      }
    }
  }

  Future<String> getBannerUrl(String userId) async {
    return _getImageUrl('banner','banners/$userId.jpg');

  }

  Future<String> getProfilePictureUrl(String userId) async {
    return _getImageUrl('profilePicture','profile_pictures/$userId.jpg');
    
  }


  

}
