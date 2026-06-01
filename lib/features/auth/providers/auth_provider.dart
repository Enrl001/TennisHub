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
      final data = await client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();
      return Profile.fromJson(data);
    } catch (_) {
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

  Future<void> signUp({
    required String email,
    required String password,
    required String role,
  }) async {
    final client = ref.read(supabaseClientProvider);
    final response =
        await client.auth.signUp(email: email, password: password);
    final userId = response.user!.id;
    await client.from('profiles').insert({'id': userId, 'role': role});
    ref.invalidateSelf();
    await future;
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
        .signInWithOAuth(OAuthProvider.google);
  }

  Future<void> signInWithApple() async {
    await ref
        .read(supabaseClientProvider)
        .auth
        .signInWithOAuth(OAuthProvider.apple);
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
