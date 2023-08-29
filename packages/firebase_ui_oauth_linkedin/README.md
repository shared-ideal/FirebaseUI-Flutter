# Firebase UI OAuth LinkedIn

[![pub package](https://img.shields.io/pub/v/firebase_ui_oauth_linkedin.svg)](https://pub.dev/packages/firebase_ui_oauth_linkedin)

Linked-In Sign In for [Firebase UI Auth](https://pub.dev/packages/firebase_ui_auth)

## Installation

Add dependencies

```sh
flutter pub add firebase_ui_auth
flutter pub add firebase_ui_oauth_linkedin

flutter pub global activate flutterfire_cli
flutterfire configure
```

Enable Linked-In provider on [firebase console](https://console.firebase.linkedin.com/).

## Usage

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_linkedin/firebase_ui_oauth_linkedin.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
        LinkedInProvider(apiKey: 'apiKey', apiSecretKey: 'apiSecretKey'),
    ]);

    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInScreen(
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            // redirect to other screen
          })
        ],
      ),
    );
  }
}
```

Alternatively you could use the `OAuthProviderButton`

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthStateListener<OAuthController>(
      listener: (oldState, newState, controller) {
        if (newState is SignedIn) {
          // navigate to other screen.
        }
      },
      child: OAuthProviderButton(
        provider: LinkedInProvider(apiKey: 'apiKey'),
      ),
    );
  }
}
```

Also there is a standalone version of the `LinkedInSignInButton`

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinkedInSignInButton(
      apiKey: 'apiKey',
      apiSecretKey: 'apiSecretKey',
      loadingIndicator: CircularProgressIndicator(),
      onSignedIn: (UserCredential credential) {
        // perform navigation.
      }
    );
  }
}
```

## API Secret Key notes

Don't hardcode your API secret key into the source code, instead use `--dart-define LINKEDIN_API_SECRET_KEY=secret` and `apiSecretKey: const String.fromEnvironment('LINKEDIN_API_SECRET_KEY)`.

For issues, please create a new [issue on the repository](https://github.com/firebase/FirebaseUI-Flutter/issues).

For feature requests, & questions, please participate on the [discussion](https://github.com/firebase/FirebaseUI-Flutter/discussions/6978) thread.

To contribute a change to this plugin, please review our [contribution guide](https://github.com/firebase/FirebaseUI-Flutter/blob/master/CONTRIBUTING.md) and open a [pull request](https://github.com/firebase/FirebaseUI-Flutter/pulls).

Please contribute to the [discussion](https://github.com/firebase/FirebaseUI-Flutter/discussions/6978) with feedback.
