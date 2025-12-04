// tela_cadastro.dart - VERSÃO SIMPLIFICADA
import 'package:flutter/material.dart';
import '../viewmodels/cadastro_viewmodel.dart';
import '../app/app_routes.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final CadastroViewModel _viewModel = CadastroViewModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nome Completo
              TextFormField(
                controller: _viewModel.nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo*',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome completo é obrigatório';
                  }
                  if (!_viewModel.validarNomeCompleto(value)) {
                    return 'Digite nome e sobrenome';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // CPF
              TextFormField(
                controller: _viewModel.cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF*',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                  hintText: '000.000.000-00',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CPF é obrigatório';
                  }
                  if (!_viewModel.validarCPF(value)) {
                    return 'CPF inválido (11 dígitos)';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Data de Nascimento
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != _viewModel.dataNascimento) {
                    setState(() {
                      _viewModel.dataNascimento = picked;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data de Nascimento*',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _viewModel.dataNascimento != null
                            ? '${_viewModel.dataNascimento!.day.toString().padLeft(2, '0')}/'
                              '${_viewModel.dataNascimento!.month.toString().padLeft(2, '0')}/'
                              '${_viewModel.dataNascimento!.year}'
                            : 'Selecione uma data',
                        style: TextStyle(
                          color: _viewModel.dataNascimento != null 
                              ? Colors.black 
                              : Colors.grey,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              if (_viewModel.dataNascimento == null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 16),
                  child: Text(
                    'Data de nascimento é obrigatória',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _viewModel.emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail*',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-mail é obrigatório';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Senha
              TextFormField(
                controller: _viewModel.senhaController,
                obscureText: !_viewModel.senhaVisivel,
                decoration: InputDecoration(
                  labelText: 'Senha*',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _viewModel.senhaVisivel
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _viewModel.toggleSenhaVisivel();
                      });
                    },
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),

              // Validação visual da senha
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRegraSenha(
                      'Maiúscula (A-Z)',
                      _viewModel.validacoesSenha['maiuscula'] ?? false,
                    ),
                    _buildRegraSenha(
                      'Minúscula (a-z)',
                      _viewModel.validacoesSenha['minuscula'] ?? false,
                    ),
                    _buildRegraSenha(
                      'Número (0-9)',
                      _viewModel.validacoesSenha['numero'] ?? false,
                    ),
                    _buildRegraSenha(
                      'Caractere especial (!@#...)',
                      _viewModel.validacoesSenha['especial'] ?? false,
                    ),
                    _buildRegraSenha(
                      'Mínimo 8 caracteres',
                      _viewModel.validacoesSenha['tamanho'] ?? false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Confirmar Senha
              TextFormField(
                controller: _viewModel.confirmarSenhaController,
                obscureText: !_viewModel.confirmarSenhaVisivel,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha*',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _viewModel.confirmarSenhaVisivel
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _viewModel.toggleConfirmarSenhaVisivel();
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirmação de senha é obrigatória';
                  }
                  if (value != _viewModel.senhaController.text) {
                    return 'As senhas não conferem';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 24),

              // Botão Cadastrar
              ElevatedButton(
                onPressed: _viewModel.formularioValido && !_viewModel.loading
                    ? () async {
                        if (_formKey.currentState!.validate() && 
                            _viewModel.dataNascimento != null) {
                          final sucesso = await _viewModel.cadastrar();
                          if (sucesso && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cadastro realizado com sucesso!'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            await Future.delayed(const Duration(milliseconds: 500));
                            if (context.mounted) {
                              await AppRoutes.navigateToLogin();
                            }
                          } else if (_viewModel.erro != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_viewModel.erro!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else if (_viewModel.dataNascimento == null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Selecione uma data de nascimento'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                ),
                child: _viewModel.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Cadastrar',
                        style: TextStyle(fontSize: 16),
                      ),
              ),

              // Link para login
              TextButton(
                onPressed: () {
                  AppRoutes.navigateToLogin();
                },
                child: const Text('Já tem conta? Faça login'),
              ),

              // Mensagem de erro
              if (_viewModel.erro != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _viewModel.erro!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegraSenha(String texto, bool cumprida) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            cumprida ? Icons.check_circle : Icons.radio_button_unchecked,
            color: cumprida ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            texto,
            style: TextStyle(
              fontSize: 12,
              color: cumprida ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}