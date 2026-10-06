import 'package:serverpod_auth_idp_server/providers/google.dart';

/// Exposes Google sign-in. It only works once `googleClientSecret` is set in
/// `config/passwords.yaml`; see `config/passwords.yaml.example`.
class GoogleIdpEndpoint extends GoogleIdpBaseEndpoint {}
