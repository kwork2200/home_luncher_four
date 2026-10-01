import 'package:get/get.dart';
import 'package:home_launcher_three/services/screen_analytics_service.dart';
import 'package:home_launcher_three/services/video_service.dart';

class FolderModel {
  final String name;
  final int videoCount;
  final List<String> videoPaths;

  FolderModel({
    required this.name,
    required this.videoCount,
    required this.videoPaths,
  });
}

class FolderListController extends GetxController {
  final RxList<FolderModel> folders = <FolderModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isGridView = false.obs;

  void toggleView() => isGridView.value = !isGridView.value;

  @override
  void onInit() {
    super.onInit();
    ScreenAnalyticsService().logScreenVisit('folder_list_screen');
    fetchFolders();
  }

  Future<void> fetchFolders() async {
    isLoading.value = true;

    try {
      final videos = await VideoService.fetchAllVideos();
      
      // Group videos by folder
      final Map<String, List<String>> folderMap = {};
      
      for (final video in videos) {
        final folderPath = video.path.substring(0, video.path.lastIndexOf('/'));
        final folderName = folderPath.split('/').last;
        
        if (!folderMap.containsKey(folderName)) {
          folderMap[folderName] = [];
        }
        folderMap[folderName]!.add(video.path);
      }
      
      // Convert to FolderModel list
      final folderList = folderMap.entries.map((entry) {
        return FolderModel(
          name: entry.key,
          videoCount: entry.value.length,
          videoPaths: entry.value,
        );
      }).toList();
      
      folders.assignAll(folderList);
    } catch (e) {
      print('Error fetching folders: $e');
      folders.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToFolder(String folderName) {
    Get.toNamed('/folder-videos', parameters: {'folderName': folderName});
  }
}
