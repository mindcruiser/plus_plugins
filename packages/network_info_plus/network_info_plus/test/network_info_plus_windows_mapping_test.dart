import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus/src/network_info_plus_windows.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:win32/win32.dart';

void main() {
  test('maps security enabled open authentication to WEP', () {
    final plugin = NetworkInfoPlusWindowsPlugin();

    expect(
      plugin.securityTypeFromDot11AuthAlgorithm(
        securityEnabled: true,
        authAlgorithm: DOT11_AUTH_ALGO_80211_OPEN,
      ),
      WifiSecurityType.wep,
    );
  });
}
