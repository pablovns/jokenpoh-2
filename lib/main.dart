import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
                color: Colors.black.withOpacity(0.12),
                blurRadius: elevation * 2,
                offset: Offset(0, elevation),
              )
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
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const SizedBox(height: 40),

            CircleContainer(
              size: 130,
              elevation: 2,
            ),

            const SizedBox(height: 16),

            Text(
              'Escolha do APP',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleContainer(
                  size: 80,
                  child: Image.asset('assets/images/pedra.png'),
                )
              ]
            ),
          ],
        ),
      ),
    );
  }
}
