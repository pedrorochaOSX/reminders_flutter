# Reminders

## Running the project

#### Install Flutter: [Install | Flutter](https://docs.flutter.dev/get-started/install)

#### Get project dependencies:
```bash
flutter pug get
```

#### Create the platforms directories you need:
```bash
flutter create --platforms=windows,android,macos,linux,ios,web .
```
The example above creates all the possible platforms directories, if you want to create only a android directory, you should use:
```bash
flutter create --platforms=android .
```

#### Create the build directory:
```bash
flutter build apk
```
The example above creates only the build directory with an android app, you can get the apk file in:
```bash
\build\app\outputs\apk\release\
```
