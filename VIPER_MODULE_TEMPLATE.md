//
//  VIPER_MODULE_TEMPLATE.md
//  ios_viper_example
//
//  Created on 2025-11-24.
//

# 📝 Template para Criar Novos Módulos VIPER

Este guia mostra como criar um novo módulo VIPER do zero seguindo o padrão do projeto.

## 🏗️ Estrutura de Pastas

Para cada novo módulo, crie a seguinte estrutura:

```
Modules/
└── NomeDoModulo/
    ├── Protocols/
    │   └── NomeDoModuloProtocols.swift
    ├── View/
    │   └── NomeDoModuloViewController.swift
    ├── Presenter/
    │   └── NomeDoModuloPresenter.swift
    ├── Interactor/
    │   └── NomeDoModuloInteractor.swift
    └── Router/
        └── NomeDoModuloRouter.swift
```

## 📋 Passo a Passo

### 1️⃣ Criar Protocols

```swift
import UIKit

// MARK: - View to Presenter
protocol NomeDoModuloViewToPresenterProtocol: BaseViewToPresenterProtocol {
    var interactor: NomeDoModuloPresenterToInteractorProtocol? { get set }
    var router: NomeDoModuloPresenterToRouterProtocol? { get set }
    
    func viewDidLoad()
    // Adicione métodos específicos do módulo
}

// MARK: - Presenter to View
protocol NomeDoModuloPresenterToViewProtocol: BasePresenterToViewProtocol {
    // Adicione métodos para atualizar a View
}

// MARK: - Presenter to Interactor
protocol NomeDoModuloPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    var presenter: NomeDoModuloInteractorToPresenterProtocol? { get set }
    
    // Adicione métodos de lógica de negócio
}

// MARK: - Interactor to Presenter
protocol NomeDoModuloInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    // Adicione callbacks do Interactor
}

// MARK: - Presenter to Router
protocol NomeDoModuloPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    // Adicione métodos de navegação
}
```

### 2️⃣ Criar View (ViewController)

```swift
import UIKit

class NomeDoModuloViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: NomeDoModuloViewToPresenterProtocol?
    
    // MARK: - UI Components
    // Adicione seus componentes de UI aqui
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Nome do Módulo"
        view.backgroundColor = .systemBackground
        
        // Configure sua UI
    }
}

// MARK: - Presenter to View Protocol

extension NomeDoModuloViewController: NomeDoModuloPresenterToViewProtocol {
    func showLoading() {
        // Implementar loading
    }
    
    func hideLoading() {
        // Implementar hide loading
    }
    
    func showError(message: String) {
        // Implementar exibição de erro
    }
}
```

### 3️⃣ Criar Presenter

```swift
import UIKit

class NomeDoModuloPresenter: NomeDoModuloViewToPresenterProtocol {
    
    // MARK: - Properties
    weak var view: BasePresenterToViewProtocol?
    var interactor: NomeDoModuloPresenterToInteractorProtocol?
    var router: NomeDoModuloPresenterToRouterProtocol?
    
    // MARK: - View to Presenter
    
    func viewDidLoad() {
        // Implementar lógica inicial
    }
}

// MARK: - Interactor to Presenter

extension NomeDoModuloPresenter: NomeDoModuloInteractorToPresenterProtocol {
    // Implementar callbacks do Interactor
}
```

### 4️⃣ Criar Interactor

```swift
import Foundation

class NomeDoModuloInteractor: NomeDoModuloPresenterToInteractorProtocol {
    
    // MARK: - Properties
    weak var presenter: NomeDoModuloInteractorToPresenterProtocol?
    
    // MARK: - Presenter to Interactor
    
    // Implementar lógica de negócio
    // Chamadas de rede
    // Acesso a dados locais
}
```

### 5️⃣ Criar Router

```swift
import UIKit

class NomeDoModuloRouter: NomeDoModuloPresenterToRouterProtocol {
    
    // MARK: - Static Module Creator
    
    static func createModule() -> UIViewController {
        let view = NomeDoModuloViewController()
        let presenter = NomeDoModuloPresenter()
        let interactor = NomeDoModuloInteractor()
        let router = NomeDoModuloRouter()
        
        // Connecting VIPER components
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    // MARK: - Presenter to Router
    
    // Implementar navegação
}
```

## 🎯 Exemplo Prático: Módulo de Perfil

Vamos criar um módulo de perfil do usuário:

### ProfileProtocols.swift

```swift
import UIKit

protocol ProfileViewToPresenterProtocol: BaseViewToPresenterProtocol {
    var interactor: ProfilePresenterToInteractorProtocol? { get set }
    var router: ProfilePresenterToRouterProtocol? { get set }
    
    func viewDidLoad()
    func didTapEditProfile()
    func didTapLogout()
}

protocol ProfilePresenterToViewProtocol: BasePresenterToViewProtocol {
    func showProfile(name: String, email: String, avatar: URL?)
}

protocol ProfilePresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    var presenter: ProfileInteractorToPresenterProtocol? { get set }
    
    func fetchUserProfile()
    func logout()
}

protocol ProfileInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func didFetchProfile(name: String, email: String, avatar: URL?)
    func didLogout()
}

protocol ProfilePresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func navigateToEditProfile(from view: UIViewController)
    func navigateToLogin(from view: UIViewController)
}
```

## ✅ Checklist para Novo Módulo

- [ ] Criar estrutura de pastas
- [ ] Definir todos os protocols
- [ ] Implementar ViewController
- [ ] Implementar Presenter
- [ ] Implementar Interactor
- [ ] Implementar Router
- [ ] Conectar todas as camadas no Router.createModule()
- [ ] Adicionar navegação de outros módulos (se necessário)
- [ ] Criar testes unitários
- [ ] Documentar funcionalidades

## 🧪 Template de Teste

```swift
import XCTest
@testable import ios_viper_example

class NomeDoModuloPresenterTests: XCTestCase {
    
    var presenter: NomeDoModuloPresenter!
    var mockView: MockNomeDoModuloView!
    var mockInteractor: MockNomeDoModuloInteractor!
    var mockRouter: MockNomeDoModuloRouter!
    
    override func setUp() {
        super.setUp()
        
        presenter = NomeDoModuloPresenter()
        mockView = MockNomeDoModuloView()
        mockInteractor = MockNomeDoModuloInteractor()
        mockRouter = MockNomeDoModuloRouter()
        
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }
    
    func testViewDidLoad() {
        // Given
        
        // When
        presenter.viewDidLoad()
        
        // Then
        // Adicione asserções
    }
}
```

## 💡 Boas Práticas

### ✅ DO (Faça)

1. **Mantenha a View burra** - Apenas exibe dados, não processa
2. **Presenter como coordenador** - Orquestra View e Interactor
3. **Interactor testável** - Toda lógica de negócio aqui
4. **Router para navegação** - Centralize toda navegação
5. **Use protocols** - Facilita testes e desacoplamento
6. **Injeção de dependências** - Via Router.createModule()

### ❌ DON'T (Não Faça)

1. **Lógica de negócio na View** - Nunca!
2. **View acessando Interactor diretamente** - Sempre via Presenter
3. **Presenter fazendo chamadas de rede** - Responsabilidade do Interactor
4. **Navegação na View** - Sempre via Router
5. **Acoplamento forte** - Use protocols
6. **Presenter com referência forte à View** - Sempre weak

## 🔄 Fluxo de Comunicação

```
User Action
    ↓
VIEW (didTapButton)
    ↓
PRESENTER (handleButtonTap)
    ↓
INTERACTOR (performAction)
    ↓
Network/Database
    ↓
INTERACTOR (callback)
    ↓
PRESENTER (didReceiveData)
    ↓
VIEW (updateUI)
```

## 📚 Recursos Adicionais

- Veja os módulos existentes como referência
- MovieList: Exemplo completo com paginação
- Search: Exemplo com debounce
- Favorites: Exemplo com persistência local
- MovieDetails: Exemplo com navegação complexa

---

**Dica**: Copie um módulo existente e adapte para acelerar o desenvolvimento!
