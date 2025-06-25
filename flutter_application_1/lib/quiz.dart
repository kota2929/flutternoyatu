class Quiz {
  final int id;
  final String genre;
  final String? image;
  final String? mp3;
  final String text;
  final String answer;
  final String answerReal;
  final String level;

  Quiz({
    required this.id,
    required this.genre,
    this.image,
    this.mp3,
    required this.text,
    required this.answer,
    required this.answerReal,
    required this.level,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
    id: json['quiz_id'] is int ? json['quiz_id'] : int.parse(json['quiz_id']),
    genre: json['quiz_genre'].toString(),
    image: json['quiz_image'],
    mp3: json['quiz_MP3'],
    text: json['quiz_text'].toString(),
    answer: json['quiz_answer'].toString(),
    answerReal: json['quiz_answer_real'].toString(),
    level: json['quiz_level'].toString(),
    );
  }
}
