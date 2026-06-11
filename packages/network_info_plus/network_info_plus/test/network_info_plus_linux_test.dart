@TestOn('linux')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:nm/nm.dart';

void main() {
  test('registered instance', () {
    NetworkInfoPlusLinuxPlugin.registerWith();
    expect(NetworkInfoPlatform.instance, isA<NetworkInfoPlusLinuxPlugin>());
  });

  group('securityTypeFromNetworkManagerFlags', () {
    late NetworkInfoPlusLinuxPlugin plugin;

    setUp(() {
      plugin = NetworkInfoPlusLinuxPlugin();
    });

    test('maps open access point flags', () {
      expect(
        plugin.securityTypeFromNetworkManagerFlags(
          flags: <NetworkManagerWifiAccessPointFlag>[],
          wpaFlags: <NetworkManagerWifiAccessPointSecurityFlag>[],
          rsnFlags: <NetworkManagerWifiAccessPointSecurityFlag>[],
        ),
        WifiSecurityType.open,
      );
    });

    test('maps WEP privacy flag without WPA or RSN flags', () {
      expect(
        plugin.securityTypeFromNetworkManagerFlags(
          flags: <NetworkManagerWifiAccessPointFlag>[
            NetworkManagerWifiAccessPointFlag.privacy,
          ],
          wpaFlags: <NetworkManagerWifiAccessPointSecurityFlag>[],
          rsnFlags: <NetworkManagerWifiAccessPointSecurityFlag>[],
        ),
        WifiSecurityType.wep,
      );
    });

    test('maps RSN security flags', () {
      final testCases =
          <(NetworkManagerWifiAccessPointSecurityFlag, WifiSecurityType)>[
            (
              NetworkManagerWifiAccessPointSecurityFlag.keyManagementSae,
              WifiSecurityType.wpa3Personal,
            ),
            (
              NetworkManagerWifiAccessPointSecurityFlag.keyManagementOwe,
              WifiSecurityType.owe,
            ),
            (
              NetworkManagerWifiAccessPointSecurityFlag.keyManagementOweTm,
              WifiSecurityType.oweTransition,
            ),
            (
              NetworkManagerWifiAccessPointSecurityFlag.keyManagement802_1X,
              WifiSecurityType.wpa2Enterprise,
            ),
            (
              NetworkManagerWifiAccessPointSecurityFlag.keyManagementPsk,
              WifiSecurityType.wpa2Personal,
            ),
          ];

      for (final (flag, securityType) in testCases) {
        expect(
          plugin.securityTypeFromNetworkManagerFlags(
            flags: <NetworkManagerWifiAccessPointFlag>[
              NetworkManagerWifiAccessPointFlag.privacy,
            ],
            wpaFlags: <NetworkManagerWifiAccessPointSecurityFlag>[],
            rsnFlags: <NetworkManagerWifiAccessPointSecurityFlag>[flag],
          ),
          securityType,
        );
      }
    });

    test('maps WPA security flags', () {
      final testCases =
          <(NetworkManagerWifiAccessPointSecurityFlag, WifiSecurityType)>[
            (
              NetworkManagerWifiAccessPointSecurityFlag.keyManagement802_1X,
              WifiSecurityType.wpaEnterprise,
            ),
            (
              NetworkManagerWifiAccessPointSecurityFlag.keyManagementPsk,
              WifiSecurityType.wpaPersonal,
            ),
          ];

      for (final (flag, securityType) in testCases) {
        expect(
          plugin.securityTypeFromNetworkManagerFlags(
            flags: <NetworkManagerWifiAccessPointFlag>[
              NetworkManagerWifiAccessPointFlag.privacy,
            ],
            wpaFlags: <NetworkManagerWifiAccessPointSecurityFlag>[flag],
            rsnFlags: <NetworkManagerWifiAccessPointSecurityFlag>[],
          ),
          securityType,
        );
      }
    });

    test('maps privacy with unrelated security flags to unknown', () {
      expect(
        plugin.securityTypeFromNetworkManagerFlags(
          flags: <NetworkManagerWifiAccessPointFlag>[
            NetworkManagerWifiAccessPointFlag.privacy,
          ],
          wpaFlags: <NetworkManagerWifiAccessPointSecurityFlag>[
            NetworkManagerWifiAccessPointSecurityFlag.pairCcmp,
          ],
          rsnFlags: <NetworkManagerWifiAccessPointSecurityFlag>[],
        ),
        WifiSecurityType.unknown,
      );
    });
  });
}
