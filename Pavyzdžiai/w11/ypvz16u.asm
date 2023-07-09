; 
; Naudojame ypvz16

;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 

   startas:                     ; nuo cia vykdomas kodas
   mov ah, 09
   mov dx, pranesimas
   int 0x21
   int 0x88
   mov ah, 0x4c                  ; tiesiog bagiame
   int 0x21
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data                   ; duomenys

   pranesimas:
      db 'Labas, bandome naudoti int 0x88... ', 0x0D, 0x0A, '$'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


