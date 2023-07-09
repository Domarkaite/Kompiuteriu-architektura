; Pirma
;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 

   startas:                     ; nuo cia vykdomas kodas
   mov ah, 09
   mov dx, pranesimas
   int 0x21
   mov ah, 0x4c                  ; tiesiog bagiame
   int 0x21
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data                   ; duomenys

   pranesimas:
      db 'Tai pirmoji programa...$' 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


