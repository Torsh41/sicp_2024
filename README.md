### Lab assignments for the course Structure and Interpretation of Computer Programs (SICP)

This repository contains small programs that implement features of the Functional and OO paradigms. The collection of programs, in some order, follows progression of the SICP book, creating procedures, doing abstractions, implementing recursions, and so on.

All of the programs are written in Common LISP (almost).

### NOTE

There is a noteworthy [program](diffdifferential_eq/main.lisp), that solves a parametrised multidimentional differential equation, with the given format:
```
∂u     ∂u     ∂²u
-- + υ -- = σ --- + f(u,t,x)
∂t     ∂x     ∂x²
```
with defined boundary conditions (the Cauchy problem). The output of the program is a `.csv` file, containing a surface - solution of the differential equation.

The program is very difficult to follow, as it uses a lot of unnecessary abstraction, pure function and data streams.


### Лабораторные работы по предмету Структура и Интерпретация Компуктерного Програмирования (SICP)

#### Список файлов

- differential_eq/
- differential_eq/php-version/
- lab1.lisp
- pow.lisp
- rational.lisp
- stream.lisp
- variadic_args.lisp
- Range.py
- side_effects.py

#### Описание каждого файла

##### differential_eq/main.lisp

Модель для численного решения дифференциальных уравнений (лабораторные Э.М.
Кольцовой).  Выполнена (в основном) в функциональной парадигме програмирования,
с использованием функций высших порядков, рекурсии и потоков (stream)

Ключевые слова:
- Модель
- Функции высшых порядков
- Рекурсия
- Абстракция

##### differential_eq/php-version/...

Таже программа для численного решения дифференциальных уравнений, выполненная в
Объектно Ориентированной Парадигме. (Не работает?)

Ключевые слова:
- Модель
- ООП, Конструктор
- Абстракция

##### lab1.lisp

Небольшая демонстрация функций высших порядков.

Ключевые слова:
- Функции высшых порядков

##### pow.lisp

Небольшая демонстрация рекурсии.

Ключевые слова:
- Рекурсия

##### rational.lisp

Абстракция, способ репрезентации рационального числа.

Ключевые слова:
- Абстракция

##### variadic_args.lisp

Абстракция, пример использования "особых" аргументов в clisp, конкретно вариадических аргументов.

Ключевые слова:
- ...

##### Range.py

ООП: Перегрузка конструктора.

Ключевые слова:
- ООП
- Конструктор
- Перегрузка

##### side_effects.py

Демонстрация "побочных эффектов" в "нечистых" функциях

Ключевые слова:
- Побочные эффекты


