//
//  SETUP_INSTRUCTIONS.md
//  ios_viper_example
//
//  Created on 2025-11-24.
//

# 🚀 Instruções de Configuração - Movie Catalog VIPER

## ⚠️ IMPORTANTE: Configurar API Key do TMDB

Para que o app funcione corretamente, você precisa configurar sua chave de API do TMDB.

### Passo 1: Obter API Key

1. Acesse: [https://www.themoviedb.org/](https://www.themoviedb.org/)
2. Crie uma conta gratuita (se ainda não tiver)
3. Vá para: **Settings → API**
4. Solicite uma API Key (escolha a opção "Developer")
5. Copie sua **API Key (v3 auth)**

### Passo 2: Configurar no Projeto

1. Abra o arquivo: `ios_viper_example/Common/Network/NetworkManager.swift`

2. Localize a linha:
```swift
private let apiKey = "YOUR_TMDB_API_KEY"
```

3. Substitua `YOUR_TMDB_API_KEY` pela sua chave:
```swift
private let apiKey = "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6"  // Exemplo
```

4. Salve o arquivo

### Passo 3: Executar o Projeto

1. Abra o projeto no Xcode:
```bash
open ios_viper_example.xcodeproj
```

2. Selecione um simulador (iPhone 15 Pro recomendado)

3. Pressione `Cmd + R` ou clique no botão Play

## 📱 Funcionalidades Disponíveis

Após configurar a API Key, você poderá:

✅ **Ver filmes populares** - Tela inicial com lista de filmes  
✅ **Buscar filmes** - Ícone de busca no canto superior direito  
✅ **Ver detalhes** - Toque em qualquer filme para ver detalhes completos  
✅ **Favoritar filmes** - Ícone de coração para adicionar aos favoritos  
✅ **Ver favoritos** - Ícone de coração preenchido no topo para ver lista de favoritos  

## 🧪 Executar Testes

Para executar os testes unitários:

1. Pressione `Cmd + U` no Xcode
2. Ou vá em: **Product → Test**

Os testes demonstram a testabilidade da arquitetura VIPER.

## 🔧 Troubleshooting

### Erro: "Invalid API Key"
- Verifique se copiou a API Key corretamente
- Certifique-se de usar a API Key v3 (não v4)
- Verifique se não há espaços extras

### Erro: "No data received"
- Verifique sua conexão com a internet
- Certifique-se de que a API Key está ativa no TMDB

### Imagens não carregam
- Verifique se o simulador tem acesso à internet
- As imagens são carregadas de forma assíncrona, aguarde alguns segundos

## 📚 Próximos Passos

Após configurar e executar o app:

1. **Explore o código** - Veja como cada módulo VIPER está estruturado
2. **Leia o README.md** - Documentação completa da arquitetura
3. **Execute os testes** - Veja exemplos de testes unitários
4. **Adicione features** - Experimente adicionar novos módulos

## 💡 Dicas

- Use o **Cmd + Shift + O** para buscar arquivos rapidamente
- Explore a pasta `Modules/` para ver a estrutura VIPER
- Cada módulo segue o mesmo padrão: Protocols → View → Presenter → Interactor → Router

---

**Desenvolvido com ❤️ usando VIPER Architecture**
