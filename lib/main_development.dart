import 'package:authentication_client/authentication_client.dart';
import 'package:chats_repository/chats_repository.dart';
import 'package:database_client/database_client.dart';
import 'package:env/env.dart';
import 'package:firebase_notifications_client/firebase_notifications_client.dart';
import 'package:flutter_instagram_offline_first_clone/app/app.dart';
import 'package:flutter_instagram_offline_first_clone/bootstrap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:search_repository/search_repository.dart';
import 'package:shared/shared.dart';
import 'package:stories_repository/stories_repository.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart'; 
import 'package:token_storage/token_storage.dart';
import 'package5/user_repository.dart';

void main() {
  bootstrap(appFlavor: AppFlavor.development(), (
    powerSyncRepository,
    firebaseMessaging,
    sharedPreferences,
    firebaseRemoteConfigRepository,
  ) async {
    final firebaseNotificationsClient = FirebaseNotificationsClient(
      firebaseMessaging: firebaseMessaging,
    );

    final notificationsRepository = NotificationsRepository(
      notificationsClient: firebaseNotificationsClient,
    );

    final tokenStorage = InMemoryTokenStorage();
    final appFlavor = AppFlavor.development();
    final googleSignIn = GoogleSignIn(
      clientId: appFlavor.getEnv(Env.iOSClientId),
      serverClientId: appFlavor.getEnv(Env.webClientId),
    );

    final authenticationClient = SupabaseAuthenticationClient(
      powerSyncRepository: powerSyncRepository,
      tokenStorage: tokenStorage,
      googleSignIn: googleSignIn,
    );

    final databaseClient = PowerSyncDatabaseClient(
      powerSyncRepository: powerSyncRepository,
    );

    final persistentStorage = PersistentStorage(
      sharedPreferences: sharedPreferences,
    );

    final storiesStorage = StoriesStorage(storage: persistentStorage);
    final userRepository = UserRepository(
      databaseClient: databaseClient,
      authenticationClient: authenticationClient,
    );

    return App(
      userRepository: userRepository,
      postsRepository: PostsRepository(databaseClient: databaseClient),
      chatsRepository: ChatsRepository(databaseClient: databaseClient),
      storiesRepository: StoriesRepository(
        databaseClient: databaseClient,
        storage: storiesStorage,
      ),
      searchRepository: SearchRepository(databaseClient: databaseClient),
      notificationsRepository: notificationsRepository,
      firebaseRemoteConfigRepository: firebaseRemoteConfigRepository,
      user: const AuthenticationUser(
        id: 'dummy-user-id-12345',
        email: 'storm.user@example.com',
        fullName: 'Storm Tester',
        username: 'storm_tester',
        avatarUrl: 'https://unsplash.com',
        pushToken: 'dummy-token-abc-123',
        isNewUser: false,
      ),
    );
  });
}
