# Non Standard Import and Export

Support import and export non standard files 

## License

This package is released under [The MIT License](./License).

---

# Нестандартный Импорт и Экспорт

Поддержка импорта и экспорта файлов нестандартного формата. 

## Лицензия 

Этот пакет выпущен под [Лицензией MIT](./License)

## Обзор Проекта

### Установка

Данный проект можно установить в пользовательскую директорию. 
Для этого необходимо выполнить код, находящийся в файле `Installer.m`. 
Блокнот `Installer.nb` с запуском данного кода располагается в той же директории. 

### Документация

Документация к проекту разделена на четыре части. 
Два раздела документации относятся к вспомогательным проектам, 
которые связаны с поддержкой различных кодировок и 
форматов представления чисел с плавующей точкой отличных от форматов IEEE. 

- [Пользовательские Кодировки - Руководство](./CustomEncoding/Documentation/Russian/Guides/Guide.md) 
- [Не IEEE Форматы Чисел - Руководство](./NotIEEENumberFormat/Documentation/Russian/Guides/Guide.md) 

Один раздел описывает поддерживаемые форматы файлов и типы данных, которые представляют их в Математике. 

- [Форматы Файлов - Руководство](./FileFormats/Documentation/Russian/Guides/Guide.md) 

Главный раздел документации посвящен работе с нестандартными типами файлов. 
В этом разделе описаны функции для импортирования и экспортирования данных, 
а также представлены примеры их использования. 

- [Нестандартный Импорт и Экспорт - Руководство](./NonStandartImportExport/Documentation/Russian/Guides/Guide.md) 

### Пакеты

Весь код приложения хранится в пакетах Mathematica и имеет следующую структуру: 

- **[CustomEncoding\`](./CustomEncoding/CustomEncoding.m)** 
- **[FileFormats\`](./FileFormats/)** 
  - [\`SEGY\`](./FileFormats/SEGY.m) 
- **[NotIEEENumberFormat\`](./NotIEEENumberFormat/NotIEEENumberFormat.m)** 
- **[NonStandartImportExport\`](./NonStandartImportExport/NonStandartImportExport.m)** 
  - [\`Extensions\`SEGY\`](./NonStandartImportExport/Extensions/SEGY.m) 
