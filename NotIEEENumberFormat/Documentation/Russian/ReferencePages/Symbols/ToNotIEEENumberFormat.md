# ToNotIEEENumberFormat

---

**ToNotIEEENumberFormat[**_numbers_, _format_**]** - возращает представление списка чисел в виде массива байт указанного формата

---

## Детали

- _numbers_ - список действительных чисел
- _format_ - один из поддерживаемых форматов или его индекс
- Поддерживаемые форматы:
  - "IBM 32 Float" индекс 1 - формат представления чисел с плавующей точкой с 32-битной точностью от IBM

## Примеры

### Основные Примеры

Если приложение установлено, то необходимо загрузить его, выполнив:

```mathematica
Get["NonStandartImportExport`"]
```

После чего станет доступна для использования функция **ToNotIEEENumberFormat** из контекста NonStandartNumberFormat\`.

### Форматы

#### IBM 32 Float

Перевод действительного числа в представление IBM 32 Float в виде 4 байт: 

```mathematica
ToNotIEEENumberFormat[{(256.0^3 - 1.0)/256.0^3}, "IBM 32 Float"]

(* {64, 255, 255, 255} *)
```

## Смотрите Также

**[NotIEEENumberSize](./NotIEEENumberSize.md)** 
**[FromNotIEEENumberFormat](./FromNotIEEENumberFormat.md)**

## Туториалы

[Не IEEE Форматы Чисел - Примеры Использования](../../Tutorials/ExampleOfUse.md)

## Связанные Руководства

[Не IEEE Форматы Чисел - Руководство](../../Guides/Guide.md)
