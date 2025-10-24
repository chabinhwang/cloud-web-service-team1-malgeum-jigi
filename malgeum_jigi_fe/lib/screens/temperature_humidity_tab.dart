import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_util.dart';
import '../widgets/tab_header.dart';
import '../models/air_quality_data.dart';

class TemperatureHumidityTab extends StatelessWidget {
  final ScrollController scrollController;

  const TemperatureHumidityTab({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    // Mock data
    const todayData = TodayEnvironmentData(
      minTemp: 8,
      maxTemp: 22,
      avgHumidity: 72,
      eveningHumidity: 85,
      currentHumidity: 62,
    );

    final appliances = [
      const ApplianceGuide(
        name: '제습기',
        status: '필요',
        time: '오후 6시 ~ 밤 11시',
        reason: '저녁부터 습도가 80% 이상으로 올라가요. 곰팡이 예방과 쾌적한 실내 환경을 위해 제습기를 켜두세요.',
        setting: '습도 55~60% 유지',
      ),
      const ApplianceGuide(
        name: '난방',
        status: '필요',
        time: '새벽 5시 ~ 오전 8시',
        reason: '새벽 기온이 8°C까지 떨어져요. 기상 30분 전에 타이머를 설정하면 따뜻하게 일어날 수 있어요.',
        setting: '20~22°C',
      ),
      const ApplianceGuide(
        name: '에어컨',
        status: '불필요',
        time: null,
        reason: '오늘은 에어컨 없이도 쾌적해요!',
        setting: null,
      ),
    ];

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        TabHeader(
          title: '온도·습도 조절 가이드',
          backgroundImage:
              'https://images.unsplash.com/photo-1685660477711-2099ce15a089',
          subtitle: '쾌적한 실내 환경을 위한 맞춤 가이드',
          scrollController: scrollController,
        ),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's Environment Summary (Material 3)
                    Card(
                      elevation: 2,
                      shadowColor: const Color(0x140D0A2C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                      color: AppTheme.lightBlue.withValues(alpha: 0.5),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              '오늘의 환경 요약',
                              style: TextStyle(
                                fontSize:
                                    18 *
                                    ResponsiveUtil.getTextScaleFactor(context),
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.thermostat,
                                          size: 32,
                                          color: AppTheme.badRed,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '기온',
                                                style: TextStyle(
                                                  fontSize:
                                                      12 *
                                                      ResponsiveUtil.getTextScaleFactor(
                                                        context,
                                                      ),
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${todayData.minTemp}°C ~ ${todayData.maxTemp}°C',
                                                style: TextStyle(
                                                  fontSize:
                                                      16 *
                                                      ResponsiveUtil.getTextScaleFactor(
                                                        context,
                                                      ),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.water_drop,
                                          size: 32,
                                          color: AppTheme.accentBlue,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '습도',
                                                style: TextStyle(
                                                  fontSize:
                                                      12 *
                                                      ResponsiveUtil.getTextScaleFactor(
                                                        context,
                                                      ),
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '평균 ${todayData.avgHumidity}%',
                                                style: TextStyle(
                                                  fontSize:
                                                      16 *
                                                      ResponsiveUtil.getTextScaleFactor(
                                                        context,
                                                      ),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '(저녁 ${todayData.eveningHumidity}%까지 상승)',
                                                style: TextStyle(
                                                  fontSize:
                                                      10 *
                                                      ResponsiveUtil.getTextScaleFactor(
                                                        context,
                                                      ),
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Appliance Guide
                    Text(
                      '📅 오늘 (10월 22일 수요일)',
                      style: TextStyle(
                        fontSize:
                            18 * ResponsiveUtil.getTextScaleFactor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Appliance Cards
                    ...appliances.map((appliance) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildApplianceCard(appliance, context),
                      );
                    }),

                    // Additional Tips (Material 3)
                    Card(
                      elevation: 2,
                      shadowColor: const Color(0x140D0A2C),
                      color: AppTheme.lightYellow.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('💡', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '꿀팁',
                                    style: TextStyle(
                                      fontSize:
                                          16 *
                                          ResponsiveUtil.getTextScaleFactor(
                                            context,
                                          ),
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '제습기와 난방을 동시에 사용할 경우 전기 요금이 증가할 수 있어요. '
                                    '타이머 기능을 활용해서 필요한 시간대에만 작동하도록 설정해보세요!',
                                    style: TextStyle(
                                      fontSize:
                                          14 *
                                          ResponsiveUtil.getTextScaleFactor(
                                            context,
                                          ),
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ), // Bottom padding for navigation bar
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplianceCard(ApplianceGuide appliance, BuildContext context) {
    Color borderColor;
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (appliance.name) {
      case '제습기':
        icon = Icons.air;
        if (appliance.isRequired) {
          borderColor = AppTheme.accentBlue;
          backgroundColor = AppTheme.lightBlue;
          textColor = AppTheme.accentBlue;
        } else {
          borderColor = AppTheme.borderColor;
          backgroundColor = Colors.grey[50]!;
          textColor = AppTheme.textSecondary;
        }
        break;
      case '난방':
        icon = Icons.thermostat;
        if (appliance.isRequired) {
          borderColor = AppTheme.badRed;
          backgroundColor = AppTheme.lightRed;
          textColor = AppTheme.badRed;
        } else {
          borderColor = AppTheme.borderColor;
          backgroundColor = Colors.grey[50]!;
          textColor = AppTheme.textSecondary;
        }
        break;
      case '에어컨':
        icon = Icons.ac_unit;
        if (appliance.isRequired) {
          borderColor = AppTheme.accentBlue;
          backgroundColor = AppTheme.lightBlue;
          textColor = AppTheme.accentBlue;
        } else {
          borderColor = AppTheme.borderColor;
          backgroundColor = Colors.grey[50]!;
          textColor = AppTheme.textSecondary;
        }
        break;
      default:
        icon = Icons.device_unknown;
        borderColor = AppTheme.borderColor;
        backgroundColor = Colors.grey[50]!;
        textColor = AppTheme.textSecondary;
    }

    return Card(
      elevation: 2,
      shadowColor: const Color(0x140D0A2C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.transparent, width: 0),
      ),
      color: backgroundColor.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              child: Icon(icon, size: 24, color: textColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        appliance.name,
                        style: TextStyle(
                          fontSize:
                              18 * ResponsiveUtil.getTextScaleFactor(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: appliance.isRequired
                              ? AppTheme.lightBlue
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          appliance.status,
                          style: TextStyle(
                            fontSize:
                                12 * ResponsiveUtil.getTextScaleFactor(context),
                            fontWeight: FontWeight.w600,
                            color: appliance.isRequired
                                ? AppTheme.primaryBlue
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (appliance.time != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '사용 시간: ',
                          style: TextStyle(
                            fontSize:
                                12 * ResponsiveUtil.getTextScaleFactor(context),
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          appliance.time!,
                          style: TextStyle(
                            fontSize:
                                12 * ResponsiveUtil.getTextScaleFactor(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '이유: ',
                        style: TextStyle(
                          fontSize:
                              12 * ResponsiveUtil.getTextScaleFactor(context),
                          color: Colors.grey[600],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '"${appliance.reason}"',
                          style: TextStyle(
                            fontSize:
                                12 * ResponsiveUtil.getTextScaleFactor(context),
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (appliance.setting != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '권장 설정: ',
                            style: TextStyle(
                              fontSize:
                                  12 *
                                  ResponsiveUtil.getTextScaleFactor(context),
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            appliance.setting!,
                            style: TextStyle(
                              fontSize:
                                  12 *
                                  ResponsiveUtil.getTextScaleFactor(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
