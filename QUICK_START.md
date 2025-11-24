# ⚡ QUICK START GUIDE

## 🚀 Começar em 5 Minutos

### 1️⃣ Obter API Key (2 min)

1. Acesse: https://www.themoviedb.org/signup
2. Crie uma conta gratuita
3. Vá em: **Settings → API → Request API Key**
4. Escolha: **Developer**
5. Copie sua **API Key (v3)**

### 2️⃣ Configurar Projeto (1 min)

1. Abra: `ios_viper_example/Common/Network/NetworkManager.swift`

2. Linha 18, substitua:
```swift
private let apiKey = "SUA_API_KEY_AQUI"
```

3. Salve o arquivo (Cmd+S)

### 3️⃣ Executar (2 min)

1. Abra o projeto:
```bash
cd /Users/fabiocunha/Documents/Projetos/ios_viper_example
open ios_viper_example.xcodeproj
```

2. Selecione: **iPhone 15 Pro** (simulador)

3. Pressione: **Cmd + R**

4. Aguarde compilar e executar

## ✅ Verificar se Funcionou

Você deve ver:
- ✅ Lista de filmes populares
- ✅ Imagens dos posters
- ✅ Botão de busca (topo direito)
- ✅ Botão de favoritos (topo direito)

## 🎯 Testar Funcionalidades

### Teste 1: Ver Detalhes
1. Toque em qualquer filme
2. Veja os detalhes completos
3. Toque no coração para favoritar

### Teste 2: Buscar
1. Toque no ícone de busca
2. Digite: "Avengers"
3. Veja os resultados

### Teste 3: Favoritos
1. Volte para lista principal
2. Toque no coração preenchido
3. Veja seus favoritos

### Teste 4: Paginação
1. Na lista principal
2. Scroll até o fim
3. Veja mais filmes carregando

## 🧪 Executar Testes

```bash
# No Xcode
Cmd + U
```

Ou:

**Product → Test**

## 📚 Próximos Passos

### Para Aprender:
1. Leia: `README.md`
2. Estude: `FLUXOS_DE_DADOS.md`
3. Veja: Código do módulo MovieList

### Para Desenvolver:
1. Leia: `VIPER_MODULE_TEMPLATE.md`
2. Crie um novo módulo
3. Adicione testes

### Para Entender:
1. Veja: `SUMARIO_EXECUTIVO.md`
2. Explore: Estrutura de pastas
3. Analise: Protocols de cada módulo

## ⚠️ Problemas Comuns

### Erro: "Invalid API Key"
**Solução:** Verifique se copiou a API Key corretamente

### Imagens não aparecem
**Solução:** Aguarde alguns segundos, são carregadas assincronamente

### Build Error
**Solução:** 
1. Clean Build Folder (Cmd+Shift+K)
2. Build novamente (Cmd+B)

### Simulador lento
**Solução:** Use iPhone 15 Pro ou superior

## 📖 Documentação Completa

- `README.md` - Documentação principal
- `SETUP_INSTRUCTIONS.md` - Setup detalhado
- `INDICE_PROJETO.md` - Índice completo
- `FLUXOS_DE_DADOS.md` - Diagramas de fluxo
- `VIPER_MODULE_TEMPLATE.md` - Como criar módulos
- `SUMARIO_EXECUTIVO.md` - Visão geral

## 🎓 Estrutura VIPER Resumida

```
Cada Módulo tem 5 camadas:

1. VIEW        → UI (ViewController)
2. PRESENTER   → Coordenação
3. INTERACTOR  → Lógica de Negócio
4. ROUTER      → Navegação
5. ENTITY      → Dados (Models)

Comunicação via PROTOCOLS
```

## 💡 Dicas Rápidas

### Navegação no Xcode
- `Cmd + Shift + O` - Buscar arquivo
- `Cmd + Shift + J` - Revelar no navegador
- `Cmd + Ctrl + ←/→` - Voltar/Avançar

### Atalhos Úteis
- `Cmd + B` - Build
- `Cmd + R` - Run
- `Cmd + U` - Test
- `Cmd + .` - Stop
- `Cmd + Shift + K` - Clean

### Explorar Código
1. Comece por: `SceneDelegate.swift`
2. Veja como cria: `MovieListRouter.createModule()`
3. Siga o fluxo: View → Presenter → Interactor

## 🎯 Checklist de Sucesso

- [ ] API Key configurada
- [ ] Projeto compilando
- [ ] App executando
- [ ] Filmes aparecendo
- [ ] Navegação funcionando
- [ ] Busca funcionando
- [ ] Favoritos funcionando
- [ ] Testes passando

## 🚀 Você está pronto!

Agora você tem um projeto VIPER completo e funcional!

**Próximo passo:** Explore o código e entenda como funciona cada camada.

---

**Tempo total: ~5 minutos**  
**Dificuldade: Fácil**  
**Resultado: App funcionando! 🎉**
