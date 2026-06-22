enum TicketStatus { open, inProgress, closed }

enum TicketPriority { low, medium, high }

enum TicketCategory { technical, billing, general }

extension TicketStatusX on TicketStatus {
  String get dbValue => name;

  static TicketStatus fromDb(String value) {
    return TicketStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TicketStatus.open,
    );
  }

  String label(bool isArabic) {
    switch (this) {
      case TicketStatus.open:
        return isArabic ? 'مفتوحة' : 'Open';
      case TicketStatus.inProgress:
        return isArabic ? 'قيد التنفيذ' : 'In Progress';
      case TicketStatus.closed:
        return isArabic ? 'مغلقة' : 'Closed';
    }
  }
}

extension TicketPriorityX on TicketPriority {
  String get dbValue => name;

  static TicketPriority fromDb(String value) {
    return TicketPriority.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TicketPriority.medium,
    );
  }

  String label(bool isArabic) {
    switch (this) {
      case TicketPriority.low:
        return isArabic ? 'منخفضة' : 'Low';
      case TicketPriority.medium:
        return isArabic ? 'متوسطة' : 'Medium';
      case TicketPriority.high:
        return isArabic ? 'عالية' : 'High';
    }
  }
}

extension TicketCategoryX on TicketCategory {
  String get dbValue => name;

  static TicketCategory fromDb(String value) {
    return TicketCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TicketCategory.general,
    );
  }

  String label(bool isArabic) {
    switch (this) {
      case TicketCategory.technical:
        return isArabic ? 'تقنية' : 'Technical';
      case TicketCategory.billing:
        return isArabic ? 'فواتير' : 'Billing';
      case TicketCategory.general:
        return isArabic ? 'عامة' : 'General';
    }
  }
}

enum SortOrder { newestFirst, oldestFirst }
