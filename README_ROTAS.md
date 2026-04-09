<!-- 
  📖 GUIA COMPLETO: SISTEMA DE ROTAS NOMEADAS
  ============================================================
  
  Este documento explica como funciona o sistema de navegação
  (rotas nomeadas) do WSports Cup Premium.
  
  Data: 09/04/2026
  Status: ✅ Implementado e Documentado
-->

# 🗺️ Sistema de Rotas Nomeadas - Guia Completo

## 📌 O que é uma Rota Nomeada?

Uma **rota nomeada** é um sistema de navegação que permite:
- Navegar para telas sem duplicar código
- Centralizar toda configuração de navegação
- Passar dados de forma controlada
- Suportar deep linking

### ❌ Forma Antiga (Ruim)
```dart
// Espalhado por todo código - DUPLICAÇÃO!
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const WorldCupPage()),
);
```

### ✅ Forma Nova (Boa)
```dart
// Centralizado, simples, reutilizável
Navigator.pushNamed(context, AppRoutes.worldCup);
```

---

## 🏗️ Arquitetura das Rotas

### 1️⃣ **AppRoutes** (`core/routes/app_routes.dart`)
Define todas as constantes de rotas:
```dart
class AppRoutes {
  static const String infoPage = '/info';       // Home
  static const String worldCup = '/world-cup';  // Simulação
}
```

### 2️⃣ **onGenerateRoute** (`main.dart`)
Mapeia rotas para widgets:
```dart
static Route<dynamic>? _generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.infoPage:
      return MaterialPageRoute(builder: (_) => const InfoPage());
    case AppRoutes.worldCup:
      return MaterialPageRoute(builder: (_) => const WorldCupPage());
  }
}
```

### 3️⃣ **Uso nas Telas**
Simples e centralizado:
```dart
// Em info_page.dart
Navigator.pushNamed(context, AppRoutes.worldCup);
```

---

## 🚀 Como Usar

### Navegação Simples
```dart
// Navegar para tela de simulação
Navigator.pushNamed(context, AppRoutes.worldCup);

// Navegar e esperar resultado
final result = await Navigator.pushNamed<bool>(
  context, 
  AppRoutes.worldCup
);
```

### Navegar com Argumentos
```dart
// Em uma tela:
Navigator.pushNamed(
  context,
  AppRoutes.teamDetail,
  arguments: {'teamId': 'brasil', 'groupId': 'A'}
);

// Na outra tela:
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final args = ModalRoute.of(context)!.settings.arguments 
    as Map<String, String>;
  final teamId = args['teamId'];
}
```

### Voltar para Rota Específica
```dart
// Volta uma tela
Navigator.pop(context);

// Volta até uma rota específica
Navigator.popUntil(
  context,
  ModalRoute.withName(AppRoutes.infoPage)
);
```

---

## 📝 Passo-a-Passo: Adicionar Nova Rota

### 1. Defina a Constante
Em `core/routes/app_routes.dart`:
```dart
class AppRoutes {
  static const String infoPage = '/info';
  static const String worldCup = '/world-cup';
  static const String minhaNovaTela = '/minha-nova-tela'; // ← NOVO
}
```

### 2. Crie o Case no onGenerateRoute
Em `main.dart` (método `_generateRoute`):
```dart
case AppRoutes.minhaNovaTela:
  return MaterialPageRoute(
    builder: (_) => const MinhaNovaTelaPage(),
    settings: settings,
  );
```

### 3. Use em Suas Telas
```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, AppRoutes.minhaNovaTela);
  },
  child: const Text('Ir para Minha Nova Tela'),
)
```

✅ **Pronto!** A rota está configurada e functional.

---

## 🎯 Vantagens Práticas

| Aspecto | Com Rotas Nomeadas | Sem Rotas Nomeadas |
|--------|------------------|-------------------|
| **Localização de rotas** | Tudo em um lugar | Espalhado por toda app |
| **Refatoração** | Alterar 1 lugar | Alterar em vários lugares |
| **Typos** | Caught em compile-time | Apenas em runtime |
| **Documentação** | Central e clara | Difícil de manter |
| **Deep linking** | Suportado | Não suportado |
| **Transições custom** | Fácil de adicionar | Difícil de padronizar |

---

## ⚡ Dicas Avançadas

### Transições Customizadas por Rota
```dart
case AppRoutes.worldCup:
  // Transição fade
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return const WorldCupPage();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
```

### Middleware/Guards (Verificação antes de navegar)
```dart
static Route<dynamic>? _generateRoute(RouteSettings settings) {
  // Verificar autenticação antes de certos rotas
  if (settings.name == AppRoutes.premium) {
    if (!isUserAuthenticated()) {
      return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
  // ... resto do código
}
```

### Deep Linking (URLs profundas)
```dart
// android/app/AndroidManifest.xml pode usar:
// wsports://info
// wsports://world-cup
// wsports://team-detail?teamId=brasil
```

---

## 📊 Estrutura Current (09/04/2026)

```
lib/
└── core/
    ├── routes/
    │   └── app_routes.dart           ← Definições de rotas
    └── ...
lib/main.dart                          ← Gerador de rotas (onGenerateRoute)
```

---

## 🔍 Verificar Rotas Configuradas

Para saber quais rotas estão disponíveis, consulte:
1. **Definições**: `AppRoutes` class em `core/routes/app_routes.dart`
2. **Implementação**: `_generateRoute()` method em `main.dart`

```dart
// Rotas disponíveis:
AppRoutes.infoPage      → /info      (Home)
AppRoutes.worldCup      → /world-cup (Simulação)
```

---

## ❓ FAQ

**P: Por que não usar `home: const InfoPage()` direto?**
R: Porque queremos suporte a rotas nomeadas, deep linking e melhor escalabilidade.

**P: Posso misturar `home` e `onGenerateRoute`?**
R: Não recomendado. Use `initialRoute` + `onGenerateRoute` para consistência.

**P: Como debugar rotas?**
R: Adicione print em `_generateRoute`:
```dart
debugPrint('Navigating to: ${settings.name}');
```

**P: Qual é o melhor padrão para nomes de rotas?**
R: Use `/` no início, use `-` para separar palavras, ex: `/user-profile`, `/team-detail`.

---

## 📚 Referências

- [Flutter Navigation & Routing](https://flutter.dev/docs/development/ui/navigation)
- [Named Routes](https://flutter.dev/docs/cookbook/navigation/named-routes)
- [Deep Linking](https://flutter.dev/docs/development/ui/navigation/deep-linking)

---

## 📝 Histórico de Alterações

| Data | Alteração | Status |
|------|-----------|--------|
| 09/04/2026 | Criar sistema de rotas nomeadas | ✅ Completo |
| ... | ... | ... |

---

**Última atualização:** 09/04/2026  
**Responsável:** GitHub Copilot  
**Status:** ✅ Documentado e Implementado
