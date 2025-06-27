Flutter Chat & Map Application
This is a full-featured, cross-platform messaging and location-tracking application built with Flutter. The app supports iOS, Android, and Web from a single codebase and implements a wide range of modern mobile development features.

Core Features
Cross-Platform Support: A single codebase powers the application on iOS, Android, and the Web, with a fully responsive and adaptive UI.

User Authentication:

Secure user registration with email, display name, country, and mobile number.

Robust login system with email and password.

Persistent user sessions that survive app restarts.

Real-Time Chat:

Live, one-on-one messaging powered by Firestore's real-time streams.

Message Status: Users can see if their messages have been Sent (single tick) and Seen (double blue tick).

Unread Notification Badges: The main "Chats" navigation icon and individual chat list items display a count of unread messages.

Push Notifications:

Using Firebase Cloud Messaging (FCM) and a backend Cloud Function, users receive push notifications for new messages even when the app is in the background or terminated.

Tapping a notification opens the app directly to the relevant chat screen.

QR Code Connectivity: Users can initiate new chats easily and securely by scanning another user's unique QR code.

Live Map Integration:

Displays the user's current location on Google Maps in real-time.

Draws a 2-kilometer rectangular overlay around the user's position that moves as they do.

Uses custom map styling to highlight water bodies like lakes and ponds.

Internationalization (l10n):

The app fully supports both English and Arabic.

The entire UI, including text and layout direction (LTR/RTL), automatically adapts based on the selected language.

Users can switch languages on the fly from the settings menu, and their preference is saved for future sessions.

Adaptive User Interface:

On smaller screens (mobile), the app uses a standard bottom navigation bar.

On larger screens (web/tablet), the UI automatically adapts to a three-column layout with a side navigation rail, a chat list, and a detailed chat view.

Technical Stack & Architecture
This project was built using a modern, scalable, and maintainable architecture.

Framework: Flutter 3.x

Backend: Firebase

Authentication: For user sign-up and login.

Cloud Firestore: As the real-time database for user profiles, chat rooms, messages, and FCM tokens.

Cloud Functions (Node.js): For sending push notifications from the backend.

Firebase Cloud Messaging (FCM): For push notification delivery.

Architecture: Clean Architecture

A feature-first project structure was used to keep code organized and modular.

Each feature is separated into Data, Domain, and Presentation layers to separate business logic from UI and data sources.

State Management: flutter_bloc / Cubit

Used to manage the state of UI components and handle business logic in a predictable way.

Navigation: go_router

Handles all app navigation, including deep linking from notifications and a StatefulShellRoute for the adaptive main UI.

Key Packages:

http: For fetching the country list from a REST API.

mobile_scanner: For a fast and efficient QR code scanner.

google_maps_flutter & geolocator: For all map and location functionality.

flutter_local_notifications: For displaying notifications when the app is in the foreground.

shared_preferences: For persisting the user's language preference.
