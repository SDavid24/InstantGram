import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instantgram/state/constants/firebase_field_name.dart';
import 'package:instantgram/state/posts/typedefs/user_id.dart';

import '../typedefs/post_id.dart';

@immutable
class CommentPayload extends MapView<String, dynamic> {
  CommentPayload({
    required UserId fromUserId,
    required PostId onPostId,
    required String comment,
  }) : super({
      FirebaseFieldName.userId: fromUserId,
      FirebaseFieldName.postId: onPostId,
      FirebaseFieldName.comment: comment,
      FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
  },);

}