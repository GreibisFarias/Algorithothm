//
//  MultipleChoiceMock.swift
//  Algorithothm
//
//  Mock "Predice" exercises, easy to medium, each one in Swift, Python and Java.
//  Every card has 2 questions about the same function: first what it returns,
//  then a trace of a variable or a line (the highlighted one).
//  Lines up to 39 characters, so they fit the monitor.
//

import Foundation

extension MultipleChoiceExercise {

    /// From easier to harder.
    static let all: [MultipleChoiceExercise] = [
        doubleAll, sumUpTo, countEvens, countVowels, reverseText,
        factorial, digitSum, indexOfMax, firstRepeated, binarySearch
    ]

    // MARK: 1. Double every number

    static let doubleAll = MultipleChoiceExercise(
        id: "double-all",
        title: "Duplicar todos",
        variants: [
            MultipleChoiceVariant(.swift, code: """
                func duplicarTodos(
                  _ nums: [Int]) -> [Int] {
                  var newArray = [Int]()
                  for num in nums {
                    var num = num * 2
                    newArray.append(num)
                  }
                  return newArray
                }
                """, questions: [
                TraceQuestion("Si nums = [1, 2, 3], ¿qué devuelve newArray?", emphasis: "nums = [1, 2, 3]",
                              answer: "[2, 4, 6]", wrong: ["[4, 5, 1]", "[2, 5, 6]", "[3, 8, 6]"]),
                TraceQuestion("En el segundo ciclo, ¿cuánto vale num antes de la línea marcada?", emphasis: "segundo ciclo",
                              highlight: "var num = num * 2",
                              answer: "num == 2", wrong: ["num == 1", "num == 4", "num == 6"])
            ]),
            MultipleChoiceVariant(.python, code: """
                def duplicar_todos(nums):
                  nuevo = []
                  for num in nums:
                    num = num * 2
                    nuevo.append(num)
                  return nuevo
                """, questions: [
                TraceQuestion("Si nums = [1, 2, 3], ¿qué devuelve la función?", emphasis: "nums = [1, 2, 3]",
                              answer: "[2, 4, 6]", wrong: ["[4, 5, 1]", "[2, 5, 6]", "[3, 8, 6]"]),
                TraceQuestion("En el segundo ciclo, ¿cuánto vale num antes de la línea marcada?", emphasis: "segundo ciclo",
                              highlight: "num = num * 2",
                              answer: "num == 2", wrong: ["num == 1", "num == 4", "num == 6"])
            ]),
            MultipleChoiceVariant(.java, code: """
                List<Integer> duplicarTodos(
                    List<Integer> nums) {
                  List<Integer> nuevo =
                      new ArrayList<>();
                  for (int num : nums) {
                    num = num * 2;
                    nuevo.add(num);
                  }
                  return nuevo;
                }
                """, questions: [
                TraceQuestion("Si nums = [1, 2, 3], ¿qué devuelve la función?", emphasis: "nums = [1, 2, 3]",
                              answer: "[2, 4, 6]", wrong: ["[4, 5, 1]", "[2, 5, 6]", "[3, 8, 6]"]),
                TraceQuestion("En el segundo ciclo, ¿cuánto vale num antes de la línea marcada?", emphasis: "segundo ciclo",
                              highlight: "num = num * 2;",
                              answer: "num == 2", wrong: ["num == 1", "num == 4", "num == 6"])
            ])
        ]
    )

    // MARK: 2. Sum up to n

    static let sumUpTo = MultipleChoiceExercise(
        id: "sum-up-to",
        title: "Sumar hasta n",
        variants: [
            MultipleChoiceVariant(.swift, code: """
                func sumarHasta(_ n: Int) -> Int {
                  var total = 0
                  for i in 1...n {
                    total += i
                  }
                  return total
                }
                """, questions: [
                TraceQuestion("Si n = 4, ¿qué devuelve la función?", emphasis: "n = 4",
                              answer: "10", wrong: ["4", "6", "16"]),
                TraceQuestion("En el tercer ciclo, ¿cuánto vale total después de la línea marcada?", emphasis: "tercer ciclo",
                              highlight: "total += i",
                              answer: "total == 6", wrong: ["total == 3", "total == 5", "total == 10"])
            ]),
            MultipleChoiceVariant(.python, code: """
                def sumar_hasta(n):
                  total = 0
                  for i in range(1, n + 1):
                    total += i
                  return total
                """, questions: [
                TraceQuestion("Si n = 4, ¿qué devuelve la función?", emphasis: "n = 4",
                              answer: "10", wrong: ["4", "6", "16"]),
                TraceQuestion("En el tercer ciclo, ¿cuánto vale total después de la línea marcada?", emphasis: "tercer ciclo",
                              highlight: "total += i",
                              answer: "total == 6", wrong: ["total == 3", "total == 5", "total == 10"])
            ]),
            MultipleChoiceVariant(.java, code: """
                int sumarHasta(int n) {
                  int total = 0;
                  for (int i = 1; i <= n; i++) {
                    total += i;
                  }
                  return total;
                }
                """, questions: [
                TraceQuestion("Si n = 4, ¿qué devuelve la función?", emphasis: "n = 4",
                              answer: "10", wrong: ["4", "6", "16"]),
                TraceQuestion("En el tercer ciclo, ¿cuánto vale total después de la línea marcada?", emphasis: "tercer ciclo",
                              highlight: "total += i;",
                              answer: "total == 6", wrong: ["total == 3", "total == 5", "total == 10"])
            ])
        ]
    )

    // MARK: 3. Count the even numbers

    static let countEvens = MultipleChoiceExercise(
        id: "count-evens",
        title: "Contar pares",
        variants: [
            MultipleChoiceVariant(.swift, code: """
                func contarPares(
                  _ nums: [Int]) -> Int {
                  var cuenta = 0
                  for n in nums {
                    if n % 2 == 0 {
                      cuenta += 1
                    }
                  }
                  return cuenta
                }
                """, questions: [
                TraceQuestion("Si nums = [4, 7, 10, 3, 8], ¿qué devuelve la función?", emphasis: "nums = [4, 7, 10, 3, 8]",
                              answer: "3", wrong: ["2", "4", "5"]),
                TraceQuestion("Con esos números, ¿cuántas veces se evalúa la línea marcada?", emphasis: "cuántas veces",
                              highlight: "if n % 2 == 0 {",
                              answer: "5 veces", wrong: ["3 veces", "4 veces", "1 vez"])
            ]),
            MultipleChoiceVariant(.python, code: """
                def contar_pares(nums):
                  cuenta = 0
                  for n in nums:
                    if n % 2 == 0:
                      cuenta += 1
                  return cuenta
                """, questions: [
                TraceQuestion("Si nums = [4, 7, 10, 3, 8], ¿qué devuelve la función?", emphasis: "nums = [4, 7, 10, 3, 8]",
                              answer: "3", wrong: ["2", "4", "5"]),
                TraceQuestion("Con esos números, ¿cuántas veces se evalúa la línea marcada?", emphasis: "cuántas veces",
                              highlight: "if n % 2 == 0:",
                              answer: "5 veces", wrong: ["3 veces", "4 veces", "1 vez"])
            ]),
            MultipleChoiceVariant(.java, code: """
                int contarPares(int[] nums) {
                  int cuenta = 0;
                  for (int n : nums) {
                    if (n % 2 == 0) {
                      cuenta++;
                    }
                  }
                  return cuenta;
                }
                """, questions: [
                TraceQuestion("Si nums = {4, 7, 10, 3, 8}, ¿qué devuelve la función?", emphasis: "nums = {4, 7, 10, 3, 8}",
                              answer: "3", wrong: ["2", "4", "5"]),
                TraceQuestion("Con esos números, ¿cuántas veces se evalúa la línea marcada?", emphasis: "cuántas veces",
                              highlight: "if (n % 2 == 0) {",
                              answer: "5 veces", wrong: ["3 veces", "4 veces", "1 vez"])
            ])
        ]
    )

    // MARK: 4. Count the vowels

    static let countVowels = MultipleChoiceExercise(
        id: "count-vowels",
        title: "Contar vocales",
        variants: [
            MultipleChoiceVariant(.swift, code: """
                func contarVocales(
                  _ texto: String) -> Int {
                  var cuenta = 0
                  for letra in texto {
                    if "aeiou".contains(letra) {
                      cuenta += 1
                    }
                  }
                  return cuenta
                }
                """, questions: [
                TraceQuestion("Si texto = \"murcielago\", ¿qué devuelve la función?", emphasis: "texto = \"murcielago\"",
                              answer: "5", wrong: ["4", "6", "10"]),
                TraceQuestion("¿Con qué letra se ejecuta por primera vez la línea marcada?", emphasis: "primera vez",
                              highlight: "cuenta += 1",
                              answer: "\"u\"", wrong: ["\"m\"", "\"a\"", "\"i\""])
            ]),
            MultipleChoiceVariant(.python, code: """
                def contar_vocales(texto):
                  cuenta = 0
                  for letra in texto:
                    if letra in "aeiou":
                      cuenta += 1
                  return cuenta
                """, questions: [
                TraceQuestion("Si texto = \"murcielago\", ¿qué devuelve la función?", emphasis: "texto = \"murcielago\"",
                              answer: "5", wrong: ["4", "6", "10"]),
                TraceQuestion("¿Con qué letra se ejecuta por primera vez la línea marcada?", emphasis: "primera vez",
                              highlight: "cuenta += 1",
                              answer: "\"u\"", wrong: ["\"m\"", "\"a\"", "\"i\""])
            ]),
            MultipleChoiceVariant(.java, code: """
                int contarVocales(String texto) {
                  int cuenta = 0;
                  for (char c : texto.toCharArray()) {
                    if ("aeiou".indexOf(c) >= 0) {
                      cuenta++;
                    }
                  }
                  return cuenta;
                }
                """, questions: [
                TraceQuestion("Si texto = \"murcielago\", ¿qué devuelve la función?", emphasis: "texto = \"murcielago\"",
                              answer: "5", wrong: ["4", "6", "10"]),
                TraceQuestion("¿Con qué letra se ejecuta por primera vez la línea marcada?", emphasis: "primera vez",
                              highlight: "cuenta++;",
                              answer: "'u'", wrong: ["'m'", "'a'", "'i'"])
            ])
        ]
    )

    // MARK: 5. Reverse a text

    static let reverseText = MultipleChoiceExercise(
        id: "reverse-text",
        title: "Invertir texto",
        variants: [
            MultipleChoiceVariant(.swift, code: """
                func invertir(
                  _ texto: String) -> String {
                  var res = ""
                  for letra in texto {
                    res = String(letra) + res
                  }
                  return res
                }
                """, questions: [
                TraceQuestion("Si texto = \"sol\", ¿qué devuelve la función?", emphasis: "texto = \"sol\"",
                              answer: "\"los\"", wrong: ["\"sol\"", "\"slo\"", "\"ols\""]),
                TraceQuestion("En el segundo ciclo, ¿cuánto vale res después de la línea marcada?", emphasis: "segundo ciclo",
                              highlight: "res = String(letra) + res",
                              answer: "res == \"os\"", wrong: ["res == \"so\"", "res == \"o\"", "res == \"los\""])
            ]),
            MultipleChoiceVariant(.python, code: """
                def invertir(texto):
                  res = ""
                  for letra in texto:
                    res = letra + res
                  return res
                """, questions: [
                TraceQuestion("Si texto = \"sol\", ¿qué devuelve la función?", emphasis: "texto = \"sol\"",
                              answer: "\"los\"", wrong: ["\"sol\"", "\"slo\"", "\"ols\""]),
                TraceQuestion("En el segundo ciclo, ¿cuánto vale res después de la línea marcada?", emphasis: "segundo ciclo",
                              highlight: "res = letra + res",
                              answer: "res == \"os\"", wrong: ["res == \"so\"", "res == \"o\"", "res == \"los\""])
            ]),
            MultipleChoiceVariant(.java, code: """
                String invertir(String texto) {
                  String res = "";
                  for (char c : texto.toCharArray()) {
                    res = c + res;
                  }
                  return res;
                }
                """, questions: [
                TraceQuestion("Si texto = \"sol\", ¿qué devuelve la función?", emphasis: "texto = \"sol\"",
                              answer: "\"los\"", wrong: ["\"sol\"", "\"slo\"", "\"ols\""]),
                TraceQuestion("En el segundo ciclo, ¿cuánto vale res después de la línea marcada?", emphasis: "segundo ciclo",
                              highlight: "res = c + res;",
                              answer: "res == \"os\"", wrong: ["res == \"so\"", "res == \"o\"", "res == \"los\""])
            ])
        ]
    )

    // MARK: 6. Factorial

    static let factorial = MultipleChoiceExercise(
        id: "factorial",
        title: "Factorial",
        variants: [
            MultipleChoiceVariant(.swift, code: """
                func factorial(_ n: Int) -> Int {
                  var resultado = 1
                  for i in 1...n {
                    resultado *= i
                  }
                  return resultado
                }
                """, questions: [
                TraceQuestion("Si n = 5, ¿qué devuelve la función?", emphasis: "n = 5",
                              answer: "120", wrong: ["25", "15", "60"]),
                TraceQuestion("En el cuarto ciclo, ¿cuánto vale resultado antes de la línea marcada?", emphasis: "cuarto ciclo",
                              highlight: "resultado *= i",
                              answer: "resultado == 6", wrong: ["resultado == 24", "resultado == 4", "resultado == 12"])
            ]),
            MultipleChoiceVariant(.python, code: """
                def factorial(n):
                  resultado = 1
                  for i in range(1, n + 1):
                    resultado *= i
                  return resultado
                """, questions: [
                TraceQuestion("Si n = 5, ¿qué devuelve la función?", emphasis: "n = 5",
                              answer: "120", wrong: ["25", "15", "60"]),
                TraceQuestion("En el cuarto ciclo, ¿cuánto vale resultado antes de la línea marcada?", emphasis: "cuarto ciclo",
                              highlight: "resultado *= i",
                              answer: "resultado == 6", wrong: ["resultado == 24", "resultado == 4", "resultado == 12"])
            ]),
            MultipleChoiceVariant(.java, code: """
                int factorial(int n) {
                  int resultado = 1;
                  for (int i = 1; i <= n; i++) {
                    resultado *= i;
                  }
                  return resultado;
                }
                """, questions: [
                TraceQuestion("Si n = 5, ¿qué devuelve la función?", emphasis: "n = 5",
                              answer: "120", wrong: ["25", "15", "60"]),
                TraceQuestion("En el cuarto ciclo, ¿cuánto vale resultado antes de la línea marcada?", emphasis: "cuarto ciclo",
                              highlight: "resultado *= i;",
                              answer: "resultado == 6", wrong: ["resultado == 24", "resultado == 4", "resultado == 12"])
            ])
        ]
    )

    // MARK: 7. Sum of the digits

    static let digitSum = MultipleChoiceExercise(
        id: "digit-sum",
        title: "Suma de dígitos",
        variants: [
            MultipleChoiceVariant(.swift, code: """
                func sumaDigitos(_ n: Int) -> Int {
                  var n = n
                  var suma = 0
                  while n > 0 {
                    suma += n % 10
                    n /= 10
                  }
                  return suma
                }
                """, questions: [
                TraceQuestion("Si n = 352, ¿qué devuelve la función?", emphasis: "n = 352",
                              answer: "10", wrong: ["352", "35", "7"]),
                TraceQuestion("En el segundo ciclo, ¿cuánto vale n antes de la línea marcada?", emphasis: "segundo ciclo",
                              highlight: "n /= 10",
                              answer: "n == 35", wrong: ["n == 3", "n == 352", "n == 5"])
            ]),
            MultipleChoiceVariant(.python, code: """
                def suma_digitos(n):
                  suma = 0
                  while n > 0:
                    suma += n % 10
                    n //= 10
                  return suma
                """, questions: [
                TraceQuestion("Si n = 352, ¿qué devuelve la función?", emphasis: "n = 352",
                              answer: "10", wrong: ["352", "35", "7"]),
                TraceQuestion("En el segundo ciclo, ¿cuánto vale n antes de la línea marcada?", emphasis: "segundo ciclo",
                              highlight: "n //= 10",
                              answer: "n == 35", wrong: ["n == 3", "n == 352", "n == 5"])
            ]),
            MultipleChoiceVariant(.java, code: """
                int sumaDigitos(int n) {
                  int suma = 0;
                  while (n > 0) {
                    suma += n % 10;
                    n /= 10;
                  }
                  return suma;
                }
                """, questions: [
                TraceQuestion("Si n = 352, ¿qué devuelve la función?", emphasis: "n = 352",
                              answer: "10", wrong: ["352", "35", "7"]),
                TraceQuestion("En el segundo ciclo, ¿cuánto vale n antes de la línea marcada?", emphasis: "segundo ciclo",
                              highlight: "n /= 10;",
                              answer: "n == 35", wrong: ["n == 3", "n == 352", "n == 5"])
            ])
        ]
    )

    // MARK: 8. Position of the largest

    static let indexOfMax = MultipleChoiceExercise(
        id: "index-of-max",
        title: "Posición del mayor",
        variants: [
            MultipleChoiceVariant(.swift, code: """
                func posMayor(_ nums: [Int]) -> Int {
                  var pos = 0
                  for i in 1..<nums.count {
                    if nums[i] > nums[pos] {
                      pos = i
                    }
                  }
                  return pos
                }
                """, questions: [
                TraceQuestion("Si nums = [3, 8, 2, 8], ¿qué devuelve la función?", emphasis: "nums = [3, 8, 2, 8]",
                              answer: "1", wrong: ["3", "8", "2"]),
                TraceQuestion("Con esos números, ¿cuántas veces se ejecuta la línea marcada?", emphasis: "cuántas veces",
                              highlight: "pos = i",
                              answer: "1 vez", wrong: ["0 veces", "2 veces", "3 veces"])
            ]),
            MultipleChoiceVariant(.python, code: """
                def pos_mayor(nums):
                  pos = 0
                  for i in range(1, len(nums)):
                    if nums[i] > nums[pos]:
                      pos = i
                  return pos
                """, questions: [
                TraceQuestion("Si nums = [3, 8, 2, 8], ¿qué devuelve la función?", emphasis: "nums = [3, 8, 2, 8]",
                              answer: "1", wrong: ["3", "8", "2"]),
                TraceQuestion("Con esos números, ¿cuántas veces se ejecuta la línea marcada?", emphasis: "cuántas veces",
                              highlight: "pos = i",
                              answer: "1 vez", wrong: ["0 veces", "2 veces", "3 veces"])
            ]),
            MultipleChoiceVariant(.java, code: """
                int posMayor(int[] a) {
                  int pos = 0;
                  for (int i = 1; i < a.length; i++) {
                    if (a[i] > a[pos]) {
                      pos = i;
                    }
                  }
                  return pos;
                }
                """, questions: [
                TraceQuestion("Si a = {3, 8, 2, 8}, ¿qué devuelve la función?", emphasis: "a = {3, 8, 2, 8}",
                              answer: "1", wrong: ["3", "8", "2"]),
                TraceQuestion("Con esos números, ¿cuántas veces se ejecuta la línea marcada?", emphasis: "cuántas veces",
                              highlight: "pos = i;",
                              answer: "1 vez", wrong: ["0 veces", "2 veces", "3 veces"])
            ])
        ]
    )

    // MARK: 9. First repeated number

    static let firstRepeated = MultipleChoiceExercise(
        id: "first-repeated",
        title: "Primer repetido",
        variants: [
            MultipleChoiceVariant(.swift, code: """
                func primerRepetido(
                  _ nums: [Int]) -> Int? {
                  var vistos = Set<Int>()
                  for n in nums {
                    if vistos.contains(n) {
                      return n
                    }
                    vistos.insert(n)
                  }
                  return nil
                }
                """, questions: [
                TraceQuestion("Si nums = [5, 2, 7, 2, 5], ¿qué devuelve la función?", emphasis: "nums = [5, 2, 7, 2, 5]",
                              answer: "2", wrong: ["5", "7", "nil"]),
                TraceQuestion("Con esos números, ¿cuántas veces se ejecuta la línea marcada?", emphasis: "cuántas veces",
                              highlight: "vistos.insert(n)",
                              answer: "3 veces", wrong: ["2 veces", "4 veces", "5 veces"])
            ]),
            MultipleChoiceVariant(.python, code: """
                def primer_repetido(nums):
                  vistos = set()
                  for n in nums:
                    if n in vistos:
                      return n
                    vistos.add(n)
                  return None
                """, questions: [
                TraceQuestion("Si nums = [5, 2, 7, 2, 5], ¿qué devuelve la función?", emphasis: "nums = [5, 2, 7, 2, 5]",
                              answer: "2", wrong: ["5", "7", "None"]),
                TraceQuestion("Con esos números, ¿cuántas veces se ejecuta la línea marcada?", emphasis: "cuántas veces",
                              highlight: "vistos.add(n)",
                              answer: "3 veces", wrong: ["2 veces", "4 veces", "5 veces"])
            ]),
            MultipleChoiceVariant(.java, code: """
                Integer primerRepetido(int[] nums) {
                  Set<Integer> vistos =
                      new HashSet<>();
                  for (int n : nums) {
                    if (vistos.contains(n)) {
                      return n;
                    }
                    vistos.add(n);
                  }
                  return null;
                }
                """, questions: [
                TraceQuestion("Si nums = {5, 2, 7, 2, 5}, ¿qué devuelve la función?", emphasis: "nums = {5, 2, 7, 2, 5}",
                              answer: "2", wrong: ["5", "7", "null"]),
                TraceQuestion("Con esos números, ¿cuántas veces se ejecuta la línea marcada?", emphasis: "cuántas veces",
                              highlight: "vistos.add(n);",
                              answer: "3 veces", wrong: ["2 veces", "4 veces", "5 veces"])
            ])
        ]
    )

    // MARK: 10. Binary search

    static let binarySearch = MultipleChoiceExercise(
        id: "binary-search",
        title: "Búsqueda binaria",
        variants: [
            MultipleChoiceVariant(.swift, code: """
                func buscar(
                  _ nums: [Int], _ x: Int) -> Int {
                  var low = 0
                  var high = nums.count - 1
                  while low <= high {
                    let mid = (low + high) / 2
                    if nums[mid] == x { return mid }
                    if nums[mid] < x {
                      low = mid + 1
                    } else {
                      high = mid - 1
                    }
                  }
                  return -1
                }
                """, questions: [
                TraceQuestion("Si nums = [1, 3, 5, 7, 9, 11] y x = 9, ¿qué devuelve la función?", emphasis: "nums = [1, 3, 5, 7, 9, 11] y x = 9",
                              answer: "4", wrong: ["3", "5", "-1"]),
                TraceQuestion("En el primer ciclo, ¿cuánto vale mid después de la línea marcada?", emphasis: "primer ciclo",
                              highlight: "let mid = (low + high) / 2",
                              answer: "mid == 2", wrong: ["mid == 3", "mid == 2.5", "mid == 4"])
            ]),
            MultipleChoiceVariant(.python, code: """
                def buscar(nums, x):
                  low, high = 0, len(nums) - 1
                  while low <= high:
                    mid = (low + high) // 2
                    if nums[mid] == x:
                      return mid
                    if nums[mid] < x:
                      low = mid + 1
                    else:
                      high = mid - 1
                  return -1
                """, questions: [
                TraceQuestion("Si nums = [1, 3, 5, 7, 9, 11] y x = 9, ¿qué devuelve la función?", emphasis: "nums = [1, 3, 5, 7, 9, 11] y x = 9",
                              answer: "4", wrong: ["3", "5", "-1"]),
                TraceQuestion("En el primer ciclo, ¿cuánto vale mid después de la línea marcada?", emphasis: "primer ciclo",
                              highlight: "mid = (low + high) // 2",
                              answer: "mid == 2", wrong: ["mid == 3", "mid == 2.5", "mid == 4"])
            ]),
            MultipleChoiceVariant(.java, code: """
                int buscar(int[] nums, int x) {
                  int low = 0;
                  int high = nums.length - 1;
                  while (low <= high) {
                    int mid = (low + high) / 2;
                    if (nums[mid] == x) return mid;
                    if (nums[mid] < x) {
                      low = mid + 1;
                    } else {
                      high = mid - 1;
                    }
                  }
                  return -1;
                }
                """, questions: [
                TraceQuestion("Si nums = {1, 3, 5, 7, 9, 11} y x = 9, ¿qué devuelve la función?", emphasis: "nums = {1, 3, 5, 7, 9, 11} y x = 9",
                              answer: "4", wrong: ["3", "5", "-1"]),
                TraceQuestion("En el primer ciclo, ¿cuánto vale mid después de la línea marcada?", emphasis: "primer ciclo",
                              highlight: "int mid = (low + high) / 2;",
                              answer: "mid == 2", wrong: ["mid == 3", "mid == 2.5", "mid == 4"])
            ])
        ]
    )
}
