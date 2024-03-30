import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/comments/typedefs/comment_id.dart';
import 'package:instantgram/state/constants/firebase_collection_name.dart';
import 'package:instantgram/state/constants/firebase_field_name.dart';
import 'package:instantgram/state/image_upload/typedefs/is_loading.dart';

class DeleteCommentStateNotifier extends StateNotifier<IsLoading> {
  DeleteCommentStateNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deleteCmment({
    required CommentId commentId,
  }) async {
    try{
      isLoading = true;

      //get comment to delete
      final query = FirebaseFirestore
          .instance
          .collection(FirebaseCollectionName.comments)
          .where(FieldPath.documentId, isEqualTo: commentId)
          .limit(1)
          .get();

      await query.then((query) async { //delete comment
        for (final doc in query.docs) {
          await doc.reference.delete();
        }
        },
      );
      return true;
    }catch(_){
      return false;
    }finally{
      isLoading = false;
    }
  }
}