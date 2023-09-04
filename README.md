# Reminders

## Use the app

You can use the app in Windows by downloading just the "windows release" directory and running the "reminders_flutter.exe" file.

## Running the project

### Install Flutter: [Install | Flutter](https://docs.flutter.dev/get-started/install)

### Get project dependencies:
```bash
flutter pug get
```

### Create the platforms directories you need:
```bash
flutter create --platforms=windows,macos,linux,android,ios,web .
```
The example above creates all the possible platforms directories, if you want to create only a windows directory, you should use:
```bash
flutter create --platforms=windows .
```

### Create the build directory:
```bash
flutter build windows
```
The example above creates only the Windows app in the build directory, you can change "windows" to any other platform that already has a directory in the project.
