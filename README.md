# Tuwaiq Gallery App

## Overview

### Features
- User Registration and Login: Secure sign-up and login process using OTP.
﻿
# Tuwaiq Gallery App

## Overview

### Features
- User Registration and Login: Secure sign-up and login process using OTP.
- Project Management: Users can manage projects and view details of each project.
- Barcode Scanning: Scan and generate barcodes using `flutter_barcode_scanner` and `barcode_widget`.
- File Management: Upload and pick files such as PDFs or images using `image_picker` and `file_picker`.
- Webview Support: Open web content using `flutter_webview_plugin` and `webview_flutter`.
- Interactive UI Components: Includes features like rating bars, countdown timers, and expansion tiles.

### User Authentication
The app uses secure authentication methods, including OTP (One Time Password) through the `pinput` package, to ensure user verification. Users can sign up, log in, and manage their profiles securely.



## DataLayer

The `DataLayer` class is responsible for managing user authentication and data retrieval in the Project Judge application. It utilizes the `GetStorage` package for local storage and interacts with an API to fetch user and project information.

### Features

- **User Authentication**: Saves and retrieves authentication information using `AuthModel`.
- **User Profile Management**: Loads user profile data from the API and stores it locally.
- **Project Information Retrieval**: Fetches project details from the API.

### Dependencies

- `get_storage`: A lightweight storage solution for Flutter applications.
- `project_judge/models/auth_model.dart`: Contains the `AuthModel` for user authentication.
- `project_judge/models/user_model.dart`: Contains the `UserModel` for user profile representation.
- `project_judge/network/api_network.dart`: Contains methods for making API calls.

### Class Members

- `ApiNetowrok api`: An instance of the `ApiNetowrok` class to handle network requests.
- `AuthModel? authUser`: Stores the authenticated user's information.
- `UserModel? userInfo`: Stores the user's profile information.
- `List<Projects>? projectInfo`: Stores information about various projects.
- `final box = GetStorage()`: Instance of `GetStorage` for local data management.

### Constructor

- `DataLayer()`: Initializes the data layer and loads any existing data from storage.

### Methods

- `saveUserAuth({required AuthModel auth})`: Saves the authentication information locally.
- `Future<void> getUserr()`: Asynchronously retrieves the user's profile from the API and stores it locally.
- `Future<void> getProjectInfo()`: Asynchronously retrieves project details from the API.
- `loadData()`: Loads stored authentication and user information from local storage.




### API Network Integration

The app implements a centralized `ApiNetwork` class that provides various network-related functionalities, consolidating multiple API methods under one unified interface. The `ApiNetwork` class is built by extending the `ConstantNetwork` and leveraging several mixins, each responsible for specific tasks. This modular approach ensures clean and maintainable code when interacting with the backend.

#### Features:

- **CreateAccountMethod**: Handles user registration and account creation.
- **VerifyAccountMethod**: Provides functionality for verifying user accounts.
- **LoginAccountMethod**: Manages user login, including authentication and session handling.
- **UpdateProfileMethod**: Enables users to update their profile information.
- **UpdateProjectMethods**: Allows users to modify details related to their projects.
- **ProjectDetails**: Retrieves detailed information about specific projects.
- **CreateProjectMethod**: Facilitates the creation of new projects through the API.
- **RatingProjectMethod**: Submits and retrieves project ratings.

The `ApiNetwork` class integrates all these methods to simplify API calls throughout the app, making it easier to handle operations like account management, project creation, and ratings submission.


By using `ApiNetwork`, the app can communicate efficiently with the backend, reducing the complexity of managing multiple API endpoints while keeping the codebase clean and scalable.


### Constant Network Configuration

The app uses a `ConstantNetwork` class to manage all the API base URLs and endpoints. This class centralizes API configuration, ensuring that endpoints are easy to maintain and reference throughout the project.

#### Key Features:

- **Base URL**:  
  All API requests are made through the base URL:  
  `https://tuwaiq-gallery.onrender.com/v1`
  
- **Endpoints**:  
  The following key API endpoints are defined within the `ConstantNetwork` class:
  - **User Authentication:**
    - `createAccountEndPoint`: `/auth/create/new/account`
    - `loginAccountEndPoint`: `/auth/login`
    - `verifyAccountEndPoint`: `/auth/verify`
    - `resendOTPEndPoint`: `/auth/resend`
  - **User Profile:**
    - `getProfileEndPoint`: `/user/profile`
  - **Project Management:**
    - `updateProjectLogoEndPoint`: `/user/edit/project/logo`
    - `updateProjectBaseEndPoint`: `/user/edit/project/base`
    - `updateProjectImagesEndPoint`: `/user/edit/project/images`
    - `updateProjectPresentationEndPoint`: `/user/edit/project/presentation`
    - `updateProjectLinksEndPoint`: `/user/edit/project/link`
    - `updateProjectMembersEndPoint`: `/user/edit/project/members`
    - `getFirstHundredProjectsEndPoint`: `/projects`
  - **Project Rating:**
    - `ratingProjectEndPoint`: `/user/rating/project`
  - **Supervisor Role:**
    - `supervisorCreate`: `/supervisor/create/project`
  - **Admin Role:**
    - `adminEndpoint`: `/admin/change/role/user`


By having all endpoints clearly defined in this class, the app can ensure consistent and centralized API management, making it easier to update or expand the network interactions.


## Navigation Page

The app features a **Navigation Page** that allows users to switch between different sections of the app, such as Home, Browse, My Projects, and Profile. A floating middle button is included, which initiates a **QR code scanner** to enable users to quickly navigate to specific project rating pages by scanning a project QR code.

### Features:

- **Bottom Navigation Bar**: A user-friendly bottom navigation bar lets users easily switch between:
  1. **Home Screen**
  2. **Browse Page**
  3. **QR Code Scanner** (Middle Button)
  4. **My Projects**
  5. **Profile Screen**
  
- **QR Code Scanner**: 
  - Integrated with the `flutter_barcode_scanner` package, users can scan a QR code to quickly navigate to the **Rating Page** for a project.
  - If the scan is successful, it retrieves the project ID and redirects the user to the **Rating Page** with the corresponding project details.
  
- **Real-Time Navigation**: 
  - Selected navigation index is maintained through the app, ensuring the user returns to the correct section.
  - The QR scanner launches from the middle button and handles scan failures gracefully with error handling.

### Rating Page

The app includes a comprehensive project rating page where users can evaluate various aspects of a project on a scale from 1 to 10. The rating categories include:

- **Idea**
- **Design**
- **Tools**
- **Practices**
- **Presentation**
- **Investment**

Each category is represented with a slider and an accompanying icon for better visual clarity. Users can also add any additional comments or feedback in the **Notes** section.  

### Features:

- **Rating Submission**: Users can submit their ratings by tapping the submit button.
- **Real-Time Feedback**: A loading animation is displayed during the submission process, and potential errors are handled with appropriate dialogs.
- **Bloc Pattern**: The page uses the Bloc pattern for state management, ensuring smooth interaction and separation of concerns.

## App Structure
The project is divided into multiple layers to promote clean architecture:

- Components: Reusable widgets such as buttons, navigation bars, and custom UI elements.
- Data Layer: Manages network requests and handles data storage (local and remote).
- Models: Contains data models used across the app.
- Screens: Contains all UI screens like `LoginScreen`, `ProjectDetailScreen`, and `BarcodeScreen`.
- Services: Manages background services like local storage and networking.


```
┣ lib
┣ 📂components
┃ ┣ 📂app_bar
┃ ┃ ┗ 📜custom_app_bar.dart
┃ ┣ 📂buttons
┃ ┃ ┣ 📜bottomNavBar.dart
┃ ┃ ┣ 📜custom_elevated_button.dart
┃ ┃ ┗ 📜custom_icon_button.dart
┃ ┣ 📂cards
┃ ┃ ┗ 📜custom_team_member_card.dart
┃ ┣ 📂containers
┃ ┃ ┣ 📜custom_manage_users_container.dart
┃ ┃ ┗ 📜custom_slider_containers.dart
┃ ┣ 📂custom_paints
┃ ┃ ┣ 📜bottom_navigation.dart
┃ ┃ ┗ 📜tuwaiq_logo_paint.dart
┃ ┣ 📂dialog
┃ ┃ ┗ 📜error_dialog.dart
┃ ┣ 📂icons
┃ ┃ ┗ 📜custom_rate_icon.dart
┃ ┣ 📂list_tiles
┃ ┃ ┗ 📜custom_project_detail_list_tile.dart
┃ ┣ 📂project_card
┃ ┃ ┗ 📜projectCard.dart
┃ ┣ 📂slider_section
┃ ┃ ┗ 📜sliderSection.dart
┃ ┣ 📂tab_bar
┃ ┃ ┣ 📜browse_projects_page.dart
┃ ┃ ┣ 📜Closed_tab_bar.dart
┃ ┃ ┣ 📜Opened_tab_bar.dart
┃ ┃ ┗ 📜tab_bar_browse.dart
┃ ┣ 📂text
┃ ┃ ┗ 📜custom_text.dart
┃ ┗ 📂text_field
┃   ┣ 📜custom_text_form_field.dart
┃   ┗ 📜noteSection_text.dart
┣ 📂data_layer
┃ ┗ 📜data_layer.dart
┣ 📂models
┃ ┣ 📜auth_model.dart
┃ ┗ 📜user_model.dart
┣ 📂network
┃ ┣ 📂mixin
┃ ┃ ┣ 📜create_account_method.dart
┃ ┃ ┣ 📜create_project_methid.dart
┃ ┃ ┣ 📜delete_project_method.dart
┃ ┃ ┣ 📜login_account_method.dart
┃ ┃ ┣ 📜project_details.dart
┃ ┃ ┣ 📜rating_project_method.dart
┃ ┃ ┣ 📜update_profile_method.dart
┃ ┃ ┣ 📜update_project_methods.dart
┃ ┃ ┣ 📜update_user_role.dart
┃ ┃ ┗ 📜verify_account_method.dart
┃ ┣ 📜api_netowrok.dart
┃ ┗ 📜constant_network.dart
┣ 📂screens
┃ ┣ 📂add_project_screen
┃ ┃ ┣ 📂cubit
┃ ┃ ┃ ┣ 📜add_project_cubit.dart
┃ ┃ ┃ ┗ 📜add_project_state.dart
┃ ┃ ┗ 📜add_project_screen.dart
┃ ┣ 📂auth
┃ ┃ ┣ 📂cubit
┃ ┃ ┃ ┣ 📜auth_cubit.dart
┃ ┃ ┃ ┗ 📜auth_state.dart
┃ ┃ ┣ 📜create_account_screen.dart
┃ ┃ ┣ 📜login_screen.dart
┃ ┃ ┗ 📜verify_screen.dart
┃ ┣ 📂barcode_screen
┃ ┃ ┗ 📜barcode_screen.dart
┃ ┣ 📂browse_page
┃ ┃ ┗ 📜browsePage.dart
┃ ┣ 📂edit_profile.dart
┃ ┃ ┣ 📂bloc
┃ ┃ ┃ ┣ 📜updateprofile_bloc.dart
┃ ┃ ┃ ┣ 📜updateprofile_event.dart
┃ ┃ ┃ ┗ 📜updateprofile_state.dart
┃ ┃ ┗ 📜edit_profile.dart
┃ ┣ 📂edit_project
┃ ┃ ┣ 📂bloc
┃ ┃ ┃ ┣ 📜edit_project_bloc.dart
┃ ┃ ┃ ┣ 📜edit_project_event.dart
┃ ┃ ┃ ┗ 📜edit_project_state.dart
┃ ┃ ┣ 📜edit_base.dart
┃ ┃ ┣ 📜edit_images.dart
┃ ┃ ┣ 📜edit_links.dart
┃ ┃ ┣ 📜edit_logo.dart
┃ ┃ ┣ 📜edit_members.dart
┃ ┃ ┣ 📜edit_presentation.dart
┃ ┃ ┗ 📜edit_project_screen.dart
┃ ┣ 📂home_screen
┃ ┃ ┣ 📂cubit
┃ ┃ ┃ ┣ 📜home_cubit.dart
┃ ┃ ┃ ┗ 📜home_state.dart
┃ ┃ ┗ 📜home_screen.dart
┃ ┣ 📂loading screen
┃ ┃ ┣ 📂cubit
┃ ┃ ┃ ┣ 📜loading_screen_cubit.dart
┃ ┃ ┃ ┗ 📜loading_screen_state.dart
┃ ┃ ┗ 📜loading_screen.dart
┃ ┣ 📂manage_user_screen
┃ ┃ ┣ 📂cubit
┃ ┃ ┃ ┣ 📜mange_user_cubit.dart
┃ ┃ ┃ ┗ 📜mange_user_state.dart
┃ ┃ ┗ 📜manage_user_screen.dart
┃ ┣ 📂myproject_page
┃ ┃ ┣ 📂bloc
┃ ┃ ┃ ┣ 📜bloc_project_bloc.dart
┃ ┃ ┃ ┣ 📜bloc_project_event.dart
┃ ┃ ┃ ┗ 📜bloc_project_state.dart
┃ ┃ ┗ 📜myProjectsPage.dart
┃ ┣ 📂navigation
┃ ┃ ┗ 📜navigationPage.dart
┃ ┣ 📂profile_screen
┃ ┃ ┣ 📂cubit
┃ ┃ ┃ ┣ 📜profile_cubit.dart
┃ ┃ ┃ ┗ 📜profile_state.dart
┃ ┃ ┗ 📜profile_screen.dart
┃ ┣ 📂rating
┃ ┃ ┣ 📂cubit
┃ ┃ ┃ ┣ 📜rating_cubit.dart
┃ ┃ ┃ ┗ 📜rating_state.dart
┃ ┃ ┗ 📜ratingPage.dart
┃ ┣ 📂search_screen
┃ ┃ ┣ 📂cubit
┃ ┃ ┃ ┣ 📜search_cubit.dart
┃ ┃ ┃ ┗ 📜search_state.dart
┃ ┃ ┗ 📜search_screen.dart
┃ ┣ 📂splash_screen
┃ ┃ ┗ 📜splash_screen.dart
┃ ┣ 📂view_project_detail_screen
┃ ┃ ┣ 📂cubit
┃ ┃ ┃ ┣ 📜view_project_details_cubit.dart
┃ ┃ ┃ ┗ 📜view_project_details_state.dart
┃ ┃ ┗ 📜view_project_detail_screen.dart
┃ ┗ 📂welcome_screen
┃   ┗ 📜welcome_screen.dart
┣ 📂services
┃ ┗ 📂extension
┃   ┗ 📜size_extension.dart
┣ 📂setup
┃ ┗ 📜init_setup.dart
┗ 📜main.dart
```

### Technologies Used
- Flutter: The app is built using Flutter for cross-platform support.
- GetIt: Service locator for dependency injection.
- Bloc: State management for handling business logic and events.

### Packages Used
- `get_it`: Dependency injection and service locator.
- `dio`: Handles HTTP requests for API integration.
- `get_storage`: Local storage management.
- `flutter_bloc`: Manages state with the Bloc pattern.
- `pinput`: Input field for OTP authentication.
- `lottie`: Provides animated assets.
- `flutter_svg`: Supports rendering SVG images.
- `device_preview`: Preview app design on different devices.
- `date_picker_plus`: Date picker for selecting dates.
- `image_picker & file_picker`: Handle image and file selection.
- `intl`: Internationalization support.
- `carousel_slider`: Create carousels for images or content.
- `expansion_tile_card`: Expansion cards for collapsible content.
- `flutter_rating_bar`: Rating bar for feedback collection.
- `circular_countdown_timer`: Timer widget.
- `url_launcher`: Launch URLs in the browser.
- `flutter_webview_plugin & webview_flutter`: Webview support.
- `open_filex`: Open files within the app.
- `uri_to_file`: Convert URIs to files.
- `flutter_barcode_scanner`: Scan barcodes.
- `barcode_widget`: Generate barcode images.
  ### Output
![Screenshot 2024-09-24 at 3 29 39 AM](https://github.com/user-attachments/assets/973e2e28-6d56-4123-b328-c50885985ff9)
![Screenshot 2024-09-23 at 8 44 04 PM](https://github.com/user-attachments/assets/bbe3c472-5385-4817-8517-d97223b86bec)
![Screenshot 2024-09-23 at 8 44 06 PM](https://github.com/user-attachments/assets/034f4a61-4054-47fa-adf4-cad0a2e62359)
![Screenshot 2024-09-23 at 8 44 09 PM](https://github.com/user-attachments/assets/96e9cf0f-b961-4d37-9bd8-45a5400d43c1)
![Screenshot 2024-09-24 at 3 32 28 AM](https://github.com/user-attachments/assets/d503811a-35c7-4bbb-b0ea-4a0ae56ec98a)
![Screenshot 2024-09-24 at 3 22 55 AM](https://github.com/user-attachments/assets/b0fc2fc6-4088-48b9-9afc-6a43b5d397fc)
![Screenshot 2024-09-24 at 3 33 44 AM](https://github.com/user-attachments/assets/24930990-2436-47e5-8636-ed0551764f70)
![Screenshot 2024-09-24 at 3 23 06 AM](https://github.com/user-attachments/assets/0bb300dc-1816-4878-902f-dfaa770acb2e)
![Screenshot 2024-09-24 at 3 37 48 AM](https://github.com/user-attachments/assets/bc24bc76-0661-4401-8658-1d058c65486d)
![Screenshot 2024-09-24 at 3 23 22 AM](https://github.com/user-attachments/assets/18922723-3f5a-4aed-bbc3-ea974eb26754)
![Screenshot 2024-09-24 at 3 23 28 AM](https://github.com/user-attachments/assets/e90fdfd8-1302-419f-b416-a6c00d749501)
![Screenshot 2024-09-24 at 3 23 31 AM](https://github.com/user-attachments/assets/c0efcfb1-7911-4d08-9a7b-3fc0b406e0b4)
![Screenshot 2024-09-24 at 3 23 36 AM](https://github.com/user-attachments/assets/d2929ab5-86de-44e3-a69f-cea7a1bca304)
![Screenshot 2024-09-24 at 3 23 55 AM](https://github.com/user-attachments/assets/7cef7661-b2bc-4914-bb6d-8a053822a920)

## Setup Instructions

### Prerequisites
- Flutter SDK
- Dart
-  Visual Studio Code (with Flutter extensions)
- Xcode (for iOS development)

### Installation
1. Clone the repository:
   git clone https://github.com/repo/flutter-app.git

2. Install the dependencies:
   flutter pub get

3. Run the app on your device or emulator:
   flutter run

### Additional Steps
- For barcode scanning and image picking features, ensure that the necessary permissions are added to the `AndroidManifest.xml` and `Info.plist` files for Android and iOS, respectively.

### Team Members
 Abdulaziz Alruwaily
 Amjad Elahi
 Linda Almakramy
  Nouf Alqahtani
