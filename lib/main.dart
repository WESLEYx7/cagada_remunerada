import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200], // Fundo mais leve para o app
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Verifica se a tela é pequena ou grande
              bool isMobile = constraints.maxWidth < 600;

              return Container(
                width: isMobile
                    ? constraints.maxWidth * 0.8
                    : constraints.maxWidth * 0.4, // Responsivo
                height: isMobile
                    ? constraints.maxHeight * 0.5
                    : constraints.maxHeight * 0.6, // Responsivo
                decoration: BoxDecoration(
                  color: Colors.blue[400], // Cor de fundo alterada
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Título estilizado
                    Text(
                      'Cagada Remunerada',
                      style: TextStyle(
                        fontSize:
                            isMobile ? 20 : 28, // Tamanho do texto responsivo
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Campo de texto 1 - Salário
                    SalarioWidget(),
                    SizedBox(height: 20), // Espaço entre os campos

                    // Campo de texto 2 - Tempo
                    TempoWidget(),
                    SizedBox(height: 20), // Espaço entre os campos

                    // Campo de texto 3 - Quantidade
                    QuantidadeWidget(),
                    SizedBox(height: 20),

                    // Botão calcular estilizado
                    BotaoCalcular(isMobile: isMobile),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

TextEditingController _controllerSalario = TextEditingController();
TextEditingController _controllerQuantidade = TextEditingController();
TextEditingController _controllerTempoCagando = TextEditingController();

class BotaoCalcular extends StatefulWidget {
  const BotaoCalcular({
    super.key,
    required this.isMobile,
  });

  final bool isMobile;

  @override
  State<BotaoCalcular> createState() => _BotaoCalcularState();
}

class _BotaoCalcularState extends State<BotaoCalcular> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange[400], // Cor do botão
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(
          vertical: widget.isMobile ? 15 : 18,
          horizontal: widget.isMobile ? 20 : 25,
        ),
      ),
      icon: Icon(Icons.calculate, color: Colors.white),
      label: TextWidget(
          nome: 'Calcular', cor: Colors.white, isMobile: widget.isMobile),
      onPressed: () {
        try {
          // Verificação dos campos antes de fazer as conversões
          if (_controllerSalario.text.isEmpty ||
              _controllerQuantidade.text.isEmpty ||
              _controllerTempoCagando.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text('Por favor, preencha todos os campos.'),
              ),
            );
            return;
          }

          // Conversão para números
          String salarioInput = _controllerSalario.text.replaceAll(',', '.');
          double salario = double.parse(salarioInput);
          int quantidadeSemana = int.parse(_controllerQuantidade.text);
          double tempoCagando = double.parse(_controllerTempoCagando.text);

          // Validação se os números são válidos
          if (salario <= 0 || quantidadeSemana <= 0 || tempoCagando <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text('Por favor, insira valores positivos.'),
              ),
            );
            return;
          }

          // Cálculo
          double calculoCagado = (salario / 30 / 8 / 60) * tempoCagando;
          double respostaCagada = calculoCagado * quantidadeSemana * 4.3;

          // Exibe o resultado
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: TextWidget(
                    nome: 'Resposta Cagada',
                    cor: const Color.fromARGB(255, 66, 165, 245),
                    isMobile: widget.isMobile),
                content: TextWidget(
                    nome:
                        'Você ganha R\$${respostaCagada.toStringAsFixed(2).replaceAll('.', ',')} por mês apenas cagando!',
                    cor: Colors.black,
                    isMobile: widget.isMobile),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Voltar',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 167, 38)),
                    ),
                  ),
                ],
              );
            },
          );
        } catch (e) {
          // Caso algum valor seja inválido (ex: não numérico)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Os dados inseridos não são válidos.'),
            ),
          );
        }
      },
    );
  }
}

class TextWidget extends StatelessWidget {
  final String nome;
  final Color cor;
  final bool isMobile;

  const TextWidget({
    required this.nome,
    required this.cor,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      nome,
      style: TextStyle(
        fontSize: isMobile ? 16 : 20, // Responsivo
        fontWeight: FontWeight.bold,
        color: cor,
      ),
    );
  }
}

// ----------------------------------------

class QuantidadeWidget extends StatelessWidget {
  const QuantidadeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _controllerQuantidade,
        keyboardType: TextInputType.number, // Define o tipo como numérico
        decoration: InputDecoration(
          hintText: 'Quantas vezes na semana',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------

class TempoWidget extends StatelessWidget {
  const TempoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _controllerTempoCagando,
        keyboardType: TextInputType.number, // Define o tipo como numérico
        decoration: InputDecoration(
          hintText: 'Tempo cagando (em minutos)',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------

class SalarioWidget extends StatelessWidget {
  const SalarioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _controllerSalario,
        keyboardType: TextInputType.number, // Define o tipo como numérico
        decoration: InputDecoration(
          hintText: 'Salário (em reais)',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
        ),
      ),
    );
  }
}
