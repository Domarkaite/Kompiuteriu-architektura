; Įvesti tekstinę eilutę iki 30 simbolių, pirmą ir trečią simbolius sukeisti vietomis
; Kompiliuojame (linux terminale): yasm yasmpvz1.asm -fbin -o yasmpvz1.com
; Paleidimas (dosbox terminale): yasmpvz1.com
;

;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 

   startas:                     ; nuo cia vykdomas kodas

   ; Išvedame pranešimą:
   mov ah, 9
   mov dx, pranesimas
   int 0x21
   
   mov ah, 9
   mov dx, naujaEilute
   int 0x21
 
   ; Baigiame programą:
   mov ah, 0x4c                  ; tiesiog bagiame
   int 0x21
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data                   ; duomenys

   pranesimas:
      db 'Labas, tai pirmoji YASM programa ...$'

   naujaEilute:
      db 0x0D, 0x0A, '$'
    
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


