#lang racket
;;Gamaliel Marines Olvera A01708746 -Jose Ricardo Rosales A01709449
;; ejercicio 1
;; funcion 'insert', numero,lista -> lista
(define (insert n lst)
  (cond ((null? lst) (list n))
        ((< n (car lst)) (cons n lst))
        (else (cons (car lst) (insert n (cdr lst))))))

(insert 4 '(5 6 7 8))
(insert 5 '(1 3 6 7 9 16))

;; ejercicio 2
;; funcion 'insert-sort' lista -> lista ordenada
(define (insert-sort lst)
  (define (insert n lst)
    (cond ((null? lst) (list n))
          ((< n (car lst)) (cons n lst))
          (else (cons (car lst) (insert n (cdr lst))))))

  (if (null? lst)
      '()
      (insert (car lst) (insert-sort (cdr lst)))))

(insert-sort '(4 3 6 8 3 0 9 1 7))

;; ejercicio 3
;; funcion 'rotate-left' numero, lista -> lista
(define (rotate-left n lst)
  (let ((n (modulo n (length lst))))
    (if (zero? n)
        lst
        (append (drop lst n) (take lst n)))))

(rotate-left 1 '(a b c d e f g))

(rotate-left -1 '(a b c d e f g))


;; ejercicio 4
;; funcion 'prime-factors' numero -> numero(s)
(define (prime-factors n)
  (let loop ((n n) (f 2) (factors '()))
    (cond ((<= n 1) factors)
          ((zero? (modulo n f)) (loop (/ n f) f (cons f factors)))
          (else (loop n (+ f 1) factors)))))

(prime-factors 96)

;; ejercicio 5
;; funcion 'gcd' numero, numero -> numero
(define (gcd a b)
  (let loop ((a a) (b b))
    (if (= b 0)
        a
        (loop b (modulo a b)))))

(gcd 42 56)


;; ejercicio 6
;; funcion 'deep-reverse' lista(s) -> lista(s)
(define (deep-reverse lst)
  (let deep-reverse-helper ((lst lst) (result '()))
    (cond ((null? lst) result)
          ((list? (car lst)) (deep-reverse-helper (cdr lst) (cons (deep-reverse (car lst)) result)))
          (else (deep-reverse-helper (cdr lst) (cons (car lst) result))))))

(deep-reverse '(a (b (c (d (e (f (g (h i j)))))))))


;; ejercicio 7
;; funcion 'insert-anywhere' objeto, lista -> lista de listas
(define (insert-anywhere x lst)
  (cond ((null? lst) (list (list x)))
        ((cons? lst)
         (append (list (cons x lst))
                 (map (lambda (l) (cons (car lst) l))
                      (insert-anywhere x (cdr lst)))))))

(insert-anywhere 'x '(1 2 3 4 5 6 7 8 9 10))


;; ejercicio 8
;; funcion 'packed' lista -> lista
(define (pack lst)
  (if (null? lst)
      '()
      (let ((first (car lst)))
        (let ((packed (pack (cdr lst))))
          (if (null? packed)
              (list (list first))
              (if (eq? first (caar packed))
                  (cons (cons first (car packed)) (cdr packed))
                  (cons (list first) packed)))))))



(pack '(a a a a b c c a a d e e e e))
(pack '())


;; ejercicio 9
;; funcion 'compressed' lista -> lista
(define (compress lst)
  (if (null? lst)
      '()
      (let ((first (car lst)))
        (let ((compressed (compress (cdr lst))))
          (if (null? compressed)
              (list first)
              (if (eq? first (car compressed))
                  compressed
                  (cons first compressed)))))))

(compress '(a a a a b c c a a d e e e e))


;10.- encode (codifica una lista)
; (encode '(a a a a b c c a a d e e e e)) -> '((4 a) (1 b) (2 c) (2 a) (1 d) (4 e))
(define (encode lst)
  (define (helper lst res)
    (cond
      ((null? lst) res)
      ((= (length lst) 1) (helper '() (append res (list (car lst)))))
      (else (let loop ((acc 1) (curr (car lst)) (rest (cdr lst)))
              (cond
                ((null? rest) (helper '() (append res (list (list acc curr)))))
                ((eq? curr (car rest)) (loop (+ acc 1) curr (cdr rest)))
                (else (helper rest (append res (list (list acc curr))))))))))

  (helper lst '()))
(encode '(a a a a b c c a a d e e e e))

;11.- encode-mod (solo codifica los elementos que se repiten)
; (encode-mod '(a a a a b c c a a d e e e e)) -> '((4 . a) b c (2 . a) d (4 . e))
(define (encode-modified lst)
  (define (helper lst current count acc)
    (cond
      ((null? lst) (reverse (cons (if (> count 1) (list count current) current) acc)))
      ((eq? current (car lst)) (helper (cdr lst) current (add1 count) acc))
      (else (helper (cdr lst) (car lst) 1 (cons (if (> count 1) (list count current) current) acc)))))
  (helper (cdr lst) (car lst) 1 '()))
(encode-modified '(a a a a b c c a a d e e e e))

; 12.- decode (decodifica una lista de listas)
; (decode '((4 a) b (2 c) (2 a) d (4 e))) -> '(a a a a b c c a a d e e e e)
(define (decode lst)
  (cond ((null? lst) '())
        ((not (pair? (car lst))) (cons (car lst) (decode (cdr lst))))
        (else (append (make-list (caar lst) (cadar lst))
                      (decode (cdr lst))))))
(decode '((4 a) b (2 c) (2 a) d (4 e)))

;13.- args-swap (intercambia los argumentos de una lista)
; (args-swap list 1 2) -> '(2 1)
(define (args-swap f)
  (lambda (x y)
    (f y x)))
((args-swap list) 1 2)

;14.- there-exists-one? (existe un elemento que cumpla con la condicion)
; (there-exists-one? positive? '(-1 -10 4 -5 -2 -1)) -> #t
(define (there-exists-one? pred lst)
  (= (length (filter pred lst)) 1))
(there-exists-one? positive? '(-1 -10 4 -5 -2 -1))


;15.- linear-search (busqueda lineal)
; (linear-search '(48 77 30 31 5 20 91 92 69 97 28 32 17 18 96) 5 =) -> 4
(define (linear-search lst x eq-fun)
  (let loop ((lst lst) (i 0))
    (cond ((null? lst) #f)
          ((eq-fun (car lst) x) i)
          (else (loop (cdr lst) (+ i 1))))))
(linear-search '(48 77 30 31 5 20 91 92 69 97 28 32 17 18 96) 5 =)

;16.- deriv (derivada de una funcion)
;(df 5) -> 75.015
(define (deriv f h)
  (lambda (x)
    (/ (- (f (+ x h)) (f x))
       h)))
(define f (lambda (x) (* x x x)))
(define df (deriv f 0.001))
(define ddf (deriv df 0.001))
(define dddf (deriv ddf 0.001))
(df 5)

;17 newton (metodo de newton para encontrar raices)
; (newton (lambda (x) (- x 10)) 1) -> 10
(define (newton f guess)
  (define df (deriv f 0.001))
  (define ddf (deriv df 0.001))
  (define dddf (deriv ddf 0.001))
  (define (newton-helper guess)
    (let ((x (- guess (/ (f guess) (df guess)))))
      (if (< (abs (- x guess)) 0.001)
          x
          (newton-helper x))))
  (newton-helper guess));
(newton (lambda (x) (- x 10)) 1)

;18 integral (integral de una funcion usando simpson)
; (integral 0 1 10 (lambda (x) (* x x x))) -> 0.25
(define (integral a b n f)
    (define h (/ (- b a) n))
    (define (simpson-helper i acc)
      (if (= i n)
          acc
            (simpson-helper (+ i 1) (+ acc (* (f (+ a (* i h))) (if (= (modulo i 2) 0) 2 4))))))
    (* (/ h 3) (+ (f a) (f b) (simpson-helper 1 0))))
(integral 0 1 10 (lambda (x) (* x x x)))


