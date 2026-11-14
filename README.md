# Laboratorio S11–S12: Aula Cupertino

Adaptación del laboratorio S7–S8 de gestión de alumnos con componentes Cupertino. El punto de entrada es lib/main.dart; las antiguas pantallas de lib/screens se conservan como referencia y no se usan.

Ejecutar: flutter pub get, seguido de flutter run. Verificar con flutter analyze y flutter test.

La aplicación incluye acceso de demostración, registro, búsqueda, edición y eliminación de alumnos con confirmación, perfil editable, fuentes e imágenes locales. Las notas van de 0 a 20 y se aprueba desde 11. El acceso acepta cualquier correo válido y contraseña de al menos seis caracteres; no hay autenticación real. Los datos viven en memoria y se restablecen al reiniciar.
