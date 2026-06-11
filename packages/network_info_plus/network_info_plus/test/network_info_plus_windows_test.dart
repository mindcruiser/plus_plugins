@TestOn('windows')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:win32/win32.dart';

void main() {
  test('registered instance', () {
    NetworkInfoPlusWindowsPlugin.registerWith();
    expect(NetworkInfoPlatform.instance, isA<NetworkInfoPlusWindowsPlugin>());
  });

  test('Test BSSID', () async {
    final plugin = NetworkInfoPlusWindowsPlugin();
    final bssID = await plugin.getWifiBSSID();
    expect(bssID, matches(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$'));
  });

  test('Wifi name', () async {
    final plugin = NetworkInfoPlusWindowsPlugin();
    final wifiName = await plugin.getWifiName();
    expect(wifiName, isNotEmpty);
  });

  test('IP Address', () async {
    final plugin = NetworkInfoPlusWindowsPlugin();
    final ipAddress = await plugin.getWifiIP();
    expect(
      ipAddress,
      matches(
        r'^(?=\d+\.\d+\.\d+\.\d+$)(?:(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])\.?){4}$',
      ),
    );
  });

  test('maps DOT11 auth algorithms to wifi security types', () {
    final plugin = NetworkInfoPlusWindowsPlugin();
    final cases =
        <
          ({bool securityEnabled, int authAlgorithm, WifiSecurityType expected})
        >[
          (
            securityEnabled: false,
            authAlgorithm: DOT11_AUTH_ALGO_80211_OPEN,
            expected: WifiSecurityType.open,
          ),
          (
            securityEnabled: true,
            authAlgorithm: DOT11_AUTH_ALGO_80211_OPEN,
            expected: WifiSecurityType.wep,
          ),
          (
            securityEnabled: true,
            authAlgorithm: DOT11_AUTH_ALGO_80211_SHARED_KEY,
            expected: WifiSecurityType.wep,
          ),
          (
            securityEnabled: true,
            authAlgorithm: DOT11_AUTH_ALGO_WPA,
            expected: WifiSecurityType.wpaEnterprise,
          ),
          (
            securityEnabled: true,
            authAlgorithm: DOT11_AUTH_ALGO_WPA_PSK,
            expected: WifiSecurityType.wpaPersonal,
          ),
          (
            securityEnabled: true,
            authAlgorithm: DOT11_AUTH_ALGO_RSNA,
            expected: WifiSecurityType.wpa2Enterprise,
          ),
          (
            securityEnabled: true,
            authAlgorithm: DOT11_AUTH_ALGO_RSNA_PSK,
            expected: WifiSecurityType.wpa2Personal,
          ),
          (
            securityEnabled: true,
            authAlgorithm: DOT11_AUTH_ALGO_WPA3,
            expected: WifiSecurityType.wpa3Enterprise192Bit,
          ),
          (
            securityEnabled: true,
            authAlgorithm: DOT11_AUTH_ALGO_WPA3_ENT,
            expected: WifiSecurityType.wpa3Enterprise,
          ),
          (
            securityEnabled: true,
            authAlgorithm: DOT11_AUTH_ALGO_WPA3_ENT_192,
            expected: WifiSecurityType.wpa3Enterprise192Bit,
          ),
          (
            securityEnabled: true,
            authAlgorithm: DOT11_AUTH_ALGO_WPA3_SAE,
            expected: WifiSecurityType.wpa3Personal,
          ),
          (
            securityEnabled: true,
            authAlgorithm: DOT11_AUTH_ALGO_OWE,
            expected: WifiSecurityType.owe,
          ),
          (
            securityEnabled: true,
            authAlgorithm: 9999,
            expected: WifiSecurityType.unknown,
          ),
        ];

    for (final testCase in cases) {
      expect(
        plugin.securityTypeFromDot11AuthAlgorithm(
          securityEnabled: testCase.securityEnabled,
          authAlgorithm: testCase.authAlgorithm,
        ),
        testCase.expected,
      );
    }
  });
}
