import 'package:home_launcher_four/modules/twitter/twitter_downloader_controller.dart';
import 'package:get/get.dart';

class TwitterDownloaderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TwitterDownloaderController>(() => TwitterDownloaderController());
  }
}
