# 🔄 FLUXOS DE DADOS - Movie Catalog VIPER

Este documento detalha os fluxos de dados completos em cada módulo do aplicativo.

## 📋 Fluxo 1: Carregar Lista de Filmes

### Sequência Completa:

```
1. App Launch
   └─> SceneDelegate.scene()
       └─> MovieListRouter.createModule()
           ├─> Cria View
           ├─> Cria Presenter
           ├─> Cria Interactor
           ├─> Cria Router
           └─> Conecta todos via protocols

2. View Loaded
   └─> MovieListViewController.viewDidLoad()
       └─> presenter.viewDidLoad()

3. Presenter Coordena
   └─> MovieListPresenter.viewDidLoad()
       ├─> view.showLoading()
       └─> interactor.fetchPopularMovies(page: 1)

4. Interactor Busca Dados
   └─> MovieListInteractor.fetchPopularMovies()
       └─> NetworkManager.fetchPopularMovies()
           └─> URLSession.dataTask()
               └─> GET https://api.themoviedb.org/3/movie/popular

5. Resposta da API
   └─> NetworkManager recebe JSON
       └─> Decodifica para MovieResponse
           └─> Retorna Result<MovieResponse, NetworkError>

6. Interactor Processa
   └─> MovieListInteractor recebe resultado
       └─> presenter.didFetchMovies([Movie])

7. Presenter Formata
   └─> MovieListPresenter.didFetchMovies()
       ├─> view.hideLoading()
       └─> view.showMovies([Movie])

8. View Atualiza UI
   └─> MovieListViewController.showMovies()
       └─> collectionView.reloadData()
           └─> UI atualizada na main thread
```

### Diagrama Visual:

```
┌─────────────┐
│  App Start  │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────┐
│  SceneDelegate                      │
│  - MovieListRouter.createModule()   │
└──────┬──────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────┐
│  MovieListViewController            │
│  - viewDidLoad()                    │
│  - presenter.viewDidLoad()          │
└──────┬──────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────┐
│  MovieListPresenter                 │
│  - view.showLoading()               │
│  - interactor.fetchPopularMovies()  │
└──────┬──────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────┐
│  MovieListInteractor                │
│  - NetworkManager.fetch()           │
└──────┬──────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────┐
│  NetworkManager                     │
│  - URLSession.dataTask()            │
│  - Decode JSON                      │
└──────┬──────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────┐
│  TMDB API                           │
│  - Returns JSON                     │
└──────┬──────────────────────────────┘
       │
       ▼ (Response)
┌─────────────────────────────────────┐
│  Interactor                         │
│  - presenter.didFetchMovies()       │
└──────┬──────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────┐
│  Presenter                          │
│  - view.hideLoading()               │
│  - view.showMovies()                │
└──────┬──────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────┐
│  View                               │
│  - collectionView.reloadData()      │
│  - UI Updated ✅                    │
└─────────────────────────────────────┘
```

## 🎬 Fluxo 2: Navegar para Detalhes

```
1. User Action
   └─> Toca em um filme na lista

2. View Captura
   └─> collectionView(_:didSelectItemAt:)
       └─> presenter.didSelectMovie(at: index)

3. Presenter Coordena
   └─> MovieListPresenter.didSelectMovie()
       ├─> Pega o Movie do array
       └─> router.navigateToMovieDetails(movie)

4. Router Navega
   └─> MovieListRouter.navigateToMovieDetails()
       ├─> MovieDetailsRouter.createModule(with: movie)
       │   ├─> Cria todas as camadas
       │   └─> Passa movie para Presenter
       └─> navigationController.push()

5. MovieDetails Carrega
   └─> MovieDetailsViewController.viewDidLoad()
       └─> presenter.viewDidLoad()
           ├─> view.showLoading()
           ├─> interactor.fetchMovieDetails(movieId)
           └─> interactor.checkIfFavorite(movie)

6. Busca Detalhes
   └─> MovieDetailsInteractor
       ├─> NetworkManager.fetchMovieDetails()
       └─> FavoritesManager.isFavorite()

7. Atualiza UI
   └─> Presenter recebe dados
       ├─> view.showMovieDetails()
       └─> view.updateFavoriteButton()
```

## 🔍 Fluxo 3: Buscar Filmes

```
1. User Action
   └─> Toca no ícone de busca

2. Navegação
   └─> MovieListRouter.navigateToSearch()
       └─> SearchRouter.createModule()

3. User Digita
   └─> UISearchController
       └─> updateSearchResults(for:)
           └─> Debounce 0.5s
               └─> presenter.searchMovies(query)

4. Busca na API
   └─> SearchPresenter
       └─> interactor.searchMovies()
           └─> NetworkManager.searchMovies()
               └─> GET /search/movie?query=...

5. Exibe Resultados
   └─> Interactor retorna [Movie]
       └─> Presenter formata
           └─> View atualiza tableView
```

### Diagrama de Debounce:

```
User Typing:  a -> ab -> abc -> abcd
              │    │     │      │
Debounce:     ✗    ✗     ✗      ✓ (0.5s depois)
              │    │     │      │
API Call:     -    -     -      ✓ search("abcd")
```

## ❤️ Fluxo 4: Adicionar aos Favoritos

```
1. User Action
   └─> Toca no ícone de coração

2. View Captura
   └─> favoriteButton tapped
       └─> presenter.didTapFavorite()

3. Presenter Coordena
   └─> MovieDetailsPresenter.didTapFavorite()
       └─> interactor.toggleFavorite(movie)

4. Interactor Processa
   └─> MovieDetailsInteractor.toggleFavorite()
       └─> FavoritesManager.toggleFavorite()
           ├─> Lê UserDefaults
           ├─> Adiciona/Remove movie
           ├─> Salva UserDefaults
           └─> Retorna novo status

5. Atualiza UI
   └─> interactor.presenter.didUpdateFavoriteStatus()
       └─> presenter.view.updateFavoriteButton()
           └─> Muda ícone: heart ↔ heart.fill
```

### Persistência Local:

```
┌─────────────────────────────────────┐
│  FavoritesManager                   │
├─────────────────────────────────────┤
│  getFavorites()                     │
│    └─> UserDefaults.data(forKey:)  │
│        └─> Decode [Movie]          │
│                                     │
│  addFavorite(movie)                 │
│    ├─> getFavorites()              │
│    ├─> append(movie)               │
│    └─> saveFavorites()             │
│                                     │
│  saveFavorites([Movie])             │
│    ├─> Encode to Data              │
│    └─> UserDefaults.set()          │
└─────────────────────────────────────┘
```

## 📱 Fluxo 5: Ver Favoritos

```
1. User Action
   └─> Toca no ícone de favoritos

2. Navegação
   └─> MovieListRouter.navigateToFavorites()
       └─> FavoritesRouter.createModule()

3. View Carrega
   └─> FavoritesViewController.viewDidLoad()
       └─> presenter.viewDidLoad()

4. Busca Favoritos
   └─> FavoritesPresenter
       └─> interactor.fetchFavorites()
           └─> FavoritesManager.getFavorites()
               └─> Lê do UserDefaults

5. Exibe Lista
   └─> Interactor retorna [Movie]
       └─> Presenter verifica se vazio
           ├─> Se vazio: view.showEmptyState()
           └─> Se tem: view.showMovies()

6. Atualização Automática
   └─> viewWillAppear()
       └─> presenter.viewWillAppear()
           └─> Recarrega favoritos
               └─> Atualiza se mudou
```

## 🔄 Fluxo 6: Paginação Infinita

```
1. User Scrolls
   └─> scrollViewDidScroll()
       └─> Detecta proximidade do fim
           └─> if offsetY > contentHeight - 100

2. Carrega Mais
   └─> presenter.loadMoreMovies()
       ├─> Incrementa currentPage
       └─> interactor.fetchPopularMovies(page: 2)

3. API Retorna
   └─> Interactor recebe novos filmes
       └─> presenter.didFetchMovies()

4. Append na Lista
   └─> Presenter detecta que não é página 1
       └─> view.appendMovies()
           └─> collectionView.insertItems()
               └─> Animação suave ✨
```

### Estado de Paginação:

```
┌─────────────────────────────────────┐
│  MovieListPresenter                 │
├─────────────────────────────────────┤
│  private var currentPage = 1        │
│  private var isLoading = false      │
│                                     │
│  loadMoreMovies()                   │
│    ├─> if isLoading: return        │
│    ├─> currentPage += 1            │
│    ├─> isLoading = true            │
│    └─> interactor.fetch(page)      │
│                                     │
│  didFetchMovies()                   │
│    ├─> isLoading = false           │
│    └─> if page == 1:               │
│           view.showMovies()         │
│        else:                        │
│           view.appendMovies()       │
└─────────────────────────────────────┘
```

## 🔄 Fluxo 7: Pull to Refresh

```
1. User Pulls Down
   └─> UIRefreshControl triggered
       └─> handleRefresh()

2. Reset Estado
   └─> presenter.refreshMovies()
       ├─> currentPage = 1
       ├─> movies.removeAll()
       └─> interactor.fetchPopularMovies(page: 1)

3. API Retorna
   └─> Novos dados chegam
       └─> presenter.didFetchMovies()

4. Atualiza UI
   └─> view.showMovies()
       ├─> collectionView.reloadData()
       └─> refreshControl.endRefreshing()
```

## ⚠️ Fluxo 8: Error Handling

```
1. Erro na API
   └─> NetworkManager retorna .failure(error)

2. Interactor Captura
   └─> switch result:
       case .failure(let error):
           └─> presenter.didFailToFetchMovies(error)

3. Presenter Trata
   └─> MovieListPresenter.didFailToFetchMovies()
       ├─> view.hideLoading()
       └─> view.showError(message)

4. View Exibe
   └─> UIAlertController
       ├─> Title: "Error"
       ├─> Message: error.localizedDescription
       └─> Action: "OK"
```

### Tipos de Erro:

```
enum NetworkError {
    case invalidURL        → "Invalid URL"
    case noData           → "No data received"
    case decodingError    → "Failed to decode"
    case serverError(msg) → Custom message
    case unknown          → "Unknown error"
}
```

## 🎯 Resumo dos Fluxos

| Fluxo | Origem | Destino | Tipo |
|-------|--------|---------|------|
| 1. Carregar Lista | App Start | MovieList | Data Flow |
| 2. Ver Detalhes | MovieList | MovieDetails | Navigation |
| 3. Buscar | MovieList | Search | Navigation |
| 4. Favoritar | MovieDetails | Local Storage | Data Flow |
| 5. Ver Favoritos | MovieList | Favorites | Navigation |
| 6. Paginar | MovieList | API | Data Flow |
| 7. Refresh | User Action | API | Data Flow |
| 8. Error | API | User | Error Flow |

## 💡 Padrões Observados

### 1. Unidirecional
```
View → Presenter → Interactor → Data Source
                ↓
            View ← Presenter ← Interactor
```

### 2. Desacoplamento
```
Camadas se comunicam apenas via Protocols
Nenhuma dependência concreta
```

### 3. Responsabilidade Única
```
View: UI
Presenter: Coordenação
Interactor: Lógica
Router: Navegação
Entity: Dados
```

---

**Este documento serve como referência para entender como os dados fluem através da arquitetura VIPER.**
