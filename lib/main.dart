
import 'package:flutter/material.dart';

void main() {
  runApp(const VPNHubApp());
}

class VPNHubApp extends StatelessWidget {
  const VPNHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPN Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C8CFF),
          secondary: Color(0xFF46DDB0),
          surface: Color(0xFF151C2B),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class VPNProfile {
  final String name;
  final String protocol;
  final String config;

  VPNProfile({
    required this.name,
    required this.protocol,
    required this.config,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<VPNProfile> profiles = [];

  bool connected = false;
  int selectedProfile = -1;

  final TextEditingController configController =
      TextEditingController();

  void addProfile() {
    configController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151C2B),
          title: const Text('Добавить профиль'),
          content: TextField(
            controller: configController,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: 'Вставьте VPN-ссылку или конфигурацию',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                final config = configController.text.trim();

                if (config.isEmpty) return;

                setState(() {
                  profiles.add(
                    VPNProfile(
                      name: 'Профиль ${profiles.length + 1}',
                      protocol: detectProtocol(config),
                      config: config,
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  String detectProtocol(String config) {
    final value = config.toLowerCase();

    if (value.startsWith('vless://')) return 'VLESS';
    if (value.startsWith('vmess://')) return 'VMess';
    if (value.startsWith('trojan://')) return 'Trojan';
    if (value.startsWith('ss://')) return 'Shadowsocks';
    if (value.startsWith('wireguard://')) return 'WireGuard';
    if (value.startsWith('hysteria2://') ||
        value.startsWith('hy2://')) {
      return 'Hysteria 2';
    }

    if (value.contains('[interface]')) return 'WireGuard';
    if (value.contains('amnezia')) return 'AmneziaWG';

    return 'Неизвестный формат';
  }

  void selectProfile(int index) {
    setState(() {
      selectedProfile = index;
      connected = false;
    });
  }

  @override
  void dispose() {
    configController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(22),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C2B48),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.shield_rounded,
                          color: Color(0xFF7194FF),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 13),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VPN HUB',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            'YOUR PRIVATE CONNECTION',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 9,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'VPN Hub',
                            applicationVersion: '0.1.0',
                          );
                        },
                        icon: const Icon(Icons.info_outline),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF192743),
                          Color(0xFF111827),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white10,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'CONNECTION STATUS',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                            letterSpacing: 2,
                          ),
                        ),

                        const SizedBox(height: 25),

                        Container(
                          width: 115,
                          height: 115,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF202F49),
                            border: Border.all(
                              color: const Color(0xFF5478C9),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.power_settings_new,
                            size: 55,
                            color: Color(0xFF8EACFF),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          connected ? 'Подключено' : 'Отключено',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 7),

                        Text(
                          selectedProfile >= 0
                              ? profiles[selectedProfile].name
                              : 'Выберите VPN-профиль',
                          style: const TextStyle(
                            color: Colors.white54,
                          ),
                        ),

                        const SizedBox(height: 22),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton(
                            onPressed: null,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF5478E8),
                              disabledBackgroundColor:
                                  const Color(0xFF5478E8),
                            ),
                            child: const Text(
                              'VPN ENGINE NOT INSTALLED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Движок подключения ещё не интегрирован',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Мои профили',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: addProfile,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Добавить'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (profiles.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151C2B),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.dns_outlined,
                            size: 42,
                            color: Colors.white38,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Пока нет профилей',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Добавьте конфигурацию VPN',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...List.generate(profiles.length, (index) {
                      final profile = profiles[index];
                      final selected = selectedProfile == index;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF151C2B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF5478E8)
                                : Colors.white10,
                          ),
                        ),
                        child: ListTile(
                          onTap: () => selectProfile(index),
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF243453),
                            child: Icon(
                              Icons.vpn_lock,
                              color: Color(0xFF8EACFF),
                            ),
                          ),
                          title: Text(
                            profile.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            profile.protocol,
                            style: const TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                          trailing: selected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF46DDB0),
                                )
                              : const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white38,
                                ),
                        ),
                      );
                    }),

                  const SizedBox(height: 25),

                  const Text(
                    'SUPPORTED FORMATS',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 13),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'VLESS',
                      'VMess',
                      'Trojan',
                      'Shadowsocks',
                      'WireGuard',
                      'AmneziaWG',
                      'WARP',
                      'Hysteria 2',
                    ].map((name) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF151C2B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 35),

                  const Center(
                    child: Text(
                      'VPN HUB  •  VERSION 0.1.0',
                      style: TextStyle(
                        color: Colors.white30,
                        fontSize: 10,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
