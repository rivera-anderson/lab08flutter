import 'package:flutter_test/flutter_test.dart';
import 'package:lab08_app/main.dart';

void main() {
  testWidgets('Verifica renderizado de pantalla LOGIN', (WidgetTester tester) async {
    // Carga la app completa
    await tester.pumpWidget(const MyApp());

    // Verifica que se renderice el título LOGIN y el botón INGRESAR
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('INGRESAR'), findsOneWidget);
    expect(find.text('Correo'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
