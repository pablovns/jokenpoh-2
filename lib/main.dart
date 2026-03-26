import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum Jogada { pedra, papel, tesoura }

enum ResultadoRodada { vitoria, derrota, empate }

class CircleContainer extends StatelessWidget {
  final Widget? child;
  final double? size;
  final double padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double elevation;
  final VoidCallback? onTap;

  const CircleContainer({
    super.key,
    this.child,
    this.size,
    this.padding = 12,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.elevation = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Colors.grey.shade200;

    Widget content = Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );

    if (size != null) {
      content = SizedBox(
        width: size,
        height: size,
        child: Center(child: content),
      );
    }

    return Material(
      color: Colors.transparent,
      elevation: elevation,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: borderWidth)
                : null,
            boxShadow: elevation > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: elevation * 2,
                      offset: Offset(0, elevation),
                    ),
                  ]
                : null,
          ),
          child: content,
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokenpoh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Pedra, Papel, Tesoura'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Random _random = Random();

  static const Map<Jogada, String> _imagensJogada = {
    Jogada.pedra: 'assets/images/pedra.png',
    Jogada.papel: 'assets/images/papel.png',
    Jogada.tesoura: 'assets/images/tesoura.png',
  };

  Jogada? _escolhaJogador;
  Jogada? _escolhaApp;
  ResultadoRodada? _resultado;

  bool get _rodadaFinalizada =>
      _escolhaJogador != null && _escolhaApp != null && _resultado != null;

  void _jogar(Jogada escolhaJogador) {
    final escolhas = Jogada.values;
    final escolhaApp = escolhas[_random.nextInt(escolhas.length)];

    ResultadoRodada resultado;

    if (escolhaJogador == escolhaApp) {
      resultado = ResultadoRodada.empate;
    } else if ((escolhaJogador == Jogada.pedra && escolhaApp == Jogada.tesoura) ||
        (escolhaJogador == Jogada.papel && escolhaApp == Jogada.pedra) ||
        (escolhaJogador == Jogada.tesoura && escolhaApp == Jogada.papel)) {
      resultado = ResultadoRodada.vitoria;
    } else {
      resultado = ResultadoRodada.derrota;
    }

    setState(() {
      _escolhaJogador = escolhaJogador;
      _escolhaApp = escolhaApp;
      _resultado = resultado;
    });
  }

  void _novaRodada() {
    setState(() {
      _escolhaJogador = null;
      _escolhaApp = null;
      _resultado = null;
    });
  }

  String _textoResultado() {
    switch (_resultado) {
      case ResultadoRodada.vitoria:
        return 'Voce venceu!';
      case ResultadoRodada.derrota:
        return 'Voce perdeu!';
      case ResultadoRodada.empate:
        return 'Empatou!';
      case null:
        return 'Escolha uma opcao para jogar';
    }
  }

  String _iconeResultado() {
    switch (_resultado) {
      case ResultadoRodada.vitoria:
        return 'assets/images/icons8-vitoria-48.png';
      case ResultadoRodada.derrota:
        return 'assets/images/icons8-perder-48.png';
      case ResultadoRodada.empate:
      case null:
        return 'assets/images/icons8-aperto-de-maos-100.png';
    }
  }

  String _imagemDaJogada(Jogada? jogada) {
    if (jogada == null) {
      return 'assets/images/padrao.png';
    }
    return _imagensJogada[jogada] ?? 'assets/images/padrao.png';
  }

  Widget _circuloEscolha({
    required String imagePath,
    double size = 104,
    double imageScale = 0.68,
    Color borderColor = const Color(0xFFA8A8A8),
    VoidCallback? onTap,
  }) {
    return CircleContainer(
      size: size,
      padding: 0,
      elevation: 0,
      backgroundColor: const Color(0xFFE5E5E5),
      borderColor: borderColor,
      borderWidth: 2,
      onTap: onTap,
      child: SizedBox(
        width: size * imageScale,
        height: size * imageScale,
        child: Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF3333),
        elevation: 0,
        titleSpacing: 20,
        title: const Text(
          'Pedra,Papel, Tesoura',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 22),
                _circuloEscolha(imagePath: _imagemDaJogada(_escolhaApp)),
                const SizedBox(height: 14),
                const Text(
                  'Escolha do APP',
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 90),
                if (!_rodadaFinalizada)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: Jogada.values.map((jogada) {
                      final bool selecionada = _escolhaJogador == jogada;

                      return _circuloEscolha(
                        size: 84,
                        imageScale: 0.66,
                        imagePath: _imagemDaJogada(jogada),
                        borderColor: selecionada
                            ? const Color(0xFFFF3333)
                            : const Color(0xFFA8A8A8),
                        onTap: () => _jogar(jogada),
                      );
                    }).toList(),
                  )
                else ...[
                  _circuloEscolha(imagePath: _imagemDaJogada(_escolhaJogador)),
                  const SizedBox(height: 12),
                  const Text(
                    'Sua Escolha',
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 104,
                    height: 104,
                    child: Image.asset(_iconeResultado(), fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _textoResultado(),
                    style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _novaRodada,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 34,
                        vertical: 10,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Jogar novamente'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
