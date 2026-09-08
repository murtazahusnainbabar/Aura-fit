import 'exercise.dart';

class Workout {
  final String id;
  final String title;
  final String category;
  final int durationMinutes;
  final int calories;
  final String difficulty;
  final String equipment;
  final String imageUrl;
  final List<String> targetMuscles;
  final List<Exercise> exercises;
  final bool isFeatured;

  const Workout({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.calories,
    required this.difficulty,
    required this.equipment,
    required this.imageUrl,
    this.targetMuscles = const [],
    this.exercises = const [],
    this.isFeatured = false,
  });
}

class WorkoutCategory {
  static const String all = 'All';
  static const String strength = 'Strength';
  static const String cardio = 'Cardio';
  static const String hiit = 'HIIT';
  static const String yoga = 'Yoga';
  static const String mobility = 'Mobility';
}

// Sample data
class WorkoutData {
  static final List<Workout> workouts = [
    Workout(
      id: '1',
      title: 'Full Body HIIT',
      category: WorkoutCategory.hiit,
      durationMinutes: 32,
      calories: 420,
      difficulty: 'Intermediate',
      equipment: 'No Equipment',
      imageUrl: '',
      targetMuscles: ['Full Body', 'Core', 'Legs'],
      isFeatured: true,
      exercises: [
        Exercise(id: 'e1', name: 'Jumping Jacks', sets: 3, reps: 20, restSeconds: 30, muscleGroup: 'Full Body'),
        Exercise(id: 'e2', name: 'Goblet Squats', sets: 4, reps: 12, restSeconds: 60, muscleGroup: 'Legs'),
        Exercise(id: 'e3', name: 'Push-ups', sets: 3, reps: 15, restSeconds: 45, muscleGroup: 'Chest'),
        Exercise(id: 'e4', name: 'Mountain Climbers', sets: 3, reps: 30, restSeconds: 30, muscleGroup: 'Core'),
        Exercise(id: 'e5', name: 'Plank', sets: 3, reps: 1, restSeconds: 45, muscleGroup: 'Core', durationSeconds: 45),
      ],
    ),
    Workout(
      id: '2',
      title: 'Core Ignition',
      category: WorkoutCategory.strength,
      durationMinutes: 25,
      calories: 280,
      difficulty: 'Beginner',
      equipment: 'Mat',
      imageUrl: '',
      targetMuscles: ['Abs', 'Obliques', 'Lower Back'],
    ),
    Workout(
      id: '3',
      title: 'Hypertrophy Chest',
      category: WorkoutCategory.strength,
      durationMinutes: 45,
      calories: 340,
      difficulty: 'Advanced',
      equipment: 'Dumbbells',
      imageUrl: '',
      targetMuscles: ['Chest', 'Shoulders', 'Triceps'],
    ),
    Workout(
      id: '4',
      title: 'Flex Vinyasa',
      category: WorkoutCategory.yoga,
      durationMinutes: 40,
      calories: 200,
      difficulty: 'Beginner',
      equipment: 'Mat',
      imageUrl: '',
      targetMuscles: ['Full Body', 'Flexibility'],
    ),
    Workout(
      id: '5',
      title: 'Athletic Rebuild',
      category: WorkoutCategory.cardio,
      durationMinutes: 30,
      calories: 380,
      difficulty: 'Intermediate',
      equipment: 'No Equipment',
      imageUrl: '',
      targetMuscles: ['Legs', 'Cardio'],
    ),
  ];
}
