import 'package:flutter/material.dart';

void main() => runApp(const CreateLeagueApp());

class CreateLeagueApp extends StatelessWidget {
  const CreateLeagueApp();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const CreateLeagueScreen(),
        '/createleague': (context) => const CreateLeagueScreen(),
      },
    );
  }
}

class CreateLeagueScreen extends StatelessWidget {
  const CreateLeagueScreen();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: CreateLeagueForm(),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Create a Moolah Master League', style: Theme.of(context).textTheme.headline2),
      ),
    );
  }
}

class CreateLeagueForm extends StatefulWidget {
  const CreateLeagueForm();
  
  @override
  _CreateLeagueFormState createState() => _CreateLeagueFormState();
}

class _CreateLeagueFormState extends State<CreateLeagueForm> {
  final _leagueNameTextController = TextEditingController();
  final _leagueSizeTextController = TextEditingController();

  double _formProgress = 0;

  void _showWelcomeScreen() {
    Navigator.of(context).pushNamed('/welcome');
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _leagueNameTextController,
      _leagueSizeTextController,
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text('Create a League', style: Theme
              .of(context)
              .textTheme
              .headline4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _leagueNameTextController,
              decoration: const InputDecoration(hintText: 'League Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _leagueSizeTextController,
              decoration: const InputDecoration(hintText: 'Size'),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.disabled) ? null : Colors.green;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.disabled) ? null : Color(0xffd62839);
              }),
            ),
            onPressed: _formProgress == 1 ? _showWelcomeScreen : null,
            child: const Text('Create a League'),
          ),
        ],
      ),
    );
  }
}
class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({
    required this.value,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }
}

