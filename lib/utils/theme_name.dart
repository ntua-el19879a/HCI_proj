enum ThemeName { green, blue, red, teal, royal, ocean, sunset }

final Map<ThemeName, String> themeNameStringMap = {
  ThemeName.green: 'Green',
  ThemeName.blue: 'Blue',
  ThemeName.red: 'Red',
  ThemeName.teal: 'Teal',
  ThemeName.royal: 'Royal',
  ThemeName.ocean: 'Ocean',
  ThemeName.sunset: 'Sunset',
};

final Map<String, ThemeName> stringToThemeNameMap = {
  'Green': ThemeName.green,
  'Blue': ThemeName.blue,
  'Red': ThemeName.red,
  'Teal': ThemeName.teal,
  'Royal': ThemeName.royal,
  'Ocean': ThemeName.ocean,
  'Sunset': ThemeName.sunset,
};

const defualtUnlockedThemes = [
  ThemeName.green,
  ThemeName.blue,
  ThemeName.red,
];
