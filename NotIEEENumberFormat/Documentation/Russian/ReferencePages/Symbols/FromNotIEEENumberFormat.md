# FromNonStandartNumberFormat

---

**FromNonStandartNumberFormat[**_bytes_, _format_**]** - конвертирует набор байт в список чисел с плавующей точкой

---

## Детали

- _bytes_ - список байт
- _format_ - формат или индекс формата конвертации
- Поддерживаются следующие форматы:
  - "IBM 32 Float" индекс 1 - формат представления чисел с плавующей точкой с 32-битной точностью от IBM

## Примеры

### Основные примеры

Если приложение установлено, то необходимо загрузить его, выполнив:

```mathematica
Get["NonStandartImportExport`"]
```

После чего станет доступна для использования функция **FromNonStandartNumberFormat** из контекста NonStandartNumberFormat\`.

### Форматы

#### IBM 32 Float

Представление числа с плавующей точкой в виде 4 байт.
Первый бит первого байт - отвечает за знак числа:

- 0 - положительное число
- 1 - отрицательное число  

Семь оставшихся бит первого байта _exp_ - экспонента.
Эти целое число  от 0 до 127.  
Тогда эспонента числа с плавующей точкой вычисляется так  _16<sup>exp - 64</sup>_.  
Три оставшихся байта представляют собой дробную часть числа такого вида _0.FFFFFF_.  
Пусть имеется набор из 4 байт:  

```mathematica
bytes = {0, 255, 255, 255}

(* Out[..] :=  {0, 255, 255, 255} *)
```

Сконвертируем его в число с плавующе точкой:  

```mathematica
FromNonStandartNumberFormat[bytes, "IBM 32 Float"]

(* Out[..] := {8.63617*10^-78} *)
```

Число близкое к единице можно получить так:  

```mathematica
{one} = FromNonStandartNumberFormat[{64, 255, 255, 255}, "IBM 32 Float"]

(* Out[..] := {1.} *)
```

На самом деле это конечно же выглядит так:  

```mathematica
FullForm[one]

(* Out[] : = 0.9999999403953552` *)
```

Кроме перевода 4 байт в число, можно перевести любое количество байт, кратное 4 в список чисел:  

```mathematica
FromNonStandartNumberFormat[RandomInteger[{0, 255}, 16], "IBM 32 Float"]

(* Out[..] := {-5.68179*10^30, -1.19861*10^-15, -3.99971*10^62, 3.28465*10^-67} *)
```

## Смотрите Также

**[NonStandartNumberByteSize](./NonStandartNumberByteSize.md)** **[ToNonStandartNumberFormat](./ToNonStandartNumberFormat.md)**

## Туториалы

[Примеры Использования](../../Tutorials/ExampleOfUse.md)

## Связанные Руководства

[Руководство - Нестандартные Форматы Числел](../../Guides/Guide.md)