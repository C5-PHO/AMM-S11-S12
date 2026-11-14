import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

Future<void> login(WidgetTester t) async {
  await t.pumpWidget(const MyApp());
  await t.enterText(find.byKey(const Key('login-email')), 'demo@aula.pe');
  await t.enterText(find.byKey(const Key('login-password')), 'demo123');
  await t.tap(find.text('Ingresar'));
  await t.pumpAndSettle();
}

void main() {
  testWidgets('registra, busca y elimina con confirmación', (t) async {
    await login(t);
    await t.tap(find.text('Registrar alumno'));
    await t.pumpAndSettle();
    await t.enterText(find.byKey(const Key('student-name')), 'Lucía');
    await t.enterText(find.byKey(const Key('student-surname')), 'Pérez');
    await t.enterText(find.byKey(const Key('student-grade')), '21');
    await t.tap(find.text('Guardar'));
    await t.pumpAndSettle();
    expect(
      find.text('Ingresa nombre, apellido y una nota entre 0 y 20'),
      findsOneWidget,
    );
    await t.enterText(find.byKey(const Key('student-grade')), '10,5');
    await t.tap(find.text('Guardar'));
    await t.pumpAndSettle();
    expect(find.text('5 alumnos en tu aula'), findsOneWidget);
    await t.tap(find.text('Listar alumnos'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(CupertinoSearchTextField), 'Lucía');
    await t.pumpAndSettle();
    expect(find.text('Lucía Pérez'), findsOneWidget);
    expect(find.textContaining('Desaprobado'), findsOneWidget);
    await t.tap(find.text('Lucía Pérez'));
    await t.pumpAndSettle();
    await t.tap(find.text('Eliminar'));
    await t.pumpAndSettle();
    await t.tap(find.text('Cancelar'));
    await t.pumpAndSettle();
    expect(find.text('Lucía Pérez'), findsOneWidget);
    await t.tap(find.text('Lucía Pérez'));
    await t.pumpAndSettle();
    await t.tap(find.text('Eliminar'));
    await t.pumpAndSettle();
    await t.tap(find.text('Eliminar'));
    await t.pumpAndSettle();
    expect(find.text('No se encontraron alumnos'), findsOneWidget);
  });
  testWidgets('edita perfil y cierra sesión sin historial', (t) async {
    await login(t);
    await t.tap(find.text('Perfil'));
    await t.pumpAndSettle();
    await t.tap(find.text('Editar perfil'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(CupertinoTextField).at(0), 'Elena Torres');
    await t.tap(find.text('Guardar'));
    await t.pumpAndSettle();
    expect(find.text('Elena Torres'), findsOneWidget);
    await t.pageBack();
    await t.pumpAndSettle();
    expect(find.text('Hola, Elena'), findsOneWidget);
    await t.tap(find.text('Cerrar sesión'));
    await t.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(Navigator.of(t.element(find.text('Ingresar'))).canPop(), isFalse);
  });
}
