
import 'shareplay_platform_interface.dart';

class Shareplay {
  Future<bool> isSharePlayAvailable() {
    return ShareplayPlatform.instance.isSharePlayAvailable();
  }
}
