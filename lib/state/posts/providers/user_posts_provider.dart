import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/auth/providers/user_id_provider.dart';
import 'package:instantgram/state/constants/firebase_collection_name.dart';
import 'package:instantgram/state/constants/firebase_field_name.dart';
import 'package:instantgram/state/posts/models/post_keys.dart';

import '../models/post.dart';

final userPostsProvider = StreamProvider.autoDispose<Iterable<Post>>((ref){
  final controller = StreamController<Iterable<Post>>();
  final userId = ref.watch(userIdProvider);  //Watch current user
  controller.onListen = (){ //Add an empty array
    controller.sink.add([]);
  };

  //Create a subscription to Firestore
  final sub = FirebaseFirestore
    .instance
    .collection(FirebaseCollectionName.posts)
    .orderBy(FirebaseFieldName.createdAt, descending: true)
    .where(PostKey.userId, isEqualTo: userId)
    .snapshots()  //allows us listen for changes
    .listen((snapshot) {

      final documents = snapshot.docs;
      final posts = documents.where((doc) => !doc.metadata.hasPendingWrites,)
          .map(
            (doc) => Post(
              postId: doc.id,
              json: doc.data(),
            ),
      );

      controller.sink.add(posts);
    });


  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });



  return controller.stream;
});