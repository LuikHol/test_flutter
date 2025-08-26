class Person {
  String id;
  String name;
  int age;
  String cpf;

  Person({
    required this.id,
    required this.name,
    required this.age,
    required this.cpf,
  });

  Person copyWith({
    String? name,
    int? age,
    String? cpf,
  }) {
    return Person(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      cpf: cpf ?? this.cpf,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'cpf': cpf,
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {

    final String id = json['id'] is int 
        ? json['id'].toString() 
        : json['id'] as String;
    
    
    final int age = json['age'] is String 
        ? int.parse(json['age']) 
        : json['age'] as int;
        
    return Person(
      id: id,
      name: json['name'] as String,
      age: age,
      cpf: json['cpf'] as String,
    );
  }
  
  @override
  String toString() {
    return 'Person(id: $id, name: $name, age: $age, cpf: $cpf)';
  }
}