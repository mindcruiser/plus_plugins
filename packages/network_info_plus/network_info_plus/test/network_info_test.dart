// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:mockito/mockito.dart';

const String kWifiNameResult = '1337wifi';
const String kWifiBSSIDResult = 'c0:ff:33:c0:d3:55';
const String kWifiIpAddressResult = '127.0.0.1';
const String kWifiIpV6 = '2002:7f00:0001:0:0:0:0:0';
const String kWifiBroadcast = '127.0.0.255';
const String kWifiGatewayIP = '127.0.0.0';
const String kWifiSubmask = '255.255.255.0';
const WifiSecurityType kWifiSecurityTypeResult = WifiSecurityType.wpa3Personal;
const LocationAuthorizationStatus kRequestLocationResult =
    LocationAuthorizationStatus.authorizedAlways;
const LocationAuthorizationStatus kGetLocationResult =
    LocationAuthorizationStatus.authorizedAlways;

void main() {
  group('NetworkInfo', () {
    late NetworkInfo networkInfo;
    late MockNetworkInfoPlatform fakePlatform;
    setUp(() async {
      fakePlatform = MockNetworkInfoPlatform();
      NetworkInfoPlatform.instance = fakePlatform;
      networkInfo = NetworkInfo();
    });

    test('getWifiName', () async {
      final result = await networkInfo.getWifiName();
      expect(result, kWifiNameResult);
    });

    test('getWifiBSSID', () async {
      final result = await networkInfo.getWifiBSSID();
      expect(result, kWifiBSSIDResult);
    });

    test('getWifiIP', () async {
      final result = await networkInfo.getWifiIP();
      expect(result, kWifiIpAddressResult);
    });

    test('getWifiBroadcast', () async {
      final result = await networkInfo.getWifiBroadcast();
      expect(result, kWifiBroadcast);
    });

    test('getWifiIPv6', () async {
      final result = await networkInfo.getWifiIPv6();
      expect(result, kWifiIpV6);
    });

    test('getWifiSubmask', () async {
      final result = await networkInfo.getWifiSubmask();
      expect(result, kWifiSubmask);
    });

    test('getWifiGatewayIP', () async {
      final result = await networkInfo.getWifiGatewayIP();
      expect(result, kWifiGatewayIP);
    });

    test('getWifiSecurityType delegates to platform', () async {
      final result = await networkInfo.getWifiSecurityType();
      expect(result, kWifiSecurityTypeResult);
    });

    test('isWifiSecure returns false for open security', () async {
      fakePlatform.wifiSecurityType = WifiSecurityType.open;

      final result = await networkInfo.isWifiSecure();

      expect(result, isFalse);
    });

    test('isWifiSecure returns true for known non-open security', () async {
      fakePlatform.wifiSecurityType = WifiSecurityType.wpa3Personal;

      final result = await networkInfo.isWifiSecure();

      expect(result, isTrue);
    });

    test('isWifiSecure returns null for unknown security', () async {
      fakePlatform.wifiSecurityType = WifiSecurityType.unknown;

      final result = await networkInfo.isWifiSecure();

      expect(result, isNull);
    });

    test(
      'isWifiSecure returns null when security type is unavailable',
      () async {
        fakePlatform.wifiSecurityType = null;

        final result = await networkInfo.isWifiSecure();

        expect(result, isNull);
      },
    );
  });
}

class MockNetworkInfoPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements NetworkInfoPlatform {
  WifiSecurityType? wifiSecurityType = kWifiSecurityTypeResult;

  @override
  Future<String> getWifiName() async {
    return kWifiNameResult;
  }

  @override
  Future<String> getWifiBSSID() async {
    return kWifiBSSIDResult;
  }

  @override
  Future<String> getWifiGatewayIP() async {
    return kWifiGatewayIP;
  }

  @override
  Future<String> getWifiSubmask() async {
    return kWifiSubmask;
  }

  @override
  Future<String> getWifiIPv6() async {
    return kWifiIpV6;
  }

  @override
  Future<String> getWifiBroadcast() async {
    return kWifiBroadcast;
  }

  @override
  Future<String> getWifiIP() async {
    return kWifiIpAddressResult;
  }

  @override
  Future<WifiSecurityType?> getWifiSecurityType() async {
    return wifiSecurityType;
  }
}
