import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/person.dart';

class PersonFormModal extends StatefulWidget {
  final Person? person;
  final Function(String?, String, int, String) onSave;
  
  const PersonFormModal({
    super.key,
    this.person,
    required this.onSave,
  }); 

  @override
  State<PersonFormModal> createState() => _PersonFormModalState();
}

class _PersonFormModalState extends State<PersonFormModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  String? _editingPersonId; 

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  void _initForm() {
    if (widget.person != null) {
      _nameController.text = widget.person!.name;
      _ageController.text = widget.person!.age.toString();
      _cpfController.text = widget.person!.cpf;
      _editingPersonId = widget.person!.id;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  // Exibe o modal de erro
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Atenção',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(message, style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.deepPurple, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  // Valida os campos do formulário
  bool _validateForm() {
    // Verifica se todos os campos estão preenchidos
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _cpfController.text.isEmpty) {
      _showErrorDialog('Preencha todos os campos!');
      return false;
    }
    
    // Verifica se o CPF tem exatamente 11 dígitos
    if (_cpfController.text.length != 11) {
      _showErrorDialog('O CPF deve ter exatamente 11 dígitos!');
      return false;
    }
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _editingPersonId == null ? 'Adicionar Pessoa' : 'Editar Pessoa',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Mostrar ID se estiver editando (para debug)
            if (_editingPersonId != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  'ID: $_editingPersonId',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Idade',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cpfController,
              decoration: const InputDecoration(
                labelText: 'CPF',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  // Validar campos
                  if (!_validateForm()) {
                    return;
                  }
                  
                  // Fechar o modal e chamar a função de callback
                  Navigator.pop(context);
                  
                  widget.onSave(
                    _editingPersonId,
                    _nameController.text,
                    int.parse(_ageController.text),
                    _cpfController.text,
                  );
                },
                child: Text(_editingPersonId == null ? 'Registrar' : 'Atualizar'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}