# ✨ Pokemon List App

## Description
This is an iOS application developed in **Swift** using **SwiftUI** and **Concurrency (async/await)**. The app displays a list of Pokémon fetched from the Pokémon API, allowing users to navigate to their details and mark favorites.

Since no specific design was requested, the UI is functional but does not focus on advanced aesthetics.

## ⚡ Architecture
The app follows the **MVVM (Model-View-ViewModel)** pattern to separate responsibilities:

- **Model**: Contains structures representing Pokémon data.
- **ViewModel**: Manages business logic and network communication.
- **View**: Handles the UI and connects to the ViewModel using `@StateObject` or `@ObservedObject`.

### Main Components:
1. **Network**: Handles HTTP requests with `URLSession` and `async/await`.
2. **DataInteractor**: Protocol defining network operations.
3. **PokemonListViewModel**: Manages the Pokémon list and pagination.
4. **PokemonListView**: Displays the list of Pokémon and allows navigation.
5. **PokemonDetailViewModel**: Manages the details of each Pokémon.
6. **PokemonDetailView**: Presents detailed information about a selected Pokémon.

## 🔍 Pokémon Search
Due to limitations in the Pokémon API, **searching does not query the API**, but instead filters the data already loaded on the screen. This means users can only search among the Pokémon already retrieved from the API.

## 🌐 Dependencies
- **SwiftUI** for the UI
- **URLSession** for network calls

## 🛠 Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/pokemon-list-app.git
   ```
2. Open the project in Xcode 16 or later.
3. Run the app on a simulator or device.

## 🧪 Tests
The application includes **unit tests** using `XCTest`, with tests for:
- API calls using `MockURLProtocol`.
- `PokemonListViewModel` functionality.
- Network error handling.

To run the tests:
```sh
Cmd + U  # Run tests in Xcode
```

## ⚙ Future Improvements
- Implement custom UI designs as per requirements.
- Enhance offline data persistence.
- Integrate API-based search if supported.

