/// The status of the location service authorization.
enum LocationAuthorizationStatus {
  /// The authorization of the location service is not determined.
  notDetermined,

  /// This app is not authorized to use location.
  restricted,

  /// User explicitly denied the location service.
  denied,

  /// User authorized the app to access the location at any time.
  authorizedAlways,

  /// User authorized the app to access the location when the app is visible to them.
  authorizedWhenInUse,

  /// Status unknown.
  unknown,
}

/// The security type of the connected wifi network.
enum WifiSecurityType {
  /// An open network.
  open,

  /// A WEP network.
  wep,

  /// A personal network.
  personal,

  /// An enterprise network.
  enterprise,

  /// A WPA personal network.
  wpaPersonal,

  /// A WPA enterprise network.
  wpaEnterprise,

  /// A WPA2 personal network.
  wpa2Personal,

  /// A WPA2 enterprise network.
  wpa2Enterprise,

  /// A WPA3 personal network.
  wpa3Personal,

  /// A WPA3 enterprise network.
  wpa3Enterprise,

  /// A WPA3 enterprise 192-bit network.
  wpa3Enterprise192Bit,

  /// A WPA3 transition network.
  wpa3Transition,

  /// An OWE network.
  owe,

  /// An OWE transition network.
  oweTransition,

  /// A WAPI PSK network.
  wapiPsk,

  /// A WAPI certificate network.
  wapiCert,

  /// A Passpoint R1/R2 network.
  passpointR1R2,

  /// A Passpoint R3 network.
  passpointR3,

  /// A DPP network.
  dpp,

  /// Security type unknown.
  unknown,
}

/// Parses a wifi security type from an enum name.
WifiSecurityType? wifiSecurityTypeFromString(String? value) {
  if (value == null) {
    return null;
  }

  for (final type in WifiSecurityType.values) {
    if (type.name == value) {
      return type;
    }
  }

  return WifiSecurityType.unknown;
}
