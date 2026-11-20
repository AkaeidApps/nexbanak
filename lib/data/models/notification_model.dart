class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final String time;
  final String type; // transaction | security | promotion | system
  final bool isRead;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: (json['id'] ?? '').toString(),
        title: (json['title'] ?? 'Notification').toString(),
        body: (json['body'] ?? json['message'] ?? '').toString(),
        time: (json['time'] ?? json['createdAt'] ?? '').toString(),
        type: (json['type'] ?? 'system').toString(),
        isRead: json['isRead'] == true || json['read'] == true,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'body': body,
        'time': time,
        'type': type,
        'isRead': isRead,
      };
}
