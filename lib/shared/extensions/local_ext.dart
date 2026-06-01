import '../models/models.dart';

extension BilingualCoach on Coach {
  String localBio(String locale) =>
      locale == 'mn' ? (bioMn ?? bio ?? '') : (bio ?? '');
}

extension BilingualService on Service {
  String localTitle(String locale) =>
      locale == 'mn' ? (titleMn ?? title) : title;

  String localDescription(String locale) =>
      locale == 'mn' ? (descriptionMn ?? description ?? '') : (description ?? '');
}

extension BilingualNotification on AppNotification {
  String localTitle(String locale) =>
      locale == 'mn' ? (titleMn ?? title ?? '') : (title ?? '');

  String localBody(String locale) =>
      locale == 'mn' ? (bodyMn ?? body ?? '') : (body ?? '');
}
