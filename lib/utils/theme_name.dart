enum ThemeName { green, blue, red, teal, royal, bubblegum, sunset }

final Map<ThemeName, String> themeNameStringMap = {
  ThemeName.green: 'Green',
  ThemeName.blue: 'Blue',
  ThemeName.red: 'Red',
  ThemeName.teal: 'Teal',
  ThemeName.royal: 'Royal',
  ThemeName.bubblegum: 'Bubble Gum',
  ThemeName.sunset: 'Sunset',
};

final Map<String, ThemeName> stringToThemeNameMap = {
  'Green': ThemeName.green,
  'Blue': ThemeName.blue,
  'Red': ThemeName.red,
  'Teal': ThemeName.teal,
  'Royal': ThemeName.royal,
  'Bubble Gum': ThemeName.bubblegum,
  'Sunset': ThemeName.sunset,
};

const defualtUnlockedThemes = [
  ThemeName.green,
  ThemeName.blue,
  ThemeName.red,
];
