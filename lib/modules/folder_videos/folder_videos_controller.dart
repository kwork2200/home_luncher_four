import 'dart:io';
import 'package:get/get.dart';
import 'package:home_launcher_four/modules/all_video/model/all_video_model.dart';
import 'package:home_launcher_four/modules/all_video/video_controller_interface.dart';
import 'package:home_launcher_four/services/screen_analytics_service.dart';
import 'package:home_launcher_four/services/video_service.dart';

class FolderVideosController extends VideoControllerInterface {
  final RxList<AllVideoItem> allVideos = <AllVideoItem>[].obs;
  final RxList<AllVideoItem> displayedVideos = <AllVideoItem>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isGridView = false.obs;
  final Rx<SortType> currentSort = SortType.dateNewOld.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;
  
  final String folderName;

  FolderVideosController({required this.folderName});

  void startSearch() {
    isSearching.value = true;
  }

  void stopSearch() {
    isSearching.value = false;
    searchQuery.value = '';
    displayedVideos.assignAll(allVideos);
    _applySort();
  }

  @override
  void onInit() {
    super.onInit();
    ScreenAnalyticsService().logScreenVisit('folder_videos_screen');
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    isLoading.value = true;

    try {
      final allDeviceVideos = await VideoService.fetchAllVideos();
      
      // Filter videos by folder name
      final folderVideos = allDeviceVideos.where((video) {
        final videoFolderName = video.path.substring(0, video.path.lastIndexOf('/')).split('/').last;
        return videoFolderName == folderName;
      }).toList();

      allVideos.assignAll(folderVideos);
      _applySort();
    } catch (e) {
      print('Error fetching folder videos: $e');
      allVideos.clear();
      displayedVideos.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleView() => isGridView.value = !isGridView.value;

  void setSort(SortType type) {
    currentSort.value = type;
    _applySort();
  }

  void _applySort() {
    final list = List<AllVideoItem>.from(allVideos);
    switch (currentSort.value) {
      case SortType.dateNewOld:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortType.dateOldNew:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortType.nameAZ:
        list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortType.nameZA:
        list.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case SortType.sizeSmallBig:
        list.sort((a, b) => a.fileSizeBytes.compareTo(b.fileSizeBytes));
        break;
      case SortType.sizeBigSmall:
        list.sort((a, b) => b.fileSizeBytes.compareTo(a.fileSizeBytes));
        break;
    }
    displayedVideos.assignAll(list);
    if (searchQuery.value.isNotEmpty) {
      search(searchQuery.value);
    }
  }

  void search(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      displayedVideos.assignAll(allVideos);
      _applySort();
      return;
    }
    final lower = query.toLowerCase();
    final filtered = allVideos.where((v) => v.title.toLowerCase().contains(lower)).toList();
    displayedVideos.assignAll(filtered);
    _applySortToDisplayedList();
  }

  void _applySortToDisplayedList() {
    final list = List<AllVideoItem>.from(displayedVideos);
    switch (currentSort.value) {
      case SortType.dateNewOld:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortType.dateOldNew:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortType.nameAZ:
        list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortType.nameZA:
        list.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case SortType.sizeSmallBig:
        list.sort((a, b) => a.fileSizeBytes.compareTo(b.fileSizeBytes));
        break;
      case SortType.sizeBigSmall:
        list.sort((a, b) => b.fileSizeBytes.compareTo(a.fileSizeBytes));
        break;
    }
    displayedVideos.assignAll(list);
  }

  Future<bool> deleteVideo(AllVideoItem item) async {
    final success = await VideoService.deleteVideo(item.path);
    if (success) {
      allVideos.removeWhere((v) => v.path == item.path);
      displayedVideos.removeWhere((v) => v.path == item.path);
      return true;
    }
    return false;
  }

  Future<File?> getFile(AllVideoItem item) async {
    final file = File(item.path);
    return await file.exists() ? file : null;
  }
}
