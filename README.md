# News Reader App

A modern, feature-rich news reader application built with Flutter. Stay updated with the latest news from around the world with a clean, intuitive interface.

## Features

### 📱 Core Functionality
- **Browse Top Headlines**: Get the latest breaking news and top stories
- **Category-based News**: Filter news by categories (General, Business, Entertainment, Health, Science, Sports, Technology)
- **Search News**: Search for specific topics, keywords, or stories
- **Read Full Articles**: View detailed article content with rich formatting
- **Share Articles**: Share interesting articles with friends and social media

### 🎨 User Experience
- **Clean, Modern UI**: Beautiful Material Design 3 interface
- **Dark/Light Theme**: Adaptive theming (can be extended)
- **Responsive Design**: Optimized for different screen sizes
- **Pull-to-Refresh**: Easy content refreshing
- **Infinite Scrolling**: Load more articles seamlessly
- **Image Loading**: Optimized image loading with placeholders

### ⚡ Performance
- **Caching**: Smart caching system for offline reading
- **Error Handling**: Comprehensive error handling with retry options
- **Loading States**: Beautiful loading indicators and states
- **API Management**: Efficient API calls with proper timeout handling

## Screenshots

*Screenshots will be added here once the app is running*

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.8.1 or higher)
- Android Studio / VS Code with Flutter extensions
- NewsAPI.org API key (free registration required)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/news_reader_app.git
   cd news_reader_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Get your NewsAPI key**
   - Go to [NewsAPI.org](https://newsapi.org/)
   - Register for a free account
   - Get your API key from the dashboard

4. **Configure API key**
   - Open `lib/core/constants.dart`
   - Replace `YOUR_NEWS_API_KEY_HERE` with your actual API key:
   ```dart
   static const String apiKey = 'your_actual_api_key_here';
   ```

5. **Generate code (for JSON serialization and Retrofit)**
   ```bash
   flutter packages pub run build_runner build
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
news_reader_app/
│
├── android/                 # Android-specific files
├── ios/                     # iOS-specific files
├── lib/
│   ├── main.dart           # App entry point
│   ├── app.dart            # App configuration and theming
│   ├── core/               # Core utilities and constants
│   │   ├── constants.dart  # App constants and configuration
│   │   └── error_handling.dart  # Error handling utilities
│   ├── models/             # Data models
│   │   ├── news_article.dart    # Article model with JSON serialization
│   │   └── news_response.dart   # API response model
│   ├── data/               # Data layer (Repository pattern)
│   │   ├── api_client.dart      # HTTP client configuration
│   │   ├── news_api_service.dart # Retrofit API service
│   │   └── news_repository.dart  # Data repository
│   ├── viewmodels/         # State management (MVVM pattern)
│   │   └── news_viewmodel.dart   # News state management
│   ├── views/              # UI screens
│   │   ├── home_screen.dart      # Main home screen
│   │   ├── news_list.dart        # News list components
│   │   └── news_detail_screen.dart # Article detail view
│   ├── widgets/            # Reusable UI components
│   │   ├── news_card.dart        # Article card widgets
│   │   └── loading_indicator.dart # Loading state widgets
│   └── utils/              # Utility functions
│       ├── date_formatter.dart   # Date formatting utilities
│       └── url_launcher_helper.dart # URL handling utilities
│
├── pubspec.yaml            # Dependencies and project configuration
└── README.md              # This file
```

## Architecture

This app follows the **MVVM (Model-View-ViewModel)** pattern with **Repository pattern** for clean architecture:

### 📦 Models
- **NewsArticle**: Represents a single news article with JSON serialization
- **NewsResponse**: Represents API response containing multiple articles

### 🏛️ Data Layer
- **ApiClient**: Configured Dio HTTP client with interceptors
- **NewsApiService**: Retrofit service for type-safe API calls
- **NewsRepository**: Manages data sources and caching logic

### 🎯 ViewModels
- **NewsViewModel**: Handles business logic and state management using Provider

### 🎨 Views
- **HomeScreen**: Main screen with category tabs and search
- **NewsList**: Reusable news list components
- **NewsDetailScreen**: Detailed article view

### 🧰 Core Utilities
- **Constants**: App-wide configuration and settings
- **ErrorHandling**: Centralized error management
- **DateFormatter**: Date/time formatting utilities
- **UrlLauncherHelper**: URL handling and sharing utilities

## API Integration

This app uses the [NewsAPI.org](https://newsapi.org/) service which provides:

- **Top Headlines**: Breaking news and top stories
- **Everything**: Search through millions of articles
- **Sources**: News sources and blogs
- **Categories**: Business, Entertainment, General, Health, Science, Sports, Technology

### API Endpoints Used

1. **Top Headlines** - `/top-headlines`
   - Get breaking news and top stories
   - Filter by country, category, or sources

2. **Everything** - `/everything`
   - Search through millions of articles
   - Filter by keywords, dates, sources, domains

## Dependencies

### Main Dependencies
- **flutter**: Flutter SDK
- **provider**: State management
- **dio**: HTTP client for API requests
- **retrofit**: Type-safe HTTP client
- **json_annotation**: JSON serialization annotations
- **url_launcher**: Launch URLs and share content
- **intl**: Date formatting and internationalization
- **flutter_spinkit**: Loading animations

### Dev Dependencies
- **json_serializable**: Generate JSON serialization code
- **build_runner**: Code generation
- **retrofit_generator**: Generate Retrofit code
- **flutter_lints**: Linting rules

## Configuration

### API Configuration
Edit `lib/core/constants.dart` to customize:
- API key
- Base URL
- Default country/category
- Request timeouts
- Error messages

### Theme Configuration
Edit `lib/app.dart` to customize:
- App colors and branding
- Typography
- Component themes
- Dark/light mode settings

## Building for Production

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Testing

Run tests with:
```bash
flutter test
```

*Note: Test files will be added in the `test/` directory*

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Troubleshooting

### Common Issues

1. **API Key Error**
   - Make sure you've set your NewsAPI key in `constants.dart`
   - Verify your API key is valid at NewsAPI.org

2. **Build Runner Issues**
   - Run `flutter packages pub run build_runner clean`
   - Then `flutter packages pub run build_runner build --delete-conflicting-outputs`

3. **Dependency Conflicts**
   - Run `flutter clean`
   - Run `flutter pub get`

4. **Network Issues**
   - Check internet connection
   - Verify API endpoints are accessible
   - Check firewall/proxy settings

## Future Enhancements

- [ ] Offline reading mode
- [ ] Bookmark/favorite articles
- [ ] Push notifications for breaking news
- [ ] Multiple language support
- [ ] Dark mode toggle
- [ ] Custom news sources
- [ ] Social media integration
- [ ] Reading progress tracking

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [NewsAPI.org](https://newsapi.org/) for providing the news data
- Flutter team for the amazing framework
- All open source contributors whose packages made this project possible

## Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/news_reader_app/issues) section
2. Create a new issue with detailed description
3. Include device information and error logs

---

**Made with ❤️ using Flutter**
