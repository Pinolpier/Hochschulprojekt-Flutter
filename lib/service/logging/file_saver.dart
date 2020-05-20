import 'package:path_provider/path_provider.dart';

class FileSaver {
  static Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    print(dir.toString());
  }
}
