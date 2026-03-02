
import 'package:equatable/equatable.dart';

import '../../domain/entities/match_entity.dart';

class WorldCupState extends Equatable {
  final List<MatchEntity> matches;
  final bool isLoading;
  final String? successMessage; // Para avisar "Palpite salvo!"

  const WorldCupState({
    this.matches = const [],
    this.isLoading = false,
    this.successMessage,
  });

  WorldCupState copyWith({
    List<MatchEntity>? matches,
    bool? isLoading,
    String? successMessage,
  }) {
    return WorldCupState(
      matches: matches ?? this.matches,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage, // Se passar null, limpa a mensagem
    );
  }

  @override
  List<Object?> get props => [matches, isLoading, successMessage];
}