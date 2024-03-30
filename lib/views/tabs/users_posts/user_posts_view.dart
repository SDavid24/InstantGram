import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/posts/providers/user_posts_provider.dart';
import 'package:instantgram/views/components/animations/empty_contents_with_texts_animation_view.dart';
import 'package:instantgram/views/components/animations/error_animation_view.dart';
import 'package:instantgram/views/components/post/posts_grid_view.dart';
import 'package:instantgram/views/constants/strings.dart';

import '../../components/animations/loading_animation_view.dart';

class UserPostView extends ConsumerWidget{
  const UserPostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userPostsProvider);
    return RefreshIndicator(
      onRefresh: (){
        ref.refresh(userPostsProvider);
        return Future.delayed(const Duration(seconds: 1));
      },
      child: posts.when( //Using 'when' function to turn an async value into a widget
        data: (posts){
          if(posts.isEmpty){
            return const EmptyContentsWithTextAnimationView(text: Strings.youHaveNoPosts);
          }else{
            return PostGridView(
              posts: posts,
            );  //Return the normal view with posts
          }
        },
        error: (error, stackTrace){
          return const ErrorAnimationView();
        },
        loading: (){
          return const LoadingAnimationView();
        },
      ),

    );
  }
}
