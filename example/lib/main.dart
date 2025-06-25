import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'examples/basic_map_example.dart';
import 'examples/marker_click_example.dart';
import 'examples/multiple_markers_example.dart';
import 'examples/various_sizes_example.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // AppConfig 초기화
  await AppConfig.instance.initialize(environment: Environment.current);

  // 디버그 정보 출력
  AppConfig.instance.printDebugInfo();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Naver Map Web 예제 모음',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExampleSelectionPage(),
    );
  }
}

class ExampleSelectionPage extends StatelessWidget {
  const ExampleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Naver Map Web 예제 모음'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Flutter Naver Map Web 예제',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '아래 예제들을 통해 다양한 사용법을 확인해보세요.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  _buildExampleCard(
                    context,
                    title: '1. 기본 지도 보기',
                    description: '가장 간단한 형태의 네이버 지도를 표시합니다.',
                    icon: Icons.map,
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BasicMapExample(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildExampleCard(
                    context,
                    title: '2. 여러 마커 표시',
                    description: '지도에 여러 개의 마커를 표시하고 클릭 이벤트를 처리합니다.',
                    icon: Icons.location_on,
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MultipleMarkersExample(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildExampleCard(
                    context,
                    title: '3. 마커 클릭 이벤트',
                    description: '마커를 클릭했을 때 정보창을 표시하고 이벤트를 처리하는 방법을 보여줍니다.',
                    icon: Icons.touch_app,
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MarkerClickExample(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildExampleCard(
                    context,
                    title: '4. 다양한 크기의 지도 위젯',
                    description: '다양한 크기와 레이아웃으로 지도 위젯을 배치하는 방법을 보여줍니다.',
                    icon: Icons.view_quilt,
                    color: Colors.purple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VariousSizesExample(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      Text(
                        '주의사항',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• 실제 사용 시 clientId를 본인의 네이버 클라우드 플랫폼 Client ID로 변경해야 합니다.\n'
                    '• 웹에서 실행할 때는 도메인 등록이 필요할 수 있습니다.\n'
                    '• 각 예제는 독립적으로 실행할 수 있도록 구성되어 있습니다.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
