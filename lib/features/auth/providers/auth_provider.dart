import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/supabase_providers.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<Profile?> build() async {
    final client = ref.watch(supabaseClientProvider);
    final user = client.auth.currentUser;
    if (user == null) return null;
    try {
      // Use maybeSingle so missing profile returns null instead of throwing
      final data = await client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data == null) {
        // Profile missing — auto-create it (handles users registered before the RPC was set up)
        debugPrint('AUTH BUILD: no profile found for ${user.id}, creating...');
        await client.rpc('create_profile', params: {
          'p_user_id': user.id,
          'p_user_role': 'customer',
        });
        final created = await client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();
        return Profile.fromJson(created);
      }

      return Profile.fromJson(data);
    } catch (e) {
      debugPrint('AUTH BUILD ERROR (profile fetch): $e');
      return null;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final client = ref.read(supabaseClientProvider);
    await client.auth
        .signInWithPassword(email: email, password: password);
    ref.invalidateSelf();
    await future;
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String role,
    String? fullName,
  }) async {
    final client = ref.read(supabaseClientProvider);
    final response =
        await client.auth.signUp(email: email, password: password);

    final user = response.user;
    if (user == null) {
      throw Exception('This email is already registered. Please sign in.');
    }

    final needsConfirmation = response.session == null;

    await client.rpc('create_profile', params: {
      'p_user_id': user.id,
      'p_user_role': role,
      'p_full_name': fullName,
    });

    if (!needsConfirmation) {
      ref.invalidateSelf();
      await future;
    }
    return needsConfirmation;
  }

  Future<void> signOut() async {
    await ref.read(supabaseClientProvider).auth.signOut();
    ref.invalidateSelf();
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    final client = ref.read(supabaseClientProvider);
    final user = client.auth.currentUser;
    if (user == null) return;
    await client.from('profiles').update(updates).eq('id', user.id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> signInWithGoogle() async {
    await ref
        .read(supabaseClientProvider)
        .auth
        .signInWithOAuth(
          OAuthProvider.google,
          redirectTo: 'myclub:///login-callback',
        );
  }

  Future<void> signInWithApple() async {
    await ref
        .read(supabaseClientProvider)
        .auth
        .signInWithOAuth(
          OAuthProvider.apple,
          redirectTo: 'myclub:///login-callback',
        );
  }
}

@riverpod
Profile? currentProfile(Ref ref) =>
    ref.watch(authProvider).value;

@riverpod
bool isAuthenticated(Ref ref) =>
    ref.watch(supabaseClientProvider).auth.currentUser != null;

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  String build() => 'en';

  void setLocale(String locale) => state = locale;
}
