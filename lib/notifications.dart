import 'dart:async';

import 'package:flutter/services.dart';

class NotificationEvent {
  NotificationEvent(this._packageName);
  String _packageName;

  String get packageName => _packageName;

  String getPackageName() {
    return '${packageName.split('<br>')[0]}';
  }

  String getTitle() {
    return '${packageName.split('<br>')[1]}';
  }

  String getText() {
    return '${packageName.split('<br>')[2]}';
  }
}

NotificationEvent _notificationEvent(String event) {
  return NotificationEvent(event);
}

class Notifications {
  static const EventChannel _notificationEventChannel =
      EventChannel('notifications.eventChannel');

  Stream<NotificationEvent> _notificationStream;

  Stream<NotificationEvent> get stream {
    _notificationStream ??= _notificationEventChannel
        .receiveBroadcastStream()
        .map((event) => _notificationEvent(event));
    return _notificationStream;
  }
}
