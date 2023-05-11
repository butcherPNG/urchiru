

class Group{
  final String name;
  final String teacher;
  final List<User> students;


  Group(
      {required this.name,
      required this.students,
      required this.teacher});
}

class User{
  final String email;
  final String role;
  final String username;

  User({required this.email, required this.username, required this.role});
}



class Task{
  final String header;
  final String description;
  final List<String> words;

  Task({required this.header, required this.words, required this.description});
}