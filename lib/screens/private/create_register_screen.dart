import 'package:flutter/material.dart';
import 'package:teste_flutter/components/empty_persons_list.dart';
import 'package:teste_flutter/components/person_card.dart';
import 'package:teste_flutter/components/person_form_modal.dart';
import 'package:teste_flutter/controllers/person_controller.dart';
import 'package:teste_flutter/models/person.dart';

class CreateRegisterScreen extends StatefulWidget {
  const CreateRegisterScreen({super.key});

  @override
  State<CreateRegisterScreen> createState() => _CreateRegisterScreenState();
}

class _CreateRegisterScreenState extends State<CreateRegisterScreen> {
  late final PersonController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Inicializa o controller com callbacks
    _controller = PersonController(
      onError: _showErrorSnackBar,
      onSuccess: _showSuccessSnackBar,
      onLoadingChanged: (isLoading) => setState(() => _isLoading = isLoading),
    );
    
    // Carrega dados iniciais
    _controller.loadPeople();
  }
  
  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showPersonModal({Person? person}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PersonFormModal(
        person: person,
        onSave: (id, name, age, cpf) {
          if (id == null) {
            _controller.createPerson(name, age, cpf);
          } else {
            _controller.updatePerson(id, name, age, cpf);
          }
        },
      ),
    );
  }

  // Método para deletar uma pessoa
  void _deletePerson(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir esta pessoa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controller.deletePerson(id);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Pessoas'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _controller.loadPeople,
            tooltip: 'Recarregar dados',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            )
          : _controller.people.isEmpty
              ? const EmptyPersonsList()
              : RefreshIndicator(
                  onRefresh: _controller.loadPeople,
                  color: Colors.deepPurple,
                  child: ListView.builder(
                    itemCount: _controller.people.length,
                    itemBuilder: (context, index) {
                      return PersonCard(
                        person: _controller.people[index],
                        onEdit: (person) => _showPersonModal(person: person),
                        onDelete: _deletePerson,
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPersonModal(),
        tooltip: 'Adicionar Pessoa',
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}