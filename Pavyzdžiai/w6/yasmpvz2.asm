; Įvesti tekstinę eilutę iki 30 simbolių, pirmą ir trečią simbolius sukeisti vietomis
; Kompiliuojame (linux terminale): yasm yasmpvz2.asm -fbin -o yasmpvz2.com
; Paleidimas (dosbox terminale): yasmpvz2.com
;

;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 

   startas:                     ; nuo cia vykdomas kodas

   ; Išvedame pranešimą/prašymą įvesti:
   mov ah, 9
   mov dx, pranesimas1
   int 0x21
   
   ; Įvedame eilutę:
   mov ah, 0x0A
   mov dx, buferisIvedimui
   int 0x21

   ; Išvedame tuščią eilutę:
   mov ah, 9
   mov dx, naujaEilute
   int 0x21
 

   ; Atliekame nurodytą sukeitimą:
   mov al, [buferisIvedimui+2]           ; AL <- pirmas simbolis
   mov ah, [buferisIvedimui+4]           ; AH <- trečias simbolis
   mov [buferisIvedimui+2], ah           ; pirmas simbolis <- AH
   mov [buferisIvedimui+4], al           ; trečias simbolis <- AL


   ; Išvedame pranešimą apie atsakymą:
   mov ah, 9
   mov dx, pranesimas2
   int 0x21
   
   
   ; Koreguojame buferį taip, kad galima būtų panaudoti 9-ą funkciją ir išvedame gautą eilutę:
   mov bx,0
   mov bl, [buferisIvedimui+1]           ; bx <- kiek įvedėme baitų
   mov byte [buferisIvedimui+bx+3], 0x0a ; pridedame gale LF (CR jau ten yra) 
   mov byte [buferisIvedimui+bx+4], '$'  ; pridedame gale '$' tam, kad 9-ą funkcija galėtų atspausdinti  
   mov ah, 9
   mov dx, buferisIvedimui+2
   int 0x21
   
   ; Baigiame programą:
   mov ah, 0x4c                  ; tiesiog bagiame
   int 0x21
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data                   ; duomenys

   pranesimas1:
      db 'Ivesk teksto eilute... ', 0x0D, 0x0A, '$'

   pranesimas2:
      db 'Gavome tokia eilute: ', 0x0D, 0x0A, '$'

   naujaEilute:
      db 0x0D, 0x0A, '$'
      
   buferisIvedimui:
      db 0x20, 0x00, '*****************************************'
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


