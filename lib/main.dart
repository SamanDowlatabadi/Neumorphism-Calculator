
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter/cupertino.dart' hide BoxDecoration, BoxShadow;
import 'package:math_expressions/math_expressions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:neumorphism_calculator/app_bar.dart';
import 'package:neumorphism_calculator/theme_data.dart';

const double a = 0;
const double b = 0;

String userQuestion = '';
String userAnswer = '';

double fontSizeUserQuestion = a;
double fontSizeUserAnswer = b;

bool percentActivator = false;
bool equalAsLastState = false;
bool parenthesesOpen = false;
bool addAutoParentheses = false;
bool themeChanger = true;

void main() {
  runApp(const MyApp());
}

//MyApp
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData(themeMode: _themeMode),
      darkTheme: themeData(themeMode: _themeMode),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      home: const CalculatorNeuApp(),
    );
  }
}

// CalculatorNeuApp
class CalculatorNeuApp extends StatefulWidget {
  const CalculatorNeuApp({super.key});

  @override
  CalculatorNeuAppState createState() => CalculatorNeuAppState();
}

class CalculatorNeuAppState extends State<CalculatorNeuApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: myAppBar(
          context: context,
          themeChangerModeButton: const ThemeChangerButton(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Theme.of(context).primaryColor,
                    // color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: -const Offset(4, 4),
                        blurRadius: 4,
                        color: Theme.of(context).primaryColorDark,
                        inset: true,
                      ),
                      BoxShadow(
                        offset: const Offset(4, 4),
                        blurRadius: 4,
                        color: Theme.of(context).cardColor,
                        inset: true,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          userQuestion,
                          style: TextStyle(
                            color: Theme.of(context).shadowColor,
                            fontSize: fontSizeUserQuestion,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        Text(
                          '=$userAnswer',
                          style: TextStyle(
                            color: Theme.of(context).shadowColor,
                            fontSize: fontSizeUserAnswer,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 'x!'
                        FunctionButton(
                          title: 'x!',
                          operation: () {
                            setState(() {
                              if (_isNumber(
                                      userQuestion[userQuestion.length - 1]) ||
                                  equalAsLastState) {
                                if (equalAsLastState) {
                                  userQuestion = userAnswer;
                                  equalAsLastState = false;
                                }
                                textStyleChangerFunc(false);
                                userQuestion += '!';
                                equalPressed();
                              }
                            });
                          },
                        ),
                        // xY
                        FunctionButton(
                          title: 'x${String.fromCharCode(0x02b8)}',
                          operation: () {
                            setState(() {
                              textStyleChangerFunc(false);
                              if (_isNumber(
                                      userQuestion[userQuestion.length - 1]) ||
                                  equalAsLastState) {
                                if (equalAsLastState) {
                                  userQuestion = userAnswer;
                                  equalAsLastState = false;
                                }
                                userQuestion += '^';
                              } else if (_isOperator(
                                  userQuestion[userQuestion.length - 1])) {
                                userQuestion = userQuestion.substring(
                                    0, userQuestion.length - 1);
                                userQuestion += '^';
                              }
                            });
                          },
                        ),
                        // '('
                        FunctionButton(
                          title: '(',
                          operation: () {
                            setState(() {
                              if (_isOperator(
                                      userQuestion[userQuestion.length - 1]) ||
                                  userQuestion.isEmpty) {
                                userQuestion += '(';
                                parenthesesOpen = true;
                              }
                              textStyleChangerFunc(false);
                            });
                          },
                        ),
                        // ')'
                        FunctionButton(
                          title: ')',
                          operation: () {
                            setState(() {
                              if (parenthesesOpen) {
                                userQuestion += ')';
                                equalPressed();
                                parenthesesOpen = false;
                                textStyleChangerFunc(false);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 'C'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          title: 'C',
                          textColor: Theme.of(context).primaryColorLight,
                          operation: () {
                            setState(() {
                              userQuestion = '';
                              userAnswer = '';
                              textStyleChangerFunc(false);
                              equalAsLastState = false;
                              parenthesesOpen = false;
                            });
                          },
                        ),
                        // 'DEL'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          icon: Icons.backspace_outlined,
                          iconColor: Theme.of(context).primaryColorLight,
                          operation: () {
                            setState(() {
                              textStyleChangerFunc(false);
                              if (userQuestion.isNotEmpty) {
                                if (userQuestion.endsWith(')')) {
                                  parenthesesOpen = true;
                                }
                                userQuestion = userQuestion.substring(
                                    0, userQuestion.length - 1);
                                if (userQuestion.isEmpty) {
                                  userAnswer = '';
                                } else if (_isOperator(
                                    userQuestion[userQuestion.length - 1])) {
                                  userAnswer = '';
                                } else if (userQuestion.endsWith('(')) {
                                  userQuestion = userQuestion.substring(
                                      0, userQuestion.length - 1);
                                  parenthesesOpen = false;
                                  addAutoParentheses = false;
                                  userAnswer = '';
                                } else {
                                  if (userQuestion.isNotEmpty) {
                                    userAnswer = userQuestion;
                                    if (parenthesesOpen) {
                                      addAutoParentheses = true;
                                    }
                                    equalPressed();
                                  }
                                }
                              }
                            });
                          },
                        ),
                        // '%'
                        RoundedButton(
                          title: '%',
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryColorLight,
                          operation: () {
                            setState(() {
                              if (_isNumber(
                                  userQuestion[userQuestion.length - 1])) {
                                percentActivator = true;
                                userQuestion = userAnswer;
                                textStyleChangerFunc(true);
                                equalPressed();
                              }
                            });
                          },
                        ),
                        // '/'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          icon: CupertinoIcons.divide,
                          iconColor: Theme.of(context).primaryColorLight,
                          operation:
                              operatorButtons(String.fromCharCode(0x00F7)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // '7'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).shadowColor,
                          title: '7',
                          operation: digitButtons('7'),
                        ),
                        // '8'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).shadowColor,
                          title: '8',
                          operation: digitButtons('8'),
                        ),
                        // '9'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).shadowColor,
                          title: '9',
                          operation: digitButtons('9'),
                        ),
                        // 'x'
                        RoundedButton(
                          title: 'x',
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryColorLight,
                          operation: operatorButtons('x'),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // '4'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).shadowColor,
                          title: '4',
                          operation: digitButtons('4'),
                        ),
                        // '5'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).shadowColor,
                          title: '5',
                          operation: digitButtons('5'),
                        ),
                        // '6'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).shadowColor,
                          title: '6',
                          operation: digitButtons('6'),
                        ),
                        RoundedButton(
                          title: '-',
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryColorLight,
                          operation: operatorButtons('-'),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // '1'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).shadowColor,
                          title: '1',
                          operation: digitButtons('1'),
                        ),
                        // '2'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).shadowColor,
                          title: '2',
                          operation: digitButtons('2'),
                        ),
                        // '3'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).shadowColor,
                          title: '3',
                          operation: digitButtons('3'),
                        ),
                        // '+'
                        RoundedButton(
                          title: '+',
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryColorLight,
                          operation: operatorButtons('+'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // '0'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).shadowColor,
                          title: '0',
                          operation: digitButtons('0'),
                        ),
                        // '.'
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).shadowColor,
                          title: '.',
                          operation: () {
                            setState(() {
                              if (_isNumber(
                                  userQuestion[userQuestion.length - 1])) {
                                if (equalAsLastState) {
                                  userQuestion = '0.';
                                  userAnswer = '0';
                                  equalAsLastState = false;
                                } else {
                                  userQuestion += '.';
                                }
                                if (parenthesesOpen) {
                                  addAutoParentheses = true;
                                }
                                textStyleChangerFunc(false);
                              } else if (userQuestion.endsWith('.')) {
                                userAnswer = userQuestion;
                              } else if (userQuestion.isEmpty) {
                                userQuestion = '0.';
                                userAnswer = '0';
                                equalAsLastState = false;
                              }
                              equalPressed();
                            });
                          },
                        ),
                        // '+/-
                        RoundedButton(
                          buttonBackGroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).shadowColor,
                          title: String.fromCharCode(0x00B1),
                          operation: () {
                            setState(() {
                              if (!userQuestion.endsWith('--')) {
                                if (userQuestion.isEmpty ||
                                    userQuestion.endsWith('(')) {
                                  userQuestion += '-';
                                } else if (_isOperator(
                                    userQuestion[userQuestion.length - 1])) {
                                  userQuestion += '-';
                                }
                                textStyleChangerFunc(false);
                              }
                            });
                          },
                        ),
                        // '='
                        RoundedButton(
                          buttonBackGroundColor:
                              Theme.of(context).primaryColorLight,
                          title: '=',
                          textColor: Theme.of(context).primaryColor,
                          operation: () {
                            setState(() {
                              if (userQuestion.isNotEmpty) {
                                textStyleChangerFunc(true);
                                equalAsLastState = true;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void textStyleChangerFunc(bool fontChanger) {
    if (fontChanger) {
      fontSizeUserQuestion = MediaQuery.of(context).size.height * 0.05;
      fontSizeUserAnswer = MediaQuery.of(context).size.height * 0.1;
    } else {
      fontSizeUserQuestion = MediaQuery.of(context).size.height * 0.1;
      fontSizeUserAnswer = MediaQuery.of(context).size.height * 0.05;
    }
  }

  Function digitButtons(String title) {
    return () {
      setState(() {
        if (userQuestion.endsWith('!')) {
          userQuestion += 'x';
        } else if (equalAsLastState) {
          userQuestion = '';
          equalAsLastState = false;
        }
        addAutoParentheses = parenthesesOpen ? true : false;
        userQuestion += title;
        textStyleChangerFunc(false);
        equalPressed();
      });
    };
  }

  Function operatorButtons(String title) {
    return () {
      setState(() {
        if (userQuestion.isNotEmpty) {
          if (userQuestion.endsWith('!')) {
            userQuestion += title;
          } else if (_isNumber(userQuestion[userQuestion.length - 1]) ||
              userQuestion.endsWith(')') ||
              equalAsLastState) {
            if (equalAsLastState) {
              userQuestion = userAnswer;
              equalAsLastState = false;
            }
            userQuestion += title;
          } else if (_isOperator(userQuestion[userQuestion.length - 1])) {
            userQuestion = userQuestion.substring(0, userQuestion.length - 1);
            userQuestion += title;
          } else if (userQuestion.endsWith('.')) {
            userQuestion += title;
          }
          textStyleChangerFunc(false);
        }
      });
    };
  }
}

// NeuContainer
class NeuContainer extends StatefulWidget {
  final bool themeChanger;
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final Function operation;
  final Color buttonBackGroundColor;

  const NeuContainer({
    super.key,
    this.themeChanger = false,
    required this.child,
    required this.borderRadius,
    required this.padding,
    required this.operation,
    required this.buttonBackGroundColor,
  });

  @override
  NeuContainerState createState() => NeuContainerState();
}

class NeuContainerState extends State<NeuContainer> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
      widget.operation();
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.themeChanger;
    return Listener(
      onPointerUp: _onPointerUp,
      onPointerDown: _onPointerDown,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.buttonBackGroundColor,
          borderRadius: widget.borderRadius,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).cardColor,
              offset: const Offset(2, 2),
              blurRadius: 2,
              inset: _isPressed,
            ),
            BoxShadow(
              color: Theme.of(context).primaryColorDark,
              offset: -const Offset(2, 2),
              blurRadius: 2,
              inset: _isPressed,
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

// TextWidget
class TextWidget extends StatelessWidget {
  final String text;
  final int maxLines;
  final double fontSize;

  const TextWidget({
    super.key,
    required this.text,
    required this.maxLines,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      maxLines: maxLines,
      textAlign: TextAlign.end,
      textDirection: TextDirection.ltr,
      style: TextStyle(
        fontSize: fontSize,
        color: Theme.of(context).shadowColor,
        fontWeight: FontWeight.w100,
      ),
    );
  }
}

// ThemeChangerButton
class ThemeChangerButton extends StatefulWidget {
  const ThemeChangerButton({
    super.key,
  });

  @override
  State<ThemeChangerButton> createState() => _ThemeChangerButtonState();
}

class _ThemeChangerButtonState extends State<ThemeChangerButton> {
  @override
  Widget build(BuildContext context) {
    return NeuContainer(
      buttonBackGroundColor: Theme.of(context).primaryColor,
      themeChanger: themeChanger,
      operation: () {
        if (themeChanger) {
          MyApp.of(context).changeTheme(ThemeMode.dark);
        } else {
          MyApp.of(context).changeTheme(ThemeMode.light);
        }
        themeChanger = !themeChanger;
      },
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              CupertinoIcons.sun_min_fill,
              color: Theme.of(context).focusColor,
            ),
            Icon(
              CupertinoIcons.moon_fill,
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}

// FunctionButton
class FunctionButton extends StatefulWidget {
  final String title;
  final Function operation;

  const FunctionButton({
    super.key,
    required this.title,
    required this.operation,
  });

  @override
  State<FunctionButton> createState() => _FunctionButtonState();
}

class _FunctionButtonState extends State<FunctionButton> {
  double padding = 17;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: NeuContainer(
        buttonBackGroundColor: Theme.of(context).primaryColor,
        operation: widget.operation,
        themeChanger: themeChanger,
        borderRadius: BorderRadius.circular(50),
        padding:
            EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.125,
          child: Center(
            child: Text(
              widget.title,
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: 'Digital',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//RoundedButton
class RoundedButton extends StatefulWidget {
  final String? title;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final Color buttonBackGroundColor;
  final Function operation;

  const RoundedButton({
    super.key,
    required this.buttonBackGroundColor,
    required this.operation,
    this.title,
    this.icon,
    this.iconColor,
    this.textColor,
  });

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  double padding = 17;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: NeuContainer(
        buttonBackGroundColor: widget.title == '='
            ? Theme.of(context).primaryColorLight
            : widget.buttonBackGroundColor,
        operation: widget.operation,
        themeChanger: themeChanger,
        borderRadius: BorderRadius.circular(20),
        padding: EdgeInsets.all(padding),
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.125,
          height: padding *2,
          child: widget.title != null
              ? Center(
                  child: Text(
                    widget.title!,
                    style: TextStyle(
                      fontWeight: widget.title == '='
                          ? FontWeight.w900
                          : FontWeight.w100,
                      color: widget.title == '='
                          ? Theme.of(context).primaryColor
                          : widget.textColor,
                      fontSize: 30,
                    ),
                  ),
                )
              : Center(
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: 30,
                  ),
                ),
        ),
      ),
    );
  }
}

void equalPressed() {
  String finalQuestion = userQuestion;
  if (addAutoParentheses) {
    finalQuestion += ')';
    addAutoParentheses = false;
  }
  finalQuestion = finalQuestion.replaceAll('x', '*');
  finalQuestion = finalQuestion.replaceAll(String.fromCharCode(0x00F7), '/');
  Parser p = Parser();
  try {
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double evalDouble = exp.evaluate(EvaluationType.REAL, cm);
    if (percentActivator) {
      evalDouble = evalDouble * 0.01;
      percentActivator = false;
    }
    if (evalDouble % 1 != 0) {
      userAnswer = '$evalDouble';
    } else {
      userAnswer = '${evalDouble.toInt()}';
    }
  } catch (e) {
    userAnswer = 'ERROR!';
  }
}

bool _isOperator(String lastChar) {
  if (lastChar == 'x' ||
      lastChar == '+' ||
      lastChar == '-' ||
      lastChar == '^' ||
      lastChar == String.fromCharCode(0x00F7)) {
    return true;
  }
  return false;
}

bool _isNumber(String lastChar) {
  if (lastChar == '0' ||
      lastChar == '1' ||
      lastChar == '2' ||
      lastChar == '3' ||
      lastChar == '4' ||
      lastChar == '5' ||
      lastChar == '6' ||
      lastChar == '7' ||
      lastChar == '8' ||
      lastChar == '9') {
    return true;
  }
  return false;
}
