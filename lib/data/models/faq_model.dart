class FAQItem {
  final String id;
  final String question;
  final String answer;
  final String category;
  final int displayOrder;
  final bool isPopular;

  FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.displayOrder,
    this.isPopular = false,
  });

  factory FAQItem.fromMap(Map<String, dynamic> map) {
    return FAQItem(
      id: map['id'] as String,
      question: map['question'] as String,
      answer: map['answer'] as String,
      category: map['category'] as String,
      displayOrder: map['displayOrder'] as int,
      isPopular: map['isPopular'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'displayOrder': displayOrder,
      'isPopular': isPopular,
    };
  }
}

class SupportIssue {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> solutions;
  final String? contactEmail;
  final String? contactPhone;

  SupportIssue({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.solutions,
    this.contactEmail,
    this.contactPhone,
  });

  factory SupportIssue.fromMap(Map<String, dynamic> map) {
    return SupportIssue(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      solutions: List<String>.from(map['solutions'] as List),
      contactEmail: map['contactEmail'] as String?,
      contactPhone: map['contactPhone'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'solutions': solutions,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
    };
  }
}
