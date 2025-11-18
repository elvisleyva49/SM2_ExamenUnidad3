import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

// MOCK SIMULADO DEL SERVICE PARA NOTICIAS
class MockNoticiasService {
  static bool retornarExitoso = true;
  static bool fallarSubidaImagen = false;
  
  static Future<bool> crearNoticia({
    required String titulo,
    required String textoCorto,
    required String descripcion,
    String? imagenUrl,
    String? enlaceExterno,
    required String autorId,
    required String autorNombre,
  }) async {
    if (!retornarExitoso) return false;
    
    // Simulamos validaciones básicas
    if (titulo.isEmpty || textoCorto.isEmpty || descripcion.isEmpty) {
      return false;
    }
    
    return true;
  }
  
  static Future<String?> subirImagen(File imagen) async {
    if (fallarSubidaImagen) return null;
    return "https://ejemplo.com/imagen.jpg";
  }
}

// VIEWMODEL DE PRUEBA PARA NOTICIAS
enum NoticiaState { idle, loading, success, error }

class NoticiasViewModelMock {
  NoticiaState state = NoticiaState.idle;
  String errorMessage = '';
  bool isLoading = false;

  Future<bool> crearNoticia({
    required String titulo,
    required String textoCorto,
    required String descripcion,
    File? imagenFile,
    String? enlaceExterno,
  }) async {
    // Validación de campos vacíos
    if (titulo.isEmpty || textoCorto.isEmpty || descripcion.isEmpty) {
      state = NoticiaState.error;
      errorMessage = 'Los campos obligatorios no pueden estar vacíos';
      isLoading = false;
      return false;
    }

    state = NoticiaState.loading;
    isLoading = true;

    try {
      String? imagenUrl;
      
      // Simular subida de imagen si existe
      if (imagenFile != null) {
        imagenUrl = await MockNoticiasService.subirImagen(imagenFile);
        if (imagenUrl == null) {
          state = NoticiaState.error;
          errorMessage = 'Error al subir la imagen';
          isLoading = false;
          return false;
        }
      }

      // Crear la noticia
      final success = await MockNoticiasService.crearNoticia(
        titulo: titulo,
        textoCorto: textoCorto,
        descripcion: descripcion,
        imagenUrl: imagenUrl,
        enlaceExterno: enlaceExterno,
        autorId: "test_autor_id",
        autorNombre: "Test Autor",
      );

      if (success) {
        state = NoticiaState.success;
        errorMessage = '';
      } else {
        state = NoticiaState.error;
        errorMessage = 'Error al crear la noticia';
      }

      isLoading = false;
      return success;
    } catch (e) {
      state = NoticiaState.error;
      errorMessage = 'Error inesperado: $e';
      isLoading = false;
      return false;
    }
  }
}

void main() {
  group('Pruebas unitarias del NoticiasViewModel', () {
    late NoticiasViewModelMock viewModel;

    setUp(() {
      viewModel = NoticiasViewModelMock();
      // Resetear mocks para cada prueba
      MockNoticiasService.retornarExitoso = true;
      MockNoticiasService.fallarSubidaImagen = false;
    });

    // ------------------------------------------------------------
    // 1. CREACIÓN EXITOSA DE NOTICIA (datos validos)
    // ------------------------------------------------------------
    test('Crear noticia con datos válidos debe ser exitoso', () async {
      final resultado = await viewModel.crearNoticia(
        titulo: "Nueva Noticia de Prueba",
        textoCorto: "Resumen de la noticia para pruebas",
        descripcion: "Esta es la descripción completa de la noticia de prueba que contiene toda la información necesaria.",
        enlaceExterno: "https://ejemplo.com/noticia",
      );

      expect(resultado, true);
      expect(viewModel.state, NoticiaState.success);
      expect(viewModel.errorMessage, '');
      expect(viewModel.isLoading, false);
    });

    // ------------------------------------------------------------
    // 2. CREACIÓN FALLIDA (campos obligatorios vacíos)
    // ------------------------------------------------------------
    test('Crear noticia con campos vacíos debe fallar', () async {
      final resultado = await viewModel.crearNoticia(
        titulo: "",
        textoCorto: "",
        descripcion: "",
      );

      expect(resultado, false);
      expect(viewModel.state, NoticiaState.error);
      expect(viewModel.errorMessage, 'Los campos obligatorios no pueden estar vacíos');
      expect(viewModel.isLoading, false);
    });

    // ------------------------------------------------------------
    // 3. ERROR EN SUBIDA DE IMAGEN
    // ------------------------------------------------------------
    test('Error en subida de imagen debe manejar el fallo correctamente', () async {
      // Configurar mock para que falle la subida de imagen
      MockNoticiasService.fallarSubidaImagen = true;
      
      // Crear un archivo mock
      final archivoMock = File('test_image.jpg');
      
      final resultado = await viewModel.crearNoticia(
        titulo: "Noticia con Imagen",
        textoCorto: "Noticia que incluye imagen",
        descripcion: "Esta noticia debería fallar al subir la imagen",
        imagenFile: archivoMock,
      );

      expect(resultado, false);
      expect(viewModel.state, NoticiaState.error);
      expect(viewModel.errorMessage, 'Error al subir la imagen');
      expect(viewModel.isLoading, false);
    });
  });
}
