enum DeviceType {
  PHONE,
  EXTENSION
}

extension DeviceTypeExtension on DeviceType {
  DeviceType toDeviceType(String input) {
    switch (input.toUpperCase()) {
      case 'P':
      case 'PHONE':
        return DeviceType.PHONE;
      case 'E':
      case 'EXTENSION':
        return DeviceType.EXTENSION;
      default:
        throw ArgumentError('Invalid device type: $input');
    }
  }

  String get id {
    switch (this) {
      case DeviceType.PHONE:
        return 'P';
      case DeviceType.EXTENSION:
        return 'E';
    }
  }

  String get name {
    switch (this) {
      case DeviceType.PHONE:
        return 'Phone';
      case DeviceType.EXTENSION:
        return 'Extension';
    }
  }
}