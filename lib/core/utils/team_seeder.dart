// lib/core/utils/team_seeder.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Ajuste este import para apontar corretamente para a sua TeamInfoEntity
import '../../features/world_cup/domain/entities/team_info_entity.dart';

Future<void> popularTodasAsSelecoes() async {
  final firestore = FirebaseFirestore.instance;

  final List<TeamInfoEntity> todasAsSelecoes = [
    // === BRASIL ===
    const TeamInfoEntity(
      id: 'br',
      name: 'Brasil',
      flagCode: 'br',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/2/2b/Confedera%C3%A7%C3%A3o_Brasileira_de_Futebol_2019.svg/512px-Confedera%C3%A7%C3%A3o_Brasileira_de_Futebol_2019.svg.png',
      coach: 'Carlo Ancelotti',
      captain: 'Danilo Marquinhos',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: 'CONMEBOL',
      nickname: 'Seleção Canarinha',
      fifaRanking: 6,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio:
          'A Seleção Brasileira é a única a ter participado de todas as edições da Copa do Mundo FIFA.',
    ),
    // groupo A
    // Mexico
    const TeamInfoEntity(
      id: 'mx',
      name: 'México',
      flagCode: 'mx',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/f/f3/Mexico_national_football_team_crest_%282022%29.png/250px-Mexico_national_football_team_crest_%282022%29.png',
      coach: 'Javier Aguirre',
      captain: 'Edson Álvarez',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/ujncse2im5flybufk7hd',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/oght3urom7kzndsw3oit',
      confederation: 'CONCACAF',
      nickname: 'El Tri / El Tricolor',
      fifaRanking:
          17, // Posição média recente; vale conferir no site da FIFA para o número exato
      founded: 1922,
      worldCupAppearances: 18, // Já contando com a edição de 2026
      worldCupWins: 0,
      worldCupYears: [
        1930,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1978,
        1986,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Mexicana de Futebol, conhecida como "El Tri", é a força mais dominante da CONCACAF. Administrada pela Federação Mexicana de Futebol (fundada em 1922), a equipe possui uma das torcidas mais apaixonadas do mundo e um histórico de presença quase constante em Copas do Mundo. O México detém o recorde de títulos da Copa Ouro e já sediou o Mundial em duas ocasiões históricas (1970 e 1986). Em 2026, os mexicanos farão história novamente ao se tornarem o primeiro país a receber a Copa do Mundo pela terceira vez, dividindo a sede com Estados Unidos e Canadá.',
    ),
    //Africa do Sul
    const TeamInfoEntity(
      id: 'za',
      name: 'África do Sul',
      flagCode: 'za',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/e/e7/South_Africa_national_soccer_team_logo.svg/250px-South_Africa_national_soccer_team_logo.svg.png',
      coach: 'Hugo Broos',
      captain: 'Ronwen Williams',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/tw8bircor6yf3kw2lz5q',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/tbrywualmgssvhscczop',
      confederation: 'CAF',
      nickname: 'Bafana Bafana / The Boys',
      fifaRanking:
          59, // Posição média recente após a excelente campanha na Copa Africana
      founded: 1991,
      worldCupAppearances: 3,
      worldCupWins: 0,
      worldCupYears: [1998, 2002, 2010],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Sul-Africana de Futebol, carinhosamente conhecida como "Bafana Bafana" (Os Rapazes), é um símbolo de união nacional. Administrada pela SAFA (fundada em sua forma atual em 1991 após o fim do Apartheid), a equipe viveu seu auge nos anos 90, conquistando a Copa das Nações Africanas em 1996. Em Copas do Mundo, marcaram presença em 1998 e 2002, mas o momento mais inesquecível foi em 2010, quando a África do Sul tornou-se a primeira nação do continente a sediar um Mundial, unindo o planeta sob o som das vuvuzelas.',
    ),
    //Coreia do Sul
    const TeamInfoEntity(
      id: 'kr',
      name: 'Coreia do Sul',
      flagCode: 'kr',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/a/a7/South_Korea_national_football_team_logo.png/250px-South_Korea_national_football_team_logo.png',
      coach: 'Hong Myung-bo',
      captain: 'Son Heung-min',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/y3epbmpzfnppvk3oqzty',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/ob1shnakgt9fblnfuohd',
      confederation: 'AFC',
      nickname: '태극전사 / Taegeuk Warriors - 붉은 악마 /  The Red Devils',
      fifaRanking:
          22, // Posição média recente; como sempre, vale bater o olho no site da FIFA para cravar o número
      founded: 1933,
      worldCupAppearances: 12, // Já incluindo a edição de 2026
      worldCupWins: 0,
      worldCupYears: [
        1954,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Sul-Coreana de Futebol, carinhosamente chamada de "Guerreiros Taegeuk" ou "Os Diabos Vermelhos", é uma das seleções mais bem-sucedidas e consistentes de todo o continente asiático. Administrada pela Associação de Futebol da Coreia (fundada em 1933), a equipe detém um recorde impressionante: classificou-se para todas as edições da Copa do Mundo ininterruptamente desde 1986. O maior feito de sua história ocorreu em 2002, quando sediou o Mundial em conjunto com o Japão e chocou o planeta ao alcançar as semifinais. Hoje, liderados pelo craque Son Heung-min, os sul-coreanos mantêm a tradição de serem adversários intensos, disciplinados e muito perigosos.',
    ),
    //Dinamarca
    const TeamInfoEntity(
      id: 'dk',
      name: 'Dinamarca',
      flagCode: 'dk',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //Macedônia do Norte
    const TeamInfoEntity(
      id: 'mk',
      name: 'Macedônia do Norte',
      flagCode: 'mk',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //República Tcheca
    const TeamInfoEntity(
      id: 'cz',
      name: 'República Tcheca',
      flagCode: 'cz',
      coatOfArmsUrl: 'https://upload.wikimedia.org/wikipedia/pt/5/5a/FACR.png',
      coach: 'Ivan Hašek', // Atualizado: assumiu a seleção no início de 2024
      captain:
          'Tomáš Souček', // Atualizado: o atual capitão e grande nome da equipe
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/tuosgsyfmqnhoqzvkdfa1',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/l9zyp0iqg4htlx8gpyov',
      confederation: 'UEFA',
      nickname:
          'Národní Tým / The National Team', // Mantido no idioma original e em inglês
      fifaRanking:
          36, // Posição média recente no ranking; vale conferir na FIFA
      founded: 1901,
      worldCupAppearances:
          9, // A FIFA contabiliza o histórico da antiga Tchecoslováquia para eles
      worldCupWins: 0,
      worldCupYears: [
        1934,
        1938,
        1954,
        1958,
        1962,
        1970,
        1982,
        1990,
        2006, // Única participação como nação independente
      ],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Tcheca de Futebol tem uma história fascinante e de muito peso na Europa. Administrada pela Associação de Futebol da República Tcheca (cujas raízes datam de 1901), a equipe herda oficialmente o glorioso histórico da antiga Tchecoslováquia, que foi vice-campeã mundial em duas ocasiões (1934 e 1962). Como nação independente (após a separação em 1993), a República Tcheca brilhou ao chegar à final da Eurocopa de 1996. Em Copas do Mundo, a sua primeira e única participação independente ocorreu em 2006, embalada por uma inesquecível "Geração de Ouro" com lendas como Pavel Nedvěd, Petr Čech e Tomáš Rosický.',
    ),
    //República da Irlanda
    const TeamInfoEntity(
      id: 'ie',
      name: 'República da Irlanda',
      flagCode: 'ie',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //groupo B
    // Canadá
    const TeamInfoEntity(
      id: 'ca',
      name: 'Canadá',
      flagCode: 'ca',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/7/7a/Logotipo_Sele%C3%A7%C3%A3o_Canad%C3%A1.png/250px-Logotipo_Sele%C3%A7%C3%A3o_Canad%C3%A1.png',
      coach: 'Jesse Marsch',
      captain: 'Alphonso Davies',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/yljvzg9zw4el3aywjwe0',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/m51czre0bdnoebtit0qo',
      confederation: 'CONCACAF',
      nickname: 'The Canucks / Les Rouges',
      fifaRanking:
          49, // Estimativa recente; lembre-se de conferir no site da FIFA
      founded: 1912,
      worldCupAppearances:
          3, // Contando com a edição de 2026, onde são um dos países-sede
      worldCupWins: 0,
      worldCupYears: [1986, 2022, 2026],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Canadense de Futebol, conhecida como "Les Rouges" (Os Vermelhos) ou "The Canucks", vive um dos momentos mais promissores de sua história. Administrada pela Associação Canadense de Futebol (fundada em 1912), a equipe tem ganhado protagonismo na CONCACAF impulsionada por uma geração de ouro liderada pelo astro Alphonso Davies. O Canadá retornou à Copa do Mundo em 2022, no Catar, quebrando um incômodo hiato que durava desde a sua estreia em 1986, e tem vaga garantida como um dos países-sede do Mundial de 2026.',
    ),
    // Itália
    const TeamInfoEntity(
      id: 'it',
      name: 'Itália',
      flagCode: 'it',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //Irlanda do Norte
    const TeamInfoEntity(
      id: 'ni',
      name: 'Irlanda do Norte',
      flagCode: 'ni',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //País de Gales
    const TeamInfoEntity(
      id: 'gb',
      name: 'País de Gales',
      flagCode: 'gb',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //Bósnia e Herzegovina
    const TeamInfoEntity(
      id: 'ba',
      name: 'Bósnia e Herzegovina',
      flagCode: 'ba',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/5/5a/Logo_of_the_Football_Association_of_Bosnia_and_Herzegovina_%282013-present%29.png/250px-Logo_of_the_Football_Association_of_Bosnia_and_Herzegovina_%282013-present%29.png',
      coach: 'Sergej Barbarez',
      captain: 'Edin Džeko',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/bvm7b7msifsf8eftnujv',
      uniformAwayUrl: 'Não disponível',
      confederation: 'UEFA',
      nickname:
          'Plavo-žuti/Azul e Amarelo - Zlatni ljiljani/Lírios Dourados - Zmajevi/Dragões',
      fifaRanking:
          74, // Estimativa recente; vale confirmar no site da FIFA para a posição exata
      founded: 1992,
      worldCupAppearances: 1,
      worldCupWins: 0,
      worldCupYears: [2014],
      worldCupTitlesYears: [],
      bio:
          'A Seleção da Bósnia e Herzegovina, frequentemente chamada de "Zmajevi" (Os Dragões), representa um país com imensa paixão pelo esporte. Formada após a independência da Iugoslávia, a Federação de Futebol da Bósnia e Herzegovina foi criada em 1992, mas só pôde se afiliar à FIFA em 1996 devido aos conflitos na região. O momento de maior glória e catarse nacional ocorreu com a histórica classificação para a Copa do Mundo de 2014, realizada no Brasil. Liderada por seu maior artilheiro e ídolo, Edin Džeko, a equipe fez sua estreia em mundiais e deixou uma marca de orgulho para toda a sua nação.',
    ),
    // Catar
    const TeamInfoEntity(
      id: 'qa',
      name: 'Catar',
      flagCode: 'qa',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/a/a9/Associa%C3%A7%C3%A3o_do_Qatar_de_Futebol.png/250px-Associa%C3%A7%C3%A3o_do_Qatar_de_Futebol.png',
      coach: 'Tintín Márquez',
      captain: 'Abdulaziz Hatem',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/it2mwlhlz23s4itrqlbg',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/uy6n61y1vdkiiqjhvgno',
      confederation: 'AFC',
      nickname: 'Al Annabi / Os Marrons',
      fifaRanking:
          110, // O Catar subiu bastante após o bicampeonato asiático; vale checar a posição exata
      founded: 1960,
      worldCupAppearances: 1,
      worldCupWins: 0,
      worldCupYears: [2022],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Catari de Futebol, conhecida como "Al Annabi" (Os Marrons), consolidou-se recentemente como uma das grandes forças do continente asiático. Administrada pela Associação de Futebol do Catar (fundada em 1960), a equipe viveu uma ascensão meteórica ao se tornar bicampeã da Copa da Ásia (2019 e 2023). O país ganhou os holofotes do planeta ao sediar a Copa do Mundo FIFA de 2022, edição que também marcou a primeira - e até agora única - participação da seleção no torneio mundial.',
    ),
    // Suiça
    const TeamInfoEntity(
      id: 'ch',
      name: 'Suíça',
      flagCode: 'ch',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/9/96/SFV_Logo.svg.png/250px-SFV_Logo.svg.png',
      coach:
          'Murat Yakin', // Ajustei o "ı" sem pingo para o "i" padrão para evitar eventuais problemas de encoding no Dart
      captain: 'Granit Xhaka',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/mctzohwvzdmxd9uifz9t',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/upcrhlof2f1koda8i9r1',
      confederation: 'UEFA',
      nickname: 'Nati / Rossocrociati / Red Crosses',
      fifaRanking:
          19, // Posição média recente e bem estável da Suíça no Top 20 da FIFA
      founded: 1895,
      worldCupAppearances: 12,
      worldCupWins: 0,
      worldCupYears: [
        1934,
        1938,
        1950,
        1954,
        1962,
        1966,
        1994,
        2006,
        2010,
        2014,
        2018,
        2022,
      ],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Suíça de Futebol é uma presença constante e extremamente sólida no cenário europeu e mundial. Administrada pela Associação Suíça de Futebol (fundada em 1895, sendo uma das mais antigas fora do Reino Unido), a equipe é carinhosamente chamada de "Nati" (abreviação em alemão para seleção nacional) ou "Rossocrociati" (Os Cruz-Vermelhas, em italiano). A Suíça sediou a Copa do Mundo em 1954, onde fez uma campanha histórica até as quartas de final. Nas últimas décadas, tornaram-se especialistas em avançar para o mata-mata, marcando presença em quase todos os mundiais desde 2006 como um adversário taticamente muito disciplinado e indigesto para qualquer gigante.',
    ),
    //Grupo C
    //Brasil
    const TeamInfoEntity(
      id: 'br',
      name: 'Brasil',
      flagCode: 'br',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Brazilian_Football_Confederation_logo.svg/250px-Brazilian_Football_Confederation_logo.svg.png',
      coach: 'Dorival Júnior',
      captain: 'Danilo',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/fwnsmsel18ntghyybimv',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/qrjzdlosfewyr0hlaw9v',
      confederation: 'CONMEBOL',
      nickname: 'A Seleção / Canarinho',
      fifaRanking:
          8, // Estimativa realista recente; vale checar o site da FIFA para a posição exata
      founded: 1914,
      worldCupAppearances: 23,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio:
          'A Seleção Brasileira é a equipe mais bem-sucedida da história das Copas do Mundo e a única a ter participado de absolutamente todas as edições do torneio. Conhecida mundialmente como a "Seleção Canarinho" devido à sua icônica camisa amarela, o Brasil é o único país pentacampeão mundial (1958, 1962, 1970, 1994 e 2002). O futebol brasileiro é famoso por sua magia, criatividade e talento ofensivo, tendo revelado ao mundo o Rei Pelé, além de lendas como Ronaldo, Romário, Ronaldinho Gaúcho, Zico e Neymar.',
    ),
    //Marrocos
    const TeamInfoEntity(
      id: 'ma',
      name: 'Marrocos',
      flagCode: 'ma',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/7/71/F%C3%A9d%C3%A9ration_Royale_Marocaine_de_Football.png/250px-F%C3%A9d%C3%A9ration_Royale_Marocaine_de_Football.png',
      coach: 'Walid Regragui',
      captain: 'Achraf Hakimi',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/a2tthvhbrr0xgbcbmmq1',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/kieno48uhpv579hdisjo',
      confederation: 'CAF',
      nickname: 'أُسُودُ الأَطلَس / Leões do Atlas',
      fifaRanking:
          12, // A seleção marroquina lidera na África e tem ficado quase sempre no Top 15 mundial
      founded: 1955,
      worldCupAppearances: 6,
      worldCupWins: 0,
      worldCupYears: [1970, 1986, 1994, 1998, 2018, 2022],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Marroquina de Futebol, imortalizada como "Os Leões do Atlas" (أُسُودُ الأَطلَس), é uma das mais fortes e táticas representantes do continente africano. Administrada pela Real Federação Marroquina de Futebol (fundada em 1955), a equipe quebrou barreiras impensáveis na Copa do Mundo de 2022, no Catar. Sob o comando de Walid Regragui e guiada por craques de nível mundial como Achraf Hakimi, Marrocos eliminou gigantes europeus como Espanha e Portugal, tornando-se a primeira seleção africana e árabe em toda a história a alcançar as semifinais de um Mundial.',
    ),
    //Haiti
    const TeamInfoEntity(
      id: 'ht',
      name: 'Haiti',
      flagCode: 'ht',
      coatOfArmsUrl: '', // Mantive vazio conforme você enviou
      coach: 'Sébastien Migné',
      captain: 'Johny Placide',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/rwel9b7fijzdvtiktqpl',
      uniformAwayUrl: '',
      confederation: 'CONCACAF',
      nickname: 'Les Grenadiers / Les Bicolores',
      fifaRanking:
          89, // Eles costumam ficar na faixa dos 85 a 90; vale conferir na FIFA para o número exato
      founded: 1904,
      worldCupAppearances: 1,
      worldCupWins: 0,
      worldCupYears: [1974],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Haitiana de Futebol, conhecida como "Les Grenadiers" ou "Les Bicolores", é uma das equipes mais tradicionais do Caribe. Administrada pela Federação Haitiana de Futebol (fundada em 1904), a equipe viveu seu maior momento de glória na década de 1970. Após conquistar o Campeonato da CONCACAF em 1973, o Haiti fez sua primeira e única participação na Copa do Mundo de 1974, na Alemanha Ocidental. Naquela edição, o país entrou para a história do futebol quando o atacante Emmanuel Sanon marcou um gol contra a Itália, quebrando a lendária invencibilidade do goleiro Dino Zoff.',
    ),
    //Escócia
    const TeamInfoEntity(
      id: 'sc',
      name: 'Escócia',
      flagCode: 'sc',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/9/95/Sele%C3%A7%C3%A3o_Escocesa_logo.png',
      coach: 'Steve Clarke',
      captain: 'Andrew Robertson',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/esob9zbobr0ivq6n8saf',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/dxgzdoetoineltyfeul7',
      confederation: 'UEFA',
      nickname: 'The Tartan Army',
      fifaRanking:
          39, // Posição média recente; lembre-se de conferir no site da FIFA
      founded: 1873,
      worldCupAppearances: 8,
      worldCupWins: 0,
      worldCupYears: [1954, 1958, 1974, 1978, 1982, 1986, 1990, 1998],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Escocesa de Futebol é uma das mais antigas e tradicionais do planeta, tendo disputado a primeira partida internacional oficial da história contra a Inglaterra, em 1872. Administrada pela Associação Escocesa de Futebol (fundada em 1873, a segunda mais velha do mundo), a equipe conta com o apoio incondicional de sua apaixonada torcida, a famosa "Tartan Army". A Escócia participou de 8 edições da Copa do Mundo, vivendo sua era de ouro nas décadas de 1970 e 1980. Apesar do enorme amor pelo esporte, a valente equipe britânica ainda busca o feito inédito de avançar da fase de grupos de um Mundial.',
    ),
    //Grupo D
    //Estados Unidos
    const TeamInfoEntity(
      id: 'us',
      name: 'Estados Unidos',
      flagCode: 'us',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/United_States_Soccer_Federation_logo.svg/250px-United_States_Soccer_Federation_logo.svg.png',
      coach: 'Mauricio Pochettino',
      captain: 'Christian Pulisic',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/hkjnqoquts56kevxasvu',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/olmpy6bu9xyg3fuzue7l',
      confederation: 'CONCACAF',
      nickname: 'The Yanks / The Stars & Stripes',
      fifaRanking:
          13, // Posição média recente; lembre-se de conferir no site da FIFA
      founded: 1913,
      worldCupAppearances: 12, // Já contando com 2026
      worldCupWins: 0,
      worldCupYears: [
        1930,
        1934,
        1950,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2022,
        2026,
      ],
      worldCupTitlesYears: [],
      bio:
          'A Seleção dos Estados Unidos, conhecida como "The Yanks" ou "The Stars & Stripes", é a principal força da CONCACAF ao lado do México. Administrada pela US Soccer (fundada em 1913), a equipe tem um histórico curioso: alcançou o 3º lugar na primeira Copa do Mundo em 1930, mas passou décadas afastada do torneio até seu renascimento nos anos 90. Após sediar o inesquecível Mundial de 1994, o futebol (soccer) cresceu exponencialmente no país. Liderados hoje por astros atuando na Europa, como Christian Pulisic, os americanos chegam como um dos países-sede da Copa de 2026 com a ambição de fazer a melhor campanha de sua era moderna.',
    ),
    // Paraguai
    const TeamInfoEntity(
      id: 'py',
      name: 'Paraguai',
      flagCode: 'py',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Asociaci%C3%B3n_Paraguaya_de_F%C3%BAtbol_logo.svg/120px-Asociaci%C3%B3n_Paraguaya_de_F%C3%BAtbol_logo.svg.png',
      coach: 'Gustavo Alfaro',
      captain: 'Gustavo Gómez',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/airb0u59sxc6bdnpduwg',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/e7anjqktyzymp2duq5gb',
      confederation: 'CONMEBOL',
      nickname: 'La Albirroja / Los Guaraníes',
      fifaRanking:
          56, // Posição média recente; vale sempre dar uma olhada na FIFA para cravar o número exato
      founded: 1906,
      worldCupAppearances: 8,
      worldCupWins: 0,
      worldCupYears: [1930, 1950, 1958, 1986, 1998, 2002, 2006, 2010],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Paraguaia de Futebol, tradicionalmente conhecida como "La Albirroja" ou "Los Guaraníes", é uma das equipes mais aguerridas e difíceis de se enfrentar na América do Sul. Administrada pela Associação Paraguaia de Futebol (fundada em 1906), a equipe é bicampeã da Copa América (1953 e 1979) e construiu sua fama mundial baseada em uma forte solidez defensiva e muita entrega física. O Paraguai possui 8 participações em Copas do Mundo. Sua campanha inesquecível e de maior destaque ocorreu em 2010, na África do Sul, quando chegaram às quartas de final e fizeram um jogo histórico e dramático contra a Espanha, que viria a ser a campeã daquela edição.',
    ),
    // Austrália
    const TeamInfoEntity(
      id: 'au',
      name: 'Austrália',
      flagCode: 'au',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Australia_national_football_team_badge.svg/250px-Australia_national_football_team_badge.svg.png',
      coach: 'Tony Popovic',
      captain: 'Mathew Ryan', // Goleiro e capitão de longa data da seleção
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/ncwgnhovwzbppfm4kva5',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/kf6qmjhggjve6js3wm4b',
      confederation: 'AFC', // Atualizado de AFF para AFC
      nickname: 'Socceroos',
      fifaRanking:
          15, // Estimativa recente; lembre-se de verificar o ranking atualizado da FIFA
      founded: 1961,
      worldCupAppearances:
          7, // estou contando 2026 ainda, apenas as edições já jogadas
      worldCupWins: 0,
      worldCupYears: [1974, 2006, 2010, 2014, 2018, 2022],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Australiana de Futebol, carinhosamente apelidada de "Socceroos" (uma mistura de soccer com kangaroos), é uma equipe conhecida por sua força física e resiliência. Em 2006, a Austrália tomou a decisão histórica de deixar a Confederação da Oceania para se juntar à Confederação Asiática (AFC), buscando competições de mais alto nível. Desde então, sagrou-se campeã da Copa da Ásia em 2015 e tornou-se presença constante nas Copas do Mundo, tendo suas melhores campanhas em 2006 e 2022, quando alcançou as oitavas de final.',
    ),
    // Turquia
    const TeamInfoEntity(
      id: 'tr',
      name: 'Turquia',
      flagCode: 'tr',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Roundel_flag_of_Turkey.svg/250px-Roundel_flag_of_Turkey.svg.png',
      coach: 'Vincenzo Montella',
      captain: 'Hakan Çalhanoğlu',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/jh1ngnyk3yk5umh01ans',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/lulekoomfkydx6sldvel',
      confederation: 'UEFA',
      nickname: 'Ay-Yıldızlılar / The Crescent-Stars',
      fifaRanking:
          40, // Posição média recente; confira na FIFA para o número exato da última atualização
      founded: 1923,
      worldCupAppearances: 2,
      worldCupWins: 0,
      worldCupYears: [1954, 2002],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Turca de Futebol é temida e respeitada por sua paixão arrebatadora e intensidade em campo. Administrada pela Federação Turca de Futebol (fundada em 1923), a equipe possui duas participações em Copas do Mundo. O grande ápice de sua história ocorreu em 2002, na Coreia do Sul e no Japão, quando a Turquia surpreendeu o planeta ao chegar às semifinais, sendo parada apenas pelo Brasil, e conquistando um histórico terceiro lugar. Empurrados por uma das torcidas mais fanáticas e barulhentas do mundo, os "Crescent-Stars" misturam técnica apurada com muita garra.',
    ),
    // Romênia
    const TeamInfoEntity(
      id: 'ro',
      name: 'Romênia',
      flagCode: 'ro',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    // Eslováquia
    const TeamInfoEntity(
      id: 'sk',
      name: 'Eslováquia',
      flagCode: 'sk',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    // Kosovo
    const TeamInfoEntity(
      id: 'xk',
      name: 'Kosovo',
      flagCode: 'xk',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    // grupo E
    // Alemanha
    const TeamInfoEntity(
      id: 'de',
      name: 'Alemanha',
      flagCode: 'de',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/a/a9/DFBEagle.png/250px-DFBEagle.png',
      coach: 'Julian Nagelsmann',
      captain: 'Joshua Kimmich',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/sdtbcsrvhkvzfmf1pb1g',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/ywl15tqcbqx93l3am3e0',
      confederation: 'UEFA',
      nickname: 'Die Mannschaft', // ou 'Nationalelf'
      fifaRanking:
          13, // Sugiro checar no site da FIFA se houve atualização recente
      founded: 1900,
      worldCupAppearances: 21,
      worldCupWins: 4,
      worldCupYears: [
        1934,
        1938,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1954, 1974, 1990, 2014],
      bio:
          'A Seleção Alemã de Futebol, frequentemente chamada de "Die Mannschaft", é uma das equipes mais tradicionais e vitoriosas da história do futebol. Administrada pela Federação Alemã de Futebol (DFB), a equipe é mundialmente reconhecida por sua resiliência, organização tática e força coletiva. Com quatro títulos de Copa do Mundo e três da Eurocopa, a Alemanha produziu lendas do esporte como Franz Beckenbauer, Gerd Müller e Lothar Matthäus, mantendo-se sempre como uma das maiores potências do futebol global.',
    ),
    //Curaçao
    const TeamInfoEntity(
      id: 'cw',
      name: 'Curaçao',
      flagCode: 'cw',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/f/f7/Federashon_Futb%C3%B2l_K%C3%B2rsou.png/250px-Federashon_Futb%C3%B2l_K%C3%B2rsou.png',
      coach:
          'Dick Advocaat', // Atualizei para o lendário técnico holandês que assumiu a equipe no início de 2024
      captain: 'Leandro Bacuna',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/j3c7amskdzuxlfoqpezc',
      uniformAwayUrl: '',
      confederation: 'CONCACAF',
      nickname: 'La Familia Azul / The Blue Family',
      fifaRanking:
          91, // Eles costumam flutuar na casa dos 80~90; vale checar o site da FIFA para a posição exata
      founded: 1921,
      worldCupAppearances: 0,
      worldCupWins: 0,
      worldCupYears: [],
      worldCupTitlesYears: [],
      bio:
          'A Seleção de Futebol de Curaçao, conhecida como "La Familia Azul", possui uma história peculiar e em plena ascensão na CONCACAF. Assumindo o legado histórico das antigas Antilhas Neerlandesas (dissolvidas em 2010), a equipe caribenha tem se fortalecido imensamente na última década. Esse salto de qualidade ocorre graças à forte presença de jogadores com dupla nacionalidade atuando em alto nível no futebol europeu, especialmente nos Países Baixos. Campeões da Copa do Caribe em 2017, eles seguem lutando pelo grande sonho de sua primeira classificação para a Copa do Mundo.',
    ),
    // Costa do Marfim
    const TeamInfoEntity(
      id: 'ci',
      name: 'Costa do Marfim',
      flagCode: 'ci',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/a/a1/F%C3%A9d%C3%A9ration_Ivorienne_de_Football.png/250px-F%C3%A9d%C3%A9ration_Ivorienne_de_Football.png',
      coach: 'Emerse Faé',
      captain: 'Franck Kessié',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/uvp3ngydpbfo8atxbxgo',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/wihnbdplqu61cp6c1jeb',
      confederation: 'CAF',
      nickname: 'Les Éléphants / Os Elefantes',
      fifaRanking:
          39, // Posição recente após o título africano; vale checar o site da FIFA
      founded: 1960,
      worldCupAppearances: 3,
      worldCupWins: 0,
      worldCupYears: [2006, 2010, 2014],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Marfinense de Futebol, temida em todo o continente como "Les Éléphants" (Os Elefantes), é uma das grandes potências da África. Administrada pela Federação Marfinense de Futebol (fundada em 1960), a equipe é tricampeã da Copa das Nações Africanas, tendo conquistado seu título mais recente de forma heroica jogando em casa, no início de 2024. O país disputou três Copas do Mundo consecutivas impulsionado pela sua maior geração de ouro, que revelou lendas globais como Didier Drogba e Yaya Touré.',
    ),
    //Equador
    const TeamInfoEntity(
      id: 'ec',
      name: 'Equador',
      flagCode: 'ec',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Logo_de_la_Federaci%C3%B3n_Ecuatoriana_de_F%C3%BAtbol_%282%29.svg/250px-Logo_de_la_Federaci%C3%B3n_Ecuatoriana_de_F%C3%BAtbol_%282%29.svg.png',
      coach: 'Sebastián Beccacece',
      captain: 'Enner Valencia',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/jw6grlqx6hv635fomolv',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/edz9yy1aktcyvkaorsoj',
      confederation: 'CONMEBOL',
      nickname: 'La Tri / La Tricolor',
      fifaRanking:
          31, // O Equador costuma oscilar na casa dos 30; vale dar uma olhada na FIFA para a posição exata
      founded: 1925,
      worldCupAppearances: 4,
      worldCupWins: 0,
      worldCupYears: [2002, 2006, 2014, 2022],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Equatoriana de Futebol, carinhosamente chamada de "La Tri" ou "La Tricolor", consolidou-se no século XXI como uma das forças mais competitivas da América do Sul. Administrada pela Federação Equatoriana de Futebol (fundada em 1925), a equipe é conhecida por seu jogo físico, velocidade e pela imponente força ao jogar na altitude de Quito. O Equador estreou em Copas do Mundo em 2002 e teve sua melhor campanha na edição de 2006, na Alemanha, quando alcançou as oitavas de final. O país tem revelado grandes talentos, liderados pelo seu maior artilheiro histórico, Enner Valencia.',
    ),
    //Grupo F
    //Holanda
    const TeamInfoEntity(
      id: 'nl',
      name: 'Holanda',
      flagCode: 'nl',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/a/a1/Netherlands_national_football_team_logo_2017.png',
      coach: 'Ronald Koeman',
      captain: 'Virgil van Dijk',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/ulk4kvgspy2qouk02ex5',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/whcnq8rf1skwvnmspppc',
      confederation: 'UEFA',
      nickname: 'Oranje / Laranja Mecânica',
      fifaRanking:
          6, // Eles costumam figurar no Top 10; vale conferir a posição exata no site da FIFA
      founded: 1889,
      worldCupAppearances: 12, // Já contando com a edição de 2026
      worldCupWins: 0,
      worldCupYears: [
        1934,
        1938,
        1974,
        1978,
        1990,
        1994,
        1998,
        2006,
        2010,
        2014,
        2022,
        2026,
      ],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Neerlandesa de Futebol, mundialmente conhecida como Holanda, é uma das equipes mais inovadoras e brilhantes da história do esporte. Apelidada de "Oranje" e eternizada como o "Carrossel Holandês" (ou Laranja Mecânica) na década de 1970, a equipe revolucionou o futebol com o conceito de "Futebol Total" sob a batuta do lendário Johan Cruyff. Administrada pela KNVB (fundada em 1889), a seleção já chegou incrivelmente perto da glória máxima três vezes, sendo vice-campeã mundial em 1974, 1978 e 2010. Apesar de ainda buscar sua primeira estrela na Copa do Mundo, a Holanda conquistou a Eurocopa de 1988 e é sempre uma adversária formidável.',
    ),
    //Japão
    const TeamInfoEntity(
      id: 'jp',
      name: 'Japão',
      flagCode: 'jp',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/3/32/JapanFA.png/120px-JapanFA.png',
      coach: 'Hajime Moriyasu',
      captain: 'Wataru Endo',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/hjcjskonfniq9wfak51w',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/hgfdiusbecn0dnh8uuid',
      confederation: 'AFC',
      nickname: 'Samurai Blue / Os Samurais Azuis',
      fifaRanking:
          18, // O Japão é o líder do ranking asiático e costuma ficar no Top 20 mundial
      founded: 1921,
      worldCupAppearances: 8, // Já incluindo a edição de 2026
      worldCupWins: 0,
      worldCupYears: [1998, 2002, 2006, 2010, 2014, 2018, 2022, 2026],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Japonesa de Futebol, mundialmente conhecida como "Samurai Blue" (Os Samurais Azuis), é a maior potência do futebol asiático. Administrada pela Associação de Futebol do Japão (fundada em 1921), a equipe detém o recorde absoluto de títulos da Copa da Ásia (quatro conquistas). O Japão estreou em Copas do Mundo na França, em 1998, e desde então qualificou-se para rigorosamente todas as edições. Conhecidos por sua imensa disciplina tática, técnica e velocidade, os japoneses marcaram a história ao sediarem a Copa de 2002 junto com a Coreia do Sul e, mais recentemente, ao vencerem gigantes europeus como Alemanha e Espanha no Mundial do Catar em 2022.',
    ),
    //Tunísia
    const TeamInfoEntity(
      id: 'tn',
      name: 'Tunísia',
      flagCode: 'tn',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/8/88/F%C3%A9d%C3%A9ration_Tunisienne_de_Football.png/250px-F%C3%A9d%C3%A9ration_Tunisienne_de_Football.png',
      coach: 'Sabri Lamouchi',
      captain: 'Ferjani Sassi',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/npo8wwnllydsmmnekj85',
      uniformAwayUrl: '',
      confederation: 'CAF',
      nickname: 'نسور قرطاج / Les Aigles de Carthage / Eagles of Carthage',
      fifaRanking:
          41, // Posição média recente; vale sempre conferir o site da FIFA para o número exato
      founded: 1957,
      worldCupAppearances: 6,
      worldCupWins: 0,
      worldCupYears: [1978, 1998, 2002, 2006, 2018, 2022],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Tunisiana de Futebol, imortalizada como as "Águias de Cartago", é uma das forças mais tradicionais e táticas do Norte da África. Administrada pela Federação Tunisiana de Futebol (fundada em 1957), a equipe detém um marco inesquecível: na Copa do Mundo de 1978, na Argentina, a Tunísia fez história ao se tornar a primeira nação africana a vencer uma partida em um Mundial (derrotando o México por 3 a 1). Campeões da Copa das Nações Africanas em 2004, jogando em casa, os tunisianos são conhecidos por sua defesa sólida e presença frequente no cenário global.',
    ),
    //Ucránia
    const TeamInfoEntity(
      id: 'ua',
      name: 'Ucrânia',
      flagCode: 'ua',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //Suécia
    const TeamInfoEntity(
      id: 'se',
      name: 'Suécia',
      flagCode: 'se',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/1/14/SFSverige.png/250px-SFSverige.png',
      coach: 'Jon Dahl Tomasson',
      captain: 'Victor Lindelöf',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/sgdlyh30cizb2ruorev2',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/zqspcaqoah0xpbnv8sxq',
      confederation: 'UEFA',
      nickname: 'Blågult / The Blue and Yellow - Tre Kronor / Three Crowns',
      fifaRanking:
          26, // Estimativa de posição média recente; vale dar uma olhada na FIFA para cravar
      founded: 1904,
      worldCupAppearances: 12,
      worldCupWins: 0,
      worldCupYears: [
        1934,
        1938,
        1950,
        1958,
        1970,
        1974,
        1978,
        1990,
        1994,
        2002,
        2006,
        2018,
      ],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Sueca de Futebol é uma das forças mais tradicionais e sólidas do futebol escandinavo e europeu. Administrada pela Associação Sueca de Futebol (fundada em 1904), a equipe possui um histórico de muito respeito em Copas do Mundo. O seu maior feito ocorreu em 1958, quando sediaram o Mundial e chegaram à grande final, sendo parados apenas pelo lendário Brasil de Pelé. Outro momento mágico e inesquecível foi a campanha de 1994, nos Estados Unidos, onde uma carismática geração de ouro conquistou um brilhante terceiro lugar.',
    ),
    //Polônia
    const TeamInfoEntity(
      id: 'pl',
      name: 'Polônia',
      flagCode: 'pl',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //Albânia
    const TeamInfoEntity(
      id: 'al',
      name: 'Albânia',
      flagCode: 'al',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //Grupo G
    //Bélgica
    const TeamInfoEntity(
      id: 'be',
      name: 'Bélgica',
      flagCode: 'be',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/b/b0/Royal_Belgian_FA_logo_2019.png/120px-Royal_Belgian_FA_logo_2019.png',
      coach: 'Domenico Tedesco',
      captain: 'Kevin De Bruyne',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/zndkyivoubtwb9zrys9e',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/ij6phb5rhng1rrbcn5tm',
      confederation: 'UEFA',
      nickname: 'De Rode Duivels / Les Diables Rouges',
      fifaRanking:
          18, // A Bélgica costuma figurar sempre no Top 5, mas vale checar a posição exata atual no site da FIFA
      founded: 1895,
      worldCupAppearances: 14,
      worldCupWins: 0,
      worldCupYears: [
        1930,
        1934,
        1938,
        1954,
        1970,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2014,
        2018,
        2022,
      ],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Belga de Futebol, mundialmente conhecida como os "Diabos Vermelhos" (De Rode Duivels em neerlandês e Les Diables Rouges em francês), é uma das equipes mais temidas da Europa contemporânea. Administrada pela Real Associação Belga de Futebol, a equipe teve imenso destaque na última década com sua aclamada "Geração de Ouro", formada por craques como Kevin De Bruyne, Eden Hazard, Romelu Lukaku e Thibaut Courtois. A Bélgica liderou o ranking da FIFA por vários anos consecutivos e teve seu auge em Copas do Mundo em 2018, quando eliminou o Brasil nas quartas de final e conquistou um histórico terceiro lugar.',
    ),
    //Egito
    const TeamInfoEntity(
      id: 'eg',
      name: 'Egito',
      flagCode: 'eg',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/3/33/Egyptian_Football_Association.png/250px-Egyptian_Football_Association.png',
      coach: 'Hossam Hassan',
      captain: 'Mohamed Salah',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/vrlltxcocq9zg3mhyhbh',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/q5alqxcij348lgvsjh5k',
      confederation: 'CAF',
      nickname: 'Os Faraós',
      fifaRanking:
          36, // Posição média recente; lembre-se de dar uma olhada na FIFA para o número exato
      founded: 1921,
      worldCupAppearances: 3,
      worldCupWins: 0,
      worldCupYears: [1934, 1990, 2018],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Egípcia de Futebol, mundialmente conhecida como "Os Faraós", é a maior e mais vitoriosa potência do continente africano. Administrada pela Associação Egípcia de Futebol (fundada em 1921), a equipe possui um domínio histórico na África, detendo o recorde absoluto de títulos da Copa das Nações Africanas (sete no total). Além disso, o Egito tem o orgulho de ter sido o primeiro país africano a disputar uma Copa do Mundo, em 1934. Hoje, a equipe é liderada em campo pelo genial Mohamed Salah, capitão e principal ídolo da nação.',
    ),
    //Irã
    const TeamInfoEntity(
      id: 'ir',
      name: 'Irã',
      flagCode: 'ir',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/a/a6/Football_Federation_Islamic_Republic_of_Iran.png/120px-Football_Federation_Islamic_Republic_of_Iran.png',
      coach: 'Amir Ghalenoei',
      captain: 'Alireza Jahanbakhsh',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/bqcklnaiyjpllxnnpgkz',
      uniformAwayUrl: '',
      confederation: 'AFC',
      nickname: 'تیم ملی / Team Melli - شیرهای ایران / Iranian Lions',
      fifaRanking:
          20, // O Irã é uma potência asiática e costuma figurar no Top 20 da FIFA
      founded: 1920,
      worldCupAppearances: 7, // Já incluindo a edição de 2026
      worldCupWins: 0,
      worldCupYears: [1978, 1998, 2006, 2014, 2018, 2022, 2026],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Iraniana de Futebol é historicamente uma das maiores e mais consistentes potências do continente asiático. Administrada pela Federação de Futebol da República Islâmica do Irã (fundada em 1920), a equipe possui um tricampeonato consecutivo da Copa da Ásia (1968, 1972 e 1976). Extremamente apoiados por sua fervorosa torcida que os chama de "Team Melli", os iranianos estrearam em Copas do Mundo na Argentina, em 1978, e nas últimas décadas se tornaram uma presença quase cativa no torneio, sempre se destacando pela sua forte disciplina física e solidez defensiva.',
    ),
    //Nova Zelândia
    const TeamInfoEntity(
      id: 'nz',
      name: 'Nova Zelândia',
      flagCode: 'nz',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/d/db/New_Zealand_Football.png/250px-New_Zealand_Football.png',
      coach: 'Darren Bazeley',
      captain: 'Chris Wood',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/hymslqcsymc13gw0n2qi',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/toascxfprvv3cql70pk0',
      confederation: 'OFC',
      nickname: 'All Whites / Ōmā',
      fifaRanking:
          104, // Estimativa da posição média recente; vale sempre conferir o site da FIFA para o número exato
      founded: 1891,
      worldCupAppearances: 2,
      worldCupWins: 0,
      worldCupYears: [1982, 2010],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Neozelandesa de Futebol, conhecida como "All Whites" (em contraste com os famosos "All Blacks" do rugby), é a principal potência da Confederação de Futebol da Oceania (OFC) desde a mudança da Austrália para a confederação asiática. Administrada pela New Zealand Football (fundada em 1891), a equipe tem duas participações em Copas do Mundo. Sua campanha na África do Sul em 2010 entrou para a história: a Nova Zelândia foi a única seleção a terminar aquele torneio invicta, empatando seus três jogos na fase de grupos, incluindo um heroico 1 a 1 contra a então campeã mundial, Itália.',
    ),
    //grupo H
    //Espanha
    const TeamInfoEntity(
      id: 'es',
      name: 'Espanha',
      flagCode: 'es',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/3/31/Spain_National_Football_Team_badge.png',
      coach: 'Luis de la Fuente',
      captain: 'Álvaro Morata',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/xv31zmvl15uxw6ajtz5t',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/qazauuvmtl5vwdq5jwr2',
      confederation: 'UEFA',
      nickname: 'La Roja / La Furia Roja',
      fifaRanking:
          3, // A Espanha está no Top 3 desde a conquista da Eurocopa de 2024
      founded: 1909,
      worldCupAppearances: 17, // Já contando com a edição de 2026
      worldCupWins: 1,
      worldCupYears: [
        1934,
        1950,
        1962,
        1966,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [2010],
      bio:
          'A Seleção Espanhola de Futebol, eternizada como "La Roja" (A Vermelha) ou "La Furia Roja", é uma das equipes mais técnicas e dominantes do futebol mundial. Administrada pela Real Federação Espanhola de Futebol (fundada em 1909), a Espanha marcou época com o estilo de jogo "tiki-taka", de muita posse de bola e passes curtos. Esse estilo encantou o planeta e a levou ao histórico título da Copa do Mundo de 2010, na África do Sul, coroado com o inesquecível gol de Andrés Iniesta. A seleção também é a maior campeã da história da Eurocopa, provando a força constante de suas gerações.',
    ),
    //Cabo Verde
    const TeamInfoEntity(
      id: 'cv',
      name: 'Cabo Verde',
      flagCode: 'cv',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/e/e1/Federa%C3%A7%C3%A3o_Cabo-Verdiana_de_Futebol.png/250px-Federa%C3%A7%C3%A3o_Cabo-Verdiana_de_Futebol.png',
      coach: 'Bubista',
      captain:
          'Vozinha', // Ryan Mendes também usa bastante a braçadeira, mas Vozinha é um líder histórico
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/l9klyjdmmi15nsccn49e',
      uniformAwayUrl: '',
      confederation: 'CAF',
      nickname: 'Tubarões Azuis / Crioulos',
      fifaRanking:
          119, // Estimativa recente (eles têm subido bastante!); vale confirmar a posição exata
      founded: 1982,
      worldCupAppearances: 0,
      worldCupWins: 0,
      worldCupYears: [],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Cabo-Verdiana de Futebol, carinhosamente conhecida como "Tubarões Azuis" (Tubarões Azuis em português e Crioulos), é uma das maiores sensações recentes do futebol africano. Administrada pela Federação Cabo-verdiana de Futebol (fundada em 1982), a equipe representa um país de pequena população, mas com um talento enorme exportado para a Europa. Embora ainda busque sua primeira classificação para a Copa do Mundo, Cabo Verde tem feito campanhas históricas na Copa das Nações Africanas (CAN), alcançando as quartas de final em edições como 2013 e 2023, provando ser um adversário duro de ser batido.',
    ),
    //Arábia Saudita
    const TeamInfoEntity(
      id: 'sa',
      name: 'Arábia Saudita',
      flagCode: 'sa',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/0/01/SAFF.png/250px-SAFF.png',
      coach: 'Hervé Renard', // Treinador de grande renome internacional
      captain: 'Salem Al-Dawsari', // Um dos principais ídolos atuais da seleção
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/towc4hza4rtyuhageatt',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/guryc2sf2uwtcjbl5xn3',
      confederation: 'AFC, sub-confonfederation: WAFF',
      nickname:
          'Al-Suqour Al-Khodhur The Green Falcons', // ou 'Al-Suqour Al-Khodhur'
      fifaRanking:
          159, // Estimativa recente; vale a pena verificar no site da FIFA
      founded: 1956,
      worldCupAppearances:
          6, // 7 se você já estiver contando a classificação para 2026
      worldCupWins: 0,
      worldCupYears: [
        1994,
        1998,
        2002,
        2006,
        2018,
        2022,
        // 2026, // Descomente esta linha se a sua aplicação já estiver considerando a Copa de 2026
      ],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Saudita de Futebol, carinhosamente conhecida como "Falcões Verdes" (Al-Suqour), é uma das principais forças do futebol no continente asiático. Filiada à AFC e à FIFA desde 1956, a equipe estreou em Copas do Mundo em 1994, onde surpreendeu ao alcançar as oitavas de final. Tradicional tricampeã da Copa da Ásia, a Arábia Saudita é uma presença frequente no cenário mundial e recentemente ficou marcada na história por vencer a Argentina (que viria a ser campeã) na fase de grupos da Copa do Mundo de 2022.',
    ),
    //Uruguai
    const TeamInfoEntity(
      id: 'uy',
      name: 'Uruguai',
      flagCode: 'uy',
      coatOfArmsUrl: 'https://upload.wikimedia.org/wikipedia/pt/0/04/AUF.png',
      coach: 'Marcelo Bielsa',
      captain: 'José Giménez',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/jdoitsqgq3msor48r88u',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/huwtab8o94i77jfpj4vy',
      confederation: 'CONMEBOL',
      nickname: 'La Celeste / The Sky Blue',
      fifaRanking:
          11, // Posição média recente; vale conferir na FIFA para o número exato
      founded: 1900,
      worldCupAppearances: 15, // Já contando com 2026
      worldCupWins: 2,
      worldCupYears: [
        1930,
        1950,
        1954,
        1962,
        1966,
        1970,
        1974,
        1986,
        1990,
        2002,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1930, 1950],
      bio:
          'A Seleção Uruguaia de Futebol, conhecida mundialmente como "La Celeste", é uma das camisas mais lendárias do esporte. Administrada pela Associação Uruguaia de Futebol (fundada em 1900), o Uruguai foi o primeiro grande dominador do futebol mundial, vencendo as Copas de 1930 (em casa) e 1950 (o eterno Maracanazo). A Celeste também ostenta quatro estrelas no peito, em referência aos seus dois títulos mundiais e às duas medalhas de ouro olímpicas de 1924 e 1928, organizadas pela FIFA. Conhecidos pela "Garra Charrúa", os uruguaios combinam uma entrega física inigualável com uma tradição de formar goleadores implacáveis.',
    ),
    //Grupo I
    //França
    const TeamInfoEntity(
      id: 'fr',
      name: 'França',
      flagCode: 'fr',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/1/12/France_national_football_team_seal.svg/250px-France_national_football_team_seal.svg.png',
      coach: 'Didier Deschamps',
      captain: 'Kylian Mbappé',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/fchfvx9e6hpjjx2zlknu',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/ol3f84rpdylgm682qhs0',
      confederation: 'UEFA',
      nickname: 'Les Bleus / Les Coqs',
      fifaRanking:
          2, // A França é presença constante no Top 3; vale checar o site da FIFA para a exatidão
      founded: 1919,
      worldCupAppearances: 17, // Já incluindo a edição de 2026 na contagem
      worldCupWins: 2,
      worldCupYears: [
        1930,
        1934,
        1938,
        1954,
        1958,
        1966,
        1978,
        1982,
        1986,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1998, 2018],
      bio:
          'A Seleção Francesa de Futebol, famosa mundialmente como "Les Bleus" (Os Azuis) ou "Les Coqs" (Os Galos), é uma das maiores e mais temidas potências do futebol. Administrada pela Federação Francesa de Futebol (fundada em 1919), a equipe é bicampeã da Copa do Mundo. A primeira estrela veio jogando em casa, em 1998, sob a batuta mágica de Zinedine Zidane. Vinte anos depois, em 2018 na Rússia, levantaram a taça novamente impulsionados pela velocidade e genialidade de Kylian Mbappé. Com elencos sempre recheados de estrelas de classe mundial, a França é favorita em qualquer torneio que disputa.',
    ),
    //Senegal
    const TeamInfoEntity(
      id: 'sn',
      name: 'Senegal',
      flagCode: 'sn',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/7/7c/FSenegalaiseF.png/250px-FSenegalaiseF.png',
      coach: 'Pape Thiaw',
      captain: 'Kalidou Koulibaly',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/k0axyudt2clw4ruxczhz',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/kzq4z4cd3sqtwr0xwetv',
      confederation: 'CAF',
      nickname: 'Les Lions de la Téranga / Lions of Teranga',
      fifaRanking:
          17, // Senegal é a 2ª força da África no ranking atual e costuma figurar no Top 20
      founded: 1960,
      worldCupAppearances: 3,
      worldCupWins: 0,
      worldCupYears: [2002, 2018, 2022],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Senegalesa de Futebol, famosa mundialmente como "Les Lions de la Téranga" (Os Leões da Teranga), é uma das equipes mais técnicas e perigosas do continente africano. Administrada pela Federação Senegalesa de Futebol (fundada em 1960), a equipe chocou o mundo logo em sua estreia em Copas do Mundo, em 2002, quando derrotou a então campeã França no jogo de abertura e alcançou as quartas de final. Recentemente, a equipe viveu o ápice de sua história ao conquistar o seu primeiro título da Copa das Nações Africanas (2021), consolidando uma geração de ouro liderada por astros como Sadio Mané e Kalidou Koulibaly.',
    ),
    //Noruega
    const TeamInfoEntity(
      id: 'no',
      name: 'Noruega',
      flagCode: 'no',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/9/97/Sele%C3%A7%C3%A3o_Norueguesa_de_Futebol_Logo.png/120px-Sele%C3%A7%C3%A3o_Norueguesa_de_Futebol_Logo.png',
      coach: 'Ståle Solbakken',
      captain: 'Martin Ødegaard',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/qe1l3fv9awnbsbq1ksxc',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/rbl4elgquvrmueotjh56',
      confederation: 'UEFA',
      nickname: '	Løvene / Os Leões',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //Iraque
    const TeamInfoEntity(
      id: 'iq',
      name: 'Iraque',
      flagCode: 'iq',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Iraq_National_Team_Badge_2021_v2.svg/250px-Iraq_National_Team_Badge_2021_v2.svg.png',
      coach: 'Jesús Casas',
      captain: 'Jalal Hassan',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/l9op8s9thwzvxx02aoed',
      uniformAwayUrl: '',
      confederation: 'AFC',
      nickname: 'Asood Al-Rafidain / Leões da Mesopotâmia',
      fifaRanking:
          58, // Posição recente (eles têm subido nas eliminatórias); vale conferir na FIFA
      founded: 1948,
      worldCupAppearances: 1,
      worldCupWins: 0,
      worldCupYears: [1986],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Iraquiana de Futebol, orgulhosamente conhecida como "Os Leões da Mesopotâmia" (Asood Al-Rafidain), tem uma história marcada por superação e resiliência. A Associação Iraquiana de Futebol foi fundada em 1948. A equipe fez sua primeira e única aparição em Copas do Mundo em 1986, no México. O momento mais emocionante e unificador de sua história esportiva ocorreu em 2007, quando, mesmo com o país severamente afetado por conflitos, a seleção conquistou o título histórico da Copa da Ásia, trazendo um momento raro de imensa alegria e união ao povo iraquiano.',
    ),
    //Bolívia
    const TeamInfoEntity(
      id: 'bo',
      name: 'Bolívia',
      flagCode: 'bo',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //Suriname
    const TeamInfoEntity(
      id: 'sr',
      name: 'Suriname',
      flagCode: 'sr',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //Grupo J
    // === ARGENTINA ===
    const TeamInfoEntity(
      id: 'ar',
      name: 'Argentina',
      flagCode: 'ar',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/f/fc/230px-Afa_logo.svg.png/250px-230px-Afa_logo.svg.png',
      coach: 'Lionel Scaloni',
      captain: 'Lionel Messi',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/vjnnyuj1fmjmw43sy6i0',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/mbsnx7l7f0d8pir0pbmf',
      confederation: 'CONMEBOL',
      nickname: 'La Albiceleste',
      fifaRanking:
          1, // Atualmente é a número 1 do mundo, mas vale sempre confirmar no ranking da FIFA
      founded: 1893,
      worldCupAppearances:
          19, // Ajustado para 19 para bater com a inclusão de 2026 na lista abaixo
      worldCupWins: 3,
      worldCupYears: [
        1930,
        1934,
        1958,
        1962,
        1966,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1978, 1986, 2022],
      bio:
          'A atual campeã mundial, a Argentina tem uma das histórias mais ricas e apaixonantes do futebol. Conhecida como "La Albiceleste", a seleção é administrada pela AFA, uma das federações mais antigas do mundo (1893). A equipe conquistou a Copa do Mundo em três ocasiões (1978, 1986 e 2022) e é a maior vencedora da Copa América. O país é famoso por revelar alguns dos maiores gênios da história do esporte, com destaque absoluto para Diego Maradona e Lionel Messi, verdadeiras divindades para os torcedores argentinos.',
    ),
    //Argélia
    const TeamInfoEntity(
      id: 'dz',
      name: 'Argélia',
      flagCode: 'dz',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/6/6b/Algeria_National_Football_Team_logo.png/120px-Algeria_National_Football_Team_logo.png',
      coach: 'Vladimir Petković',
      captain: 'Riyad Mahrez',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/yk4xey4ser0lr4ebhooo',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/ztgvrdyhy6utri4nei0o',
      confederation: 'CAF',
      nickname: 'ثعالب الصحراء - Les Fennecs',
      fifaRanking:
          73, // Estimativa recente; lembre-se de checar o ranking atualizado da FIFA
      founded: 1962,
      worldCupAppearances: 4,
      worldCupWins: 0,
      worldCupYears: [1982, 1986, 2010, 2014],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Argelina de Futebol, conhecida como "Les Fennecs" (As Raposas do Deserto), é uma das equipes mais tradicionais e respeitadas do continente africano. Filiada à FIFA após a independência do país em 1962, a Argélia sagrou-se campeã da Copa das Nações Africanas em duas ocasiões (1990 e 2019). Em Copas do Mundo, suas campanhas mais memoráveis incluem a vitória histórica sobre a Alemanha Ocidental em sua estreia em 1982, e a emocionante campanha de 2014, quando alcançou as oitavas de final e levou a futura campeã Alemanha à prorrogação.',
    ),
    //Áustria
    const TeamInfoEntity(
      id: 'at',
      name: 'Áustria',
      flagCode: 'at',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/c/cb/OFB.png/120px-OFB.png',
      coach: 'Ralf Rangnick',
      captain: 'David Alaba',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/ju02ldsqzngtyljdax8t',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/senxnvtoo3ikdbjc1bm5',
      confederation: 'UEFA',
      nickname: 'Das Team / Wunderteam ',
      fifaRanking:
          22, // Estimativa recente; lembre-se de verificar o site da FIFA para o número exato
      founded: 1904,
      worldCupAppearances: 7,
      worldCupWins: 0,
      worldCupYears: [1934, 1954, 1958, 1978, 1982, 1990, 1998],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Austríaca de Futebol, frequentemente chamada de "Das Team" (A Equipe) ou "Unsere Burschen" (Nossos Garotos), possui uma história clássica no futebol europeu. A equipe ficou eternizada na década de 1930 com o lendário "Wunderteam" (Time Maravilha), que encantou o mundo com seu estilo de jogo. Sua melhor campanha em Copas do Mundo ocorreu em 1954, quando conquistou o terceiro lugar. Outro momento inesquecível de sua história é o "Milagre de Córdoba", na Copa de 1978, quando derrotou a grande rival Alemanha Ocidental.',
    ),
    //Jordânia
    const TeamInfoEntity(
      id: 'jo',
      name: 'Jordânia',
      flagCode: 'jo',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/4/44/Jordan_Football_Association.png/250px-Jordan_Football_Association.png',
      coach: 'Jamal Sellami',
      captain: 'Ihsan Haddad',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/viz21rpdfywc12kwx8ky',
      uniformAwayUrl: '',
      confederation: 'AFC',
      nickname: 'Al-Nashama / Os Bravos',
      fifaRanking:
          71, // Estimativa da posição atual após a ótima campanha na Copa da Ásia
      founded: 1949,
      worldCupAppearances: 0,
      worldCupWins: 0,
      worldCupYears: [],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Jordaniana de Futebol, orgulhosamente conhecida como "Al-Nashama" (Os Bravos ou Os Cavalheiros), tem mostrado um crescimento espetacular no cenário do futebol asiático. Administrada pela Associação de Futebol da Jordânia (fundada em 1949), a equipe ainda luta pelo sonho de sua primeira classificação para uma Copa do Mundo. No entanto, o país fez história recentemente ao realizar uma campanha épica e chegar à grande final da Copa da Ásia de 2023 (disputada no início de 2024), provando definitivamente ser uma força emergente e perigosa na AFC.',
    ),
    //Grupo K
    //Portugal
    const TeamInfoEntity(
      id: 'pt',
      name: 'Portugal',
      flagCode: 'pt',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Portugal_National_Team_logo.png/250px-Portugal_National_Team_logo.png',
      coach: 'Roberto Martínez',
      captain: 'Cristiano Ronaldo',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/uhdimpfaaikrhpgrqrop',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/spr7kwpu8hisoaezku5h',
      confederation: 'UEFA',
      nickname: 'Seleção das Quinas / Os Navegadores',
      fifaRanking: 7, // Portugal mantém-se firmemente no Top 10 mundial
      founded: 1914,
      worldCupAppearances: 9, // Já contando com a presença garantida em 2026
      worldCupWins: 0,
      worldCupYears: [1966, 1986, 2002, 2006, 2010, 2014, 2018, 2022, 2026],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Portuguesa de Futebol, carinhosamente chamada de "Seleção das Quinas", é uma das equipas mais talentosas do futebol moderno. Administrada pela Federação Portuguesa de Futebol (fundada em 1914), a equipa viveu um crescimento meteórico no século XXI. Com um histórico que conta com lendas como Eusébio e o recordista Cristiano Ronaldo, Portugal alcançou a glória europeia ao vencer o Euro 2016 e a Liga das Nações em 2019. Em Mundiais, o seu melhor registo é o 3º lugar em 1966, e a nação chega a 2026 com uma das gerações mais tecnicamente evoluídas da sua história.',
    ),
    //Uzbequistão
    const TeamInfoEntity(
      id: 'uz',
      name: 'Uzbequistão',
      flagCode: 'uz',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/b/b6/Uzbekistan_Football_Federation.png/250px-Uzbekistan_Football_Federation.png',
      coach: 'Srečko Katanec',
      captain: 'Eldor Shomurodov',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/h458sro0m2hiipjof14h',
      uniformAwayUrl: '',
      confederation: 'AFC',
      nickname: 'Oq boʻrilar / White Wolves',
      fifaRanking:
          68, // Posição média recente; vale conferir na FIFA para o número exato
      founded: 1946,
      worldCupAppearances: 0,
      worldCupWins: 0,
      worldCupYears: [],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Uzbeque de Futebol, conhecida como "Oq boʻrilar" (White Wolves), é uma das potências emergentes da Ásia Central. Desde a sua filiação à FIFA em 1994, após a independência, o Uzbequistão tem batido na trave para se classificar para o Mundial, chegando por diversas vezes às fases finais das eliminatórias. Com um futebol físico e organizado, e contando com o talento do artilheiro Eldor Shomurodov, a equipe conquistou a medalha de ouro nos Jogos Asiáticos de 1994 e entra no ciclo de 2026 como uma das favoritas a conquistar uma das novas vagas do continente asiático.',
    ),
    //Colômbia
    const TeamInfoEntity(
      id: 'co',
      name: 'Colômbia',
      flagCode: 'co',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/FCF-Logo-2023.svg/250px-FCF-Logo-2023.svg.png',
      coach: 'Néstor Lorenzo',
      captain: 'James Rodríguez',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/h8aekdaep7rar2fmolt4',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/xamovce4u5nbcz7j52eh',
      confederation: 'CONMEBOL',
      nickname: 'Los Cafeteros / La Tricolor',
      fifaRanking:
          14, // A Colômbia vive ótima fase e está no topo do ranking, mas sempre vale conferir a posição exata
      founded: 1924,
      worldCupAppearances: 6,
      worldCupWins: 0,
      worldCupYears: [1962, 1990, 1994, 1998, 2014, 2018],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Colombiana de Futebol, carinhosamente chamada de "Los Cafeteros" e "La Tricolor", é uma das equipes mais queridas e tradicionais da América do Sul. Administrada pela Federação Colombiana de Futebol (fundada em 1924), a seleção viveu gerações mágicas, desde os anos 90 com Carlos Valderrama e Freddy Rincón, até a conquista invicta da Copa América de 2001. Em Copas do Mundo, a sua campanha mais inesquecível ocorreu em 2014, no Brasil, quando alcançou as quartas de final guiada pelo talento de James Rodríguez, artilheiro daquela edição.',
    ),
    //Republica do Congo
    const TeamInfoEntity(
      id: 'cd', // Atenção: alterado de 'cg' para 'cd' (código ISO da Rep. Democrática do Congo)
      name: 'Rep. Democrática do Congo',
      flagCode: 'cd', // Alterado para 'cd'
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/e/ee/F%C3%A9d%C3%A9ration_Congolaise_de_Football_Association.png/250px-F%C3%A9d%C3%A9ration_Congolaise_de_Football_Association.png',
      coach: 'Sébastien Desabre',
      captain: 'Chancel Mbemba',
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/bwbiybxtuo1wn2i4fi9z',
      uniformAwayUrl: '',
      confederation: 'CAF',
      nickname: 'Les Léopards / Os Leopardos',
      fifaRanking:
          63, // Posição média atual após a boa campanha na última Copa Africana
      founded: 1919,
      worldCupAppearances: 1,
      worldCupWins: 0,
      worldCupYears: [1974],
      worldCupTitlesYears: [],
      bio:
          'A Seleção da República Democrática do Congo, temida e respeitada no continente como "Les Léopards" (Os Leopardos), é uma das equipes mais tradicionais da África Subsaariana. Administrada pela FECOFA (fundada em 1919), a nação tem uma história rica e de pioneirismo. Em 1974, quando o país ainda se chamava Zaire, eles fizeram história ao se tornarem a primeira nação da África Subsaariana a se classificar para uma Copa do Mundo (disputada na Alemanha Ocidental). Bicampeões da Copa das Nações Africanas (1968 e 1974), os Leopardos buscam o tão sonhado retorno ao Mundial.',
    ),
    //Jamaica
    const TeamInfoEntity(
      id: 'jm',
      name: 'Jamaica',
      flagCode: 'jm',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //Nova Caledônia
    const TeamInfoEntity(
      id: 'nc',
      name: 'Nova Caledônia',
      flagCode: 'nc',
      coatOfArmsUrl: '',
      coach: '',
      captain: '',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: '',
      nickname: '',
      fifaRanking: 0,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio: 'Informacoes aqui em breve.',
    ),
    //Grupo L
    //Inglaterra
    const TeamInfoEntity(
      id: 'gb',
      name: 'Inglaterra',
      flagCode: 'gb',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Arms_of_The_Football_Association_%28include_star%29.svg/250px-Arms_of_The_Football_Association_%28include_star%29.svg.png',
      coach: 'Thomas Tuchel',
      captain: 'Harry Kane',
      // titular
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/tirswisd1vmvdxrvesuq',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/eh1z0bvlp8mdtp032mts',
      confederation: 'UEFA',
      nickname: 'The Three Lions / Os Três Leões',
      fifaRanking:
          4, // A Inglaterra costuma se manter firme no Top 5; lembre-se de checar o número exato na FIFA
      founded: 1863,
      worldCupAppearances: 17, // Já englobando a edição de 2026
      worldCupWins: 1,
      worldCupYears: [
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1982,
        1986,
        1990,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1966],
      bio:
          'A Seleção Inglesa de Futebol, famosa como "The Three Lions" (Os Três Leões), representa o país onde o futebol moderno foi inventado. Administrada pela The Football Association (FA), a federação de futebol mais antiga do mundo (fundada em 1863), a Inglaterra é uma das forças mais tradicionais do esporte. O ápice de sua história ocorreu em 1966, quando sediou e venceu a Copa do Mundo, erguendo a taça no lendário estádio de Wembley. Apesar de décadas de frustrações após esse título, os ingleses vivem uma ótima fase recente com uma geração extremamente talentosa, liderada pelo artilheiro Harry Kane.',
    ),
    //Croácia
    const TeamInfoEntity(
      id: 'hr',
      name: 'Croácia',
      flagCode: 'hr',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/c/cf/Croatia_football_federation.png/250px-Croatia_football_federation.png',
      coach: 'Zlatko Dalić',
      captain: 'Luka Modrić',
      // titular
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/mcmgpow5acrce5axuqtl',
      uniformAwayUrl: '',
      confederation: 'UEFA',
      nickname: 'Vatreni/Os Ardentes - Kockasti/O Time Xadrez',
      fifaRanking:
          10, // A Croácia tem se mantido no Top 10 nos últimos anos, mas vale checar a posição exata na FIFA
      founded: 1912,
      worldCupAppearances: 6,
      worldCupWins: 0,
      worldCupYears: [1998, 2002, 2006, 2014, 2018, 2022],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Croata de Futebol, conhecida como "Vatreni" (Os Ardentes), é uma das equipes mais surpreendentes e resilientes do futebol moderno. A Federação Croata de Futebol foi fundada em 1912, mas a seleção só se afiliou à FIFA em 1992, após a independência do país. Apesar da curta história em Copas do Mundo (apenas 6 participações), a Croácia já alcançou o pódio três vezes: um histórico terceiro lugar em sua estreia em 1998, o inesquecível vice-campeonato em 2018 e, novamente, o terceiro lugar no Catar em 2022, liderada pela genialidade inesgotável de seu maior ídolo, Luka Modrić.',
    ),
    //Gana
    const TeamInfoEntity(
      id: 'gh',
      name: 'Gana',
      flagCode: 'gh',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/6/67/Ghana_Football_Association.png/250px-Ghana_Football_Association.png',
      coach: 'A definir',
      captain: 'Jordan Ayew',
      // titular
      uniformHomeUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/ei4zvumfyumtdowhjusf',
      uniformAwayUrl:
          'https://img.olympics.com/images/image/private//t_s_w1460/f_auto/primary/g7yrqiwekej1mggfoapx',
      confederation: 'CAF',
      nickname: 'The Black Stars / Estrelas Negras',
      fifaRanking:
          67, // Posição média recente; lembre-se de conferir no site da FIFA a posição exata
      founded: 1957,
      worldCupAppearances: 4,
      worldCupWins: 0,
      worldCupYears: [2006, 2010, 2014, 2022],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Ganesa de Futebol, temida e respeitada como "The Black Stars" (As Estrelas Negras), é uma das equipes mais fortes e tradicionais do continente africano. A Associação de Futebol de Gana foi fundada em 1957, mesmo ano da independência do país. Tetracampeã da Copa das Nações Africanas, Gana estreou em Copas do Mundo em 2006. O momento mais inesquecível de sua história no torneio ocorreu em 2010, na África do Sul, quando a equipe encantou o mundo e chegou a um passo das semifinais, parando apenas nas quartas de final em um jogo épico e dramático contra o Uruguai.',
    ),
    //Panamá
    const TeamInfoEntity(
      id: 'pa',
      name: 'Panamá',
      flagCode: 'pa',
      coatOfArmsUrl: '',
      coach: 'Thomas Christiansen',
      captain: 'Aníbal Godoy',
      //titular
      uniformHomeUrl:
          'https://upload.wikimedia.org/wikipedia/commons/d/da/Kit_shorts_pan25h.png',
      //reserva
      uniformAwayUrl:
          'https://upload.wikimedia.org/wikipedia/commons/6/6d/Kit_shorts_pan25a.png',
      confederation: 'CONCACAF',
      nickname: 'La Marea Roja or Los Canaleros',
      fifaRanking: 33,
      founded: 1937,
      worldCupAppearances: 2,
      worldCupWins: 0,
      worldCupYears: [2018, 2026],
      worldCupTitlesYears: [],
      bio:
          'A Seleção Panamenha de Futebol representa o Panamá nas competições de futebol da FIFA. É considerada uma seleção em ascensão na região do Caribe, tendo conquistado vaga para a Copa de 2018, que foi a primeira de sua história.',
    ),
  ];

  debugPrint('⏳ Iniciando a inserção de ${todasAsSelecoes.length} seleções...');
  int inseridasComSucesso = 0;

  for (var selecao in todasAsSelecoes) {
    try {
      await firestore
          .collection('teams_info')
          .doc(selecao.id)
          .set(selecao.toMap());

      inseridasComSucesso++;
      debugPrint('✅ ${selecao.name} inserida!');
    } catch (e) {
      debugPrint('❌ ERRO ao inserir ${selecao.name}: $e');
    }
  }

  debugPrint(
    '🎉 CONCLUÍDO: $inseridasComSucesso/${todasAsSelecoes.length} seleções salvas no Firestore!',
  );
}
