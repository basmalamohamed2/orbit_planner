enum TaskCategory {
  study,
  work,
  personal;

  String get label => switch (this) {
    TaskCategory.study => 'Study',
    TaskCategory.work => 'Work',
    TaskCategory.personal => 'Personal',
  };
}
