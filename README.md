# 🎬 Movie Catalog - VIPER Architecture

Um aplicativo iOS de catálogo de filmes implementado com arquitetura **VIPER** (View, Interactor, Presenter, Entity, Router), demonstrando as melhores práticas de desenvolvimento iOS modular e testável.

## 📋 Sobre o Projeto

Este projeto é uma implementação completa da arquitetura VIPER, criado para demonstrar:
- ✅ Separação clara de responsabilidades
- ✅ Alta testabilidade
- ✅ Escalabilidade e manutenibilidade
- ✅ Modularização de features
- ✅ Integração com API REST (TMDB)
- ✅ Persistência local de dados

## 🏗️ Arquitetura VIPER

### Diagrama de Componentes

```
┌─────────────────────────────────────────────────────────────┐
│                         VIPER MODULE                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────┐         ┌───────────┐        ┌──────────┐   │
│  │   VIEW   │◄───────►│ PRESENTER │◄──────►│  ROUTER  │   │
│  └──────────┘         └───────────┘        └──────────┘   │
│       ▲                     ▲                               │
│       │                     │                               │
│       │                     ▼                               │
│       │              ┌─────────────┐                        │
│       │              │ INTERACTOR  │                        │
│       │              └─────────────┘                        │
│       │                     │                               │
│       │                     ▼                               │
│       │              ┌─────────────┐                        │
│       └──────────────┤   ENTITY    │                        │
│                      └─────────────┘                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Responsabilidades de Cada Camada

#### 📱 **View** (UIViewController)
- Exibe dados na interface
- Captura eventos do usuário (taps, gestos)
- **NÃO** contém lógica de negócio
- Comunica-se apenas com o Presenter

#### 🎯 **Presenter**
- Ponte entre View e Interactor
- Formata dados para exibição
- Gerencia estado da View
- Coordena fluxo de dados

#### 💼 **Interactor**
- Contém toda a lógica de negócio
- Acessa serviços externos (Network, Database)
- Processa e valida dados
- **Altamente testável**

#### 🗺️ **Router**
- Gerencia navegação entre módulos
- Cria e monta módulos VIPER
- Controla fluxo de telas (push, modal, etc)

#### 📦 **Entity**
- Models de dados
- Structs/Classes que representam dados
- Independentes da UI

## 📂 Estrutura do Projeto

```
ios_viper_example/
├── Common/
│   ├── Protocols/
│   │   └── ViperProtocols.swift          # Protocolos base VIPER
│   ├── Entities/
│   │   └── Movie.swift                   # Entidades de dados
│   ├── Network/
│   │   └── NetworkManager.swift          # Gerenciador de rede
│   └── Storage/
│       └── FavoritesManager.swift        # Persistência local
│
├── Modules/
│   ├── MovieList/                        # 📋 Lista de filmes
│   │   ├── Protocols/
│   │   │   └── MovieListProtocols.swift
│   │   ├── View/
│   │   │   ├── MovieListViewController.swift
│   │   │   └── MovieCell.swift
│   │   ├── Presenter/
│   │   │   └── MovieListPresenter.swift
│   │   ├── Interactor/
│   │   │   └── MovieListInteractor.swift
│   │   └── Router/
│   │       └── MovieListRouter.swift
│   │
│   ├── MovieDetails/                     # 🎬 Detalhes do filme
│   │   ├── Protocols/
│   │   ├── View/
│   │   ├── Presenter/
│   │   ├── Interactor/
│   │   └── Router/
│   │
│   ├── Search/                           # 🔍 Busca de filmes
│   │   ├── Protocols/
│   │   ├── View/
│   │   ├── Presenter/
│   │   ├── Interactor/
│   │   └── Router/
│   │
│   └── Favorites/                        # ❤️ Filmes favoritos
│       ├── Protocols/
│       ├── View/
│       ├── Presenter/
│       ├── Interactor/
│       └── Router/
│
└── AppDelegate.swift
└── SceneDelegate.swift
```

## 🎯 Módulos Implementados

### 1. 📋 MovieList
**Funcionalidades:**
- Lista de filmes populares
- Paginação infinita
- Pull-to-refresh
- Navegação para detalhes, busca e favoritos

**Fluxo:**
```
User Action → View → Presenter → Interactor → NetworkManager
                ↑                      ↓
                └──────────────────────┘
```

### 2. 🎬 MovieDetails
**Funcionalidades:**
- Exibição detalhada do filme
- Informações: título, sinopse, nota, duração, gêneros
- Toggle de favorito
- Imagens (poster e backdrop)

**Destaque:**
- Integração com FavoritesManager
- UI rica com gradientes e layouts complexos

### 3. 🔍 Search
**Funcionalidades:**
- Busca de filmes por nome
- Debounce de 0.5s para otimização
- Resultados em tempo real
- Empty state quando não há busca

**Técnicas:**
- DispatchWorkItem para debounce
- UISearchController integrado

### 4. ❤️ Favorites
**Funcionalidades:**
- Lista de filmes favoritados
- Persistência local com UserDefaults
- Atualização automática ao voltar da tela de detalhes
- Empty state quando não há favoritos

## 🔌 Integração com TMDB API

### Endpoints Utilizados:
- `GET /movie/popular` - Filmes populares
- `GET /movie/{id}` - Detalhes do filme
- `GET /search/movie` - Busca de filmes

### Configuração da API Key:

1. Obtenha sua API key em: [https://www.themoviedb.org/settings/api](https://www.themoviedb.org/settings/api)

2. Copie o arquivo de exemplo:
```bash
cp ios_viper_example/Configuration.plist.example ios_viper_example/Configuration.plist
```

3. Abra `Configuration.plist` e substitua `YOUR_TMDB_API_KEY` pela sua chave:

```xml
<key>TMDB_API_KEY</key>
<string>SUA_API_KEY_AQUI</string>
```

> ⚠️ **Segurança**: O arquivo `Configuration.plist` está no `.gitignore` e nunca será commitado ao repositório, mantendo sua API key segura.


## 🧪 Testabilidade

A arquitetura VIPER facilita testes unitários:

### Exemplo de Teste do Presenter:

```swift
class MovieListPresenterTests: XCTestCase {
    var presenter: MovieListPresenter!
    var mockView: MockMovieListView!
    var mockInteractor: MockMovieListInteractor!
    var mockRouter: MockMovieListRouter!
    
    override func setUp() {
        super.setUp()
        presenter = MovieListPresenter()
        mockView = MockMovieListView()
        mockInteractor = MockMovieListInteractor()
        mockRouter = MockMovieListRouter()
        
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }
    
    func testViewDidLoad_CallsInteractor() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockInteractor.fetchPopularMoviesCalled)
    }
    
    func testDidFetchMovies_UpdatesView() {
        // Given
        let movies = [Movie(...)]
        
        // When
        presenter.didFetchMovies(movies)
        
        // Then
        XCTAssertTrue(mockView.showMoviesCalled)
        XCTAssertEqual(mockView.moviesShown, movies)
    }
}
```

### Exemplo de Teste do Interactor:

```swift
class MovieListInteractorTests: XCTestCase {
    var interactor: MovieListInteractor!
    var mockPresenter: MockMovieListPresenter!
    
    func testFetchPopularMovies_Success() {
        // Given
        let expectation = self.expectation(description: "Fetch movies")
        
        // When
        interactor.fetchPopularMovies(page: 1)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.mockPresenter.didFetchMoviesCalled)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
}
```

## 🚀 Como Executar

1. **Clone o repositório**
```bash
git clone <repository-url>
cd ios_viper_example
```

2. **Abra o projeto no Xcode**
```bash
open ios_viper_example.xcodeproj
```

3. **Configure a API Key**
- Copie `Configuration.plist.example` para `Configuration.plist`
- Adicione sua TMDB API key no arquivo `Configuration.plist`


4. **Execute o projeto**
- Selecione um simulador ou dispositivo
- Pressione `Cmd + R`

## 📱 Features Implementadas

- ✅ Lista de filmes populares com paginação
- ✅ Detalhes completos do filme
- ✅ Sistema de favoritos com persistência local
- ✅ Busca de filmes com debounce
- ✅ Pull-to-refresh
- ✅ Loading states
- ✅ Error handling
- ✅ Empty states
- ✅ Navegação fluida entre módulos
- ✅ Imagens assíncronas

## 🎨 Decisões de Design

### Por que VIPER?

1. **Separação de Responsabilidades**: Cada camada tem uma responsabilidade única e bem definida
2. **Testabilidade**: Fácil criar mocks e testar cada componente isoladamente
3. **Escalabilidade**: Adicionar novos módulos é simples e não afeta módulos existentes
4. **Manutenibilidade**: Código organizado facilita manutenção e debugging
5. **Trabalho em Equipe**: Múltiplos desenvolvedores podem trabalhar em módulos diferentes

### Padrões Utilizados:

- **Singleton**: NetworkManager, FavoritesManager
- **Delegate**: Comunicação entre camadas via protocols
- **Dependency Injection**: Injeção de dependências no Router
- **Factory Method**: Criação de módulos no Router

## 📊 Fluxo de Dados Completo

### Exemplo: Carregar Lista de Filmes

```
1. User abre o app
   ↓
2. SceneDelegate cria MovieListRouter.createModule()
   ↓
3. Router monta todas as camadas e conecta protocolos
   ↓
4. View chama presenter.viewDidLoad()
   ↓
5. Presenter chama interactor.fetchPopularMovies()
   ↓
6. Interactor chama NetworkManager.fetchPopularMovies()
   ↓
7. NetworkManager faz request para TMDB API
   ↓
8. Response é decodificada em [Movie]
   ↓
9. Interactor chama presenter.didFetchMovies()
   ↓
10. Presenter formata dados e chama view.showMovies()
    ↓
11. View atualiza UI na main thread
```

## 🔄 Exemplo de Navegação

### MovieList → MovieDetails

```swift
// 1. User toca em um filme
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    presenter?.didSelectMovie(at: indexPath.item)
}

// 2. Presenter notifica Router
func didSelectMovie(at index: Int) {
    let movie = movies[index]
    router?.navigateToMovieDetails(from: viewController, with: movie)
}

// 3. Router cria módulo e navega
func navigateToMovieDetails(from view: UIViewController, with movie: Movie) {
    let detailsModule = MovieDetailsRouter.createModule(with: movie)
    view.navigationController?.pushViewController(detailsModule, animated: true)
}
```

## 💡 Próximos Passos / Melhorias

- [ ] Adicionar testes unitários completos
- [ ] Implementar cache de imagens (Kingfisher/SDWebImage)
- [ ] Adicionar Core Data para favoritos
- [ ] Implementar filtros por gênero
- [ ] Adicionar trailers (YouTube integration)
- [ ] Dark mode customizado
- [ ] Animações de transição
- [ ] Compartilhamento de filmes
- [ ] Watchlist separada de favoritos

## 📚 Referências

- [VIPER Architecture](https://www.objc.io/issues/13-architecture/viper/)
- [TMDB API Documentation](https://developers.themoviedb.org/3)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## 👨‍💻 Autor

Desenvolvido como exemplo de implementação VIPER para iOS.

## 📄 Licença

Este projeto é livre para uso educacional e demonstrativo.

---

**Nota**: Este projeto foi criado para demonstrar a arquitetura VIPER em um cenário real. É ideal para estudos, entrevistas técnicas e como base para projetos escaláveis.