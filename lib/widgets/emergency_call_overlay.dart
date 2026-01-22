 import 'dart:ui';
 import 'package:flutter/material.dart';
 import 'package:go_router/go_router.dart';
 import 'package:url_launcher/url_launcher.dart';

class EmergencyCallOverlay extends StatelessWidget {
  final Widget child;

  const EmergencyCallOverlay({super.key, required this.child});

  static final List<Map<String, String>> coreNumbers = [
    {
      'number': '110',
      'titleEn': 'Police emergency',
      'titleCn': '报警求助',
      'sceneEn': 'Theft, robbery, personal safety, getting lost',
      'sceneCn': '盗窃、抢劫、人身伤害、迷路、走失、紧急求助',
      'tipEn': '24h, no area code, can work even with no credit or weak signal',
      'tipCn': '无需区号，24 小时，手机停机或无话费通常也可拨打'
    },
    {
      'number': '120',
      'titleEn': 'Medical emergency',
      'titleCn': '医疗急救',
      'sceneEn': 'Sudden illness, injury, ambulance needed',
      'sceneCn': '突发疾病、受伤、急症、需要救护车',
      'tipEn': 'Clearly describe location, symptoms, and contact number',
      'tipCn': '清晰说明地点、症状和联系电话'
    },
    {
      'number': '119',
      'titleEn': 'Fire emergency',
      'titleCn': '火警救援',
      'sceneEn': 'Fire, explosion, people trapped, hazardous leak',
      'sceneCn': '火灾、爆炸、被困、危险品泄漏',
      'tipEn': 'Explain fire location, fire size, and if anyone is trapped',
      'tipCn': '讲清起火地点、火势大小、有无人员被困'
    },
    {
      'number': '122',
      'titleEn': 'Traffic accident',
      'titleCn': '交通事故',
      'sceneEn': 'Car accident, road dispute, traffic jam',
      'sceneCn': '车祸、交通纠纷、道路堵塞',
      'tipEn': 'Describe location and damage or injuries',
      'tipCn': '说明位置、车损和人员伤亡情况'
    },
  ];

  static final List<Map<String, String>> helperNumbers = [
    {
      'number': '12308',
      'titleEn': 'Consular protection',
      'titleCn': '领事保护（外交部）',
      'sceneEn': 'Lost passport, visa issues, consular help',
      'sceneCn': '护照丢失、签证问题、领事协助',
      'tipEn': 'From abroad: +86-10-12308, backup +86-10-65612308',
      'tipCn': '境外拨打：+86-10-12308，备用：+86-10-65612308'
    },
    {
      'number': '12345',
      'titleEn': 'Government service hotline',
      'titleCn': '政务服务热线',
      'sceneEn': 'Non-emergency complaints, consultation, general help',
      'sceneCn': '非紧急投诉、咨询、求助',
      'tipEn': 'Useful for travel service disputes and policy questions',
      'tipCn': '可解决旅游服务纠纷、政策疑问等'
    },
    {
      'number': '12315',
      'titleEn': 'Consumer protection',
      'titleCn': '消费维权',
      'sceneEn': 'Shopping disputes, fake advertising, quality issues',
      'sceneCn': '购物纠纷、虚假宣传、质量问题',
      'tipEn': 'Keep receipts and invoices as evidence',
      'tipCn': '保留小票、发票等凭证'
    },
    {
      'number': '12301',
      'titleEn': 'Tourism hotline',
      'titleCn': '旅游服务热线',
      'sceneEn': 'Scenic spot complaints, travel questions, basic help',
      'sceneCn': '景区投诉、旅游咨询、应急帮助',
      'tipEn': 'Merged into 12345 in many cities but still useful in some',
      'tipCn': '已整合至 12345，部分地区仍可拨打'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final preferChineseFirst = locale.languageCode == 'zh';
    final isChinese = locale.languageCode == 'zh';

    return Stack(
      children: [
        Positioned.fill(child: child),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showEmergencyCallSheet(context, preferChineseFirst),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.phone_in_talk,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isChinese ? '紧急电话' : 'Emergency Call',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _goHome(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.home,
                                color: Colors.black87,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isChinese ? '首页' : 'Home',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEmergencyCallSheet(BuildContext context, bool preferChineseFirst) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 56),
                      child: Text(
                        preferChineseFirst
                            ? '全国核心紧急电话（免费直拨）'
                            : 'Core emergency numbers (China-wide, free)',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22, 
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  if (!preferChineseFirst) ...[
                    const SizedBox(height: 6),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 56),
                        child: Text(
                          '全国核心紧急电话',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15, 
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (preferChineseFirst) ...[
                     const SizedBox(height: 6),
                     const Center(
                       child: Padding(
                         padding: EdgeInsets.only(right: 56),
                         child: Text(
                           'Core emergency numbers',
                           textAlign: TextAlign.center,
                           style: TextStyle(
                             fontSize: 15,
                             color: Colors.black54,
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                       ),
                     ),
                  ],

                  const SizedBox(height: 20),
                  ...coreNumbers.map((item) => _buildEmergencyCard(
                    context, 
                    item, 
                    preferChineseFirst, 
                    isCore: true
                  )).toList(),
                  
                  const SizedBox(height: 32),
                  
                  Center(
                    child: Text(
                      preferChineseFirst
                          ? '实用辅助电话'
                          : 'Helpful hotlines',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (!preferChineseFirst) ...[
                    const SizedBox(height: 6),
                    const Center(
                      child: Text(
                        '实用辅助电话',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15, 
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  if (preferChineseFirst) ...[
                    const SizedBox(height: 6),
                    const Center(
                      child: Text(
                        'Helpful hotlines',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  ...helperNumbers.map((item) => _buildEmergencyCard(
                    context, 
                    item, 
                    preferChineseFirst, 
                    isCore: false
                  )).toList(),
                  
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline, size: 20, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Tips',
                              style: TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Stay calm and clearly tell: location, what happened, and your phone number.',
                          style: TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• You can say “Can you speak English?”. Some cities provide English service.',
                          style: TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• From abroad, add +86 before the number when calling China.',
                          style: TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• Even with low balance or no SIM, 110/120/119 may still work.',
                          style: TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
               Positioned(
                 right: 16,
                 top: 64,
                 child: GestureDetector(
                   onTap: () => Navigator.of(context).pop(),
                   child: Container(
                     width: 40,
                     height: 40,
                     decoration: BoxDecoration(
                       color: Colors.white,
                       shape: BoxShape.circle,
                       boxShadow: [
                         BoxShadow(
                           color: Colors.black.withOpacity(0.08),
                           blurRadius: 8,
                           offset: const Offset(0, 2),
                         ),
                       ],
                     ),
                     child: const Icon(
                       Icons.close,
                       size: 22,
                       color: Colors.black54,
                     ),
                   ),
                 ),
               ),
            ],
          ),
        );
      },
    );
  }

  void _goHome(BuildContext context) {
    context.go('/');
  }

  Widget _buildEmergencyCard(
    BuildContext context, 
    Map<String, String> item, 
    bool preferChineseFirst,
    {required bool isCore}
  ) {
    final number = item['number'] ?? '';
    final titleEn = item['titleEn'] ?? '';
    final titleCn = item['titleCn'] ?? '';
    final sceneEn = item['sceneEn'] ?? '';
    final sceneCn = item['sceneCn'] ?? '';
    final tipEn = item['tipEn'] ?? '';
    final tipCn = item['tipCn'] ?? '';

    final primaryColor = isCore ? Colors.red : Colors.blue;
    final bgColor = isCore ? Colors.red[50] : Colors.blue[50];
    final iconColor = isCore ? Colors.red[700] : Colors.blue[700];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _callNumber(number),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _iconForNumber(number),
                    color: iconColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Number + Title
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            number,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: primaryColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  preferChineseFirst ? titleCn : titleEn,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  preferChineseFirst ? titleEn : titleCn,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      Divider(height: 1, color: Colors.grey[200]),
                      const SizedBox(height: 12),
                      
                      // Scenes
                      if (sceneEn.isNotEmpty || sceneCn.isNotEmpty) ...[
                        Text(
                          preferChineseFirst 
                              ? (sceneCn.isNotEmpty ? sceneCn : sceneEn)
                              : (sceneEn.isNotEmpty ? sceneEn : sceneCn),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                        if ((preferChineseFirst && sceneEn.isNotEmpty) || (!preferChineseFirst && sceneCn.isNotEmpty))
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              preferChineseFirst ? sceneEn : sceneCn,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                                height: 1.3,
                              ),
                            ),
                          ),
                      ],
                      
                      // Tips
                      if (tipEn.isNotEmpty || tipCn.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, size: 14, color: Colors.grey[400]),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    preferChineseFirst 
                                        ? (tipCn.isNotEmpty ? tipCn : tipEn)
                                        : (tipEn.isNotEmpty ? tipEn : tipCn),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                      height: 1.3,
                                    ),
                                  ),
                                  if ((preferChineseFirst && tipEn.isNotEmpty) || (!preferChineseFirst && tipCn.isNotEmpty))
                                    Text(
                                      preferChineseFirst ? tipEn : tipCn,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[500],
                                        height: 1.2,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Call Button
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor!.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.phone,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _callNumber(String number) async {
    if (number.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  IconData _iconForNumber(String number) {
    switch (number) {
      case '110':
        return Icons.local_police;
      case '120':
        return Icons.medical_services;
      case '119':
        return Icons.local_fire_department;
      case '122':
        return Icons.directions_car;
      case '12308':
        return Icons.public;
      case '12345':
        return Icons.account_balance;
      case '12315':
        return Icons.shopping_bag;
      case '12301':
        return Icons.map;
      default:
        return Icons.phone_in_talk;
    }
  }
}
