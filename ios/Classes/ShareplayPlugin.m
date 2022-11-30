#import "ShareplayPlugin.h"
#if __has_include(<shareplay/shareplay-Swift.h>)
#import <shareplay/shareplay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "shareplay-Swift.h"
#endif

@implementation ShareplayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftShareplayPlugin registerWithRegistrar:registrar];
}
@end
