// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:firebase_ui_oauth/firebase_ui_oauth.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart' hide OAuthProvider;

import 'theme.dart';

const _kProviderId = 'linkedin.com';

class LinkedInAuthProvider extends AuthProvider {
  /// Creates a new instance.
  LinkedInAuthProvider() : super(_kProviderId);

  static OAuthCredential credential({
    required String accessToken,
    required String secret,
  }) {
    return LinkedInAuthCredential._credential(
      accessToken: accessToken,
      secret: secret,
    );
  }

  /// This corresponds to the sign-in method identifier.
  static String get LINKEDIN_SIGN_IN_METHOD {
    return _kProviderId;
  }

  // ignore: public_member_api_docs
  static String get PROVIDER_ID {
    return _kProviderId;
  }

  Map<String, String> _parameters = {};

  /// Returns the parameters for this provider instance.
  Map<String, String> get parameters {
    return _parameters;
  }

  LinkedInAuthProvider setCustomParameters(
      Map<String, String> customOAuthParameters,
      ) {
    _parameters = customOAuthParameters;
    return this;
  }
}

class LinkedInAuthCredential extends OAuthCredential {
  LinkedInAuthCredential._({
    required String accessToken,
    required String secret,
  }) : super(
      providerId: _kProviderId,
      signInMethod: _kProviderId,
      accessToken: accessToken,
      secret: secret);

  factory LinkedInAuthCredential._credential({
    required String accessToken,
    required String secret,
  }) {
    return LinkedInAuthCredential._(accessToken: accessToken, secret: secret);
  }
}

class LinkedInSignInArgs extends ProviderArgs {
  final String clientId;
  final String clientSecret;

  @override
  final String redirectUri;

  @override
  final host = 'www.linkedin.com';

  @override
  final path = 'oauth/v2/authorization';

  LinkedInSignInArgs({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
  });

  @override
  Map<String, String> buildQueryParameters() {
    return {
      'client_id': clientId,
      'client_secret': clientSecret,
      'redirect_uri': redirectUri,
    };
  }
}

class LinkedInProvider extends OAuthProvider {
  @override
  final providerId = 'linkedin.com';
  final String clientId;
  final String clientSecret;
  final String? redirectUri;

  @override
  final style = const LinkedInProviderButtonStyle();

  @override
  late final desktopSignInArgs = LinkedInSignInArgs(
    clientId: clientId,
    clientSecret: clientSecret,
    redirectUri: redirectUri ?? defaultRedirectUri,
  );

  LinkedInProvider({
    required this.clientId,
    required this.clientSecret,
    this.redirectUri,
  });

  @override
  void mobileSignIn(AuthAction action) {
    LinkedInUserWidget(
      redirectUrl: redirectUri,
      clientId: clientId,
      clientSecret: clientSecret,
      onGetUserProfile:
          (UserSucceededAction linkedInUser) {
        print('Access token ${linkedInUser.user.token.accessToken}');
        print('First name: ${linkedInUser.user.firstName!.localized!.label}');
        print('Last name: ${linkedInUser.user.lastName!.localized!.label}');
      },
      onError: (UserFailedAction e) {
        print('Error: ${e.toString()}');
      },
    );
  }

  @override
  OAuthCredential fromDesktopAuthResult(AuthResult result) {
    return LinkedInAuthProvider.credential(
      accessToken: result.accessToken!,
      secret: result.tokenSecret!,
    );
  }

  @override
  LinkedInAuthProvider get firebaseAuthProvider => LinkedInAuthProvider();

  @override
  Future<void> logOutProvider() {
    return SynchronousFuture(null);
  }

  @override
  bool supportsPlatform(TargetPlatform platform) {
    return true;
  }
}
