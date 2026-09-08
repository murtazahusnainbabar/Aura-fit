class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String membershipTier; // 'free' | 'pro'
  final int currentStreak;
  final int totalWorkouts;
  final double weightKg;
  final double heightCm;
  final int age;
  final String fitnessGoal;
  final int weeklyGoalDays;
  final double activeCaloriesGoal;
  final double workoutMinutesGoal;
  final double waterLitersGoal;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl = '',
    this.membershipTier = 'free',
    this.currentStreak = 0,
    this.totalWorkouts = 0,
    this.weightKg = 75.0,
    this.heightCm = 175.0,
    this.age = 25,
    this.fitnessGoal = 'Build Muscle',
    this.weeklyGoalDays = 4,
    this.activeCaloriesGoal = 500,
    this.workoutMinutesGoal = 45,
    this.waterLitersGoal = 2.5,
  });

  static const UserProfile demo = UserProfile(
    id: 'u1',
    name: 'Alex Chen',
    email: 'alex@aurafit.app',
    membershipTier: 'pro',
    currentStreak: 7,
    totalWorkouts: 124,
    weightKg: 74.2,
    heightCm: 178,
    age: 28,
    fitnessGoal: 'Build Muscle',
    weeklyGoalDays: 5,
    activeCaloriesGoal: 520,
    workoutMinutesGoal: 45,
    waterLitersGoal: 2.5,
  );
}
