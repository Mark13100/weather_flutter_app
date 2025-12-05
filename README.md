# Weather Flutter App

## How to run
1. Clone the repository:
   git clone https://github.com/Mark13100/weather_flutter_app.git
2. Enter the project folder:
   cd weather_flutter_app
3. Get dependencies:
   flutter pub get
4. Run the app:
   flutter run -d chrome   # For web
   flutter run -d android  # For Android

## API Key
- Put your API key in `lib/services/api_service.dart` at the line:
  const String apiKey = 'YOUR_API_KEY';

## APK
- Android APK can be found at:
  build/app/outputs/flutter-apk/app-release.apk

## Features
- Search weather by city
- View weather details
- Save favorite cities
- Settings page
