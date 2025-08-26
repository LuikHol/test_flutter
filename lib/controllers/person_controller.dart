import 'dart:math';
import '../models/person.dart';
import '../services/person_service.dart';
import 'dart:developer' as dev;

class PersonController {
  final PersonService _service = PersonService();
  final List<Person> people = [];
  final void Function(String) onError;
  final void Function(String) onSuccess;
  final void Function(bool) onLoadingChanged;

  PersonController({
    required this.onError,
    required this.onSuccess,
    required this.onLoadingChanged,
  });

  // Carregar pessoas
  Future<void> loadPeople() async {
    onLoadingChanged(true);

    try {
      dev.log('Iniciando carregamento de pessoas...');
      final loadedPeople = await _service.getAllPersons();
      dev.log('API retornou ${loadedPeople.length} pessoas');
      
      people.clear();
      people.addAll(loadedPeople);
      
      // Para debug - exibir todas as pessoas carregadas
      if (people.isEmpty) {
        dev.log('ATENÇÃO: Lista de pessoas está vazia após carregar da API');
      } else {
        dev.log('Pessoas carregadas com sucesso: ${people.length}');
        for (var person in people) {
          dev.log('Pessoa na lista - ID: ${person.id}, Nome: ${person.name}');
        }
      }
    } catch (e) {
      dev.log('Erro ao carregar pessoas: $e', error: e);
      onError('Erro ao carregar pessoas: $e');
    } finally {
      onLoadingChanged(false);
    }
  }

  // Criar pessoa
  Future<void> createPerson(String name, int age, String cpf) async {
    onLoadingChanged(true);
    
    try {
      final String newId = _generateId();
      dev.log('Criando nova pessoa com ID: $newId');
      
      final newPerson = Person(
        id: newId,
        name: name,
        age: age,
        cpf: cpf,
      );
      
      final createdPerson = await _service.createPerson(newPerson);
      dev.log('Pessoa criada na API com ID: ${createdPerson.id}');
      
      people.add(createdPerson);
      onSuccess('Pessoa adicionada com sucesso!');
    } catch (e) {
      dev.log('Erro ao criar pessoa: $e', error: e);
      onError('Erro ao salvar: $e');
      
      // Fallback para modo offline
      final newPerson = Person(
        id: _generateId(),
        name: name,
        age: age,
        cpf: cpf,
      );
      
      people.add(newPerson);
      dev.log('Pessoa criada localmente com ID: ${newPerson.id}');
      onSuccess('Erro na API. Pessoa adicionada localmente.');
    } finally {
      onLoadingChanged(false);
    }
  }

  // Atualizar pessoa
  Future<void> updatePerson(String id, String name, int age, String cpf) async {
    onLoadingChanged(true);
    
    try {
      dev.log('Atualizando pessoa com ID: $id');
      
      final updatedPerson = Person(
        id: id,
        name: name,
        age: age,
        cpf: cpf,
      );
      
      final result = await _service.updatePerson(updatedPerson);
      dev.log('Pessoa atualizada na API com ID: ${result.id}');
      
      // Procurar pelo ID exato que estamos editando
      final index = people.indexWhere((p) => p.id == id);
      if (index != -1) {
        dev.log('Pessoa encontrada na posição $index com ID: ${people[index].id}');
        people[index] = result;
      } else {
        dev.log('ATENÇÃO: Pessoa com ID $id não encontrada na lista!');
        people.add(result);
      }
      
      onSuccess('Pessoa atualizada com sucesso!');
    } catch (e) {
      dev.log('Erro ao atualizar pessoa: $e', error: e);
      onError('Erro ao salvar: $e');
      
      // Fallback para modo offline
      final index = people.indexWhere((p) => p.id == id);
      if (index != -1) {
        final updatedPerson = Person(
          id: id,
          name: name,
          age: age,
          cpf: cpf,
        );
        
        people[index] = updatedPerson;
        dev.log('Pessoa atualizada localmente com ID: ${updatedPerson.id}');
        onSuccess('Erro na API. Pessoa atualizada localmente.');
      }
    } finally {
      onLoadingChanged(false);
    }
  }

  // Deletar pessoa
  Future<void> deletePerson(String id) async {
    onLoadingChanged(true);
    
    try {
      dev.log('Excluindo pessoa com ID: $id');
      final success = await _service.deletePerson(id);
      
      people.removeWhere((person) => person.id == id);
      
      if (success) {
        onSuccess('Pessoa excluída com sucesso!');
      } else {
        onError('Erro ao excluir da API, mas excluído localmente.');
      }
    } catch (e) {
      dev.log('Erro ao excluir pessoa: $e', error: e);
      people.removeWhere((person) => person.id == id);
      onError('Erro ao excluir da API, mas excluído localmente.');
    } finally {
      onLoadingChanged(false);
    }
  }

  // Método para gerar um ID único
  String _generateId() {
    return Random().nextInt(10000).toString();
  }
}