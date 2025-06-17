import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quebragalho2/api_config.dart';

class ModalAdicionarTags extends StatefulWidget {
  final List<String> selectedTags;
  final Function(List<String>) onTagsSelected;

  const ModalAdicionarTags({
    Key? key,
    required this.selectedTags,
    required this.onTagsSelected,
  }) : super(key: key);

  @override
  State<ModalAdicionarTags> createState() => _ModalAdicionarTagsState();
}

class _ModalAdicionarTagsState extends State<ModalAdicionarTags> {
  List<Map<String, dynamic>> _availableTags = [];
  List<String> _selectedTags = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
    _loadTags();
  }

  Future<void> _loadTags() async {
    try {
      final response = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/tags'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _availableTags = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar tags: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Selecione as Tags',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableTags.map((tag) {
                    final isSelected = _selectedTags.contains(tag['nome']);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(tag['nome']),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tag['nome']);
                          } else {
                            _selectedTags.remove(tag['nome']);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  widget.onTagsSelected(_selectedTags);
                  Navigator.pop(context);
                },
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}