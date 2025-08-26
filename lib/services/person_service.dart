import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';
import 'dart:developer' as dev;

class PersonService {
  final String baseUrl = 'https://teste-flutter.free.beeceptor.com';
  
  // Método para buscar todas as pessoas
  Future<List<Person>> getAllPersons() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/person'));
      
      dev.log('GET /person - Status: ${response.statusCode}');
      dev.log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        dev.log('Convertendo ${jsonList.length} pessoas do JSON');
        
        final List<Person> people = [];
        
        for (var item in jsonList) {
          try {
            if (item is Map && item.containsKey('id') && 
                item.containsKey('name') && 
                item.containsKey('age') && 
                item.containsKey('cpf')) {
              
              final String id = item['id'].toString();
              final String name = item['name'].toString();
              final int age = int.parse(item['age'].toString());
              final String cpf = item['cpf'].toString();
              
              people.add(Person(
                id: id,
                name: name,
                age: age,
                cpf: cpf,
              ));
              
              dev.log('Pessoa processada: ID=$id, Nome=$name');
            } else {
              dev.log('Item inválido no JSON: $item');
            }
          } catch (e) {
            dev.log('Erro ao processar item: $e', error: e);
          }
        }
        
        dev.log('Total de ${people.length} pessoas carregadas');
        return people;
      } else {
        throw Exception('Falha ao carregar pessoas: ${response.statusCode}');
      }
    } catch (e) {
      dev.log('Erro detalhado na requisição GET: $e', error: e);
      // Retornar lista vazia em vez de lançar exceção
      return [];
    }
  }
  
  // Método para criar uma nova pessoa
  Future<Person> createPerson(Person person) async {
    try {
      dev.log('POST /person - Enviando: ${json.encode(person.toJson())}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/person'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(person.toJson()),
      );
      
      dev.log('POST /person - Status: ${response.statusCode}');
      dev.log('Response body: ${response.body}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        // Garantir que o ID seja uma string
        if (responseData['id'] != null && responseData['id'] is! String) {
          responseData['id'] = responseData['id'].toString();
        }
        
        final Person createdPerson = Person.fromJson(responseData);
        
        dev.log('Pessoa criada com ID: ${createdPerson.id}');
        
        return createdPerson;
      } else {
        throw Exception('Falha ao criar pessoa: ${response.statusCode}');
      }
    } catch (e) {
      dev.log('Erro detalhado na requisição POST: $e', error: e);
      // Retornar a pessoa original em vez de lançar exceção
      return person;
    }
  }
  
  // Método para atualizar dados de uma pessoa existente
  Future<Person> updatePerson(Person person) async {
    try {
      dev.log('PUT /person/${person.id} - Enviando: ${json.encode(person.toJson())}');
      
      final response = await http.put(
        Uri.parse('$baseUrl/person/${person.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(person.toJson()),
      );
      
      dev.log('PUT /person/${person.id} - Status: ${response.statusCode}');
      dev.log('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        return Person.fromJson(responseData);
      } else {
        throw Exception('Falha ao atualizar pessoa: ${response.statusCode}');
      }
    } catch (e) {
      dev.log('Erro detalhado na requisição PUT: $e', error: e);
      // Retornar a pessoa original em vez de lançar exceção
      return person;
    }
  }
  
  // Método para deletar uma pessoa
  Future<bool> deletePerson(String id) async {
    try {
      dev.log('DELETE /person/$id');
      
      final response = await http.delete(Uri.parse('$baseUrl/person/$id'));
      
      dev.log('DELETE /person/$id - Status: ${response.statusCode}');
      
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      dev.log('Erro detalhado na requisição DELETE: $e', error: e);
      return false;
    }
  }
}