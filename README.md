# Pay Dart

A mobile application built with Flutter for managing and paying fees. It provides a seamless experience for students/users to track their fee details, view payment history, and generate receipts.

## Features

*   User Authentication (Login, Forgot Password, OTP Verification)
*   Detailed Fee Display (current fees, additional charges)
*   Student Data Management
*   Payment History Tracking
*   Receipt Generation (likely in PDF format)
*   Secure Local Data Storage (using `shared_preferences`)
*   Cross-Platform Compatibility (iOS, Android, potentially others)

## Technology Stack

*   **Framework:** Flutter
*   **Language:** Dart
*   **Key Packages/Libraries:**
    *   `http`: For making API calls to backend services.
    *   `provider`: For state management.
    *   `shared_preferences`: For local data storage (e.g., authentication tokens).
    *   `pdf`: For generating PDF receipts.
    *   `permission_handler`: For managing device permissions (e.g., storage access for receipts).
    *   `google_fonts`: For custom fonts.
    *   `flutter_svg_provider`/`flutter_svg`: For using SVG assets.
    *   `open_filex`: For opening generated files (e.g., PDFs).

## Project Structure

*   `lib/`: Contains all the Dart code for the application.
    *   `main.dart`: Entry point of the application.
    *   `UI_Screens/`: Contains all the user interface screens.
    *   `services/`: Contains services for data fetching, API communication, etc.
    *   `models/`: Contains data model classes.
    *   `Templete/`: Contains templates (e.g., for PDF generation).
*   `assets/`: Contains static assets like images and logos.
*   `android/`, `ios/`, `web/`, etc.: Platform-specific code and configurations.
*   `pubspec.yaml`: Project manifest file, including dependencies and metadata.

## Getting Started / How to Run

*   Clone the repository: `git clone <repository-url>`
*   Navigate to the project directory: `cd pay_dart`
*   Install dependencies: `flutter pub get`
*   Run the application: `flutter run`
