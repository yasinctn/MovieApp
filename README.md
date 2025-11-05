# 🎬 MovieApp

A modern iOS movie discovery application built with UIKit, featuring real-time data from The Movie Database (TMDB) API. Browse trending movies, explore detailed information, manage your favorites, and discover new films with an elegant user interface.

## ✨ Features

### 🏠 Home Screen
- **Multiple Movie Categories**: Browse Now Playing, Popular, Top Rated, and Upcoming movies
- **Dynamic Layouts**: Featured carousel for popular movies with larger cards
- **Horizontal Scrolling Sections**: Smooth navigation through different movie categories
- **Show All**: Expand any section to view complete movie lists

### 🎭 Movie Details
- **Comprehensive Information**: Title, tagline, overview, genres, runtime, and release date
- **Cast & Crew**: Horizontal scrolling cast list with profile photos and character names
- **High-Quality Images**: Backdrop and poster images with smooth loading
- **Rating Badge**: Visual vote average display
- **Favorite Toggle**: Add or remove movies from favorites instantly

### ❤️ Favorites
- **Local Persistence**: Save your favorite movies using UserDefaults
- **Offline Access**: View favorite movie information without internet
- **Real-time Updates**: Favorites sync across all screens automatically
- **Empty State**: Friendly UI when no favorites are added

### 🎨 User Interface
- **Programmatic UI**: 100% code-based interface with SnapKit constraints
- **Dark Mode Support**: Seamless adaptation to system appearance
- **Modern Design**: Card-based layouts with shadows and rounded corners
- **Smooth Animations**: Elegant transitions and loading states
- **Tab Bar Navigation**: Easy switching between Home, Favorites, and Profile

## 🛠 Tech Stack

### Language & Framework
- **Swift 5.9+**
- **UIKit** - Programmatic UI (no Storyboards)
- **iOS 16.4+** deployment target

### Architecture
- **MVVM (Model-View-ViewModel)** pattern
- **Protocol-oriented programming**
- **Dependency Injection** with custom DIContainer

### Third-Party Libraries
- **[SnapKit](https://github.com/SnapKit/SnapKit)** - Auto Layout DSL
- **[Alamofire](https://github.com/Alamofire/Alamofire)** - HTTP networking
- **[PromiseKit](https://github.com/mxcl/PromiseKit)** - Promise-based async operations
- **[SDWebImage](https://github.com/SDWebImage/SDWebImage)** - Image loading and caching

### Data Source
- **[TMDB API](https://www.themoviedb.org/documentation/api)** - Movie data and images

## 📋 Requirements

- Xcode 15.0+
- iOS 16.4+
- Swift 5.9+
- CocoaPods or Swift Package Manager
- TMDB API Key (free registration)

## 🚀 Installation

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/MovieApp.git
cd MovieApp
```

### 2. Install Dependencies

#### Using Swift Package Manager (Recommended)
Dependencies are already configured in the project. Simply open the project in Xcode and dependencies will be resolved automatically.

#### Using CocoaPods
```bash
pod install
open MovieApp.xcworkspace
```

### 3. Configure TMDB API

1. Register for a free account at [TMDB](https://www.themoviedb.org/signup)
2. Navigate to [API Settings](https://www.themoviedb.org/settings/api) and copy your API Read Access Token (Bearer Token)
3. Create `Config.xcconfig` file in the project root:

```bash
# Config.xcconfig
TMDB_BASE_URL = https:/$()/api.themoviedb.org/3
TMDB_BEARER_TOKEN = YOUR_BEARER_TOKEN_HERE
```

4. Add the config file to your Xcode project
5. Ensure `ConfigManager.swift` reads from the config file

### 4. Build and Run
```bash
# Select your target device/simulator in Xcode
# Press Cmd + R to build and run
```

## 🏗 Project Structure

```
MovieApp/
├── Assets.xcassets/                 # App icons and color sets
├── Common/
│   ├── Core/
│   │   ├── AppDelegate.swift
│   │   ├── SceneDelegate.swift
│   │   └── AppRouter.swift          # Navigation coordinator
│   └── Utils/
│       ├── ConfigManager.swift      # Configuration management
│       ├── DIContainer.swift        # Dependency injection
│       └── Extensions/              # Swift extensions
├── Data/
│   ├── Domain/                      # Business logic models
│   │   ├── Movie.swift
│   │   ├── MovieDetail.swift
│   │   └── Cast.swift
│   └── DTO/                         # API response models
│       ├── MovieResponseDTO.swift
│       └── MovieDetailResponseDTO.swift
├── Services/
│   ├── NetworkClient.swift          # HTTP request handler
│   ├── TMDBApiService.swift         # TMDB API business logic
│   ├── FavoritesService.swift       # Local favorites management
│   └── Enums/
│       ├── APIEndpoint.swift
│       ├── MovieSection.swift
│       └── NetworkError.swift
└── Screens/
    ├── HomeScreen/                  # Main movie feed
    │   ├── HomeViewController.swift
    │   ├── HomeViewModel.swift
    │   └── UIComponents/
    │       └── MovieCell/
    ├── DetailScreen/                # Movie details
    │   ├── DetailViewController.swift
    │   ├── DetailViewModel.swift
    │   └── CastCollectionViewCell.swift
    ├── FavoritesScreen/             # Favorites list
    │   ├── FavoritesViewController.swift
    │   └── FavoritesViewModel.swift
    ├── MoreMovieViewController.swift # Show all movies
    └── MainTabBarController.swift   # Tab bar navigation
```

## 🎯 Architecture Overview

### MVVM Pattern
```
┌─────────────┐         ┌──────────────┐         ┌─────────┐
│    View     │────────▶│  ViewModel   │────────▶│  Model  │
│ (UIKit)     │◀────────│  (Logic)     │◀────────│ (Data)  │
└─────────────┘         └──────────────┘         └─────────┘
                              │
                              │
                        ┌─────▼──────┐
                        │  Services  │
                        │ (API/Local)│
                        └────────────┘
```

### Data Flow
```
API (TMDB) → NetworkClient → DTO → Domain Model → ViewModel → View
```

### Key Components

- **AppRouter**: Centralized navigation management
- **DIContainer**: Dependency injection for ViewControllers and Services
- **NetworkClient**: Generic HTTP request handler with PromiseKit
- **TMDBApiService**: TMDB-specific API implementations
- **FavoritesService**: Local storage with UserDefaults and NotificationCenter

## 🔑 Key Features Implementation

### Favorites System
- **Storage**: JSON-encoded `Movie` objects in UserDefaults
- **Real-time Updates**: NotificationCenter broadcasts changes
- **Automatic Sync**: All screens observe favorite state changes
- **Toggle UI**: Heart button with filled/unfilled states

### Image Caching
- **SDWebImage**: Automatic disk and memory caching
- **Placeholders**: SF Symbols for loading states
- **Optimized URLs**: TMDB image CDN with appropriate sizes

### Error Handling
- **Network Errors**: Retry buttons with user-friendly messages
- **Loading States**: Activity indicators during API calls
- **Empty States**: Informative messages when no content available

## 📚 API Endpoints Used

| Endpoint | Description |
|----------|-------------|
| `GET /movie/now_playing` | Movies currently in theaters |
| `GET /movie/popular` | Popular movies |
| `GET /movie/top_rated` | Highest rated movies |
| `GET /movie/upcoming` | Movies coming soon |
| `GET /movie/{id}?append_to_response=credits` | Detailed movie info with cast |

## 🎨 Design Patterns

- **Protocol-Oriented Programming**: All services use protocol abstraction
- **Dependency Injection**: DIContainer manages object creation
- **Delegation**: ViewModel-to-View communication via closures
- **Observer Pattern**: NotificationCenter for favorites updates
- **Factory Pattern**: ViewController creation through DIContainer

## 🔮 Future Improvements

- [ ] Search functionality with debouncing
- [ ] Movie filtering and sorting options
- [ ] User reviews and ratings
- [ ] Trailer playback integration
- [ ] Core Data migration for advanced persistence
- [ ] Similar movies recommendations
- [ ] Share movie feature
- [ ] Watchlist separate from favorites
- [ ] iPad support with adaptive layouts
- [ ] Localization for multiple languages
- [ ] Unit and UI tests


## 👏 Acknowledgments

- [The Movie Database (TMDB)](https://www.themoviedb.org/) for providing the movie data API
- [SnapKit](https://github.com/SnapKit/SnapKit) for elegant Auto Layout
- [Alamofire](https://github.com/Alamofire/Alamofire) for networking
- [PromiseKit](https://github.com/mxcl/PromiseKit) for async handling
- [SDWebImage](https://github.com/SDWebImage/SDWebImage) for image management
