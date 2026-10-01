import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_launcher_three/modules/all_video/model/all_video_model.dart';
import 'package:home_launcher_three/utils/app_colors.dart';
import 'package:home_launcher_three/utils/app_dimensions.dart';
import 'package:home_launcher_three/utils/app_font_size.dart';
import 'package:home_launcher_three/widgets/common/common_text.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as vt;
import 'package:path_provider/path_provider.dart';

class VideoThumbnail extends StatelessWidget {
  final AllVideoItem item;
  final double width;
  final double height;

  const VideoThumbnail({
    super.key,
    required this.item,
    required this.width,
    required this.height,
  });

  Future<String?> _generateThumbnail() async {
    try {
      final tempDir = await getTemporaryDirectory();
      return await vt.VideoThumbnail.thumbnailFile(
        video: item.path,
        thumbnailPath: tempDir.path,
        imageFormat: vt.ImageFormat.JPEG,
        maxHeight: 300,
        quality: 75,
      );
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<String?>(
              future: _generateThumbnail(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return Image.file(
                    File(snapshot.data!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black12,
                        child: Icon(Icons.videocam, size: 48.sp, color: Colors.grey),
                      );
                    },
                  );
                }
                return Container(
                  color: Colors.black12,
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator(strokeWidth: 2))
                      : Icon(Icons.videocam, size: 48.sp, color: Colors.grey),
                );
              },
            ),
            Positioned(
              right: 4.w,
              bottom: 4.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                color: Colors.black54,
                child: CommonText(
                  text: item.durationText,
                  fontSize: AppFontSize.fontSmall,
                  color: AppColors.backgroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
