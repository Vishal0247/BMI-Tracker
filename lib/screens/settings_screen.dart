import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Settings',
          style: AppTextStyles.title1,
        ),
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme Settings
                _buildSectionHeader('Appearance'),
                const SizedBox(height: 12),
                _buildSettingCard(
                  'Dark Mode',
                  'Use dark theme',
                  Switch(
                    value: appState.isDarkMode,
                    onChanged: (value) {
                      appState.toggleDarkMode();
                    },
                    activeThumbColor: AppColors.primaryStart,
                  ),
                ),
                const SizedBox(height: 20),

                // Unit Settings
                _buildSectionHeader('Units'),
                const SizedBox(height: 12),
                _buildUnitSelector(appState),
                const SizedBox(height: 20),

                // About Section
                _buildSectionHeader('About'),
                const SizedBox(height: 12),
                _buildSettingTile(
                  'About App',
                  Icons.info,
                  () => _showAboutDialog(context),
                ),
                const SizedBox(height: 8),
                _buildSettingTile(
                  'Privacy Policy',
                  Icons.privacy_tip,
                  () => _showPrivacyPolicy(context),
                ),
                const SizedBox(height: 8),
                _buildSettingTile(
                  'Terms & Conditions',
                  Icons.description,
                  () => _showTermsAndConditions(context),
                ),
                const SizedBox(height: 20),

                // Goals
                _buildSectionHeader('Goals'),
                const SizedBox(height: 12),
                _buildSettingTile(
                  'Target Weight',
                  Icons.flag,
                  () => _showTargetWeightDialog(context, appState),
                  subtitle: appState.targetWeight != null ? '${appState.targetWeight!.toStringAsFixed(1)} ${appState.unitSystem == 'metric' ? 'kg' : 'lbs'}' : 'Not set',
                ),
                const SizedBox(height: 20),

                // Notifications
                _buildSectionHeader('Notifications'),
                const SizedBox(height: 12),
                _buildSettingCard(
                  'Daily Reminder',
                  'Remind me to log my weight',
                  Switch(
                    value: appState.isReminderEnabled,
                    onChanged: (value) {
                      appState.toggleReminder();
                    },
                    activeThumbColor: AppColors.primaryStart,
                  ),
                ),
                const SizedBox(height: 20),

                // Data Management
                _buildSectionHeader('Data Management'),
                const SizedBox(height: 12),
                _buildSettingTile(
                  'Clear History',
                  Icons.delete_forever,
                  () => _showClearHistoryDialog(context, appState),
                  textColor: AppColors.error,
                ),
                const SizedBox(height: 8),
                _buildSettingTile(
                  'Export Data',
                  Icons.download,
                  () => _showExportDialog(context),
                ),
                const SizedBox(height: 40),

                // App Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.textSecondary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Information',
                        style: AppTextStyles.title3,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('App Name', 'BMI Calculator Pro'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Version', '1.0.0'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Build', '1'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Footer
                Center(
                  child: Text(
                    'Made with ❤️ for your health',
                    style: AppTextStyles.caption1,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingCard(String title, String subtitle, Widget trailing) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.body1),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyles.caption1),
            ],
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color textColor = AppColors.textPrimary,
    String? subtitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryStart, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption1,
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: AppColors.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body3),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryStart,
          ),
        ),
      ],
    );
  }

  Widget _buildUnitSelector(AppStateProvider appState) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              appState.setUnitSystem('metric');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: appState.unitSystem == 'metric'
                    ? AppColors.primaryGradient
                    : null,
                color: appState.unitSystem == 'metric'
                    ? null
                    : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Metric (kg/cm)',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: appState.unitSystem == 'metric'
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              appState.setUnitSystem('imperial');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: appState.unitSystem == 'imperial'
                    ? AppColors.primaryGradient
                    : null,
                color: appState.unitSystem == 'imperial'
                    ? null
                    : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Imperial (lb/ft)',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: appState.unitSystem == 'imperial'
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'About BMI Calculator Pro',
          style: AppTextStyles.title2,
        ),
        content: Text(
          'BMI Calculator Pro is a premium health tracking app designed to help you monitor your Body Mass Index and maintain a healthy lifestyle.\n\nVersion: 1.0.0\n\nDeveloped with ❤️ for your wellbeing.',
          style: AppTextStyles.body2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Privacy Policy',
          style: AppTextStyles.title2,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your privacy is important to us.',
                style: AppTextStyles.title3,
              ),
              const SizedBox(height: 12),
              Text(
                '• We do not collect personal data from you.\n• All your BMI records are stored locally on your device.\n• We do not share your data with third parties.\n• You can delete your data at any time.',
                style: AppTextStyles.body2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Terms & Conditions',
          style: AppTextStyles.title2,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'By using this app, you agree to:',
                style: AppTextStyles.title3,
              ),
              const SizedBox(height: 12),
              Text(
                '• Use the app for personal health tracking purposes only.\n• BMI values are for informational purposes and not medical advice.\n• Consult healthcare professionals for medical advice.\n• We are not responsible for any health decisions based on this app.',
                style: AppTextStyles.body2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(
      BuildContext context, AppStateProvider appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Clear History?',
          style: AppTextStyles.title2,
        ),
        content: Text(
          'Are you sure you want to delete all your BMI records? This action cannot be undone.',
          style: AppTextStyles.body2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appState.clearAllRecords();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('History cleared')),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showTargetWeightDialog(BuildContext context, AppStateProvider appState) {
    final TextEditingController _controller = TextEditingController(
      text: appState.targetWeight?.toStringAsFixed(1) ?? '',
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('Set Target Weight', style: AppTextStyles.title2),
        content: TextField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: 'e.g. 70.0',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: AppTextStyles.body1,
        ),
        actions: [
          TextButton(
            onPressed: () {
              appState.setTargetWeight(null);
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.error)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final val = double.tryParse(_controller.text);
              if (val != null && val > 0) {
                appState.setTargetWeight(val);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('Export Data', style: AppTextStyles.title2),
        content: Text('Choose export format:', style: AppTextStyles.body2),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _exportCSV(appState);
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _exportPDF(appState);
            },
            child: const Text('PDF'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportCSV(AppStateProvider appState) async {
    final records = appState.getAllRecords();
    if (records.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No records to export.')));
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('Date,Weight,Height,BMI,Category');
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    
    for (var r in records) {
      buffer.writeln('${formatter.format(r.dateTime)},${r.weight},${r.height},${r.bmi.toStringAsFixed(1)},${r.category}');
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/bmi_history.csv');
    await file.writeAsString(buffer.toString());

    await Share.shareXFiles([XFile(file.path)], text: 'My BMI History');
  }

  Future<void> _exportPDF(AppStateProvider appState) async {
    final records = appState.getAllRecords();
    if (records.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No records to export.')));
      return;
    }

    final doc = pw.Document();
    final formatter = DateFormat('yyyy-MM-dd');

    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('BMI History Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Date', 'Weight', 'Height', 'BMI', 'Category'],
                  ...records.map((r) => [
                        formatter.format(r.dateTime),
                        r.weight.toStringAsFixed(1),
                        r.height.toStringAsFixed(1),
                        r.bmi.toStringAsFixed(1),
                        r.category,
                      ])
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'BMI_History_Report.pdf',
    );
  }
}
