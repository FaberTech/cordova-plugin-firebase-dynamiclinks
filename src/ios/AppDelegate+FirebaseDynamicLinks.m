#import "AppDelegate+FirebaseDynamicLinks.h"
#import "FirebaseDynamicLinks.h"
@import Firebase;
@import FirebaseInvites;
@import GoogleSignIn;

@implementation AppDelegate (FirebasePlugin)

// [START openurl]
- (BOOL)application:(nonnull UIApplication *)application
            openURL:(nonnull NSURL *)url
            options:(nonnull NSDictionary<NSString *, id> *)options {
  if ([FirebaseDynamicLinks.instance isSigningIn]) {
    [FirebaseDynamicLinks.instance isSigningIn:NO];

    return [[GIDSignIn sharedInstance] handleURL:url
             sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                    annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
  } else {
    // call super
    return [self identity_application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
  }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  // Handle App Invite requests
  FIRReceivedInvite *invite =
      [FIRInvites handleURL:url sourceApplication:sourceApplication annotation:annotation];
  if (invite) {
    NSString *matchType = (invite.matchType == FIRReceivedInviteMatchTypeWeak) ? @"Weak" : @"Strong";
    [FirebaseDynamicLinks.instance sendDynamicLinkData:@{
                                   @"deepLink": invite.deepLink,
                                   @"invitationId": invite.inviteId,
                                   @"matchType": matchType
                                   }];
    return YES;
  }

  FIRDynamicLink *dynamicLink =
    [[FIRDynamicLinks dynamicLinks] dynamicLinkFromCustomSchemeURL:url];
  if (dynamicLink) {
      NSString *matchType = (dynamicLink.matchConfidence == FIRDynamicLinkMatchConfidenceWeak) ? @"Weak" : @"Strong";
      [FirebaseDynamicLinks.instance sendDynamicLinkData:@{
                                     @"deepLink": dynamicLink.url.absoluteString,
                                     @"matchType": matchType
                                   }];

      return YES;
  }

  if ([FirebaseDynamicLinks.instance isSigningIn]) {
    [FirebaseDynamicLinks.instance isSigningIn:NO];

    return [[GIDSignIn sharedInstance] handleURL:url
                             sourceApplication:sourceApplication
                                    annotation:annotation];
  } else {
    // call super
    return [self application:app openURL:url
            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
            annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
  }
}
// [END openurl]

// [START continueuseractivity]
- (BOOL)application:(UIApplication *)application
    continueUserActivity:(NSUserActivity *)userActivity
      restorationHandler:(void (^)(NSArray *))restorationHandler {
  BOOL handled = [[FIRDynamicLinks dynamicLinks]
                     handleUniversalLink:userActivity.webpageURL
                              completion:^(FIRDynamicLink * _Nullable dynamicLink,
                                           NSError * _Nullable error) {
    // [START_EXCLUDE]
    NSString *matchType = (dynamicLink.matchConfidence == FIRDynamicLinkMatchConfidenceWeak) ? @"Weak" : @"Strong";
    [FirebaseDynamicLinks.instance sendDynamicLinkData:@{
                                     @"deepLink": dynamicLink.url.absoluteString,
                                     @"matchType": matchType
                                   }];
    // [END_EXCLUDE]
  }];

  return handled;
}
// [END continueuseractivity]

@end
