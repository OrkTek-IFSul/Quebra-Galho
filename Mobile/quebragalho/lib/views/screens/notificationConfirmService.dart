import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/screens/pageViewCliente.dart';

/// StatefulWidget que exibe a tela de confirmação de serviço com animações.
class NotificationConfirmService extends StatefulWidget {
  const NotificationConfirmService({super.key});

  @override
  State<NotificationConfirmService> createState() =>
      _NotificationConfirmServiceState();
}

/// Estado associado à tela de confirmação de serviço.
/// Utiliza o TickerProviderStateMixin para animações.
class _NotificationConfirmServiceState extends State<NotificationConfirmService>
    with TickerProviderStateMixin {
  // Controlador para a animação do fundo roxo (expansão de escala).
  late AnimationController _backgroundController;
  // Controlador para a animação do ícone de "check" (escala do ícone).
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();

    // Inicializa o controlador do fundo roxo com duração de 300 milissegundos.
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Inicializa o controlador do ícone com duração de 150 milissegundos.
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    // Inicia a animação do fundo roxo.
    _backgroundController.forward().then((_) {
      // Após a animação do fundo roxo, inicia a animação do ícone.
      _iconController.forward();
    });
  }

  @override
  void dispose() {
    // Libera os recursos dos controladores de animação.
    _backgroundController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Corpo principal da tela centralizado.
      body: Center(
        // Padding para adicionar espaço nas laterais baseado em 10% da largura da tela.
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize
                    .min, // A coluna ocupa apenas o espaço necessário para seu conteúdo.
            crossAxisAlignment:
                CrossAxisAlignment
                    .start, // Alinha os elementos da coluna à esquerda.
            children: [
              // Animação de escala para o fundo roxo com ícone.
              ScaleTransition(
                scale:
                    _backgroundController, // Controla a escala do fundo roxo.
                child: Container(
                  height: 80,
                  width: 80,
                  // Define a aparência do fundo: cor púrpura e formato circular.
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    // Animação de escala para o ícone de "check".
                    child: ScaleTransition(
                      scale: _iconController, // Controla a escala do ícone.
                      child: Icon(
                        Icons.check, // Ícone de confirmação.
                        color: Colors.white, // Ícone na cor branca.
                        size: 40, // Tamanho do ícone.
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24), // Espaço vertical após a animação.
              // Texto de confirmação do serviço.
              Text(
                'Serviço \nconfirmado!', // Mensagem de confirmação com quebra de linha.
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30, // Tamanho do texto.
                  color: Colors.purple, // Texto na cor púrpura.
                  fontWeight: FontWeight.bold, // Texto em negrito.
                ),
              ),
              SizedBox(height: 16), // Espaçamento vertical.
              // Rótulo indicando data agendada.
              Text(
                'Data agendada:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4), // Pequeno espaçamento vertical.
              // Exibição da data e hora agendadas.
              Text(
                '14/08 - 18:00',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16), // Espaçamento vertical.
              // Texto explicativo sobre o agendamento.
              Text(
                'Seu agendamento foi confirmado. Agora só esperar o prestador executar o serviço no horário combinado.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16), // Espaçamento vertical.
              // Texto informativo sobre a disponibilidade da avaliação.
              Text(
                'A avaliação só estará disponível após o horário de execução que foi solicitado pelo app.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),

      // Botão fixado na parte inferior da tela (bottomNavigationBar).
      bottomNavigationBar: SizedBox(
        height: 60, // Altura do botão.
        child: ElevatedButton(
          onPressed: () {
            // Ao pressionar, retorna à tela anterior (início).
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PageViewCore()),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple, // Cor de fundo do botão.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Remove cantos arredondados.
            ),
          ),
          child: Text(
            'Voltar para início', // Rótulo do botão.
            style: TextStyle(
              fontSize: 18, // Tamanho da fonte.
              color: Colors.white, // Cor do texto.
              fontWeight: FontWeight.bold, // Negrito para destaque.
            ),
          ),
        ),
      ),
    );
  }
}
