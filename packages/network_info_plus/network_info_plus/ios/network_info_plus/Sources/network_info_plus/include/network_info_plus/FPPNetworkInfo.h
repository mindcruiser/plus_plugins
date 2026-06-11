#import <Foundation/Foundation.h>

@interface FPPNetworkInfo : NSObject

@property(nonatomic, readonly) NSString *SSID;
@property(nonatomic, readonly) NSString *BSSID;
@property(nonatomic, readonly) NSString *securityType;

- (instancetype)initWithSSID:(NSString *)SSID BSSID:(NSString *)BSSID;
- (instancetype)initWithSSID:(NSString *)SSID
                       BSSID:(NSString *)BSSID
                securityType:(NSString *)securityType;

@end
