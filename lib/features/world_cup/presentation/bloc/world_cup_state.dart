import 'package:equatable/equatable.dart';

import '../../domain/entities/match_entity.dart';

class WorldCupState extends Equatable {
  final List<MatchEntity> matches;
  final bool isLoading;
  final String? successMessage; // Para avisar "Palpite salvo!"
  final String? errorMessage; // Para avisar sobre falta de internet

  const WorldCupState({
    this.matches = const [],
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  WorldCupState copyWith({
    List<MatchEntity>? matches,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WorldCupState(
      matches: matches ?? this.matches,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage, // Se passar null, limpa a mensagem
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [matches, isLoading, successMessage, errorMessage];
}
