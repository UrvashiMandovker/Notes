# Secure Notes App

A Flutter-based secure note-taking app with encryption, biometric authentication, and background sync.

## Features
- **UI**: User-friendly interface with biometric authentication.
- **Security**: AES encryption, secure file handling, and local storage.
- **Background Sync**: Periodic note syncing (concept implementation) without excessive battery drain.
- **Concurrency**: File locking and thread-safe operations for data integrity.
- **State Management**: BLoC for efficient state handling.

## Tech Stack
- Flutter, Isolates, Flutter Secure Storage, BLoC

## Installation
```sh
git clone https://github.com/UrvashiMandovker/Secure_Notes.git
cd Notes
flutter pub get
flutter run
```

## Security Measures
- AES encryption for data protection.
- Biometric authentication.
- File locking for safe concurrent access.

## Future Enhancements
- Cloud sync, multi-device support, additional authentication options.

## License
MIT License

## Author
**Urvashi Mandovker**  
[GitHub Profile](https://github.com/UrvashiMandovker)


### Flutter and Dart Versions

- **Flutter Version**:  3.27.1  
- **Dart Version**: 3.6.0 

To ensure compatibility, make sure you have these versions installed.

You can check your current versions using the following command:
```bash
flutter --version