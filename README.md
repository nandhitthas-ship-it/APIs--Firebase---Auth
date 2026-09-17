# Firebase API Starter

A Flutter starter app demonstrating:

- Firebase email/password registration, sign-in, auth state, and sign-out.
- A `users/{uid}` Firestore profile document protected by user ownership rules.
- REST requests, status validation, JSON decoding, and typed response parsing.

## Setup

### Windows prerequisites

The commands below are not built into PowerShell. Install the tools first:

1. Download the **Flutter SDK for Windows** from
   [docs.flutter.dev/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows)
   and extract it to a path without spaces, for example `C:\src\flutter`.
2. Add `C:\src\flutter\bin` to the user `Path` environment variable. Close and
   reopen PowerShell, then verify:

   ```powershell
   flutter --version
   flutter doctor
   ```

   Android Studio and an Android SDK are required if you want to run on an
   Android emulator or device. Run `flutter doctor` and follow its reported
   actions.
3. Install the Firebase CLI. Node.js is required:

   ```powershell
   npm install --global firebase-tools
   firebase login
   firebase --version
   ```

4. Install the FlutterFire CLI:

   ```powershell
   dart pub global activate flutterfire_cli
   ```

   If PowerShell still cannot find `flutterfire`, add the Dart pub cache to
   `Path`, reopen PowerShell, and retry:

   ```text
   %LOCALAPPDATA%\Pub\Cache\bin
   ```

5. Create a Firebase project, enable **Authentication > Email/Password**, and
   create a Firestore database.
6. From this directory, run:

   ```powershell
   flutterfire configure
   flutter pub get
   ```

   `flutterfire configure` replaces `lib/firebase_options.dart` with the
   environment-specific configuration. Do not commit production credentials
   or configuration files from another Firebase project.
7. Deploy the database rules:

   ```powershell
   firebase deploy --only firestore:rules
   ```

8. Run the app:

   ```powershell
   flutter run
   ```

## Firestore model

The app writes one document per authenticated user:

```text
users/{uid}
  email: string
  displayName: string
  createdAt: timestamp
```

The rules allow an authenticated user to read or write only their own
document. Deletes are disabled by default; add a deliberate account-deletion
flow before enabling them.

## REST integration

`RestApiService` calls `https://jsonplaceholder.typicode.com/posts?_limit=10`
and validates both the HTTP status and the expected JSON fields. Replace
`baseUrl` with your API endpoint and add authentication headers through the
`http.Client` boundary rather than embedding secrets in the app.

## Validation checklist

- Reject empty email, password, and registration display name locally.
- Let Firebase return structured authentication errors.
- Keep Firestore rules restrictive and test them with the Firebase Emulator
  before production deployment.
- Treat all network payloads as untrusted and validate their shape before use.
