# Non Standart Import and Export

Support import and export non standart files

---

# Нестандартный Импорт и Экспорт

Поддержка импорта и экспорта файлов нестандартного формата

## Обзор Проекта

### Установка

Данный проект можно установить в пользовательскую директорию. 
Для этого необходимо выполнить код, находящийся в файле `Installer.m`. 
Блокнот `Installer.nb` с запуском данного кода располагается в той же директории. 

### Документация

Документация к проекту разделена на три части. 
Два раздела документации относятся к вспомогательным проектам, 
которые связаны с поддержкой различных кодировок и 
форматов представления чисел с плавующей точкой отличных от форматов IEEE. 

- [Руководство - Пользовательские Кодировки](./CustomEncoding/Documentation/Russian/Guides/Guide.md)
- [Руководство - Не IEEE Форматы Чисел](./NotIEEENumberFormat/Documentation/Russian/Guides/Guide.md)

Главный раздел документации посвящен работе с различными нестандартными типами файлов. 
В этом разделе описаны функции для импортирования и экспортирования данных, а также представлены примеры 
их использования. Кроме того подробно рассматриваются поддерживаемые расширения файлов. 

- [Руководство - Нестандартный Импорт и Экспорт](./NonStandartImportExport/Documentation/Russian/Guides/Guide.md)

### Пакеты

Весь код приложения хранится в пакетах Mathematica и имеет следующую структуру: 

- **[CustomEncoding\`](./CustomEncoding/CustomEncoding.m )**
- **[NotIEEENumberFormat\`](./NotIEEENumberFormat/NotIEEENumberFormat.m)**
- **[NonStandartImportExport\`](./NonStandartImportExport/NonStandartImportExport.m)**
  - [\`Extensions\`SEGY\`](./NonStandartImportExport/Extensions/SEGY.m)
