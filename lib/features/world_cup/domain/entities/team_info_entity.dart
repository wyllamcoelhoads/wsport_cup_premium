class TeamInfoEntity {
  final String id; // document ID no Firestore (ex: 'br', 'ar', 'fr')
  final String name;
  final String flagCode; // código para flagcdn.com
  final String coatOfArmsUrl; // URL do brasão oficial
  final String coach; // treinador
  final String captain; // capitão
  final String uniformHomeUrl; // imagem do uniforme titular
  final String uniformAwayUrl; // imagem do uniforme reserva
  final String confederation; // UEFA, CONMEBOL, etc.
  final String nickname; // apelido da seleção
  final int fifaRanking;
  final int founded; // ano de fundação da federação
  final int worldCupAppearances; // total de participações em Copas
  final int worldCupWins; // títulos conquistados
  final List<int> worldCupYears; // anos de todas as participações
  final List<int> worldCupTitlesYears; // anos dos títulos
  final String? bio; // descrição curta

  const TeamInfoEntity({
    required this.id,
    required this.name,
    required this.flagCode,
    required this.coatOfArmsUrl,
    required this.coach,
    required this.captain,
    required this.uniformHomeUrl,
    required this.uniformAwayUrl,
    required this.confederation,
    required this.nickname,
    required this.fifaRanking,
    required this.founded,
    required this.worldCupAppearances,
    required this.worldCupWins,
    required this.worldCupYears,
    required this.worldCupTitlesYears,
    this.bio,
  });

  factory TeamInfoEntity.fromMap(String id, Map<String, dynamic> map) {
    return TeamInfoEntity(
      id: id,
      name: map['name'] as String? ?? '',
      flagCode: map['flagCode'] as String? ?? '',
      coatOfArmsUrl: map['coatOfArmsUrl'] as String? ?? '',
      coach: map['coach'] as String? ?? 'A confirmar',
      captain: map['captain'] as String? ?? 'A confirmar',
      uniformHomeUrl: map['uniformHomeUrl'] as String? ?? '',
      uniformAwayUrl: map['uniformAwayUrl'] as String? ?? '',
      confederation: map['confederation'] as String? ?? '',
      nickname: map['nickname'] as String? ?? '',
      fifaRanking: (map['fifaRanking'] as num?)?.toInt() ?? 0,
      founded: (map['founded'] as num?)?.toInt() ?? 0,
      worldCupAppearances: (map['worldCupAppearances'] as num?)?.toInt() ?? 0,
      worldCupWins: (map['worldCupWins'] as num?)?.toInt() ?? 0,
      worldCupYears: (map['worldCupYears'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toInt())
          .toList(),
      worldCupTitlesYears: (map['worldCupTitlesYears'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toInt())
          .toList(),
      bio: map['bio'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'flagCode': flagCode,
      'coatOfArmsUrl': coatOfArmsUrl,
      'coach': coach,
      'captain': captain,
      'uniformHomeUrl': uniformHomeUrl,
      'uniformAwayUrl': uniformAwayUrl,
      'confederation': confederation,
      'nickname': nickname,
      'fifaRanking': fifaRanking,
      'founded': founded,
      'worldCupAppearances': worldCupAppearances,
      'worldCupWins': worldCupWins,
      'worldCupYears': worldCupYears,
      'worldCupTitlesYears': worldCupTitlesYears,
      'bio': bio,
    };
  }
}
