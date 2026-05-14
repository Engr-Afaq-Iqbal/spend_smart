// lib/core/l10n/app_translations.dart
// ─────────────────────────────────────────────────────────────────────────────
// GetX Translations class — maps locale codes to string maps.
//
// Usage anywhere in the app:
//   'home_income'.tr          → "Income" / "الدخل"
//   'reports_sar_more'.trArgs(['950'])  → "SAR 950 more"
//
// To add a new language:
//   1. Create assets/l10n/fr.json
//   2. Add 'fr_FR' key to _keys map below
//   3. Register Locale('fr','FR') in main.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': _en,
        'ar_SA': _ar,
      };

  // ── English ────────────────────────────────────────────────────────────────
  static const Map<String, String> _en = {
    'appName': 'SpendSmart',

    // Navigation
    'nav_home': 'Home',
    'nav_expenses': 'Expenses',
    'nav_add': 'Add',
    'nav_reports': 'Reports',
    'nav_coach': 'Coach',

    // Greetings
    'greeting_morning': 'Good Morning',
    'greeting_afternoon': 'Good Afternoon',
    'greeting_evening': 'Good Evening',

    // Home screen
    'home_income': 'Income',
    'home_available': 'Available',
    'home_spent': 'Spent',
    'home_financial_health': 'Financial Health',
    'home_very_good': 'Very Good',
    'home_monthly_budget': 'Monthly Budget',
    'home_budget_used': '% used',
    'home_top_categories': 'Top Categories',
    'home_view_all': 'View All',
    'home_ai_insights': 'AI Insights',
    'home_spendSmart_ai': 'SpendSmart AI',
    'home_recent_transactions': 'Recent Transactions',
    'home_savings_goal': 'Savings Goal',
    'home_upcoming_bills': 'Upcoming Bills',
    'home_days': 'days',
    'home_of': 'of',
    'home_remaining': 'remaining',
    'home_pts': 'pts',

    // Categories
    'category_food': 'Food & Dining',
    'category_transport': 'Transport',
    'category_shopping': 'Shopping',
    'category_entertainment': 'Entertainment',
    'category_others': 'Others',

    // Reports (legacy keys kept for compatibility)
    'reports_title': 'Reports & Analytics',
    'reports_week': 'Week',
    'reports_month': 'Month',
    'reports_quarter': 'Quarter',
    'reports_year': 'Year',
    'reports_total_spent': 'Total Spent',
    'reports_total_income': 'Total Income',
    'reports_vs_last_month': 'vs last month',
    'reports_spending_by_category': 'Spending by Category',
    'reports_daily_spending': 'Daily Spending',
    'reports_actual': 'Actual',
    'reports_avg': 'Avg',
    'reports_month_over_month': 'Month-over-Month',
    'reports_this_month': 'This month',
    'reports_sar_more': 'SAR @amount more',
    'reports_top_merchants': 'Top Merchants',
    'reports_export_pdf': 'Export PDF',
    'reports_share_card': 'Share Card',
    'reports_export_csv': 'Export CSV',
    'reports_export_success': 'Export Successful ✓',
    'reports_file_saved': 'File saved successfully.',
    'reports_open': 'Open',
    'reports_export_failed': 'Export Failed',
    'reports_share_coming_soon': 'Shareable card feature coming soon!',
    'reports_share_card_label': 'Share Card',

    // Reports v2 — tab labels
    'rpt_reports': 'Reports',
    'rpt_overview': 'Overview',
    'rpt_income': 'Income',
    'rpt_expenses': 'Expenses',
    'rpt_net_worth': 'Net Worth',

    // Reports v2 — period chips
    'rpt_7d': '7D',
    'rpt_1m': '1M',
    'rpt_3m': '3M',
    'rpt_6m': '6M',
    'rpt_1y': '1Y',

    // Reports v2 — period date label
    'rpt_may_2026': 'May 2026',

    // Reports v2 — export sheet
    'rpt_export_report': 'Export Report',
    'rpt_export_as_pdf': 'Export as PDF',
    'rpt_export_pdf_sub': 'Full-page PDF report',
    'rpt_export_as_csv': 'Export as CSV',
    'rpt_export_csv_sub': 'Raw data spreadsheet',
    'rpt_share_summary': 'Share Summary',
    'rpt_share_summary_sub': 'Share as image card',

    // Reports v2 — Overview tab
    'rpt_total_balance': 'Total Balance',
    'rpt_vs_last_month': 'vs last month',
    'rpt_total_income': 'Total Income',
    'rpt_last_mo': 'last mo.',
    'rpt_total_expenses': 'Total Expenses',
    'rpt_spending_breakdown': 'Spending Breakdown',
    'rpt_top5': 'Top 5',
    'rpt_income_vs_expenses': 'Income vs Expenses',
    'rpt_ai_insight': 'AI INSIGHT',
    'rpt_overview_insight': 'Your spending is 8% below the 3-month average. Keep it up!',

    // Reports v2 — Income tab
    'rpt_total_income_tab': 'Total Income',
    'rpt_daily_income': 'Daily Income',
    'rpt_income_breakdown': 'Income Breakdown',
    'rpt_by_source': 'By Source',
    'rpt_income_sources': 'Income Sources',
    'rpt_on_track': 'ON TRACK',
    'rpt_income_insight': 'Your salary income is up 18% this month compared to last.',
    'rpt_salary': 'Salary',
    'rpt_business': 'Business',
    'rpt_freelancing': 'Freelancing',
    'rpt_investment': 'Investment',
    'rpt_other': 'Other',
    'rpt_stc_main': 'STC Main Account',
    'rpt_alrajhi': 'AlRajhi Bank',
    'rpt_wise_usd': 'Wise USD',
    'rpt_snb_capital': 'SNB Capital',
    'rpt_cash': 'Cash',

    // Reports v2 — Expenses tab
    'rpt_total_expenses_tab': 'Total Expenses',
    'rpt_daily_expenses': 'Daily Expenses',
    'rpt_expense_breakdown': 'Expense Breakdown',
    'rpt_by_category': 'By Category',
    'rpt_top_expense_categories': 'Top Expense Categories',
    'rpt_heads_up': 'HEADS UP',
    'rpt_expense_insight': 'Food & Dining is your top category at 29%. Consider meal prep to save more.',
    'rpt_food_dining': 'Food & Dining',
    'rpt_transport': 'Transport',
    'rpt_shopping': 'Shopping',
    'rpt_bills': 'Bills & Utilities',

    // Reports v2 — Net Worth tab
    'rpt_net_worth_label': 'Net Worth',
    'rpt_vs_last_3months': 'vs last 3 months',
    'rpt_net_worth_trend': 'Net Worth Trend',
    'rpt_last_3months': 'Last 3 Months',
    'rpt_assets': 'Assets',
    'rpt_liabilities': 'Liabilities',
    'rpt_assets_vs_liabilities': 'Assets vs Liabilities',
    'rpt_net_worth_history': 'Net Worth History',
    'rpt_networth_insight': 'Your net worth grew SAR 33,300 over the last 3 months (+10.3%).',
    'rpt_3months_ago': '3 Months Ago',
    'rpt_1month_ago': '1 Month Ago',
    'rpt_current': 'Current',

    // Settings
    'settings_title': 'Settings',
    'settings_free_plan': 'Free Plan',
    'settings_upgrade_title': 'Upgrade to Pro',
    'settings_upgrade_subtitle': 'Advanced AI insights, unlimited reports & more',
    'settings_upgrade_start': 'Start',

    'settings_section_ai': 'AI & GAMES',
    'settings_section_appearance': 'APPEARANCE',
    'settings_section_language': 'LANGUAGE & REGION',
    'settings_section_security': 'SECURITY',
    'settings_section_data': 'DATA',
    'settings_section_notifications': 'NOTIFICATIONS',
    'settings_section_account': 'ACCOUNT',

    'settings_play_earn': 'Play & Earn AI Credits',
    'settings_play_earn_subtitle': 'Mini-games & daily bonuses',
    'settings_hen_blitz_guide': 'Hen Blitz Game Hub',
    'settings_hen_blitz_guide_subtitle': 'Guides, personal best & play',

    'settings_dark_mode': 'Dark Mode',
    'settings_font_size': 'Font Size',
    'settings_font_size_value': 'Medium',
    'settings_accent_color': 'Accent Color',
    'settings_language': 'Language',
    'settings_language_value': 'English',
    'settings_currency': 'Currency',
    'settings_currency_value': 'SAR — Saudi Riyal',
    'settings_ramadan_mode': 'Ramadan Mode',
    'settings_ramadan_subtitle': 'Suhoor/Iftar times',
    'settings_biometric': 'Biometric / Face ID',
    'settings_pin_code': 'PIN Code',
    'settings_pin_code_value': 'Enabled',
    'settings_auto_lock': 'Auto-lock',
    'settings_auto_lock_value': 'After 1 min',
    'settings_cloud_sync': 'Cloud Sync',
    'settings_export_data': 'Export Data',
    'settings_family_mode': 'Family Mode',
    'settings_family_mode_value': '3 members',
    'settings_budget_alerts': 'Budget Alerts',
    'settings_upcoming_bills': 'Upcoming Bills',
    'settings_weekly_summary': 'Weekly Summary',
    'settings_support': 'Support & Help',
    'settings_rate_app': 'Rate the App',
    'settings_delete_account': 'Delete Account',

    'settings_coming_soon': 'Coming Soon',
    'settings_coming_soon_body': '@feature will be available in the next update.',
    'settings_rate_title': '⭐ Rate SpendSmart',
    'settings_rate_body': 'Opening the App Store... (coming soon)',
    'settings_delete_title': 'Delete Account',
    'settings_delete_body':
        'This will permanently delete all your data. This action cannot be undone.',
    'settings_delete_confirm': 'Delete',
    'settings_delete_cancel': 'Cancel',
    'settings_delete_submitted': 'Account Deletion',
    'settings_delete_submitted_body':
        'Request submitted. You will receive a confirmation email.',
    'settings_upgrade_snackbar': '✨ Upgrade to Pro',
    'settings_upgrade_snackbar_body':
        'Unlimited reports, AI insights & more. Coming soon!',

    // Accent color picker
    'accent_color_title': 'Accent Color',
    'accent_color_presets': 'Preset Colors',
    'accent_color_custom': 'Custom Color',
    'accent_color_pick': 'Pick a Color',
    'accent_color_apply': 'Apply',
    'accent_color_cancel': 'Cancel',
    'accent_color_current': 'Current',

    'footer_version': 'SpendSmart v2.4.5 · All rights reserved',
    'coming_soon': 'Coming soon',

    // ── Timeline / Expenses screen ────────────────────────────────────────────
    'timeline_title': 'Transaction Timeline',
    'timeline_filter_daily': 'Daily',
    'timeline_filter_weekly': 'Weekly',
    'timeline_filter_monthly': 'Monthly',
    'timeline_total_spent': 'Total Spent',
    'timeline_day_total': 'Day Total',
    'timeline_week_total': 'Week Total',
    'timeline_month_total': 'Month Total',
    'timeline_transactions': 'Transactions',
    'timeline_no_transactions': 'No transactions',
    'timeline_no_transactions_sub': 'No expenses found for this period.',
    'timeline_weekly_totals': 'Weekly Totals',
    'timeline_category_health': 'Health',
    'timeline_category_utilities': 'Utilities',
    'timeline_category_income': 'Income',
    'timeline_category_other': 'Other',

    // ── Add Transaction sheet ─────────────────────────────────────────────────
    'add_transaction': 'ADD TRANSACTION',
    'add_expense': 'Add Expense',
    'add_expense_sub': 'Track your spending',
    'add_income': 'Add Income',
    'add_income_sub': 'Log your earnings',
    'scan_receipt': 'Scan Receipt',
    'voice_expense': 'Voice Expense',
    'voice_expense_sub': 'Speak to log',

    // ── Add Expense / Add Income form ─────────────────────────────────────────
    'save': 'Save',
    'save_expense': 'Save Expense',
    'save_income': 'Save Income',
    'suggests': 'AI suggests',
    'accept': 'Accept',
    'dismiss': 'Dismiss',
    'enter_chip': 'Enter...',
    'add_note_merchant': 'Add note, merchant, date...',
    'optional_details': 'OPTIONAL DETAILS',
    'merchant': 'MERCHANT',
    'merchant_hint': 'e.g. Starbucks',
    'note': 'NOTE',
    'note_hint': 'Optional note',
    'date': 'DATE',
    'today': 'Today',
    'recurring': 'RECURRING',
    'monthly': 'Monthly',
    'off': 'Off',
    'payment_method': 'PAYMENT METHOD',
    'bank_transfer': 'Bank Transfer',
    'cash': 'Cash',
    'online': 'Online',
    'scan_receipt_instead': 'Scan receipt instead',
    'ai_fills_auto': 'AI fills details automatically',
    'ai_badge': '+AI',
    'income_type': 'INCOME TYPE',
    'source_desc': 'SOURCE / DESCRIPTION',
    'source_desc_hint': 'e.g. Monthly salary',
    'account': 'ACCOUNT',
    'after_saving': 'After saving',

    // ── Premium gate ──────────────────────────────────────────────────────────
    'premium': 'PREMIUM',
    'premium_feature': 'Premium Feature',
    'unlock_premium': 'Unlock Premium',
    'maybe_later': 'Maybe Later',
    'premium_voice_title': 'Voice Expense',
    'premium_voice_desc': 'Record your expense using your voice. AI transcribes and categorises it automatically.',

    // ── Voice expense screen ──────────────────────────────────────────────────
    'listening': 'Listening...',
    'voice_hint': 'Say something like "Coffee at Starbucks, 25 riyals"',
    'edit': 'Edit',
    'amount': 'AMOUNT',
    'category': 'CATEGORY',

    // ── Expense category labels (used by ExpenseCategoryProps.labelKey) ───────
    'food_dining': 'Food & Dining',
    'transport': 'Transport',
    'shopping': 'Shopping',
    'entertainment': 'Entertainment',
    'health': 'Health',

    // ── Income type labels (used by IncomeTypeProps.labelKey) ─────────────────
    'salary': 'Salary',
    'business': 'Business',
    'freelancing': 'Freelancing',
    'investment': 'Investment',
    'rental': 'Rental',
    'interest': 'Interest',
    'other': 'Other',

    // ── Subscription screen ───────────────────────────────────────────────────
    'sub_unlock_potential': 'Unlock Your Full Potential',
    'sub_choose_plan': 'Choose Your Plan',
    'sub_free_trial': '7-day free trial — no card required',
    'sub_monthly': 'Monthly',
    'sub_yearly': 'Yearly',
    'sub_save_25': 'Save 25%',
    'sub_restore': 'Restore Purchase',
    'sub_terms': 'Terms',
    'sub_privacy': 'Privacy',
    'sub_cancel_anytime': 'Cancel anytime · No hidden fees',

    // Plan names
    'sub_free': 'Free',
    'sub_pro': 'Pro',
    'sub_family': 'Family',

    // Plan prices & periods
    'sub_free_price': 'Free',
    'sub_per_month': '/month',
    'sub_per_year': '/year',

    // CTA buttons
    'sub_current_plan': 'Current Plan',
    'sub_start_trial': 'Start 7-Day Free Trial',
    'sub_most_popular': 'Most Popular',

    // Success snackbar
    'sub_success_title': 'Subscription Activated!',
    'sub_success_body': 'Welcome to Pro. Enjoy all premium features.',

    // Free plan features
    'sub_feat_manual': 'Manual expense tracking',
    'sub_feat_5cat': '5 expense categories',
    'sub_feat_basic_charts': 'Basic charts & reports',
    'sub_feat_ai_scan_2': 'AI receipt scan (2/month)',
    'sub_feat_pdf': 'PDF export',
    'sub_feat_family': 'Family mode',
    'sub_feat_voice': 'Voice expense entry',
    'sub_feat_ai_coach': 'AI financial coach',

    // Pro plan features
    'sub_feat_unlimited_cat': 'Unlimited categories',
    'sub_feat_unlimited_ai': 'Unlimited AI scans',
    'sub_feat_voice_ar_en': 'Voice entry (Arabic + English)',
    'sub_feat_pdf_pro': 'PDF & CSV export',
    'sub_feat_bank_import': 'Bank statement import',
    'sub_feat_sub_tracker': 'Subscription tracker',
    'sub_feat_bnpl': 'BNPL tracker',
    'sub_feat_family_mode': 'Family mode',

    // Family plan features
    'sub_feat_everything_pro': 'Everything in Pro',
    'sub_feat_6members': 'Up to 6 family members',
    'sub_feat_shared_budget': 'Shared family budget',
    'sub_feat_profiles': 'Individual spending profiles',
    'sub_feat_pocket_kids': 'Pocket money for kids',
    'sub_feat_parental': 'Parental controls',
    'sub_feat_per_member': 'SAR 30/member per year',
    'sub_feat_zatca': 'ZATCA compliance',
  };

  // ── Arabic ─────────────────────────────────────────────────────────────────
  static const Map<String, String> _ar = {
    'appName': 'سبيند سمارت',

    'nav_home': 'الرئيسية',
    'nav_expenses': 'المصروفات',
    'nav_add': 'إضافة',
    'nav_reports': 'التقارير',
    'nav_coach': 'المساعد',

    'greeting_morning': 'صباح الخير',
    'greeting_afternoon': 'مساء الخير',
    'greeting_evening': 'مساء النور',

    'home_income': 'الدخل',
    'home_available': 'المتاح',
    'home_spent': 'المنفق',
    'home_financial_health': 'الصحة المالية',
    'home_very_good': 'ممتاز',
    'home_monthly_budget': 'الميزانية الشهرية',
    'home_budget_used': '٪ مستخدم',
    'home_top_categories': 'أبرز الفئات',
    'home_view_all': 'عرض الكل',
    'home_ai_insights': 'تحليلات الذكاء الاصطناعي',
    'home_spendSmart_ai': 'سبيند سمارت AI',
    'home_recent_transactions': 'المعاملات الأخيرة',
    'home_savings_goal': 'هدف الادخار',
    'home_upcoming_bills': 'الفواتير القادمة',
    'home_days': 'أيام',
    'home_of': 'من',
    'home_remaining': 'متبقي',
    'home_pts': 'نقطة',

    'category_food': 'الطعام والمطاعم',
    'category_transport': 'المواصلات',
    'category_shopping': 'التسوق',
    'category_entertainment': 'الترفيه',
    'category_others': 'أخرى',

    'reports_title': 'التقارير والتحليلات',
    'reports_week': 'أسبوع',
    'reports_month': 'شهر',
    'reports_quarter': 'ربع سنة',
    'reports_year': 'سنة',
    'reports_total_spent': 'إجمالي المنفق',
    'reports_total_income': 'إجمالي الدخل',
    'reports_vs_last_month': 'مقارنة بالشهر الماضي',
    'reports_spending_by_category': 'الإنفاق حسب الفئة',
    'reports_daily_spending': 'الإنفاق اليومي',
    'reports_actual': 'الفعلي',
    'reports_avg': 'المتوسط',
    'reports_month_over_month': 'مقارنة شهرية',
    'reports_this_month': 'هذا الشهر',
    'reports_sar_more': 'ريال @amount زيادة',
    'reports_top_merchants': 'أبرز التجار',
    'reports_export_pdf': 'تصدير PDF',
    'reports_share_card': 'مشاركة البطاقة',
    'reports_export_csv': 'تصدير CSV',
    'reports_export_success': 'تم التصدير بنجاح ✓',
    'reports_file_saved': 'تم حفظ الملف بنجاح.',
    'reports_open': 'فتح',
    'reports_export_failed': 'فشل التصدير',
    'reports_share_coming_soon': 'ميزة المشاركة ستكون متاحة قريباً!',
    'reports_share_card_label': 'مشاركة البطاقة',

    // Reports v2 — tab labels
    'rpt_reports': 'التقارير',
    'rpt_overview': 'نظرة عامة',
    'rpt_income': 'الدخل',
    'rpt_expenses': 'المصروفات',
    'rpt_net_worth': 'صافي الثروة',

    // Reports v2 — period chips
    'rpt_7d': '7أ',
    'rpt_1m': '1ش',
    'rpt_3m': '3ش',
    'rpt_6m': '6ش',
    'rpt_1y': '1س',

    // Reports v2 — period date label
    'rpt_may_2026': 'مايو 2026',

    // Reports v2 — export sheet
    'rpt_export_report': 'تصدير التقرير',
    'rpt_export_as_pdf': 'تصدير كـ PDF',
    'rpt_export_pdf_sub': 'تقرير PDF كامل الصفحة',
    'rpt_export_as_csv': 'تصدير كـ CSV',
    'rpt_export_csv_sub': 'جدول بيانات خام',
    'rpt_share_summary': 'مشاركة الملخص',
    'rpt_share_summary_sub': 'مشاركة كبطاقة صورة',

    // Reports v2 — Overview tab
    'rpt_total_balance': 'إجمالي الرصيد',
    'rpt_vs_last_month': 'مقارنة بالشهر الماضي',
    'rpt_total_income': 'إجمالي الدخل',
    'rpt_last_mo': 'الشهر الماضي',
    'rpt_total_expenses': 'إجمالي المصروفات',
    'rpt_spending_breakdown': 'تفصيل الإنفاق',
    'rpt_top5': 'أفضل 5',
    'rpt_income_vs_expenses': 'الدخل مقابل المصروفات',
    'rpt_ai_insight': 'تحليل الذكاء الاصطناعي',
    'rpt_overview_insight': 'إنفاقك أقل بنسبة 8% من متوسط الأشهر الثلاثة. استمر!',

    // Reports v2 — Income tab
    'rpt_total_income_tab': 'إجمالي الدخل',
    'rpt_daily_income': 'الدخل اليومي',
    'rpt_income_breakdown': 'تفصيل الدخل',
    'rpt_by_source': 'حسب المصدر',
    'rpt_income_sources': 'مصادر الدخل',
    'rpt_on_track': 'في المسار الصحيح',
    'rpt_income_insight': 'دخل راتبك ارتفع بنسبة 18% هذا الشهر مقارنة بالشهر الماضي.',
    'rpt_salary': 'الراتب',
    'rpt_business': 'الأعمال',
    'rpt_freelancing': 'العمل الحر',
    'rpt_investment': 'الاستثمار',
    'rpt_other': 'أخرى',
    'rpt_stc_main': 'حساب STC الرئيسي',
    'rpt_alrajhi': 'بنك الراجحي',
    'rpt_wise_usd': 'Wise دولار',
    'rpt_snb_capital': 'SNB كابيتال',
    'rpt_cash': 'نقدي',

    // Reports v2 — Expenses tab
    'rpt_total_expenses_tab': 'إجمالي المصروفات',
    'rpt_daily_expenses': 'المصروفات اليومية',
    'rpt_expense_breakdown': 'تفصيل المصروفات',
    'rpt_by_category': 'حسب الفئة',
    'rpt_top_expense_categories': 'أعلى فئات الإنفاق',
    'rpt_heads_up': 'تنبيه',
    'rpt_expense_insight': 'الطعام والمطاعم هي فئتك الأولى بنسبة 29%. فكر في تحضير الطعام للتوفير.',
    'rpt_food_dining': 'الطعام والمطاعم',
    'rpt_transport': 'المواصلات',
    'rpt_shopping': 'التسوق',
    'rpt_bills': 'الفواتير والمرافق',

    // Reports v2 — Net Worth tab
    'rpt_net_worth_label': 'صافي الثروة',
    'rpt_vs_last_3months': 'مقارنة بآخر 3 أشهر',
    'rpt_net_worth_trend': 'مسار صافي الثروة',
    'rpt_last_3months': 'آخر 3 أشهر',
    'rpt_assets': 'الأصول',
    'rpt_liabilities': 'الالتزامات',
    'rpt_assets_vs_liabilities': 'الأصول مقابل الالتزامات',
    'rpt_net_worth_history': 'سجل صافي الثروة',
    'rpt_networth_insight': 'نما صافي ثروتك بمقدار 33,300 ريال خلال الأشهر الثلاثة الماضية (+10.3%).',
    'rpt_3months_ago': 'منذ 3 أشهر',
    'rpt_1month_ago': 'منذ شهر',
    'rpt_current': 'الحالي',

    'settings_title': 'الإعدادات',
    'settings_free_plan': 'الخطة المجانية',
    'settings_upgrade_title': 'ترقية إلى Pro',
    'settings_upgrade_subtitle': 'تحليلات ذكاء اصطناعي متقدمة وتقارير غير محدودة والمزيد',
    'settings_upgrade_start': 'ابدأ',

    'settings_section_ai': 'الذكاء الاصطناعي والألعاب',
    'settings_section_appearance': 'المظهر',
    'settings_section_language': 'اللغة والمنطقة',
    'settings_section_security': 'الأمان',
    'settings_section_data': 'البيانات',
    'settings_section_notifications': 'الإشعارات',
    'settings_section_account': 'الحساب',

    'settings_play_earn': 'العب واربح رصيد AI',
    'settings_play_earn_subtitle': 'ألعاب مصغرة ومكافآت يومية',
    'settings_hen_blitz_guide': 'مركز لعبة Hen Blitz',
    'settings_hen_blitz_guide_subtitle': 'الأدلة وأفضل النتائج',

    'settings_dark_mode': 'الوضع المظلم',
    'settings_font_size': 'حجم الخط',
    'settings_font_size_value': 'متوسط',
    'settings_accent_color': 'لون التمييز',
    'settings_language': 'اللغة',
    'settings_language_value': 'العربية / الإنجليزية',
    'settings_currency': 'العملة',
    'settings_currency_value': 'ريال سعودي',
    'settings_ramadan_mode': 'وضع رمضان',
    'settings_ramadan_subtitle': 'أوقات السحور والإفطار',
    'settings_biometric': 'بصمة / التعرف على الوجه',
    'settings_pin_code': 'رمز PIN',
    'settings_pin_code_value': 'مفعّل',
    'settings_auto_lock': 'القفل التلقائي',
    'settings_auto_lock_value': 'بعد دقيقة واحدة',
    'settings_cloud_sync': 'المزامنة السحابية',
    'settings_export_data': 'تصدير البيانات',
    'settings_family_mode': 'وضع العائلة',
    'settings_family_mode_value': '3 أعضاء',
    'settings_budget_alerts': 'تنبيهات الميزانية',
    'settings_upcoming_bills': 'الفواتير القادمة',
    'settings_weekly_summary': 'الملخص الأسبوعي',
    'settings_support': 'الدعم والمساعدة',
    'settings_rate_app': 'قيّم التطبيق',
    'settings_delete_account': 'حذف الحساب',

    'settings_coming_soon': 'قريباً',
    'settings_coming_soon_body': '@feature ستكون متاحة في التحديث القادم.',
    'settings_rate_title': '⭐ قيّم سبيند سمارت',
    'settings_rate_body': 'فتح متجر التطبيقات... (قريباً)',
    'settings_delete_title': 'حذف الحساب',
    'settings_delete_body':
        'سيتم حذف جميع بياناتك بشكل دائم. لا يمكن التراجع عن هذا الإجراء.',
    'settings_delete_confirm': 'حذف',
    'settings_delete_cancel': 'إلغاء',
    'settings_delete_submitted': 'طلب الحذف',
    'settings_delete_submitted_body':
        'تم تقديم الطلب. ستتلقى بريداً إلكترونياً للتأكيد.',
    'settings_upgrade_snackbar': '✨ ترقية إلى Pro',
    'settings_upgrade_snackbar_body':
        'تقارير غير محدودة وتحليلات AI والمزيد. قريباً!',

    'accent_color_title': 'لون التمييز',
    'accent_color_presets': 'الألوان المحددة مسبقاً',
    'accent_color_custom': 'لون مخصص',
    'accent_color_pick': 'اختر لوناً',
    'accent_color_apply': 'تطبيق',
    'accent_color_cancel': 'إلغاء',
    'accent_color_current': 'الحالي',

    'footer_version': 'سبيند سمارت v2.4.5 · جميع الحقوق محفوظة',
    'coming_soon': 'قريباً',

    // ── Timeline / Expenses screen ────────────────────────────────────────────
    'timeline_title': 'سجل المعاملات',
    'timeline_filter_daily': 'يومي',
    'timeline_filter_weekly': 'أسبوعي',
    'timeline_filter_monthly': 'شهري',
    'timeline_total_spent': 'إجمالي الإنفاق',
    'timeline_day_total': 'إجمالي اليوم',
    'timeline_week_total': 'إجمالي الأسبوع',
    'timeline_month_total': 'إجمالي الشهر',
    'timeline_transactions': 'المعاملات',
    'timeline_no_transactions': 'لا توجد معاملات',
    'timeline_no_transactions_sub': 'لا توجد مصروفات لهذه الفترة.',
    'timeline_weekly_totals': 'الإجماليات الأسبوعية',
    'timeline_category_health': 'الصحة',
    'timeline_category_utilities': 'المرافق',
    'timeline_category_income': 'الدخل',
    'timeline_category_other': 'أخرى',

    // ── Add Transaction sheet ─────────────────────────────────────────────────
    'add_transaction': 'إضافة معاملة',
    'add_expense': 'إضافة مصروف',
    'add_expense_sub': 'تتبع إنفاقك',
    'add_income': 'إضافة دخل',
    'add_income_sub': 'سجّل إيراداتك',
    'scan_receipt': 'مسح الإيصال',
    'voice_expense': 'مصروف صوتي',
    'voice_expense_sub': 'تكلم لتسجيل',

    // ── Add Expense / Add Income form ─────────────────────────────────────────
    'save': 'حفظ',
    'save_expense': 'حفظ المصروف',
    'save_income': 'حفظ الدخل',
    'suggests': 'الذكاء الاصطناعي يقترح',
    'accept': 'قبول',
    'dismiss': 'رفض',
    'enter_chip': 'إدخال...',
    'add_note_merchant': 'أضف ملاحظة، تاجر، تاريخ...',
    'optional_details': 'تفاصيل اختيارية',
    'merchant': 'التاجر',
    'merchant_hint': 'مثال: ستاربكس',
    'note': 'ملاحظة',
    'note_hint': 'ملاحظة اختيارية',
    'date': 'التاريخ',
    'today': 'اليوم',
    'recurring': 'متكرر',
    'monthly': 'شهري',
    'off': 'إيقاف',
    'payment_method': 'طريقة الدفع',
    'bank_transfer': 'تحويل بنكي',
    'cash': 'نقدي',
    'online': 'إلكتروني',
    'scan_receipt_instead': 'مسح الإيصال بدلاً من ذلك',
    'ai_fills_auto': 'الذكاء الاصطناعي يملأ التفاصيل تلقائياً',
    'ai_badge': '+AI',
    'income_type': 'نوع الدخل',
    'source_desc': 'المصدر / الوصف',
    'source_desc_hint': 'مثال: راتب شهري',
    'account': 'الحساب',
    'after_saving': 'بعد الإضافة',

    // ── Premium gate ──────────────────────────────────────────────────────────
    'premium': 'بريميوم',
    'premium_feature': 'ميزة بريميوم',
    'unlock_premium': 'فتح بريميوم',
    'maybe_later': 'ربما لاحقاً',
    'premium_voice_title': 'المصروف الصوتي',
    'premium_voice_desc': 'سجّل مصروفك بصوتك. الذكاء الاصطناعي يحوله إلى نص ويصنفه تلقائياً.',

    // ── Voice expense screen ──────────────────────────────────────────────────
    'listening': 'جارٍ الاستماع...',
    'voice_hint': 'قل مثلاً "قهوة في ستاربكس، 25 ريال"',
    'edit': 'تعديل',
    'amount': 'المبلغ',
    'category': 'الفئة',

    // ── Expense category labels (used by ExpenseCategoryProps.labelKey) ───────
    'food_dining': 'الطعام والمطاعم',
    'transport': 'المواصلات',
    'shopping': 'التسوق',
    'entertainment': 'الترفيه',
    'health': 'الصحة',

    // ── Income type labels (used by IncomeTypeProps.labelKey) ─────────────────
    'salary': 'الراتب',
    'business': 'الأعمال',
    'freelancing': 'العمل الحر',
    'investment': 'الاستثمار',
    'rental': 'الإيجار',
    'interest': 'الفوائد',
    'other': 'أخرى',

    // ── Subscription screen ───────────────────────────────────────────────────
    'sub_unlock_potential': 'أطلق إمكاناتك الكاملة',
    'sub_choose_plan': 'اختر خطتك',
    'sub_free_trial': '7 أيام مجانية — بدون بطاقة',
    'sub_monthly': 'شهري',
    'sub_yearly': 'سنوي',
    'sub_save_25': 'وفّر 25%',
    'sub_restore': 'استعادة الشراء',
    'sub_terms': 'الشروط',
    'sub_privacy': 'الخصوصية',
    'sub_cancel_anytime': 'إلغاء في أي وقت · بدون رسوم خفية',

    // Plan names
    'sub_free': 'مجاني',
    'sub_pro': 'برو',
    'sub_family': 'عائلي',

    // Plan prices & periods
    'sub_free_price': 'مجاناً',
    'sub_per_month': '/شهر',
    'sub_per_year': '/سنة',

    // CTA buttons
    'sub_current_plan': 'خطتك الحالية',
    'sub_start_trial': 'ابدأ التجربة المجانية 7 أيام',
    'sub_most_popular': 'الأكثر شيوعاً',

    // Success snackbar
    'sub_success_title': 'تم تفعيل الاشتراك!',
    'sub_success_body': 'مرحباً في برو. استمتع بجميع المزايا المميزة.',

    // Free plan features
    'sub_feat_manual': 'تتبع المصروفات يدوياً',
    'sub_feat_5cat': '5 فئات للمصروفات',
    'sub_feat_basic_charts': 'مخططات وتقارير أساسية',
    'sub_feat_ai_scan_2': 'مسح AI للإيصالات (2/شهر)',
    'sub_feat_pdf': 'تصدير PDF',
    'sub_feat_family': 'الوضع العائلي',
    'sub_feat_voice': 'إدخال المصروفات بالصوت',
    'sub_feat_ai_coach': 'المستشار المالي بالذكاء الاصطناعي',

    // Pro plan features
    'sub_feat_unlimited_cat': 'فئات غير محدودة',
    'sub_feat_unlimited_ai': 'مسح AI غير محدود',
    'sub_feat_voice_ar_en': 'إدخال صوتي (عربي + إنجليزي)',
    'sub_feat_pdf_pro': 'تصدير PDF وCSV',
    'sub_feat_bank_import': 'استيراد كشف حساب بنكي',
    'sub_feat_sub_tracker': 'متتبع الاشتراكات',
    'sub_feat_bnpl': 'متتبع الشراء الآن وادفع لاحقاً',
    'sub_feat_family_mode': 'الوضع العائلي',

    // Family plan features
    'sub_feat_everything_pro': 'كل مزايا برو',
    'sub_feat_6members': 'حتى 6 أفراد من العائلة',
    'sub_feat_shared_budget': 'ميزانية عائلية مشتركة',
    'sub_feat_profiles': 'ملفات إنفاق فردية',
    'sub_feat_pocket_kids': 'مصروف الجيب للأطفال',
    'sub_feat_parental': 'رقابة الوالدين',
    'sub_feat_per_member': '30 ريال/عضو سنوياً',
    'sub_feat_zatca': 'امتثال هيئة الزكاة والضريبة',
  };
}
