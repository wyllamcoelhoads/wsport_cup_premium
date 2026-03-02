import '../../domain/entities/match_entity.dart';

class WorldCupMockData {
  static final List<MatchEntity> matches = [
    // =========================================================================
    // FASE DE GRUPOS (12 Grupos - 48 Seleções)
    // =========================================================================
    _createMatch('a1', 'Mexico', 'mx', 'South Africa', 'za', 'GROUP A'),
    _createMatch('a2', 'South Korea', 'kr', 'Denmark', 'dk', 'GROUP A'),
    _createMatch('b1', 'Canada', 'ca', 'Switzerland', 'ch', 'GROUP B'),
    _createMatch('b2', 'Qatar', 'qa', 'Norway', 'no', 'GROUP B'),
    _createMatch('c1', 'Brazil', 'br', 'Morocco', 'ma', 'GROUP C'),
    _createMatch('c2', 'Haiti', 'ht', 'Scotland', 'gb-sct', 'GROUP C'),
    _createMatch('d1', 'USA', 'us', 'Paraguay', 'py', 'GROUP D'),
    _createMatch('d2', 'Australia', 'au', 'Poland', 'pl', 'GROUP D'),
    _createMatch('e1', 'Germany', 'de', 'Ecuador', 'ec', 'GROUP E'),
    _createMatch('e2', 'Ivory Coast', 'ci', 'Curacao', 'cw', 'GROUP E'),
    _createMatch('f1', 'Netherlands', 'nl', 'Japan', 'jp', 'GROUP F'),
    _createMatch('f2', 'Tunisia', 'tn', 'Ukraine', 'ua', 'GROUP F'),
    _createMatch('g1', 'Belgium', 'be', 'Egypt', 'eg', 'GROUP G'),
    _createMatch('g2', 'Iran', 'ir', 'New Zealand', 'nz', 'GROUP G'),
    _createMatch('h1', 'Spain', 'es', 'Uruguay', 'uy', 'GROUP H'),
    _createMatch('h2', 'Saudi Arabia', 'sa', 'Cape Verde', 'cv', 'GROUP H'),
    _createMatch('i1', 'France', 'fr', 'Senegal', 'sn', 'GROUP I'),
    _createMatch('i2', 'Nigeria', 'ng', 'Peru', 'pe', 'GROUP I'),
    _createMatch('j1', 'Argentina', 'ar', 'Austria', 'at', 'GROUP J'),
    _createMatch('j2', 'Algeria', 'dz', 'Jordan', 'jo', 'GROUP J'),
    _createMatch('k1', 'Portugal', 'pt', 'Colombia', 'co', 'GROUP K'),
    _createMatch('k2', 'Uzbekistan', 'uz', 'Costa Rica', 'cr', 'GROUP K'),
    _createMatch('l1', 'England', 'gb-eng', 'Croatia', 'hr', 'GROUP L'),
    _createMatch('l2', 'Ghana', 'gh', 'Panama', 'pa', 'GROUP L'),

    // =========================================================================
    // MATA-MATA (Caminho oficial de 48 times)
    // =========================================================================

    // --- ROUND OF 32 (16 jogos obrigatórios) ---
    _createMatch('r32_1', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_2', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_3', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_4', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_5', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_6', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_7', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_8', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_9', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_10', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_11', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_12', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_13', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_14', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_15', 'A definir', 'un', 'A definir', 'un', 'R32'),
    _createMatch('r32_16', 'A definir', 'un', 'A definir', 'un', 'R32'),

    // --- OITAVAS DE FINAL (R16) ---
    _createMatch('r16_1', 'A definir', 'un', 'A definir', 'un', 'R16'),
    _createMatch('r16_2', 'A definir', 'un', 'A definir', 'un', 'R16'),
    _createMatch('r16_3', 'A definir', 'un', 'A definir', 'un', 'R16'),
    _createMatch('r16_4', 'A definir', 'un', 'A definir', 'un', 'R16'),
    _createMatch('r16_5', 'A definir', 'un', 'A definir', 'un', 'R16'),
    _createMatch('r16_6', 'A definir', 'un', 'A definir', 'un', 'R16'),
    _createMatch('r16_7', 'A definir', 'un', 'A definir', 'un', 'R16'),
    _createMatch('r16_8', 'A definir', 'un', 'A definir', 'un', 'R16'),

    // --- QUARTAS DE FINAL (QF) ---
    _createMatch('qf_1', 'A definir', 'un', 'A definir', 'un', 'QF'),
    _createMatch('qf_2', 'A definir', 'un', 'A definir', 'un', 'QF'),
    _createMatch('qf_3', 'A definir', 'un', 'A definir', 'un', 'QF'),
    _createMatch('qf_4', 'A definir', 'un', 'A definir', 'un', 'QF'),

    // --- SEMIFINAL (SF) ---
    _createMatch('sf_1', 'A definir', 'un', 'A definir', 'un', 'SF'),
    _createMatch('sf_2', 'A definir', 'un', 'A definir', 'un', 'SF'),

    // --- FINAL ---
    _createMatch('final', 'A definir', 'un', 'A definir', 'un', 'FINAL'),
  ];

  static MatchEntity _createMatch(
    String id,
    String home,
    String hFlag,
    String away,
    String aFlag,
    String group,
  ) {
    return MatchEntity(
      id: id,
      homeTeam: home,
      homeFlag: hFlag == 'un'
          ? 'https://flagcdn.com/w320/un.png'
          : 'https://flagcdn.com/w320/$hFlag.png',
      awayTeam: away,
      awayFlag: aFlag == 'un'
          ? 'https://flagcdn.com/w320/un.png'
          : 'https://flagcdn.com/w320/$aFlag.png',
      date: DateTime(2026, 6, 11, 12, 0),
      stadium: 'TBD',
      group: group,
      status: 'Scheduled',
    );
  }
}
