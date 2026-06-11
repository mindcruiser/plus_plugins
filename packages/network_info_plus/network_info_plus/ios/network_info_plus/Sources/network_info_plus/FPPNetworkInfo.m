#import "./include/network_info_plus/FPPNetworkInfo.h"

@implementation FPPNetworkInfo

- (instancetype)initWithSSID:(NSString *)SSID BSSID:(NSString *)BSSID {
  return [self initWithSSID:SSID BSSID:BSSID securityType:nil];
}

- (instancetype)initWithSSID:(NSString *)SSID
                       BSSID:(NSString *)BSSID
                securityType:(NSString *)securityType {
  if ((self = [super init])) {
    _SSID = [SSID copy];
    _BSSID = [BSSID copy];
    _securityType = [securityType copy];
  }
  return self;
}

@end
