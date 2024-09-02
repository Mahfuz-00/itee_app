/// Represents a venue for an exam.
///
/// This class contains information about a specific venue where an
/// exam takes place, including its unique identifier and name.
///
/// ### Properties:
/// - [id]: The unique identifier for the venue.
/// - [name]: The name of the venue.
///
/// ### Factory Method:
/// - `fromJson`: A factory method that creates a [Venue] instance from
///   a JSON object.
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

/// Represents a category of exams.
///
/// This class holds details about a specific category of exams,
/// including a unique identifier and name.
///
/// ### Properties:
/// - [id]: The unique identifier for the exam category.
/// - [name]: The name of the exam category.
///
/// ### Factory Method:
/// - `fromJson`: A factory method that creates an [ExamCategory]
///   instance from a JSON object.
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

/// Represents a type of exam within a category.
///
/// This class provides information about a specific type of exam,
/// including its unique identifier and name.
///
/// ### Properties:
/// - [id]: The unique identifier for the exam type.
/// - [name]: The name of the exam type.
///
/// ### Factory Method:
/// - `fromJson`: A factory method that creates an [ExamType]
///   instance from a JSON object.
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

/// Represents a book related to an exam.
///
/// This class encapsulates information about a book associated with
/// an exam, including its unique identifier, name, and price.
///
/// ### Properties:
/// - [id]: The unique identifier for the book.
/// - [name]: The name of the book.
/// - [bookprice]: The price of the book.
///
/// ### Factory Method:
/// - `fromJson`: A factory method that creates a [Book] instance
///   from a JSON object.
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
