import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/models/professional.dart';
import 'package:flutter_quebragalho/services/profissional_service.dart';
import 'package:flutter_quebragalho/views/widgets/ProfessionalCardItem.dart';

class ProfessionalListScreen extends StatefulWidget {
  @override
  _ProfessionalListScreenState createState() => _ProfessionalListScreenState();
}

class _ProfessionalListScreenState extends State<ProfessionalListScreen> {
  late Future<List<Professional>> _professionals;
  final ProfissionalService _profissionalService = ProfissionalService();

  @override
  void initState() {
    super.initState();
    _professionals = _profissionalService.getProfessionals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profissionais')),
      body: FutureBuilder<List<Professional>>(
        future: _professionals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar profissionais'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum profissional encontrado'));
          } else {
            List<Professional> professionals = snapshot.data!;
            return ListView.builder(
              itemCount: professionals.length,
              itemBuilder: (context, index) {
                var professional = professionals[index];
                return ProfessionalCard(
                  imageUrl: professional.imageUrl,
                  name: professional.name,
                  tag: professional.tag,
                  price: professional.price,
                  isVerified: professional.isVerified,
                  onTap: () {
                    // Ação ao clicar no card do profissional
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
