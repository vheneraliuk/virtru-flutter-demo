part of 'decrypt_cubit.dart';

class DecryptState extends Equatable {
  final bool loading;
  final XFile? inputFile;
  final XFile? decryptedFile;
  final String? decryptedString;
  final VirtruError? error;

  const DecryptState._({
    this.loading = false,
    this.inputFile,
    this.decryptedFile,
    this.decryptedString,
    this.error,
  });

  factory DecryptState.initial() {
    return const DecryptState._();
  }

  DecryptState copyWith({
    bool loading = false,
    XFile? inputFile,
    XFile? decryptedFile,
    String? decryptedString,
    VirtruError? error,
    bool removeInputFile = false,
  }) {
    return DecryptState._(
      loading: loading,
      inputFile: removeInputFile ? null : inputFile ?? this.inputFile,
      decryptedFile: decryptedFile ?? this.decryptedFile,
      decryptedString: decryptedString ?? this.decryptedString,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        inputFile,
        decryptedString,
        decryptedFile,
        error,
      ];
}
