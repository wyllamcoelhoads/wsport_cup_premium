import '../../domain/entities/match_entity.dart';

class WorldCupMockData {
  static final List<MatchEntity> matches = [
    // =========================================================================
    // RODADA 1 (Semana 1)
    // =========================================================================
    _createMatch(
      'a1',
      'Mexico',
      'mx',
      'South Africa',
      'za',
      'GROUP A',
      DateTime(2026, 6, 11, 15, 0),
    ),
    _createMatch(
      'a2',
      'South Korea',
      'kr',
      'Playoff EU-D',
      'xx',
      'GROUP A',
      DateTime(2026, 6, 11, 18, 0),
    ),

    _createMatch(
      'b1',
      'Canada',
      'ca',
      'Playoff EU-A',
      'xx',
      'GROUP B',
      DateTime(2026, 6, 12, 16, 0),
    ),
    _createMatch(
      'b2',
      'USA',
      'us',
      'Paraguay',
      'py',
      'GROUP D',
      DateTime(2026, 6, 12, 19, 0),
    ),

    // Estreia do Brasil (Grupo C)
    _createMatch(
      'c1',
      'Brazil',
      'br',
      'Morocco',
      'ma',
      'GROUP C',
      DateTime(2026, 6, 13, 16, 0),
    ),
    _createMatch(
      'c2',
      'Scotland',
      'gb-sct',
      'Haiti',
      'ht',
      'GROUP C',
      DateTime(2026, 6, 13, 19, 0),
    ),

    // =========================================================================
    // RODADA 2 (Semana 2)
    // =========================================================================
    _createMatch(
      'a3',
      'Mexico',
      'mx',
      'South Korea',
      'kr',
      'GROUP A',
      DateTime(2026, 6, 18, 15, 0),
    ),
    _createMatch(
      'a4',
      'South Africa',
      'za',
      'Playoff EU-D',
      'xx',
      'GROUP A',
      DateTime(2026, 6, 18, 18, 0),
    ),

    // 2º Jogo do Brasil (Grupo C)
    _createMatch(
      'c3',
      'Brazil',
      'br',
      'Haiti',
      'ht',
      'GROUP C',
      DateTime(2026, 6, 19, 16, 0),
    ),
    _createMatch(
      'c4',
      'Morocco',
      'ma',
      'Scotland',
      'gb-sct',
      'GROUP C',
      DateTime(2026, 6, 19, 19, 0),
    ),

    // =========================================================================
    // RODADA 3 (Semana 3)
    // =========================================================================
    _createMatch(
      'a5',
      'Mexico',
      'mx',
      'Playoff EU-D',
      'xx',
      'GROUP A',
      DateTime(2026, 6, 24, 15, 0),
    ),
    _createMatch(
      'a6',
      'South Korea',
      'kr',
      'South Africa',
      'za',
      'GROUP A',
      DateTime(2026, 6, 24, 15, 0),
    ),

    // 3º Jogo do Brasil (Grupo C)
    _createMatch(
      'c5',
      'Brazil',
      'br',
      'Scotland',
      'gb-sct',
      'GROUP C',
      DateTime(2026, 6, 24, 16, 0),
    ),
    _createMatch(
      'c6',
      'Morocco',
      'ma',
      'Haiti',
      'ht',
      'GROUP C',
      DateTime(2026, 6, 24, 16, 0),
    ),

    // =========================================================================
    // MATA-MATA (Estrutura de Chaveamento)
    // =========================================================================
    _createMatch(
      'r16_1',
      '1º Grupo A',
      'xx',
      '2º Grupo B',
      'xx',
      'R16',
      DateTime(2026, 6, 28),
    ),
    _createMatch(
      'r16_2',
      '1º Grupo C',
      'xx',
      '2º Grupo D',
      'xx',
      'R16',
      DateTime(2026, 6, 28),
    ),
    _createMatch(
      'r16_3',
      '1º Grupo E',
      'xx',
      '2º Grupo F',
      'xx',
      'R16',
      DateTime(2026, 6, 29),
    ),
    _createMatch(
      'r16_4',
      '1º Grupo G',
      'xx',
      '2º Grupo H',
      'xx',
      'R16',
      DateTime(2026, 6, 29),
    ),
    _createMatch(
      'r16_5',
      '1º Grupo I',
      'xx',
      '2º Grupo J',
      'xx',
      'R16',
      DateTime(2026, 6, 30),
    ),
    _createMatch(
      'r16_6',
      '1º Grupo K',
      'xx',
      '2º Grupo L',
      'xx',
      'R16',
      DateTime(2026, 6, 30),
    ),
    _createMatch(
      'r16_7',
      '2º Grupo A',
      'xx',
      '2º Grupo C',
      'xx',
      'R16',
      DateTime(2026, 7, 1),
    ),
    _createMatch(
      'r16_8',
      '2º Grupo E',
      'xx',
      '2º Grupo G',
      'xx',
      'R16',
      DateTime(2026, 7, 1),
    ),

    _createMatch(
      'qf_1',
      'Venc. Oitavas 1',
      'xx',
      'Venc. Oitavas 2',
      'xx',
      'QF',
      DateTime(2026, 7, 4),
    ),
    _createMatch(
      'qf_2',
      'Venc. Oitavas 3',
      'xx',
      'Venc. Oitavas 4',
      'xx',
      'QF',
      DateTime(2026, 7, 4),
    ),
    _createMatch(
      'qf_3',
      'Venc. Oitavas 5',
      'xx',
      'Venc. Oitavas 6',
      'xx',
      'QF',
      DateTime(2026, 7, 5),
    ),
    _createMatch(
      'qf_4',
      'Venc. Oitavas 7',
      'xx',
      'Venc. Oitavas 8',
      'xx',
      'QF',
      DateTime(2026, 7, 5),
    ),

    _createMatch(
      'sf_1',
      'Venc. Quartas 1',
      'xx',
      'Venc. Quartas 2',
      'xx',
      'SF',
      DateTime(2026, 7, 9),
    ),
    _createMatch(
      'sf_2',
      'Venc. Quartas 3',
      'xx',
      'Venc. Quartas 4',
      'xx',
      'SF',
      DateTime(2026, 7, 10),
    ),

    _createMatch(
      'final',
      'Venc. Semi 1',
      'xx',
      'Venc. Semi 2',
      'xx',
      'FINAL',
      DateTime(2026, 7, 19),
    ),
  ];

  static MatchEntity _createMatch(
    String id,
    String home,
    String hFlag,
    String away,
    String aFlag,
    String group,
    DateTime date,
  ) {
    return MatchEntity(
      id: id,
      homeTeam: home,
      homeFlag: 'https://flagcdn.com/w320/$hFlag.png',
      awayTeam: away,
      awayFlag: 'https://flagcdn.com/w320/$aFlag.png',
      date: date, // <--- Agora usa a data real!
      stadium: 'TBD',
      country: 'TBD',
      location: 'TBD',
      group: group,
      status: 'Scheduled',
    );
  }
}
