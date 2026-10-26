import 'package:flutter/material.dart';

/// Collection of all SVG icon paths used throughout DropX
class AppIcons {
  // Send / Transfer
  static const String send = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M22 2L11 13" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M22 2L15 22L11 13L2 9L22 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String receive = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 2V16M12 16L8 12M12 16L16 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M2 17L2 19C2 20.1046 2.89543 21 4 21L20 21C21.1046 21 22 20.1046 22 19V17" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String transfer = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M5 12H19M19 12L13 6M19 12L13 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  // Navigation
  static const String home = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M3 9.5L12 3L21 9.5V20C21 20.5523 20.5523 21 20 21H15V16H9V21H4C3.44772 21 3 20.5523 3 20V9.5Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String history = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 8V12L15 15M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C14.8273 3 17.35 4.30367 19 6.34267" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M19 3V7H15" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String settings = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 15C13.6569 15 15 13.6569 15 12C15 10.3431 13.6569 9 12 9C10.3431 9 9 10.3431 9 12C9 13.6569 10.3431 15 12 15Z" stroke="currentColor" stroke-width="2"/>
  <path d="M19.4 15C19.1277 15.6171 19.2583 16.3378 19.73 16.82L19.79 16.88C20.1812 17.2698 20.4013 17.7979 20.4013 18.35C20.4013 18.9021 20.1812 19.4302 19.79 19.82C19.3975 20.2132 18.8677 20.4328 18.315 20.4328C17.7623 20.4328 17.2325 20.2132 16.84 19.82L16.78 19.76C16.2978 19.2883 15.5771 19.1577 14.96 19.43C14.3458 19.6897 13.9357 20.2895 13.93 20.96V21.12C13.93 22.2 13.05 23.08 11.97 23.08C10.89 23.08 10.01 22.2 10.01 21.12V21.04C9.99326 20.3497 9.56974 19.7361 8.94 19.49C8.32294 19.2177 7.60218 19.3483 7.12 19.82L7.06 19.88C6.66752 20.2732 6.13769 20.4928 5.585 20.4928C5.03231 20.4928 4.50248 20.2732 4.11 19.88C3.71686 19.4875 3.49721 18.9577 3.49721 18.405C3.49721 17.8523 3.71686 17.3225 4.11 16.93L4.17 16.87C4.64173 16.3878 4.77233 15.6671 4.5 15.05C4.24029 14.4358 3.64053 14.0257 2.97 14.02H2.81C1.73 14.02 0.85 13.14 0.85 12.06C0.85 10.98 1.73 10.1 2.81 10.1H2.89C3.58026 10.0833 4.19394 9.65974 4.44 9.03C4.71233 8.41294 4.58173 7.69218 4.11 7.21L4.05 7.15C3.65686 6.75752 3.43721 6.22769 3.43721 5.675C3.43721 5.12231 3.65686 4.59248 4.05 4.2C4.44248 3.80686 4.97231 3.58721 5.525 3.58721C6.07769 3.58721 6.60752 3.80686 7 4.2L7.06 4.26C7.54218 4.73173 8.26294 4.86233 8.88 4.59H8.94C9.55415 4.33029 9.96427 3.73053 9.97 3.06V2.9C9.97 1.82 10.85 0.94 11.93 0.94C13.01 0.94 13.89 1.82 13.89 2.9V2.98C13.8957 3.65053 14.3058 4.25029 14.92 4.51C15.5371 4.78233 16.2578 4.65173 16.74 4.18L16.8 4.12C17.1925 3.72686 17.7223 3.50721 18.275 3.50721C18.8277 3.50721 19.3575 3.72686 19.75 4.12C20.1432 4.51248 20.3628 5.04231 20.3628 5.595C20.3628 6.14769 20.1432 6.67752 19.75 7.07L19.69 7.13C19.2183 7.61218 19.0877 8.33294 19.36 8.95V9.01C19.6197 9.62415 20.2195 10.0343 20.89 10.04H21.05C22.13 10.04 23.01 10.92 23.01 12C23.01 13.08 22.13 13.96 21.05 13.96H20.97C20.2995 13.9657 19.6997 14.3758 19.44 14.99L19.4 15Z" stroke="currentColor" stroke-width="2"/>
</svg>''';

  static const String profile = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M20 21V19C20 16.7909 18.2091 15 16 15H8C5.79086 15 4 16.7909 4 19V21" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <circle cx="12" cy="7" r="4" stroke="currentColor" stroke-width="2"/>
</svg>''';

  // Files & Media
  static const String file = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M14 2H6C4.89543 2 4 2.89543 4 4V20C4 21.1046 4.89543 22 6 22H18C19.1046 22 20 21.1046 20 20V8L14 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M14 2V8H20" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String image = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="3" width="18" height="18" rx="2" stroke="currentColor" stroke-width="2"/>
  <circle cx="8.5" cy="8.5" r="1.5" fill="currentColor"/>
  <path d="M21 15L16 10L5 21" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String video = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M15 10L19.553 7.724C19.7905 7.60534 20.0724 7.60534 20.3099 7.724C20.7536 7.94688 20.9999 8.42001 20.9999 8.929V15.071C20.9999 15.58 20.7536 16.0531 20.3099 16.276C20.0724 16.3947 19.7905 16.3947 19.553 16.276L15 14V10Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="2" y="7" width="14" height="10" rx="2" stroke="currentColor" stroke-width="2"/>
</svg>''';

  static const String audio = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M9 18V5L21 3V16" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="6" cy="18" r="3" stroke="currentColor" stroke-width="2"/>
  <circle cx="18" cy="16" r="3" stroke="currentColor" stroke-width="2"/>
</svg>''';

  static const String document = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M14 2H6C4.89543 2 4 2.89543 4 4V20C4 21.1046 4.89543 22 6 22H18C19.1046 22 20 21.1046 20 20V8L14 2Z" stroke="currentColor" stroke-width="2"/>
  <path d="M14 2V8H20" stroke="currentColor" stroke-width="2"/>
  <path d="M16 13H8M16 17H8M10 9H8" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String apk = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="5" y="2" width="14" height="20" rx="2" stroke="currentColor" stroke-width="2"/>
  <circle cx="12" cy="17" r="1" fill="currentColor"/>
  <path d="M9 6H15M9 10H13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String archive = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M21 8V21H3V8" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M23 3H1V8H23V3Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M10 12H14" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  // Network & Connection
  static const String wifi = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M5 12.55C7.24 10.32 10.15 9 12.5 9C14.85 9 17.76 10.32 20 12.55" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M1.5 8.5C4.83 5.18 8.87 3.5 12.5 3.5C16.13 3.5 20.17 5.18 23.5 8.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M8.5 16.5C9.82 15.22 11.12 14.5 12.5 14.5C13.88 14.5 15.18 15.22 16.5 16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="12.5" cy="20" r="1" fill="currentColor"/>
</svg>''';

  static const String hotspot = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="2"/>
  <path d="M6.34 6.34C4.9 7.79 4 9.79 4 12C4 14.21 4.9 16.21 6.34 17.66" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M17.66 6.34C19.1 7.79 20 9.79 20 12C20 14.21 19.1 16.21 17.66 17.66" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M3.51 3.51C1.34 5.68 0 8.69 0 12C0 15.31 1.34 18.32 3.51 20.49" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M20.49 3.51C22.66 5.68 24 8.69 24 12C24 15.31 22.66 18.32 20.49 20.49" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String qrCode = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="3" width="7" height="7" rx="1" stroke="currentColor" stroke-width="2"/>
  <rect x="14" y="3" width="7" height="7" rx="1" stroke="currentColor" stroke-width="2"/>
  <rect x="3" y="14" width="7" height="7" rx="1" stroke="currentColor" stroke-width="2"/>
  <rect x="5" y="5" width="3" height="3" fill="currentColor"/>
  <rect x="16" y="5" width="3" height="3" fill="currentColor"/>
  <rect x="5" y="16" width="3" height="3" fill="currentColor"/>
  <path d="M14 14H16V16H14V14ZM16 16H18V18H16V16ZM18 14H20V16H18V14ZM14 18H16V20H14V18ZM18 18H20V20H18V18Z" fill="currentColor"/>
</svg>''';

  static const String scan = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M3 9V4C3 3.44772 3.44772 3 4 3H9" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M21 9V4C21 3.44772 20.5523 3 20 3H15" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M3 15V20C3 20.5523 3.44772 21 4 21H9" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M21 15V20C21 20.5523 20.5523 21 20 21H15" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <line x1="2" y1="12" x2="22" y2="12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  // Actions
  static const String search = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="2"/>
  <path d="M21 21L16.5 16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String close = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M18 6L6 18M6 6L18 18" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String check = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M20 6L9 17L4 12" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String checkCircle = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/>
  <path d="M9 12L11 14L15 10" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String add = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 5V19M5 12H19" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"/>
</svg>''';

  static const String delete = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M3 6H21M8 6V4H16V6M19 6L18.0887 19.1059C18.0387 19.6215 17.6043 20 17.0866 20H6.91343C6.39572 20 5.96131 19.6215 5.91126 19.1059L5 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String share = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="18" cy="5" r="3" stroke="currentColor" stroke-width="2"/>
  <circle cx="6" cy="12" r="3" stroke="currentColor" stroke-width="2"/>
  <circle cx="18" cy="19" r="3" stroke="currentColor" stroke-width="2"/>
  <path d="M8.59 13.51L15.42 17.49M15.41 6.51L8.59 10.49" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String copy = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="9" y="9" width="13" height="13" rx="2" stroke="currentColor" stroke-width="2"/>
  <path d="M5 15H4C2.89543 15 2 14.1046 2 13V4C2 2.89543 2.89543 2 4 2H13C14.1046 2 15 2.89543 15 4V5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String edit = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M11 4H4C3.44772 4 3 4.44772 3 5V20C3 20.5523 3.44772 21 4 21H19C19.5523 21 20 20.5523 20 20V13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M18.5 2.5C19.0523 1.94772 19.9477 1.94772 20.5 2.5C21.0523 3.05228 21.0523 3.94772 20.5 4.5L12 13L9 14L10 11L18.5 2.5Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String filter = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M22 3H2L10 12.46V19L14 21V12.46L22 3Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String sort = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M3 6H21M6 12H18M10 18H14" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String grid = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="3" width="7" height="7" rx="1" stroke="currentColor" stroke-width="2"/>
  <rect x="14" y="3" width="7" height="7" rx="1" stroke="currentColor" stroke-width="2"/>
  <rect x="3" y="14" width="7" height="7" rx="1" stroke="currentColor" stroke-width="2"/>
  <rect x="14" y="14" width="7" height="7" rx="1" stroke="currentColor" stroke-width="2"/>
</svg>''';

  static const String list = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M8 6H21M8 12H21M8 18H21M3 6H3.01M3 12H3.01M3 18H3.01" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String back = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M19 12H5M5 12L12 19M5 12L12 5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String chevronRight = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String more = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="5" r="1.5" fill="currentColor"/>
  <circle cx="12" cy="12" r="1.5" fill="currentColor"/>
  <circle cx="12" cy="19" r="1.5" fill="currentColor"/>
</svg>''';

  // Status / Info
  static const String speed = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 2C6.47715 2 2 6.47715 2 12C2 14.9611 3.26277 17.6293 5.29289 19.5M12 2C17.5228 2 22 6.47715 22 12C22 14.9611 20.7372 17.6293 18.7071 19.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M12 12L16.5 7.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <circle cx="12" cy="12" r="2" fill="currentColor"/>
</svg>''';

  static const String lightning = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M13 2L4.09 12.11C3.77 12.5 4.02 13.09 4.51 13.09H10.5L9 22L19.91 11.89C20.23 11.5 19.98 10.91 19.49 10.91H13.5L13 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String folder = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M22 19C22 19.5304 21.7893 20.0391 21.4142 20.4142C21.0391 20.7893 20.5304 21 20 21H4C3.46957 21 2.96086 20.7893 2.58579 20.4142C2.21071 20.0391 2 19.5304 2 19V5C2 4.46957 2.21071 3.96086 2.58579 3.58579C2.96086 3.21071 3.46957 3 4 3H9L11 6H20C20.5304 6 21.0391 6.21071 21.4142 6.58579C21.7893 6.96086 22 7.46957 22 8V19Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String storage = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <ellipse cx="12" cy="5" rx="9" ry="3" stroke="currentColor" stroke-width="2"/>
  <path d="M21 12C21 13.6569 16.9706 15 12 15C7.02944 15 3 13.6569 3 12" stroke="currentColor" stroke-width="2"/>
  <path d="M3 5V19C3 20.6569 7.02944 22 12 22C16.9706 22 21 20.6569 21 19V5" stroke="currentColor" stroke-width="2"/>
</svg>''';

  static const String notification = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M18 8C18 6.4087 17.3679 4.88258 16.2426 3.75736C15.1174 2.63214 13.5913 2 12 2C10.4087 2 8.88258 2.63214 7.75736 3.75736C6.63214 4.88258 6 6.4087 6 8C6 15 3 17 3 17H21C21 17 18 15 18 8Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M13.73 21C13.5542 21.3031 13.3019 21.5547 12.9982 21.7295C12.6946 21.9044 12.3504 21.9965 12 21.9965C11.6496 21.9965 11.3054 21.9044 11.0018 21.7295C10.6982 21.5547 10.4458 21.3031 10.27 21" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String play = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
  <path d="M10 8L16 12L10 16V8Z" fill="currentColor"/>
</svg>''';

  static const String pause = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
  <path d="M10 8V16M14 8V16" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String open = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M18 13V19C18 19.5304 17.7893 20.0391 17.4142 20.4142C17.0391 20.7893 16.5304 21 16 21H5C4.46957 21 3.96086 20.7893 3.58579 20.4142C3.21071 20.0391 3 19.5304 3 19V8C3 7.46957 3.21071 6.96086 3.58579 6.58579C3.96086 6.21071 4.46957 6 5 6H11" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M15 3H21V9" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M10 14L21 3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String selectAll = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="3" width="8" height="8" rx="1" stroke="currentColor" stroke-width="2"/>
  <rect x="13" y="3" width="8" height="8" rx="1" stroke="currentColor" stroke-width="2"/>
  <rect x="3" y="13" width="8" height="8" rx="1" stroke="currentColor" stroke-width="2"/>
  <path d="M13 17.5L15.5 20L21 13" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String camera = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M23 19C23 19.5304 22.7893 20.0391 22.4142 20.4142C22.0391 20.7893 21.5304 21 21 21H3C2.46957 21 1.96086 20.7893 1.58579 20.4142C1.21071 20.0391 1 19.5304 1 19V8C1 7.46957 1.21071 6.96086 1.58579 6.58579C1.96086 6.21071 2.46957 6 3 6H7L9 3H15L17 6H21C21.5304 6 22.0391 6.21071 22.4142 6.58579C22.7893 6.96086 23 7.46957 23 8V19Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="12" cy="13" r="4" stroke="currentColor" stroke-width="2"/>
</svg>''';

  static const String security = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 22C12 22 4 18 4 12V5L12 2L20 5V12C20 18 12 22 12 22Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M9 12L11 14L15 10" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String info = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
  <path d="M12 16V12M12 8H12.01" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String warning = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M10.29 3.86L1.82 18C1.64537 18.3024 1.55296 18.6453 1.55199 18.9945C1.55101 19.3437 1.64149 19.6871 1.81442 19.9905C1.98736 20.2939 2.2365 20.5467 2.53748 20.7239C2.83846 20.9011 3.1808 20.9962 3.53 21H20.47C20.8192 20.9962 21.1615 20.9011 21.4625 20.7239C21.7635 20.5467 22.0126 20.2939 22.1856 19.9905C22.3585 19.6871 22.449 19.3437 22.448 18.9945C22.447 18.6453 22.3546 18.3024 22.18 18L13.71 3.86C13.5317 3.56611 13.2807 3.32312 12.9812 3.15448C12.6817 2.98585 12.3437 2.89725 12 2.89725C11.6563 2.89725 11.3183 2.98585 11.0188 3.15448C10.7193 3.32312 10.4683 3.56611 10.29 3.86Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M12 9V13M12 17H12.01" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String refresh = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M23 4V10H17" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M20.49 15C19.84 16.8 18.6094 18.3341 16.9998 19.3451C15.3901 20.356 13.4947 20.7784 11.6059 20.5491C9.71704 20.3197 7.97207 19.452 6.65672 18.0887C5.34136 16.7253 4.52597 14.9522 4.33963 13.0576C4.15329 11.1629 4.60601 9.25935 5.62377 7.65239C6.64153 6.04543 8.16421 4.83046 9.94999 4.2C11.7358 3.56955 13.6851 3.58736 15.4604 4.25001C17.2358 4.91265 18.7365 6.17918 19.7 7.8" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const String theme = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="4" stroke="currentColor" stroke-width="2"/>
  <path d="M12 2V4M12 20V22M4.22 4.22L5.64 5.64M18.36 18.36L19.78 19.78M2 12H4M20 12H22M4.22 19.78L5.64 18.36M18.36 5.64L19.78 4.22" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static const String language = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
  <path d="M2 12H22" stroke="currentColor" stroke-width="2"/>
  <path d="M12 2C12 2 8 7 8 12C8 17 12 22 12 22C12 22 16 17 16 12C16 7 12 2 12 2Z" stroke="currentColor" stroke-width="2"/>
</svg>''';

  static const String phone = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="5" y="2" width="14" height="20" rx="2" stroke="currentColor" stroke-width="2"/>
  <circle cx="12" cy="18" r="1" fill="currentColor"/>
</svg>''';

  static const String laptop = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="2" y="3" width="20" height="14" rx="2" stroke="currentColor" stroke-width="2"/>
  <path d="M1 21H23" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M7 21L5 17M17 21L19 17" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''';
}

class SvgIcon extends StatelessWidget {
  final String svgString;
  final double size;
  final Color? color;

  const SvgIcon(
    this.svgString, {
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? Theme.of(context).colorScheme.onSurface;
    final coloredSvg = svgString.replaceAll('currentColor', '#${iconColor.value.toRadixString(16).padLeft(8, '0').substring(2)}');
    
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SvgPainter(coloredSvg, iconColor),
        size: Size(size, size),
      ),
    );
  }
}

// For SVG rendering we use flutter_svg package, this is a placeholder
// In actual implementation, use flutter_svg's SvgPicture.string
class _SvgPainter extends CustomPainter {
  final String svgString;
  final Color color;
  
  _SvgPainter(this.svgString, this.color);
  
  @override
  void paint(Canvas canvas, Size size) {}
  
  @override
  bool shouldRepaint(_SvgPainter oldDelegate) => oldDelegate.color != color;
}
