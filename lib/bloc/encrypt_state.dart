part of 'encrypt_cubit.dart';

class EncryptState extends Equatable {
  final List<String> shareWith;
  final bool loading;
  final bool encryptToRca;
  final File? inputFile;
  final File? encryptedFile;
  final String? rcaLink;
  final VirtruError? error;

  const EncryptState._({
    required this.shareWith,
    this.loading = false,
    this.encryptToRca = false,
    this.inputFile,
    this.encryptedFile,
    this.rcaLink,
    this.error,
  });

  factory EncryptState.initial() {
    return EncryptState._(shareWith: List.empty(growable: true));
  }

  EncryptState copyWith({
    String? newShareWith,
    String? removeShareWith,
    bool loading = false,
    bool? encryptToRca,
    File? inputFile,
    File? encryptedFile,
    String? rcaLink,
    VirtruError? error,
    bool removeInputFile = false,
  }) {
    final newShareWithList = shareWith.toList();
    if (newShareWith != null) {
      newShareWithList.add(newShareWith);
    }
    if (removeShareWith != null) {
      newShareWithList.remove(removeShareWith);
    }
    return EncryptState._(
      shareWith: newShareWithList,
      loading: loading,
      inputFile: removeInputFile ? null : inputFile ?? this.inputFile,
      encryptToRca: encryptToRca ?? this.encryptToRca,
      encryptedFile: encryptedFile ?? this.encryptedFile,
      rcaLink: rcaLink ?? this.rcaLink,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [shareWith, loading, encryptToRca, inputFile, encryptedFile, error];
}
