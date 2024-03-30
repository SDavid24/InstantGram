
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart'as img;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/constants/firebase_collection_name.dart';
import 'package:instantgram/state/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:instantgram/state/image_upload/extensions/constants/constants.dart';
import 'package:instantgram/state/image_upload/extensions/get_collectionn_name_from_file_type.dart';
import 'package:instantgram/state/image_upload/extensions/get_image_data_aspect_ratio.dart';
import 'package:instantgram/state/image_upload/typedefs/is_loading.dart';
import 'package:flutter/foundation.dart';
import 'package:instantgram/state/posts/models/post_payload.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../post_settings/models/post_setting.dart';
import '../../posts/typedefs/user_id.dart';
import '../models/file_type.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ImageUploadNotifier extends StateNotifier<IsLoading>{
  ImageUploadNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> upload({
    required File file,
    required FileType fileType,
    required String message,
    required Map<PostSetting, bool> postSettings,
    required UserId userId

  }) async {
    isLoading = true;

    late Uint8List thumbnailUint8List;

    switch (fileType) {
      case FileType.image:
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if(fileAsImage  == null){
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }
        //create thumbnail
        final thumbnailForImage = img.copyResize(
          fileAsImage,
          width: Constants.imageThumbnailWidth,
        );

        ////Get the image out of the thumbnail
        final thumbnailData = img.encodeJpg(thumbnailForImage);
        thumbnailUint8List = Uint8List.fromList(thumbnailData);
        break;

      case FileType.video:
        final thumbnailForVideo = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: Constants.videoThumbnailMaxHeight,
          quality: Constants.videoThumbnailQuality,
        );
        if (thumbnailForVideo == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }else{
          thumbnailUint8List = thumbnailForVideo;
        }

        break;
    }

    //Calculate the aspect Ratio
    final thumbnailAspectRatio = await thumbnailUint8List.getAspectRatio();

    //calculate references
    final fileName = const Uuid().v4();

    //Create references to the thumbnail and the image itself
    final thumbnailRef = FirebaseStorage
        .instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.thumbnails)
        .child(fileName);

    final originalFileRef = FirebaseStorage
        .instance
        .ref()
        .child(userId)
        .child(fileType.collectionName)
        .child(fileName);
    

    try{
      //Upload thumbnail
      final thumbnailUploadTask = await thumbnailRef.putData(thumbnailUint8List);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      //Upload original file
      final originalFileUploadTask = await originalFileRef.putData(thumbnailUint8List);
      final originalFileStorageId = originalFileUploadTask.ref.name;

      //upload the post itself
      final postPayload = PostPayload(
          userId: userId,
          message: message,
          thumbnailUrl: await thumbnailRef.getDownloadURL(),
          fileUrl: await originalFileRef.getDownloadURL(),
          fileType: fileType,
          fileName: fileName,
          aspectRatio: thumbnailAspectRatio,
          thumbnailStorageId: thumbnailStorageId,
          originalFileStorageId: originalFileStorageId,
          postSettings: postSettings
      );

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .add(postPayload);

      return true;
    }catch(_){
      return false;
    }finally{
      isLoading = false;
    }
  }
}