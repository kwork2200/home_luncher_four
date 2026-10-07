import 'package:get/get.dart';
import 'package:home_launcher_four/modules/folder_list/folder_list_controller.dart';

class FolderListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FolderListController>(() => FolderListController());
  }
}
