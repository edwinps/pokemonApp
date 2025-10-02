# ✨ Pokemon List App


## 📌 Description
This is an iOS application developed in **Swift** using **SwiftUI**, **Concurrency (async/await)**, and **SwiftData**. The app displays a list of Pokémon fetched from the **Pokémon API**, allowing users to navigate to their details and mark them as favorites.

Since no specific design was requested, the UI is functional but does not focus on advanced aesthetics.

---

## ⚡ Architecture
The app follows the **MVVM (Model-View-ViewModel)** pattern to ensure a clear separation of concerns:

- **Model**: Contains structures representing Pokémon data.
- **ViewModel**: Manages business logic, including network communication and data persistence.
- **View**: Handles the UI and binds to the ViewModel using `@StateObject` or `@ObservedObject`.

### **Main Components**
1. **Network**: Handles HTTP requests using `URLSession` with `async/await`.
2. **DataInteractor**: Protocol defining network operations.
3. **PokemonListViewModel**: Manages the Pokémon list, pagination, and favorite functionality.
4. **PokemonListView**: Displays the list of Pokémon and allows navigation.
5. **PokemonDetailViewModel**: Fetches and manages detailed information about a selected Pokémon.
6. **PokemonDetailView**: Presents Pokémon details, including type, stats, and evolution chain.
7. **DataStorageInteractor**: Uses **SwiftData** to persist favorites locally.

---

## ⭐ Favorites Management with SwiftData
This app **uses SwiftData to store favorite Pokémon locally**, allowing users to:
- **Mark Pokémon as favorites** in the list view.
- **Persist favorite selections** even after closing the app.
- **Compare and sort Pokémon by favorites**.

### **How it Works**
1. When a Pokémon is marked as favorite, it is **saved in SwiftData**.
2. If the Pokémon is already a favorite, **tapping the favorite button removes it**.
3. The **favorite Pokémon IDs are compared with the loaded Pokémon list**, so the app can:
   - Display a **filled star icon** for favorites.
   - Sort favorites first if the user selects the **Favorites** sorting option.

### **SwiftData Integration**
- The app uses `@Model` and `ModelContainer` to manage **local storage of favorite Pokémon**.
- **`SwiftDataService`** (`DataStorage`) provides methods for:
  - Fetching saved favorites (`loadFavorites()`).
  - Adding a Pokémon to favorites (`addFavorite(id:name:)`).
  - Removing a Pokémon from favorites (`removeFavorite(id:)`).
- `PokemonListViewModel` **syncs the favorite Pokémon with SwiftData** when the app starts.

---

## 🔍 Pokémon Search
Due to limitations in the Pokémon API, **searching does not query the API**, but instead **filters the Pokémon already loaded in the list**.  
Users can only search among the Pokémon already retrieved from the API.

---

## 🌐 Dependencies
- **SwiftUI** for UI components.
- **URLSession** for network requests.
- **SwiftData** for local favorite persistence.

---

## 🛠 Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/pokemon-list-app.git
   ```
2. Open the project in **Xcode 16 or later**.
3. Run the app on a simulator or device.

---

## 🧪 Unit Tests
The app includes **unit tests** using `XCTest`, covering:
- **API calls** using `MockURLProtocol`.
- **ViewModel logic**, including pagination and error handling.
- **SwiftData integration**, ensuring favorites are stored and retrieved correctly.

To run the tests:
```sh
Cmd + U  # Run tests in Xcode
```

---