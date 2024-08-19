class Venue {
  final int id;
  final String name;

  Venue({required this.id, required this.name});

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class ExamCategory {
  final int id;
  final String name;

  ExamCategory({required this.id, required this.name});

  factory ExamCategory.fromJson(Map<String, dynamic> json) {
    return ExamCategory(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class ExamType {
  final int id;
  final String name;

  ExamType({required this.id, required this.name});

  factory ExamType.fromJson(Map<String, dynamic> json) {
    return ExamType(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class Book {
  final int id;
  final String name;
  final String bookprice;

  Book(
      {
      required this.id,
      required this.name,
      required this.bookprice});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      name: json['book_name'] as String,
      bookprice: json['book_price'] as String,
    );
  }
}
