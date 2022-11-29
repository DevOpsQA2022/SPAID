import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/service/app_service.dart';
import 'package:spaid/service/locator.dart';


class ImagePickerProvider extends BaseProvider{
  final _mediaService = locator<AppService>();

  File? _selectedImage;

  bool get hasSelectedImage => _selectedImage != null;

  File? get selectedImage => _selectedImage;

  Future selectImage({bool? fromGallery}) async {
   // _selectedImage = await _mediaService.getFile(fileType: FileType.image);
    notifyListeners();
  }

}