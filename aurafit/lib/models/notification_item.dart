enum NotificationType { ai, achievement, reminder, workout }

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  static final List<NotificationItem> samples = [
    NotificationItem(
      id: 'n1',
      title: 'Aura AI Coach',
      body: 'Your recovery score is 87%. Perfect day for your upper body session.',
      type: NotificationType.ai,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    NotificationItem(
      id: 'n2',
      title: '🏆 Achievement Unlocked!',
      body: 'First to Completion — You\'ve done your first HIIT workout. Keep it up!',
      type: NotificationType.achievement,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Workout Reminder',
      body: 'Time for your Core Ignition session. You\'re on a 7-day streak!',
      type: NotificationType.reminder,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationItem(
      id: 'n4',
      title: 'Aura AI Insight',
      body: 'You\'ve increased your squat volume by 18% this week. Excellent progress!',
      type: NotificationType.ai,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: 'n5',
      title: '🔥 Streak Alert',
      body: '7 days in a row! Aura recommends a light recovery session today.',
      type: NotificationType.achievement,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
  ];
}
