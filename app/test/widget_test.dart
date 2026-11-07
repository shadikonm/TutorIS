import 'package:flutter_test/flutter_test.dart';
import 'package:tutoris/main.dart';

void main() {
  testWidgets('Стартовый экран показывает выбор ролей', (tester) async {
    await tester.pumpWidget(const TutorISApp());

    expect(find.text('TutorIS'), findsOneWidget);
    expect(find.text('Я ученик'), findsOneWidget);
    expect(find.text('Я репетитор'), findsOneWidget);
  });

  testWidgets('Ученик может открыть свой кабинет и расписание', (tester) async {
    await tester.pumpWidget(const TutorISApp());
    await tester.tap(find.text('Я ученик'));
    await tester.pumpAndSettle();

    expect(find.text('Кабинет ученика'), findsOneWidget);
    await tester.tap(find.text('Расписание'));
    await tester.pumpAndSettle();
    expect(find.text('Математика · 15:00–16:00'), findsOneWidget);
  });

  testWidgets('Репетитор открывает собственный кабинет', (tester) async {
    await tester.pumpWidget(const TutorISApp());
    await tester.tap(find.text('Я репетитор'));
    await tester.pumpAndSettle();

    expect(find.text('Кабинет репетитора'), findsOneWidget);
    expect(find.text('Открыть работы учеников'), findsOneWidget);
  });

  testWidgets('Отправка работы и проверка видны обеим ролям', (tester) async {
    await tester.pumpWidget(const TutorISApp());

    // Ученик отправляет домашнее задание.
    await tester.tap(find.text('Я ученик'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Задания'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Отправить на проверку'));
    await tester.tap(find.text('Отправить на проверку'));
    await tester.pumpAndSettle();
    expect(find.text('На проверке'), findsOneWidget);

    // Репетитор видит работу и отправляет отзыв.
    await tester.tap(find.text('Сменить роль'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Я репетитор'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Задания'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Айдана отправила работу'), findsOneWidget);
    await tester.ensureVisible(find.text('Проверить и отправить отзыв'));
    await tester.tap(find.text('Проверить и отправить отзыв'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Проверено. Отзыв отправлен'), findsOneWidget);

    // Ученик после возвращения в кабинет видит результат.
    await tester.tap(find.text('Сменить роль'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Я ученик'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Задания'));
    await tester.pumpAndSettle();
    expect(find.text('Проверено'), findsOneWidget);
    expect(find.text('Отзыв репетитора'), findsOneWidget);
  });
}
