import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:instantgram/views/components/animations/error_animation_view.dart';
import 'package:video_player/video_player.dart';

import '../../../state/posts/models/post.dart';
import '../animations/loading_animation_view.dart';

class PostVideoView extends HookWidget{
  final Post post;

  const PostVideoView({
    super.key,
    required this.post,
  });


  @override
  Widget build(BuildContext context) {
    ///TODO: check if VideoPlayerController.networkUrl also works
    final controller = VideoPlayerController.network(
      post.fileUrl,
    );

    final isVideoPlayerReady = useState(false);

    useEffect(() {
      controller.initialize()
          .then( (value) {
        isVideoPlayerReady.value = true;
        controller.setLooping(true);
        controller.play();
      },
      );
      return controller.dispose;
    }, [controller]);
    
    switch (isVideoPlayerReady.value){
      case true:
        return AspectRatio(
          aspectRatio: post.aspectRatio,
          child: VideoPlayer(
            controller,
          ),
        );
      case false:
        return const LoadingAnimationView();
      default:
        //this shouldn't be called
        return const ErrorAnimationView();


    }
    
    

    return Container();


  }}