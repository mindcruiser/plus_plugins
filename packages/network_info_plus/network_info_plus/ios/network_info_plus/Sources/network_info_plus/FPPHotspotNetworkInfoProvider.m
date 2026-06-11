#import "./include/network_info_plus/FPPHotspotNetworkInfoProvider.h"
#import <NetworkExtension/NetworkExtension.h>

@implementation FPPHotspotNetworkInfoProvider

static NSString *
FPPStringFromHotspotSecurityType(NEHotspotNetworkSecurityType securityType)
    API_AVAILABLE(ios(15.0)) {
  switch (securityType) {
  case NEHotspotNetworkSecurityTypeOpen:
    return @"open";
  case NEHotspotNetworkSecurityTypeWEP:
    return @"wep";
  case NEHotspotNetworkSecurityTypePersonal:
    return @"personal";
  case NEHotspotNetworkSecurityTypeEnterprise:
    return @"enterprise";
  case NEHotspotNetworkSecurityTypeUnknown:
    return @"unknown";
  }

  return @"unknown";
}

- (void)fetchNetworkInfoWithCompletionHandler:
    (void (^)(FPPNetworkInfo *network))completionHandler
    API_AVAILABLE(ios(14)) {
  [NEHotspotNetwork fetchCurrentWithCompletionHandler:^(
                        NEHotspotNetwork *network) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (network) {
        NSString *securityType = nil;
        if (@available(iOS 15.0, *)) {
          securityType = FPPStringFromHotspotSecurityType(network.securityType);
        }
        completionHandler([[FPPNetworkInfo alloc] initWithSSID:network.SSID
                                                         BSSID:network.BSSID
                                                  securityType:securityType]);
        return;
      }
      completionHandler(nil);
    });
  }];
}

@end
