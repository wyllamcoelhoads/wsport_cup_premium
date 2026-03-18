class RepescagemData {
  // Mapa com as seleções reais
  static const Map<String, List<Map<String, String>>> opcoes = {
    // Chaves EXATAS que usaremos na busca
    'Vencedor Rep A': [
      {'name': 'Itália', 'flag': 'https://flagcdn.com/w320/it.png'},
      {
        'name': 'Irlanda do Norte',
        'flag': 'https://flagcdn.com/w320/gb-nir.png',
      },
      {'name': 'País de Gales', 'flag': 'https://flagcdn.com/w320/gb-wls.png'},
      {'name': 'Bósnia', 'flag': 'https://flagcdn.com/w320/ba.png'},
    ],
    'Vencedor Rep B': [
      {'name': 'Ucrânia', 'flag': 'https://flagcdn.com/w320/ua.png'},
      {'name': 'Suécia', 'flag': 'https://flagcdn.com/w320/se.png'},
      {'name': 'Polônia', 'flag': 'https://flagcdn.com/w320/pl.png'},
      {'name': 'Albânia', 'flag': 'https://flagcdn.com/w320/al.png'},
    ],
    'Vencedor Rep C': [
      {'name': 'Turquia', 'flag': 'https://flagcdn.com/w320/tr.png'},
      {'name': 'Romênia', 'flag': 'https://flagcdn.com/w320/ro.png'},
      {'name': 'Eslováquia', 'flag': 'https://flagcdn.com/w320/sk.png'},
      {'name': 'Kosovo', 'flag': 'https://flagcdn.com/w320/xk.png'},
    ],
    'Vencedor Rep D': [
      {'name': 'Dinamarca', 'flag': 'https://flagcdn.com/w320/dk.png'},
      {'name': 'Macedônia do Norte', 'flag': 'https://flagcdn.com/w320/mk.png'},
      {'name': 'República Tcheca', 'flag': 'https://flagcdn.com/w320/cz.png'},
      {'name': 'Rep. da Irlanda', 'flag': 'https://flagcdn.com/w320/ie.png'},
    ],
    'Vencedor Rep 1': [
      {'name': 'RD do Congo', 'flag': 'https://flagcdn.com/w320/cd.png'},
      {'name': 'Jamaica', 'flag': 'https://flagcdn.com/w320/jm.png'},
      {'name': 'Nova Caledônia', 'flag': 'https://flagcdn.com/w320/nc.png'},
    ],
    'Vencedor Rep 2': [
      {'name': 'Iraque', 'flag': 'https://flagcdn.com/w320/iq.png'},
      {'name': 'Bolívia', 'flag': 'https://flagcdn.com/w320/bo.png'},
      {'name': 'Suriname', 'flag': 'https://flagcdn.com/w320/sr.png'},
    ],
  };

  // Identifica quais placeholders pertencem a qual grupo
  static List<String> placeholdersNoGrupo(String groupName) {
    // ATENÇÃO: Os textos retornados aqui DEVEM ser idênticos às chaves acima
    if (groupName == 'GRUPO A') return ['Vencedor Rep D'];
    if (groupName == 'GRUPO B') return ['Vencedor Rep A'];
    if (groupName == 'GRUPO D') return ['Vencedor Rep C'];
    if (groupName == 'GRUPO F') return ['Vencedor Rep B'];
    if (groupName == 'GRUPO I') return ['Vencedor Rep 2'];
    if (groupName == 'GRUPO K') return ['Vencedor Rep 1'];
    return [];
  }
}
