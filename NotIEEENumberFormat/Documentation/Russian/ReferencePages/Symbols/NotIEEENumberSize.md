# NotIEEENumberSize

---

**NotIEEENumberSize[**_format_**]** - возвращает количество байт для представления числа в указанном формате

---

## Детали

- _format_ один из поддерживаемых форматов, строка или внутренний индекс

## Примеры

### Основные Примеры

Если приложение установлено, то необходимо загрузить его, выполнив:

```mathematica
Get["NonStandartImportExport`"]
```

После чего станет доступна функция для вычисления числа байт.
Так можно вычислить длину числа в представлении формата числа с плавующей точкой и 32-х битной точностью IBM:

```mathematica
NotIEEENumberSize["IBM 32 Float"]

(* Out[..] := 4 *)
```

## Смотрите Также

**[FromNotIEEENumberFormat](./FromNotIEEENumberFormat.md)** 
**[ToNotIEEENumberFormat](./ToNotIEEENumberFormat.md)**

## Туториалы

[Не IEEE Форматы Числел - Примеры Использования](../../Tutorials/ExampleOfUse.md)

## Связанные Руководства

[Не IEEE Форматы Числел - Руководство](../../Guides/Guide.md)
