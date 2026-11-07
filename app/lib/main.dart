import 'package:flutter/material.dart';

void main() => runApp(const TutorISApp());

const Color brand = Color(0xFF5145B8);
const Color background = Color(0xFFF6F7FB);

class TutorISApp extends StatefulWidget {
  const TutorISApp({super.key});

  @override
  State<TutorISApp> createState() => _TutorISAppState();
}

class _TutorISAppState extends State<TutorISApp> {
  String? role;
  int tab = 0;
  bool submitted = false;
  bool reviewed = false;
  String feedback = 'Хорошая работа! Проверь решение третьего примера.';

  void setRole(String newRole) => setState(() {
        role = newRole;
        tab = 0;
      });

  void switchRole() => setState(() {
        role = null;
        tab = 0;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TutorIS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: brand),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          centerTitle: false,
        ),
      ),
      home: role == null ? _roleSelection() : _dashboard(),
    );
  }

  Widget _roleSelection() {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.school_rounded, size: 66, color: brand),
                const SizedBox(height: 20),
                const Text('TutorIS', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: brand)),
                const SizedBox(height: 12),
                const Text('Расписание, домашние задания и результаты — в одном месте.',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                const SizedBox(height: 38),
                _choice(Icons.menu_book_rounded, 'Я репетитор',
                    'Организую занятия и проверяю работы', () => setRole('tutor')),
                const SizedBox(height: 14),
                _choice(Icons.person_outline_rounded, 'Я ученик',
                    'Смотрю расписание и сдаю задания', () => setRole('student')),
                const SizedBox(height: 20),
                const Text('Демонстрационная версия: данные хранятся только до перезапуска приложения.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _choice(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            Icon(icon, color: brand, size: 34),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ])),
            const Icon(Icons.chevron_right),
          ]),
        ),
      ),
    );
  }

  Widget _dashboard() {
    final isTutor = role == 'tutor';
    final titles = ['Главная', 'Расписание', 'Задания'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('TutorIS', style: TextStyle(fontWeight: FontWeight.bold, color: brand)),
        actions: [
          TextButton.icon(
            onPressed: switchRole,
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Сменить роль'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(titles[tab], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(isTutor ? 'Кабинет репетитора' : 'Кабинет ученика',
                  style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 22),
              if (tab == 0) ..._homeWidgets(isTutor),
              if (tab == 1) ..._scheduleWidgets(isTutor),
              if (tab == 2) ..._homeworkWidgets(isTutor),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (index) => setState(() => tab = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Главная'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Расписание'),
          NavigationDestination(icon: Icon(Icons.assignment_outlined), label: 'Задания'),
        ],
      ),
    );
  }

  List<Widget> _homeWidgets(bool isTutor) => [
        _infoCard(
          icon: Icons.waving_hand_outlined,
          title: isTutor ? 'Добрый день, преподаватель!' : 'Привет, Айдана!',
          subtitle: isTutor ? 'Сегодня у вас 2 занятия.' : 'Следующий урок — математика в 15:00.',
        ),
        const SizedBox(height: 12),
        _infoCard(
          icon: isTutor ? Icons.fact_check_outlined : Icons.assignment_turned_in_outlined,
          title: isTutor
              ? 'Работ на проверке: ${submitted && !reviewed ? 1 : 0}'
              : 'Домашнее задание: Квадратные уравнения',
          subtitle: isTutor
              ? (submitted && !reviewed ? 'Айдана отправила работу. Откройте «Задания».' : 'Новых работ пока нет.')
              : _studentStatus(),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => setState(() => tab = 2),
          icon: const Icon(Icons.assignment_outlined),
          label: Text(isTutor ? 'Открыть работы учеников' : 'Открыть домашние задания'),
        ),
      ];

  List<Widget> _scheduleWidgets(bool isTutor) => [
        _infoCard(
          icon: Icons.event_available_outlined,
          title: 'Математика · 15:00–16:00',
          subtitle: isTutor ? 'Ученик: Айдана · 19 ноября' : 'Репетитор · 19 ноября',
        ),
        const SizedBox(height: 12),
        _infoCard(
          icon: Icons.event_outlined,
          title: 'Геометрия · 18:30–19:30',
          subtitle: isTutor ? 'Ученик: Алихан · 19 ноября' : 'Следующее занятие · 21 ноября',
        ),
        const SizedBox(height: 16),
        const Text('Занятия демонстрационные. Создание и сохранение расписания подключим к API позднее.',
            style: TextStyle(color: Colors.black54)),
      ];

  List<Widget> _homeworkWidgets(bool isTutor) {
    if (isTutor) {
      return [
        _infoCard(
          icon: Icons.inbox_outlined,
          title: 'Квадратные уравнения',
          subtitle: !submitted
              ? 'Айдана ещё не отправила работу.'
              : reviewed
                  ? 'Проверено. Отзыв отправлен ученику.'
                  : 'Айдана отправила работу · На проверке',
        ),
        const SizedBox(height: 14),
        if (submitted) ...[
          const Text('Ответ ученика (демо)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _infoCard(icon: Icons.description_outlined, title: 'Решение №1–5',
              subtitle: 'Работа ученика успешно получена в демонстрационном хранилище состояния.'),
          const SizedBox(height: 12),
          if (!reviewed)
            FilledButton.icon(
              onPressed: () => setState(() => reviewed = true),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Проверить и отправить отзыв'),
            )
          else
            _infoCard(icon: Icons.rate_review_outlined, title: 'Комментарий репетитора', subtitle: feedback),
        ],
      ];
    }
    return [
      _infoCard(
        icon: Icons.menu_book_outlined,
        title: 'Квадратные уравнения',
        subtitle: 'Решите задания № 1–5. Дедлайн: 21 ноября, 20:00.',
      ),
      const SizedBox(height: 14),
      _infoCard(icon: Icons.info_outline, title: 'Статус', subtitle: _studentStatus()),
      const SizedBox(height: 14),
      if (!submitted)
        FilledButton.icon(
          onPressed: () => setState(() {
            submitted = true;
            reviewed = false;
          }),
          icon: const Icon(Icons.send_outlined),
          label: const Text('Отправить на проверку'),
        ),
      if (reviewed) ...[
        const SizedBox(height: 16),
        _infoCard(icon: Icons.rate_review_outlined, title: 'Отзыв репетитора', subtitle: feedback),
      ],
    ];
  }

  String _studentStatus() {
    if (reviewed) return 'Проверено';
    if (submitted) return 'На проверке';
    return 'Не отправлено';
  }

  Widget _infoCard({required IconData icon, required String title, required String subtitle}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: brand, size: 28),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 7),
            Text(subtitle, style: const TextStyle(color: Colors.black54, height: 1.45)),
          ])),
        ]),
      ),
    );
  }
}
