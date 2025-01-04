enum DeviceType {
  phone,
  extension
}

extension DeviceTypeExtension on DeviceType {
  DeviceType toDeviceType(String input) {
    switch (input.toUpperCase()) {
      case 'P':
      case 'PHONE':
        return DeviceType.phone;
      case 'E':
      case 'EXTENSION':
        return DeviceType.extension;
      default:
        throw ArgumentError('Invalid device type: $input');
    }
  }

  String get id {
    switch (this) {
      case DeviceType.phone:
        return 'P';
      case DeviceType.extension:
        return 'E';
    }
  }

  String get name {
    switch (this) {
      case DeviceType.phone:
        return 'Phone';
      case DeviceType.extension:
        return 'Extension';
    }
  }
}