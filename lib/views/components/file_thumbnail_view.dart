import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/views/components/animations/loading_animation_view.dart';
import 'package:instantgram/views/components/animations/small_error_animation_view.dart';

import '../../state/image_upload/models/thumbnail_request.dart';
import '../../state/image_upload/providers/thumbnail_provider.dart';

class FileThumbnailView extends ConsumerWidget{
  final ThumbnailRequest thumbnailRequest;
  const FileThumbnailView({super.key, required this.thumbnailRequest });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnail = ref.watch(thumbnailProvider(
      thumbnailRequest,
    ));
    return thumbnail.when(
      data: (imageAspectRatio){
        return AspectRatio(
          aspectRatio: imageAspectRatio.aspectRatio,
          child: imageAspectRatio.image,
        );
      },
      loading: (){
        return const LoadingAnimationView();
      },
      error: (error, stackTrace){
        return const SmallErrorAnimationView();
      },
    );
  }
}

