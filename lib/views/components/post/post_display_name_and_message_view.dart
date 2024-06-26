import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/user_info/providers/user_info_model_provider.dart';
import 'package:instantgram/views/components/animations/small_error_animation_view.dart';
import 'package:instantgram/views/components/rich_two_parts_text.dart';

import '../../../state/posts/models/post.dart';

class PostDisplayNameAndMessageView extends ConsumerWidget {
  final Post post;

  const PostDisplayNameAndMessageView({
    super.key,
    required this.post,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final userInfoModel = ref.watch(
      userInfoModelProvider(post.userId),
    );
    
    return userInfoModel.when(
      data: (userInfoModel){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichTwoPartsTexts(
            leftPart: userInfoModel.displayName,
            rightPart: post.message,
          ),
        );
      },
      loading: (){
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace){
        return const SmallErrorAnimationView();
      },
    );
    
  }
}
