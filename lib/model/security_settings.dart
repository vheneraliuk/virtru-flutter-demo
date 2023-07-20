import 'package:equatable/equatable.dart';

class SecuritySettings extends Equatable {
  final bool persistentProtectionEnabled;
  final bool watermarkEnabled;
  final DateTime? expirationDate;

  factory SecuritySettings.initial() =>
      const SecuritySettings._(false, false, null);

  const SecuritySettings._(
    this.persistentProtectionEnabled,
    this.watermarkEnabled,
    this.expirationDate,
  );

  SecuritySettings copyWith({
    bool? persistentProtectionEnabled,
    bool? watermarkEnabled,
    DateTime? expirationDate,
    bool removeExpiration = false,
  }) =>
      SecuritySettings._(
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
