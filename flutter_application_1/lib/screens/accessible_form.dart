import 'package:flutter/material.dart';
import '../widgets/accessible_button.dart';
import '../utils/accessibility_utils.dart';

class AccessibleFormScreen extends StatefulWidget {
  const AccessibleFormScreen({super.key});

  @override
  State<AccessibleFormScreen> createState() => _AccessibleFormScreenState();
}

class _AccessibleFormScreenState extends State<AccessibleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isLoading = false;
  double _fontSize = 16.0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simular procesamiento
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() => _isLoading = false);
        AccessibilityUtils.showAccessibleSnackBar(
          context, 
          'Formulario enviado correctamente',
        );
      }
    }
  }

  void _increaseFontSize() {
    setState(() {
      _fontSize += 2.0;
      if (_fontSize > 24.0) _fontSize = 24.0;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      _fontSize -= 2.0;
      if (_fontSize < 14.0) _fontSize = 14.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(  // QUITÉ EL 'const'
          header: true,    // CORREGIDO: 'header' en lugar de 'heading'
          child: const Text('Formulario Accesible'),
        ),
        actions: [
          // Botón para ajustar tamaño de fuente
          IconButton(
            onPressed: _increaseFontSize,
            icon: const Icon(Icons.zoom_in),
            tooltip: 'Aumentar tamaño de texto',
          ),
          IconButton(
            onPressed: _decreaseFontSize,
            icon: const Icon(Icons.zoom_out),
            tooltip: 'Disminuir tamaño de texto',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Semantics(
            container: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título semánticamente importante
                Semantics(  // QUITÉ EL 'const'
                  header: true,  // CORREGIDO: 'header' en lugar de 'heading'
                  child: const Text(
                    'Complete sus datos',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Campo de nombre
                Semantics(
                  textField: true,
                  label: 'Campo de nombre completo',
                  hint: 'Ingrese su nombre y apellido',
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre Completo',
                      hintText: 'Ingrese su nombre y apellido',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: TextStyle(fontSize: _fontSize),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su nombre';
                      }
                      return null;
                    },
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Campo de email
                Semantics(
                  textField: true,
                  label: 'Campo de correo electrónico',
                  hint: 'Ingrese su dirección de email',
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      hintText: 'ejemplo@correo.com',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: _fontSize),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Ingrese un email válido';
                      }
                      return null;
                    },
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Campo de teléfono
                Semantics(
                  textField: true,
                  label: 'Campo de número de teléfono',
                  hint: 'Ingrese su número de teléfono',
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                      hintText: '+1234567890',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: _fontSize),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su teléfono';
                      }
                      return null;
                    },
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Botón accesible personalizado
                AccessibleButton(
                  onPressed: _isLoading ? null : _submitForm,
                  text: _isLoading ? 'Enviando...' : 'Enviar Formulario',
                  icon: _isLoading ? Icons.hourglass_top : Icons.send,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: _fontSize,
                ),
                
                const SizedBox(height: 16),
                
                // Información de accesibilidad
                Semantics(
                  container: true,
                  label: 'Información de accesibilidad. Esta aplicación incluye características '
                         'para usuarios con discapacidades visuales y motoras.',
                  child: Card(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,  // CORREGIDO
                            child: Text(
                              'Características Accesibles:',
                              style: TextStyle(
                                fontSize: _fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildFeatureItem('✓ Tamaño de texto ajustable', _fontSize),
                          _buildFeatureItem('✓ Navegación por voz compatible', _fontSize),
                          _buildFeatureItem('✓ Alto contraste disponible', _fontSize),
                          _buildFeatureItem('✓ Etiquetas descriptivas', _fontSize),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
      // Botón flotante accesible
      floatingActionButton: Semantics(
        button: true,
        label: 'Limpiar formulario',
        child: FloatingActionButton(
          onPressed: () {
            _nameController.clear();
            _emailController.clear();
            _phoneController.clear();
            AccessibilityUtils.showAccessibleSnackBar(
              context, 
              'Formulario limpiado',
            );
          },
          tooltip: 'Limpiar formulario',
          backgroundColor: Colors.orange,
          child: const Icon(Icons.cleaning_services),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, double fontSize) {
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize - 2),
        ),
      ),
    );
  }
}