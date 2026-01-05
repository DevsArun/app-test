import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _input = '';
  String _operator = '';
  double _firstOperand = 0;
  bool _shouldResetDisplay = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _clearAll();
      } else if (value == '=') {
        _calculateResult();
      } else if (_isOperator(value)) {
        _handleOperator(value);
      } else {
        _handleNumber(value);
      }
    });
  }

  void _clearAll() {
    _display = '0';
    _input = '';
    _operator = '';
    _firstOperand = 0;
    _shouldResetDisplay = false;
  }

  void _handleNumber(String value) {
    if (_shouldResetDisplay) {
      _display = value;
      _input = value;
      _shouldResetDisplay = false;
    } else {
      if (_display == '0' && value != '.') {
        _display = value;
        _input = value;
      } else if (value == '.' && _display.contains('.')) {
        return;
      } else {
        _display += value;
        _input += value;
      }
    }
  }

  void _handleOperator(String operator) {
    if (_input.isEmpty && _operator.isEmpty) {
      return;
    }

    if (_operator.isNotEmpty && _input.isNotEmpty) {
      _calculateResult();
    }

    _firstOperand = double.tryParse(_display) ?? 0;
    _operator = operator;
    _shouldResetDisplay = true;
    _input = '';
  }

  void _calculateResult() {
    if (_operator.isEmpty || _input.isEmpty) {
      return;
    }

    double secondOperand = double.tryParse(_display) ?? 0;
    double result = 0;

    switch (_operator) {
      case '+':
        result = _firstOperand + secondOperand;
        break;
      case '−':
        result = _firstOperand - secondOperand;
        break;
      case '×':
        result = _firstOperand * secondOperand;
        break;
      case '÷':
        if (secondOperand == 0) {
          _display = 'Error';
          _operator = '';
          _input = '';
          _shouldResetDisplay = true;
          return;
        }
        result = _firstOperand / secondOperand;
        break;
    }

    _display = _formatResult(result);
    _operator = '';
    _input = '';
    _shouldResetDisplay = true;
  }

  String _formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    }
    return result.toString();
  }

  bool _isOperator(String value) {
    return value == '+' || value == '−' || value == '×' || value == '÷';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildDisplay(),
          const Divider(height: 1, color: Colors.grey),
          Expanded(
            child: _buildButtonGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplay() {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.centerRight,
      child: Text(
        _display,
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildButtonGrid() {
    final List<String> buttons = [
      '7', '8', '9', '÷',
      '4', '5', '6', '×',
      '1', '2', '3', '−',
      'C', '0', '.', '+',
      '=',
    ];

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 16,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                return _buildButton(buttons[index]);
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: _buildButton('='),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    Color buttonColor;
    Color textColor = Colors.white;

    if (text == 'C') {
      buttonColor = Colors.red[700]!;
    } else if (_isOperator(text) || text == '=') {
      buttonColor = Colors.orange[700]!;
    } else {
      buttonColor = Colors.grey[850]!;
    }

    return ElevatedButton(
      onPressed: () => _onButtonPressed(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(24),
        elevation: 2,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
