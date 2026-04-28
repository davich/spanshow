import 'package:flutter_test/flutter_test.dart';
import 'package:spanshow/main.dart';

void main() {
  testWidgets('Shows screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const SpanShowApp());
    expect(find.text('SpanShow'), findsOneWidget);
  });
}
