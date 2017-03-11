# NonStandartExport

---

**NonStandartExport[**_file_, _data_, _format_**]** - экспортирует данные в файл с указанным форматом

---

## Детали

- _file_ - целевой файл, может иметь тип **String** или **File**
- _data_ - данные для экспорта
- _format_ - тип файла или расширение
- Поддерживаются следующие расширения:
  - "SEGY" - тип файлов для хранения сейсмографических измерений

## Примеры

### Основные примеры

Если приложение установлено, то необходимо загрузить его, выполнив:

```mathematica
Get["NonStandartImportExport`"]
```

После чего станет доступна для использования функция **NonStandartExport**.  

### Поддерживаемые Расширения

#### SEGY

Экспорт в виде SEG-Y поддерживается для данных, хранящихся в виде объекта SEGYData.  
Этот объект обычно представляет собой набо из четырех пар ключ-значение.  
Сконструировать такой объект можно самостоятельно.  Подробнее об устройстве SEGYData  можно прочитать в описание этого типа данных.  Здесь можно пользоваться готовым тестовым примером. Получить минимальный полноценный фрагмент данных можно выполнив следующий код:  

```mathematica
path = FileNameJoin[{$NonStandartImportExportDirectory, "NonStandartImportExportExample", "SEGYDataExample"}];
data = Get[path] 

```

## Смотрите Также

**[NonStandartImport](./NonStandartImport.md)** **[ToNonStandartLoad](./ToNonStandartLoad.md)**
**[SEGYData](./SEGYData.md)**
**[SEGYUnload](./SEGYUnload.md)**

## Туториалы

[Примеры Использования](../../Tutorials/ExampleOfUse.md)

## Связанные Руководства

[Руководство - Нестандартный Импорт и Экспорт](../../Guides/Guide.md)
