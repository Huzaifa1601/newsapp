import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../core/services/service_providers.dart';
import '../../data/datasources/news_remote_data_source.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/repositories/news_repository.dart';

final newsRemoteDataSourceProvider = Provider<NewsRemoteDataSource>((ref) {
  return NewsRemoteDataSource(client: ref.read(httpClientProvider));
});

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(
    remoteDataSource: ref.read(newsRemoteDataSourceProvider),
    cacheService: ref.read(newsCacheServiceProvider),
    preferences: ref.read(appPreferencesProvider),
  );
});

final speechToTextProvider = Provider<SpeechToText>((ref) {
  return SpeechToText();
});
