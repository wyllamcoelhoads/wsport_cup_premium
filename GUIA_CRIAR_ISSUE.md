<!-- 
  📖 GUIA - COMO CRIAR A ISSUE NO GITHUB
  ============================================================
  
  Passo-a-passo para criar a issue documentando todas as
  mudanças no repositório GitHub.
-->

# 📖 Guia: Como Criar a Issue no GitHub

## 🎯 Objetivo
Documentar formalmente todas as modificações e melhorias realizadas no projeto através de uma **Issue no GitHub**.

---

## 📋 Passo-a-Passo

### ✅ **PASSO 1: Ir para o Repositório**

1. Abra seu navegador
2. Vá para: **https://github.com/wyllamcoelhoads/wsport_cup_premium**
3. Clique na aba **"Issues"** no topo

```
GitHub.com → wyllamcoelhoads/wsport_cup_premium → Issues → New Issue
```

---

### ✅ **PASSO 2: Clicar em "New Issue"**

- Procure pelo botão verde **"New Issue"** (lado direito)
- Clique nele

```
┌────────────────────────────────────────┐
│  Issues   Pull Requests   ...          │
│                                        │
│                    [🟢 New Issue]      │ ← Clique aqui
└────────────────────────────────────────┘
```

---

### ✅ **PASSO 3: Preencher Título**

**Campo: "Title"**

Cole o título sugerido:
```
🎯 [FEAT] Refatoração de Arquitetura: Navegação por Rotas Nomeadas + Hub de Informações
```

---

### ✅ **PASSO 4: Preencher Descrição**

**Campo: "Leave a comment"** (o grande campo de texto)

1. Abra o arquivo:  
   `ISSUE_TEMPLATE_DOCUMENTACAO.md`
   
   (localizado na raiz do projeto)

2. Copie **TODO** o conteúdo (Ctrl+A → Ctrl+C)

3. Cole no campo de comentário da issue (Ctrl+V)

---

### ✅ **PASSO 5: Adicionar Labels (Opcional mas Recomendado)**

À direita do formulário, procure por **"Labels"**:

Clique em cada um para selecionar:
- ✅ `enhancement` (melhoria)
- ✅ `documentation` (documentação)
- ✅ `refactoring` (refatoração)

```
👉 Se não conseguir ver Labels, clique em:
   "Select 2 items" → marca os 3 acima
```

---

### ✅ **PASSO 6: Adicionar Assignee (Opcional)**

À direita, procure por **"Assignee"**:
- Clique e selecione seu nome de usuário
- Isso indica que VOCÊ foi quem fez a implementação

---

### ✅ **PASSO 7: Adicionar Projects (Opcional)**

Se tiver um projeto no GitHub:
- À direita, clique em **"Projects"**
- Selecione o projeto relevante

---

### ✅ **PASSO 8: Revisar e Publicar**

1. **Revise o conteúdo:**
   - Título está claro? ✅
   - Descrição completa? ✅
   - Labels selecionadas? ✅

2. **Clique em botão verde:**
   ```
   [🟢 Submit new issue]
   ```

---

## 🎉 Pronto!

A issue foi criada com sucesso! 🎉

---

## 📸 Preview da Issue (Como Ficará)

```
═════════════════════════════════════════════════════════════════
Title: 🎯 [FEAT] Refatoração de Arquitetura: Navegação por Rotas 
       Nomeadas + Hub de Informações

Status: Open
Created: 09/04/2026
Author: wyllamcoelhoads
Labels: enhancement, documentation, refactoring

═════════════════════════════════════════════════════════════════

## 📌 Resumo Executivo

Implementação de um sistema de navegação escalável e uma 
arquitetura UX mais intuitiva para o WSports Cup Premium...

[todo o conteúdo do ISSUE_TEMPLATE_DOCUMENTACAO.md]

═════════════════════════════════════════════════════════════════
```

---

## 💡 Dicas Extra

### Se Quiser Editar a Issue Depois:
1. Vá para a issue que acabou de criar
2. Clique em **"Edit"** (ícone de lápis)
3. Faça as alterações
4. Clique em **"Update comment"**

### Se Quiser Criar um Pull Request Conectado:
1. Crie o PR normalmente
2. Na descrição do PR, adicione:
   ```
   Closes #123
   ```
   (substitua 123 pelo número da issue)
3. Quando merged, a issue fecha automaticamente

### Se Quiser Converter para Draft (Rascunho):
1. Clique em **"..."** (3 pontinhos)
2. Selecione **"Convert to draft"**
3. Isso mantém a issue sem ser resolvida

---

## ✅ Checklist Final

- [ ] Issue criada com título claro
- [ ] Descrição completa com todas as mudanças
- [ ] Labels adicionadas (enhancement, documentation, refactoring)
- [ ] Assignee definido (você)
- [ ] Issue visível em: Issues → Open
- [ ] Você consegue comentar sobre ela

---

## 🔗 Links Úteis

### Após criar a issue, você pode:

1. **Compartilhar link:**
   ```
   https://github.com/wyllamcoelhoads/wsport_cup_premium/issues/[NUMERO]
   ```

2. **Mencionar em commits:**
   ```
   git commit -m "feat: xyz #[NUMERO]"
   ```

3. **Vincular a PR:**
   ```
   Closes #[NUMERO]
   ```

---

## 🚀 Próximo Passo

Após criar a issue, você pode:

1. **Criar um Pull Request** para oficializar as mudanças
2. **Adicionar comentários** se tiver observações
3. **Convidar reviewers** para avaliação
4. **Marcar como resolved** quando tudo estiver pronto

---

## ❓ Possíveis Dúvidas

**P: Não consigo ver o botão "New Issue"?**  
R: Certifique-se de estar na aba "Issues" e não em "Pull Requests"

**P: Posso adicionar imagens/screenshots?**  
R: Sim! Arraste para o campo de texto da issue

**P: Como adiciono código formatado?**  
R: Use ` ``` ` para bloco de código (já está no template)

**P: Posso fechar a própria issue?**  
R: Sim, clique em "Close issue" assim que todo o trabalho terminar

---

**Data:** 09/04/2026  
**Versão:** 1.0  
**Status:** ✅ Pronto para usar
