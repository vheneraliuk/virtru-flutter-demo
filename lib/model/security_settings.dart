import 'package:equatable/equatable.dart';

class VirtruSecuritySettings extends Equatable {
  final bool persistentProtectionEnabled;
  final bool watermarkEnabled;
  final DateTime? expirationDate;

  factory VirtruSecuritySettings.initial() =>
      const VirtruSecuritySettings._(false, false, null);

  const VirtruSecuritySettings._(
    this.persistentProtectionEnabled,
    this.watermarkEnabled,
    this.expirationDate,
  );

  VirtruSecuritySettings copyWith({
    bool? persistentProtectionEnabled,
    bool? watermarkEnabled,
    DateTime? expirationDate,
    bool removeExpiration = false,
  }) =>
      VirtruSecuritySettings._(
        persistentProtectionEnabled ?? this.persistentProtectionEnabled,
        watermarkEnabled ?? this.watermarkEnabled,
        removeExpiration ? null : expirationDate ?? this.expirationDate,
      );

  @override
  List<Object?> get props => [
        persistentProtectionEnabled,
        watermarkEnabled,
        expirationDate,
      ];
}
