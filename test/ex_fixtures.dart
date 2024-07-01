import 'package:eagleyeix/metric.dart';

/// A collection of example ExMetricKey instances to be used as fixtures.
class ExMetricKeyFixtures {
  /// Example metric key for tracking button clicks in a shopping app.
  static final ExMetricKey buttonClick = ExMetricKey(
    name: ['interaction', 'button_click'],
    dimensions: {'button_id': 'add_to_cart', 'screen': 'product_page'},
  );

  /// Example metric key for tracking screen views in a social media app.
  static final ExMetricKey screenView = ExMetricKey(
    name: ['interaction', 'screen_view'],
    dimensions: {'screen_name': 'profile', 'user_id': 'user123'},
  );

  /// Example metric key for tracking API call performance in a backend service.
  static final ExMetricKey apiCallPerformance = ExMetricKey(
    name: ['performance', 'api_call'],
    dimensions: {'endpoint': '/get_user', 'status_code': '200'},
  );

  /// Example metric key for tracking user login attempts in an authentication system.
  static final ExMetricKey loginAttempt = ExMetricKey(
    name: ['security', 'login_attempt'],
    dimensions: {'method': 'password', 'result': 'success'},
  );

  /// Example metric key for tracking in-app purchases in a mobile game.
  static final ExMetricKey inAppPurchase = ExMetricKey(
    name: ['transaction', 'in_app_purchase'],
    dimensions: {'item_id': 'sword_001', 'user_id': 'gamer456'},
  );

  /// Example metric key for tracking page load times in a web application.
  static final ExMetricKey pageLoadTime = ExMetricKey(
    name: ['performance', 'page_load'],
    dimensions: {'page_url': '/home', 'browser': 'Chrome'},
  );

  /// Example metric key for tracking custom events in an analytics platform.
  static final ExMetricKey customEvent = ExMetricKey(
    name: ['event', 'custom'],
    dimensions: {'event_name': 'user_signup', 'source': 'newsletter'},
  );

  /// Example metric key for tracking file downloads in a document management system.
  static final ExMetricKey fileDownload = ExMetricKey(
    name: ['interaction', 'file_download'],
    dimensions: {'file_id': 'doc789', 'user_role': 'admin'},
  );

  /// Example metric key for tracking error occurrences in a logging system.
  static final ExMetricKey errorOccurrence = ExMetricKey(
    name: ['error', 'occurrence'],
    dimensions: {'error_code': '500', 'module': 'auth'},
  );

  /// Example metric key for tracking user feedback submissions in a feedback system.
  static final ExMetricKey userFeedback = ExMetricKey(
    name: ['interaction', 'user_feedback'],
    dimensions: {'feedback_type': 'bug_report', 'priority': 'high'},
  );
}
