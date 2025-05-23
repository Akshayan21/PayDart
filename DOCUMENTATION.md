# Pay Dart Project Documentation

## 1. Introduction

The Pay Dart application is a Flutter-based mobile app designed to streamline fee management and payment for users. It allows users to access their fee statements, track payment history, and generate receipts efficiently.

## 2. User Flow Diagram (Flowchart)

### Flow 1: Initial App Launch & Login

*   App Start
    *   Check `shared_preferences` for `auth_token`.
    *   IF `auth_token` exists:
        *   Navigate to `DetailsDisplayingScreen`.
    *   ELSE (`auth_token` does not exist):
        *   Navigate to `LoginScreen`.
*   `LoginScreen`:
    *   User enters credentials.
    *   (App communicates with backend API via `http` service).
    *   IF login successful (and OTP is required by flow):
        *   Navigate to `OtpVerificationScreen`.
        *   `OtpVerificationScreen`: User enters OTP.
            *   IF OTP valid: Navigate to `DetailsDisplayingScreen`.
            *   ELSE: Show error.
    *   IF login successful (and OTP is NOT required):
        *   Navigate to `DetailsDisplayingScreen`.
    *   ELSE (login failed):
        *   Show error on `LoginScreen`.

### Flow 2: Forgot Password

*   From `LoginScreen`: User taps "Forgot Password".
*   Navigate to `ForgetPasswordScreen`.
    *   User enters identifying information (e.g., email/student ID).
    *   (App communicates with backend API).
    *   IF successful: Navigate to `OtpVerificationScreen`.
*   `OtpVerificationScreen`: User enters OTP.
    *   IF OTP valid: Navigate to `NewPasswordScreen`.
    *   ELSE: Show error.
*   `NewPasswordScreen`: User sets a new password.
    *   (App communicates with backend API to update password).
    *   IF successful: Navigate to `LoginScreen`.
    *   ELSE: Show error.

### Flow 3: Main Application Usage (from `DetailsDisplayingScreen`)

*   `DetailsDisplayingScreen`:
    *   **View Student Data:** Information fetched via `students_data_fetching.dart`.
    *   **View Fee Details:** Information fetched via `fees_details_fetching.dart` and `additional_fees_details.dart`.
    *   **View Payment History:** Information fetched via `payment_history_service.dart` / `payment_history_details.dart`.
    *   **(Assumed) Initiate Payment:** User taps 'Pay Now' button, potentially leading to a payment gateway or API call.
    *   **Generate/Download Receipt:**
        *   User action triggers receipt generation.
        *   `recipte_service.dart` is used (likely with the `pdf` package).
        *   `permission_handler` checks/requests storage permission.
        *   Receipt is saved to device storage (using `path_provider`).
        *   `open_filex` might be used to open the generated receipt.
        *   `flutter_media_downloader` could be an alternative for managing downloads.

## 3. Detailed Explanation of Components

### `lib/main.dart`

*   **Purpose:** The main entry point of the Flutter application.
*   **Functionality:**
    *   Initializes Flutter bindings (`WidgetsFlutterBinding.ensureInitialized()`).
    *   Checks for an existing `auth_token` in `shared_preferences` to determine the initial screen (`LoginScreen` or `DetailsDisplayingScreen`).
    *   Includes `requestStoragePermission()` to handle Android storage permissions, crucial for saving files like PDF receipts.
    *   Defines the root `MyApp` widget, which sets up `MaterialApp`, theme, and initial route.

### UI Screens (`lib/UI_Screens/`)

*   `details_displaying_screen.dart`: The main screen after successful login. Displays student information, fee details, payment history, and provides access to other features like receipt generation.
*   `forget_password.dart`: Allows users to initiate the password recovery process, typically by entering their registered email or username.
*   `login_screen.dart`: The initial screen for user authentication. Collects user credentials (e.g., username/ID and password).
*   `new_password_screen.dart`: Allows users to set a new password after successfully verifying their identity through the OTP screen during password recovery.
*   `otp_verification_screen.dart`: Used for verifying a One-Time Password (OTP) sent to the user, typically as part of login or password recovery flows.

### Services (`lib/services/`)

*   `additional_fees_details.dart`: Responsible for fetching details about any additional or miscellaneous fees applicable to the user.
*   `fees_details_fetching.dart`: Handles the primary logic for fetching the main fee structure and details for the logged-in user.
*   `payment_history_details.dart` & `payment_history_service.dart`: These services work together to fetch and manage the user's payment history records from the backend.
*   `recipte_service.dart`: Manages the generation of payment receipts. This likely involves using the `pdf` package to create PDF documents and `path_provider` to find suitable storage locations.
*   `students_data_fetching.dart`: Fetches general student-specific data or profile information required by the application.

### Models (`lib/models/`)

*   `data_modals.dart`: Defines Dart classes that structure the data fetched from various API endpoints (e.g., student details, fee components). This helps in type-safe data handling.
*   `payment_history.dart`: Defines the Dart class structure for individual payment history records, ensuring consistent data representation.

### Templates (`lib/Templete/`)

*   `pdf_templete.dart`: Contains the layout and styling logic for generating PDF receipts or other documents. It works in conjunction with the `pdf` package and `recipte_service.dart`.

## 4. Data Flow

*   **Fetching Data:** Primarily through services in `lib/services/`. These services use the `http` package to make API calls to a backend server to retrieve student information, fee details, payment history, etc.
*   **Local Storage:** `shared_preferences` is used for storing simple key-value pairs persistently, most notably the `auth_token` after successful login, to keep the user session active.
*   **State Management:** The `provider` package is likely used for managing application state, allowing different widgets to access and react to changes in data (e.g., user authentication status, fetched fee details).
*   **File System Interaction:** For receipt generation and downloads, the app uses:
    *   `permission_handler` to request storage permissions.
    *   `path_provider` to get appropriate directory paths for saving files.
    *   `pdf` package to generate PDF files in memory.
    *   The generated PDF is then written to the file system.
    *   `open_filex` or `flutter_media_downloader` might be used to open or manage these downloaded files.

## 5. Key Dependencies (Role in Project)

*   `http`: Core package for all network communications (fetching data from and sending data to backend APIs).
*   `provider`: Facilitates state management, making it easier to share and update data across different parts of the widget tree.
*   `shared_preferences`: Used for storing the authentication token and potentially other simple user preferences locally on the device.
*   `pdf`: Enables the creation and customization of PDF documents, primarily used for generating payment receipts.
*   `permission_handler`: Manages runtime permission requests (e.g., asking for storage access before saving a receipt).
*   `open_filex`: Allows the application to trigger the opening of files (like a generated PDF receipt) using the appropriate external application.
*   `flutter_otp_text_field`: Provides a pre-built and customizable UI widget for entering One-Time Passwords.
*   `google_fonts`: Used to incorporate custom fonts from the Google Fonts library, enhancing UI design.
*   `flutter_svg_provider` / `flutter_svg`: Enable the use of Scalable Vector Graphics (SVG) for icons and images, ensuring they look sharp at any resolution.
*   `date_picker_plus`: Provides advanced date picking functionalities.
*   `flutter_media_downloader`: An alternative or complementary tool for managing file downloads.
