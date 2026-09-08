class Exercise {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final int restSeconds;
  final String muscleGroup;
  final int? durationSeconds;
  final String? videoUrl;
  bool isCompleted;

  Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    required this.muscleGroup,
    this.durationSeconds,
    this.videoUrl,
    this.isCompleted = false,
  });
}
