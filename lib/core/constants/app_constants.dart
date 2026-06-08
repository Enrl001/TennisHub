class AppConstants {
  AppConstants._();
  static const String supabaseUrl = 'https://ulaqewapxddbdqlberiy.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVsYXFld2FweGRkYmRxbGJlcml5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA0MDMzMjgsImV4cCI6MjA5NTk3OTMyOH0.vtdusVjY2SCDJ0U5yreHGDy4CyVN_LsYugEikivAPCU';

  static const String defaultCurrency = 'MNT';
  /// Display + edge-function conversion when service prices are in USD.
  static const int smartpayMntPerUsd = 3500;
  static const String defaultLocale = 'mn';
}
