//
//  SortingExerciseMock.swift
//  Algorithothm
//
//  Mock "aprende y arma" exercises, easy to medium, each one in Swift, Python and Java.
//  The front shows a solved example; the back asks for a similar function where the user
//  orders the blocks inside the loop. The first block is given as a hint.
//
//  Rules for the blocks, so the check (exact order) is fair:
//  - written without the loop's indentation, LoopSolution adds it (2 spaces per level)
//  - only one order is right: each block depends on the one before it
//  - lines up to 42 characters on the back and 39 on the front, so they fit the monitor
//

import Foundation

extension SortingExercise {

    /// From easier to harder.
    static let all: [SortingExercise] = [
        evenWords, secondLargest, climbingStairs, reverseArray, fizzBuzz,
        mostFrequent, twoSum, pivotIndex, searchInsert, maxSubarray
    ]

    // MARK: 1. Filter evens

    static let evenWords = SortingExercise(
        id: "even-words",
        title: "Filtrar pares",
        explanation: "Esta función devuelve solo los números pares de un arreglo. La condición marcada es el corazón del código: deja pasar únicamente los números cuyo resto al dividir entre 2 es 0.",
        variants: [
            SortingVariant(
                .swift,
                example: """
                func soloPares(
                  _ nums: [Int]) -> [Int] {
                  var newArray = [Int]()
                  for num in nums {
                    if num % 2 == 0 {
                      newArray.append(num)
                    }
                  }
                  return newArray
                }
                """,
                highlight: "if num % 2 == 0 {",
                setup: """
                func procesarPalabras(
                  _ palabras: [String]
                ) -> [String] {
                  var newArray = [String]()
                  for palabra in palabras {
                """,
                loopBody: [
                    "if palabra.count % 2 == 0 {",
                    "  let newWord = palabra.uppercased()",
                    "  newArray.append(newWord)\n} else {",
                    "  newArray.append(palabra)\n}"
                ],
                ending: """
                  }
                  return newArray.sorted()
                }
                """
            ),
            SortingVariant(
                .python,
                example: """
                def solo_pares(nums):
                  nuevo = []
                  for num in nums:
                    if num % 2 == 0:
                      nuevo.append(num)
                  return nuevo
                """,
                highlight: "if num % 2 == 0:",
                setup: """
                def procesar_palabras(palabras):
                  nuevo = []
                  for palabra in palabras:
                """,
                loopBody: [
                    "if len(palabra) % 2 == 0:",
                    "  nueva = palabra.upper()",
                    "  nuevo.append(nueva)\nelse:",
                    "  nuevo.append(palabra)"
                ],
                ending: """
                  return sorted(nuevo)
                """
            ),
            SortingVariant(
                .java,
                example: """
                List<Integer> soloPares(
                    List<Integer> nums) {
                  List<Integer> nuevo =
                      new ArrayList<>();
                  for (int num : nums) {
                    if (num % 2 == 0) {
                      nuevo.add(num);
                    }
                  }
                  return nuevo;
                }
                """,
                highlight: "if (num % 2 == 0) {",
                setup: """
                List<String> procesarPalabras(
                    List<String> palabras) {
                  List<String> nuevo =
                      new ArrayList<>();
                  for (String p : palabras) {
                """,
                loopBody: [
                    "if (p.length() % 2 == 0) {",
                    "  String grande = p.toUpperCase();",
                    "  nuevo.add(grande);\n} else {",
                    "  nuevo.add(p);\n}"
                ],
                ending: """
                  }
                  Collections.sort(nuevo);
                  return nuevo;
                }
                """
            )
        ]
    )

    // MARK: 2. Second largest

    static let secondLargest = SortingExercise(
        id: "second-largest",
        title: "Segundo mayor",
        explanation: "Esta función recorre el arreglo guardando el número más grande que ha visto. La condición marcada compara cada número con el mayor actual y, si es más grande, lo reemplaza.",
        variants: [
            SortingVariant(
                .swift,
                example: """
                func mayor(_ nums: [Int]) -> Int {
                  var mayor = nums[0]
                  for n in nums {
                    if n > mayor {
                      mayor = n
                    }
                  }
                  return mayor
                }
                """,
                highlight: "if n > mayor {",
                setup: """
                func segundoMayor(
                  _ nums: [Int]
                ) -> Int {
                  var primero = Int.min
                  var segundo = Int.min
                  for n in nums {
                """,
                loopBody: [
                    "if n > primero {",
                    "  segundo = primero",
                    "  primero = n\n} else if n > segundo {",
                    "  segundo = n\n}"
                ],
                ending: """
                  }
                  return segundo
                }
                """
            ),
            SortingVariant(
                .python,
                example: """
                def mayor(nums):
                  mayor = nums[0]
                  for n in nums:
                    if n > mayor:
                      mayor = n
                  return mayor
                """,
                highlight: "if n > mayor:",
                setup: """
                def segundo_mayor(nums):
                  primero = float("-inf")
                  segundo = float("-inf")
                  for n in nums:
                """,
                loopBody: [
                    "if n > primero:",
                    "  segundo = primero",
                    "  primero = n\nelif n > segundo:",
                    "  segundo = n"
                ],
                ending: """
                  return segundo
                """
            ),
            SortingVariant(
                .java,
                example: """
                int mayor(int[] nums) {
                  int mayor = nums[0];
                  for (int n : nums) {
                    if (n > mayor) {
                      mayor = n;
                    }
                  }
                  return mayor;
                }
                """,
                highlight: "if (n > mayor) {",
                setup: """
                int segundoMayor(int[] nums) {
                  int primero = Integer.MIN_VALUE;
                  int segundo = Integer.MIN_VALUE;
                  for (int n : nums) {
                """,
                loopBody: [
                    "if (n > primero) {",
                    "  segundo = primero;",
                    "  primero = n;\n} else if (n > segundo) {",
                    "  segundo = n;\n}"
                ],
                ending: """
                  }
                  return segundo;
                }
                """
            )
        ]
    )

    // MARK: 3. Climbing stairs

    static let climbingStairs = SortingExercise(
        id: "climbing-stairs",
        title: "Subir escaleras",
        explanation: "Esta función calcula el n-ésimo número de Fibonacci sin recursión. Solo guarda los dos últimos valores y la línea marcada los suma para obtener el siguiente.",
        variants: [
            SortingVariant(
                .swift,
                example: """
                func fibonacci(_ n: Int) -> Int {
                  var a = 0
                  var b = 1
                  for _ in 0..<n {
                    let siguiente = a + b
                    a = b
                    b = siguiente
                  }
                  return a
                }
                """,
                highlight: "let siguiente = a + b",
                setup: """
                func formasDeSubir(_ n: Int) -> Int {
                  // pasos de 1, 2 o 3 escalones
                  var a = 0
                  var b = 0
                  var c = 1
                  for _ in 0..<n {
                """,
                loopBody: [
                    "let total = a + b + c",
                    "a = b",
                    "b = c",
                    "c = total"
                ],
                ending: """
                  }
                  return c
                }
                """
            ),
            SortingVariant(
                .python,
                example: """
                def fibonacci(n):
                  a, b = 0, 1
                  for _ in range(n):
                    siguiente = a + b
                    a = b
                    b = siguiente
                  return a
                """,
                highlight: "siguiente = a + b",
                setup: """
                def formas_de_subir(n):
                  # pasos de 1, 2 o 3 escalones
                  a, b, c = 0, 0, 1
                  for _ in range(n):
                """,
                loopBody: [
                    "total = a + b + c",
                    "a = b",
                    "b = c",
                    "c = total"
                ],
                ending: """
                  return c
                """
            ),
            SortingVariant(
                .java,
                example: """
                int fibonacci(int n) {
                  int a = 0;
                  int b = 1;
                  for (int i = 0; i < n; i++) {
                    int siguiente = a + b;
                    a = b;
                    b = siguiente;
                  }
                  return a;
                }
                """,
                highlight: "int siguiente = a + b;",
                setup: """
                int formasDeSubir(int n) {
                  // pasos de 1, 2 o 3 escalones
                  int a = 0, b = 0, c = 1;
                  for (int i = 0; i < n; i++) {
                """,
                loopBody: [
                    "int total = a + b + c;",
                    "a = b;",
                    "b = c;",
                    "c = total;"
                ],
                ending: """
                  }
                  return c;
                }
                """
            )
        ]
    )

    // MARK: 4. Reverse an array

    static let reverseArray = SortingExercise(
        id: "reverse-array",
        title: "Invertir arreglo",
        explanation: "Esta función revisa si un texto es un palíndromo. Usa dos punteros, uno al inicio y otro al final, y la línea marcada los hace avanzar uno hacia el otro mientras no se crucen.",
        variants: [
            SortingVariant(
                .swift,
                example: """
                func esPalindromo(
                  _ texto: String
                ) -> Bool {
                  let letras = Array(texto)
                  var i = 0
                  var j = letras.count - 1
                  while i < j {
                    if letras[i] != letras[j] {
                      return false
                    }
                    i += 1
                    j -= 1
                  }
                  return true
                }
                """,
                highlight: "while i < j {",
                setup: """
                func invertir(_ nums: [Int]) -> [Int] {
                  var arr = nums
                  var izq = 0
                  var der = arr.count - 1
                  while izq < der {
                """,
                loopBody: [
                    "let temp = arr[izq]",
                    "arr[izq] = arr[der]",
                    "arr[der] = temp",
                    "izq += 1\nder -= 1"
                ],
                ending: """
                  }
                  return arr
                }
                """
            ),
            SortingVariant(
                .python,
                example: """
                def es_palindromo(texto):
                  i, j = 0, len(texto) - 1
                  while i < j:
                    if texto[i] != texto[j]:
                      return False
                    i += 1
                    j -= 1
                  return True
                """,
                highlight: "while i < j:",
                setup: """
                def invertir(arr):
                  izq, der = 0, len(arr) - 1
                  while izq < der:
                """,
                loopBody: [
                    "temp = arr[izq]",
                    "arr[izq] = arr[der]",
                    "arr[der] = temp",
                    "izq += 1\nder -= 1"
                ],
                ending: """
                  return arr
                """
            ),
            SortingVariant(
                .java,
                example: """
                boolean esPalindromo(String texto) {
                  int i = 0;
                  int j = texto.length() - 1;
                  while (i < j) {
                    if (texto.charAt(i) !=
                        texto.charAt(j)) {
                      return false;
                    }
                    i++;
                    j--;
                  }
                  return true;
                }
                """,
                highlight: "while (i < j) {",
                setup: """
                int[] invertir(int[] arr) {
                  int izq = 0;
                  int der = arr.length - 1;
                  while (izq < der) {
                """,
                loopBody: [
                    "int temp = arr[izq];",
                    "arr[izq] = arr[der];",
                    "arr[der] = temp;",
                    "izq++;\nder--;"
                ],
                ending: """
                  }
                  return arr;
                }
                """
            )
        ]
    )

    // MARK: 5. FizzBuzz

    static let fizzBuzz = SortingExercise(
        id: "fizz-buzz",
        title: "FizzBuzz",
        explanation: "Esta función clasifica un número como positivo, negativo o cero. Las condiciones se revisan en orden y la línea marcada solo se evalúa si la primera no se cumplió.",
        variants: [
            SortingVariant(
                .swift,
                example: """
                func clasificar(_ n: Int) -> String {
                  if n > 0 {
                    return "positivo"
                  } else if n < 0 {
                    return "negativo"
                  } else {
                    return "cero"
                  }
                }
                """,
                highlight: "} else if n < 0 {",
                setup: """
                func fizzBuzz(_ n: Int) -> [String] {
                  var r = [String]()
                  for i in 1...n {
                """,
                loopBody: [
                    "if i % 15 == 0 {",
                    "  r.append(\"FizzBuzz\")\n} else if i % 3 == 0 {",
                    "  r.append(\"Fizz\")\n} else if i % 5 == 0 {",
                    "  r.append(\"Buzz\")\n} else {",
                    "  r.append(String(i))\n}"
                ],
                ending: """
                  }
                  return r
                }
                """
            ),
            SortingVariant(
                .python,
                example: """
                def clasificar(n):
                  if n > 0:
                    return "positivo"
                  elif n < 0:
                    return "negativo"
                  else:
                    return "cero"
                """,
                highlight: "elif n < 0:",
                setup: """
                def fizz_buzz(n):
                  r = []
                  for i in range(1, n + 1):
                """,
                loopBody: [
                    "if i % 15 == 0:",
                    "  r.append(\"FizzBuzz\")\nelif i % 3 == 0:",
                    "  r.append(\"Fizz\")\nelif i % 5 == 0:",
                    "  r.append(\"Buzz\")\nelse:",
                    "  r.append(str(i))"
                ],
                ending: """
                  return r
                """
            ),
            SortingVariant(
                .java,
                example: """
                String clasificar(int n) {
                  if (n > 0) {
                    return "positivo";
                  } else if (n < 0) {
                    return "negativo";
                  } else {
                    return "cero";
                  }
                }
                """,
                highlight: "} else if (n < 0) {",
                setup: """
                List<String> fizzBuzz(int n) {
                  List<String> r = new ArrayList<>();
                  for (int i = 1; i <= n; i++) {
                """,
                loopBody: [
                    "if (i % 15 == 0) {",
                    "  r.add(\"FizzBuzz\");\n} else if (i % 3 == 0) {",
                    "  r.add(\"Fizz\");\n} else if (i % 5 == 0) {",
                    "  r.add(\"Buzz\");\n} else {",
                    "  r.add(String.valueOf(i));\n}"
                ],
                ending: """
                  }
                  return r;
                }
                """
            )
        ]
    )

    // MARK: 6. Most frequent

    static let mostFrequent = SortingExercise(
        id: "most-frequent",
        title: "El más frecuente",
        explanation: "Esta función cuenta cuántas veces aparece cada letra de un texto. La línea marcada suma 1 al contador de la letra actual; si la letra aún no estaba, empieza desde 0.",
        variants: [
            SortingVariant(
                .swift,
                example: """
                func contarLetras(
                  _ texto: String
                ) -> [Character: Int] {
                  var conteo = [Character: Int]()
                  for letra in texto {
                    conteo[letra, default: 0] += 1
                  }
                  return conteo
                }
                """,
                highlight: "conteo[letra, default: 0] += 1",
                setup: """
                func masFrecuente(
                  _ nums: [Int]
                ) -> Int {
                  var conteo = [Int: Int]()
                  var maximo = 0
                  var resultado = nums[0]
                  for n in nums {
                """,
                loopBody: [
                    "conteo[n, default: 0] += 1",
                    "let veces = conteo[n]!",
                    "if veces > maximo {",
                    "  maximo = veces\n  resultado = n\n}"
                ],
                ending: """
                  }
                  return resultado
                }
                """
            ),
            SortingVariant(
                .python,
                example: """
                def contar_letras(texto):
                  conteo = {}
                  for c in texto:
                    conteo[c] = conteo.get(c, 0) + 1
                  return conteo
                """,
                highlight: "conteo[c] = conteo.get(c, 0) + 1",
                setup: """
                def mas_frecuente(nums):
                  conteo = {}
                  maximo = 0
                  resultado = nums[0]
                  for n in nums:
                """,
                loopBody: [
                    "conteo[n] = conteo.get(n, 0) + 1",
                    "veces = conteo[n]",
                    "if veces > maximo:",
                    "  maximo = veces\n  resultado = n"
                ],
                ending: """
                  return resultado
                """
            ),
            SortingVariant(
                .java,
                example: """
                Map<Character, Integer> contar(
                    String texto) {
                  Map<Character, Integer> conteo =
                      new HashMap<>();
                  for (char c : texto.toCharArray()) {
                    conteo.merge(c, 1, Integer::sum);
                  }
                  return conteo;
                }
                """,
                highlight: "conteo.merge(c, 1, Integer::sum);",
                setup: """
                int masFrecuente(int[] nums) {
                  Map<Integer, Integer> conteo =
                      new HashMap<>();
                  int maximo = 0;
                  int resultado = nums[0];
                  for (int n : nums) {
                """,
                loopBody: [
                    "conteo.merge(n, 1, Integer::sum);",
                    "int veces = conteo.get(n);",
                    "if (veces > maximo) {",
                    "  maximo = veces;\n  resultado = n;\n}"
                ],
                ending: """
                  }
                  return resultado;
                }
                """
            )
        ]
    )

    // MARK: 7. Two Sum

    static let twoSum = SortingExercise(
        id: "two-sum",
        title: "Dos sumas",
        explanation: "Esta función revisa si un arreglo tiene números repetidos. Guarda cada número en un conjunto y la condición marcada pregunta si ya lo había visto antes: si es así, encontró un duplicado.",
        variants: [
            SortingVariant(
                .swift,
                example: """
                func hayDuplicados(
                  _ nums: [Int]
                ) -> Bool {
                  var vistos = Set<Int>()
                  for n in nums {
                    if vistos.contains(n) {
                      return true
                    }
                    vistos.insert(n)
                  }
                  return false
                }
                """,
                highlight: "if vistos.contains(n) {",
                setup: """
                func dosSuma(
                  _ nums: [Int], _ objetivo: Int
                ) -> [Int] {
                  var vistos = [Int: Int]()
                  for (i, n) in nums.enumerated() {
                """,
                loopBody: [
                    "let falta = objetivo - n",
                    "if let j = vistos[falta] {",
                    "  return [j, i]\n}",
                    "vistos[n] = i"
                ],
                ending: """
                  }
                  return []
                }
                """
            ),
            SortingVariant(
                .python,
                example: """
                def hay_duplicados(nums):
                  vistos = set()
                  for n in nums:
                    if n in vistos:
                      return True
                    vistos.add(n)
                  return False
                """,
                highlight: "if n in vistos:",
                setup: """
                def dos_suma(nums, objetivo):
                  vistos = {}
                  for i, n in enumerate(nums):
                """,
                loopBody: [
                    "falta = objetivo - n",
                    "if falta in vistos:",
                    "  return [vistos[falta], i]",
                    "vistos[n] = i"
                ],
                ending: """
                  return []
                """
            ),
            SortingVariant(
                .java,
                example: """
                boolean hayDuplicados(int[] nums) {
                  Set<Integer> vistos =
                      new HashSet<>();
                  for (int n : nums) {
                    if (vistos.contains(n)) {
                      return true;
                    }
                    vistos.add(n);
                  }
                  return false;
                }
                """,
                highlight: "if (vistos.contains(n)) {",
                setup: """
                int[] dosSuma(
                    int[] nums, int objetivo) {
                  Map<Integer, Integer> vistos =
                      new HashMap<>();
                  for (int i = 0; i < nums.length; i++) {
                """,
                loopBody: [
                    "int falta = objetivo - nums[i];",
                    "if (vistos.containsKey(falta)) {",
                    "  int j = vistos.get(falta);\n  return new int[] {j, i};\n}",
                    "vistos.put(nums[i], i);"
                ],
                ending: """
                  }
                  return new int[0];
                }
                """
            )
        ]
    )

    // MARK: 8. Pivot index

    static let pivotIndex = SortingExercise(
        id: "pivot-index",
        title: "Índice pivote",
        explanation: "Esta función devuelve la suma acumulada de un arreglo: cada posición guarda la suma de todos los números hasta ese punto. La línea marcada va sumando cada número al total.",
        variants: [
            SortingVariant(
                .swift,
                example: """
                func sumaAcumulada(
                  _ nums: [Int]
                ) -> [Int] {
                  var total = 0
                  var resultado = [Int]()
                  for n in nums {
                    total += n
                    resultado.append(total)
                  }
                  return resultado
                }
                """,
                highlight: "total += n",
                setup: """
                func indicePivote(
                  _ nums: [Int]
                ) -> Int {
                  let total = nums.reduce(0, +)
                  var izquierda = 0
                  for (i, n) in nums.enumerated() {
                """,
                loopBody: [
                    "let derecha = total - izquierda - n",
                    "if izquierda == derecha {",
                    "  return i\n}",
                    "izquierda += n"
                ],
                ending: """
                  }
                  return -1
                }
                """
            ),
            SortingVariant(
                .python,
                example: """
                def suma_acumulada(nums):
                  total = 0
                  resultado = []
                  for n in nums:
                    total += n
                    resultado.append(total)
                  return resultado
                """,
                highlight: "total += n",
                setup: """
                def indice_pivote(nums):
                  total = sum(nums)
                  izquierda = 0
                  for i, n in enumerate(nums):
                """,
                loopBody: [
                    "derecha = total - izquierda - n",
                    "if izquierda == derecha:",
                    "  return i",
                    "izquierda += n"
                ],
                ending: """
                  return -1
                """
            ),
            SortingVariant(
                .java,
                example: """
                int[] sumaAcumulada(int[] nums) {
                  int n = nums.length;
                  int[] resultado = new int[n];
                  int total = 0;
                  for (int i = 0; i < n; i++) {
                    total += nums[i];
                    resultado[i] = total;
                  }
                  return resultado;
                }
                """,
                highlight: "total += nums[i];",
                setup: """
                int indicePivote(int[] nums) {
                  int total = 0;
                  for (int n : nums) total += n;
                  int izq = 0;
                  for (int i = 0; i < nums.length; i++) {
                """,
                loopBody: [
                    "int der = total - izq - nums[i];",
                    "if (izq == der) {",
                    "  return i;\n}",
                    "izq += nums[i];"
                ],
                ending: """
                  }
                  return -1;
                }
                """
            )
        ]
    )

    // MARK: 9. Search insert position

    static let searchInsert = SortingExercise(
        id: "search-insert",
        title: "Posición de inserción",
        explanation: "Esta función busca un número en un arreglo ordenado partiéndolo a la mitad en cada paso. La línea marcada calcula el centro del rango que todavía queda por revisar.",
        variants: [
            SortingVariant(
                .swift,
                example: """
                func buscar(
                  _ nums: [Int], _ objetivo: Int
                ) -> Int? {
                  var low = 0
                  var high = nums.count - 1
                  while low <= high {
                    let mid = (low + high) / 2
                    if nums[mid] == objetivo {
                      return mid
                    }
                    if nums[mid] < objetivo {
                      low = mid + 1
                    } else {
                      high = mid - 1
                    }
                  }
                  return nil
                }
                """,
                highlight: "let mid = (low + high) / 2",
                setup: """
                func posicion(
                  _ nums: [Int], _ objetivo: Int
                ) -> Int {
                  var low = 0
                  var high = nums.count - 1
                  while low <= high {
                """,
                loopBody: [
                    "let mid = (low + high) / 2",
                    "if nums[mid] == objetivo {\n  return mid",
                    "} else if nums[mid] < objetivo {\n  low = mid + 1",
                    "} else {\n  high = mid - 1\n}"
                ],
                ending: """
                  }
                  return low
                }
                """
            ),
            SortingVariant(
                .python,
                example: """
                def buscar(nums, objetivo):
                  low, high = 0, len(nums) - 1
                  while low <= high:
                    mid = (low + high) // 2
                    if nums[mid] == objetivo:
                      return mid
                    if nums[mid] < objetivo:
                      low = mid + 1
                    else:
                      high = mid - 1
                  return None
                """,
                highlight: "mid = (low + high) // 2",
                setup: """
                def posicion(nums, objetivo):
                  low, high = 0, len(nums) - 1
                  while low <= high:
                """,
                loopBody: [
                    "mid = (low + high) // 2",
                    "if nums[mid] == objetivo:\n  return mid",
                    "elif nums[mid] < objetivo:\n  low = mid + 1",
                    "else:\n  high = mid - 1"
                ],
                ending: """
                  return low
                """
            ),
            SortingVariant(
                .java,
                example: """
                int buscar(int[] nums, int objetivo) {
                  int low = 0;
                  int high = nums.length - 1;
                  while (low <= high) {
                    int mid = (low + high) / 2;
                    if (nums[mid] == objetivo) {
                      return mid;
                    }
                    if (nums[mid] < objetivo) {
                      low = mid + 1;
                    } else {
                      high = mid - 1;
                    }
                  }
                  return -1;
                }
                """,
                highlight: "int mid = (low + high) / 2;",
                setup: """
                int posicion(int[] nums, int objetivo) {
                  int low = 0;
                  int high = nums.length - 1;
                  while (low <= high) {
                """,
                loopBody: [
                    "int mid = (low + high) / 2;",
                    "if (nums[mid] == objetivo) {\n  return mid;",
                    "} else if (nums[mid] < objetivo) {\n  low = mid + 1;",
                    "} else {\n  high = mid - 1;\n}"
                ],
                ending: """
                  }
                  return low;
                }
                """
            )
        ]
    )

    // MARK: 10. Maximum subarray

    static let maxSubarray = SortingExercise(
        id: "max-subarray",
        title: "Subarreglo máximo",
        explanation: "Esta función encuentra la mejor ganancia comprando y vendiendo una acción una sola vez. Recuerda el precio más bajo visto hasta ahora y la línea marcada calcula cuánto se ganaría vendiendo hoy.",
        variants: [
            SortingVariant(
                .swift,
                example: """
                func mejorGanancia(
                  _ precios: [Int]
                ) -> Int {
                  var minimo = Int.max
                  var mejor = 0
                  for p in precios {
                    minimo = min(minimo, p)
                    mejor = max(mejor, p - minimo)
                  }
                  return mejor
                }
                """,
                highlight: "mejor = max(mejor, p - minimo)",
                setup: """
                func sumaMaxima(
                  _ nums: [Int]
                ) -> Int {
                  var actual = 0
                  var mejor = Int.min
                  for n in nums {
                """,
                loopBody: [
                    "actual += n",
                    "if actual > mejor {\n  mejor = actual\n}",
                    "if actual < 0 {\n  actual = 0\n}"
                ],
                ending: """
                  }
                  return mejor
                }
                """
            ),
            SortingVariant(
                .python,
                example: """
                def mejor_ganancia(precios):
                  minimo = float("inf")
                  mejor = 0
                  for p in precios:
                    minimo = min(minimo, p)
                    mejor = max(mejor, p - minimo)
                  return mejor
                """,
                highlight: "mejor = max(mejor, p - minimo)",
                setup: """
                def suma_maxima(nums):
                  actual = 0
                  mejor = float("-inf")
                  for n in nums:
                """,
                loopBody: [
                    "actual += n",
                    "if actual > mejor:\n  mejor = actual",
                    "if actual < 0:\n  actual = 0"
                ],
                ending: """
                  return mejor
                """
            ),
            SortingVariant(
                .java,
                example: """
                int mejorGanancia(int[] precios) {
                  int bajo = Integer.MAX_VALUE;
                  int mejor = 0;
                  for (int p : precios) {
                    bajo = Math.min(bajo, p);
                    mejor = Math.max(mejor, p - bajo);
                  }
                  return mejor;
                }
                """,
                highlight: "mejor = Math.max(mejor, p - bajo);",
                setup: """
                int sumaMaxima(int[] nums) {
                  int actual = 0;
                  int mejor = Integer.MIN_VALUE;
                  for (int n : nums) {
                """,
                loopBody: [
                    "actual += n;",
                    "if (actual > mejor) {\n  mejor = actual;\n}",
                    "if (actual < 0) {\n  actual = 0;\n}"
                ],
                ending: """
                  }
                  return mejor;
                }
                """
            )
        ]
    )
}
