# Popular Movies

O Popular Movies é um aplicativo iOS desenvolvido em SwiftUI, que consome a API pública do The Movie Database (TMDB) para exibir filmes populares, realizar buscas e gerenciar uma lista de favoritos offline.

O projeto foi criado como parte de um desafio técnico, com foco em arquitetura escalável, boas práticas de Swift Concurrency e persistência local usando Core Data.

## 🚀 Setup do Projeto

### 🔑 Configuração da API Key
1. Crie um arquivo `Secrets.xcconfig` na raiz do projeto (mesmo nível do `.xcodeproj`).
2. Adicione sua chave da API TMDB:
    API_KEY = sua_chave_aqui
3. No Xcode, vá em:
- Target ▸ Build Settings ▸ User-Defined ▸ API_KEY = $(API_KEY)
4. Verifique se a API_KEY está na aba Info do Target.

## 📦 Dependências

O projeto utiliza as seguintes bibliotecas via **Swift Package Manager (SPM)**:

- **[YouTubePlayerKit](https://github.com/SvenTiigi/YouTubePlayerKit)**  
  Usada para exibir trailers diretamente dentro do app via player nativo do YouTube.

Para instalar as dependências:
1. Abra o projeto no Xcode.
2. Vá em **File ▸ Add Packages...**
3. Adicione o repositório:
    https://github.com/SvenTiigi/YouTubePlayerKit
4. Certifique-se de que o pacote está atribuído ao target **PopularMovies**.

### ▶️ Executando o App
Abra o projeto em Xcode 15+ e selecione **Run (⌘ + R)** no esquema *PopularMoviesApp*.

O app:

- Exibe filmes populares da TMDB
- Permite buscar filmes pelo nome
- Exibe detalhes com sinopse, nota e trailer
- Permite favoritar filmes (armazenamento offline via Core Data)

### 🧪 Executando os Testes
No menu do Xcode:
> Product ▸ Test (⌘ + U)

Os testes de unidade usam XCTest e cobrem:

- Inserção e remoção de filmes favoritos (Core Data)
- Persistência offline
- Carregamento inicial e paginação

### Decisões Arquiteturais

O projeto segue uma arquitetura inspirada no artigo 
["Building Large-Scale Apps with SwiftUI" (Azam Sharp)](https://azamsharp.medium.com/building-large-scale-apps-with-swiftui-a-guide-to-modular-architecture-9c967be13001).

#### Camadas principais:
- **Networking:** APIClient, MovieService
- **Domain:** Modelos (`Movie`, `MovieResponse`)
- **Presentation:** ViewModels + Views (SwiftUI)
- **Persistence:** CoreData (Favorites)

### 🧠 Decisões tomadas

✅ Uso de MVVM com Swift Concurrency (async/await) para clareza e testabilidade
✅ Core Data escolhido para persistência local robusta
✅ AsyncImage com fallback placeholder para carregamento leve de imagens
✅ Search com debounce (Combine) para otimizar requisições
❌ UserDefaults rejeitado (limite de dados e sem suporte binário)
❌ Realm e SwiftData descartados (dependência externa / versão instável)

### Mapa de Camadas e Responsabilidades

```text
PopularMoviesApp
├── Core/
│   ├── APIClient.swift             → Cliente genérico da API TMDB
│   ├── MovieService.swift          → Camada de serviços da API
│   ├── Models/                     
│   │   ├── Movie.swift             → Estruturas Movie, MovieResponse
│   │   └── Video.swift             → Estruturas Video, VideoResponse
│   └── Network/
│       ├── APIClient.swift         → Cliente genérico da API TMDB
│       └── MovieService.swift      → Camada de serviços da API
├── Features/
│   ├── Popular/                    → PopularView + ViewModel
│   ├── Favorites/                  → FavoritesView + ViewModel
│   └── Details/                    → MovieDetailView
├── Data/
│   ├── CoreDataManager.swift.      → Inicializar e gerenciar o NSPersistentContainer do app
│   ├── Favorite.swift.             → Modelo Swift que representa a Entity “Favorite”
│   ├── Favorites.xcdatamodeld      → Modelo de dados do Core Data
│   └── FavoritesManager.swift      → Gerencia favoritos no Core Data.
├── Extension
│   └── MovieExtension.swift        → Facilita a exibição do overview do filme, caso não tenha nenhum texto.
├── Helpers
│   ├── ImageURLBuilder.swift       → Facilita a busca da URL para a image de um filme.
│   └── NetworkMonitor.swift        → Verifica se existe internet
├── Views
│   ├── MovieCardView.swift         → Visual dos dos filmes na tela de Popular e Favoritos
│   ├── PosterView.swift            → Mostra a imagem do Filme
│   └── TrailerPlayerSheet.swift    → Abre o player do Youtube
├── Launch Screen.storyboard
├── pt-BR.lproj/Localizable.strings
└── Assets.xcassets
```


### Limitações
- Falta de cache de imagens (atualmente depende de AsyncImage)
- Core Data sem migração de schema (somente 1 versão)
- Falta de testes de UI (apenas unit tests)

### Melhorias Futuras
- Implementar SwiftData no lugar de Core Data
- Adicionar suporte a temas claros/escuros personalizados
- Adicionar modo offline com cache completo de filmes populares
- Implementar testes de integração com MockNetwork

### Conclusão
O projeto foi desenvolvido com foco em clareza, boas práticas de arquitetura SwiftUI e persistência local robusta.

O código foi estruturado para facilitar manutenção, testes e futura modularização em múltiplos targets.