; Įvesti 3 neneigiamus sveikus  skaičius nuo 0 iki 65535; 
; Atspausdinti jų sumą;
; Į galimą perpildymą dėmesio nekreipti 
%include 'yasmmac.inc'          ; Pagalbiniai makrosai
;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 

   startas:                     ; nuo cia vykdomas kodas
   
   ; --------------------------------------------- Ivestis -------------
   macPutString 'Ivesk pirma skaiciu', crlf, '$'
   call procGetUInt16
   mov [sk1], ax
   macNewLine 

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   macPutString 'Ivesk antra skaiciu', crlf, '$'
   call procGetUInt16
   mov [sk2], ax
   macNewLine 
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   macPutString 'Ivesk trecia skaiciu', crlf, '$'
   call procGetUInt16
   mov [sk3], ax
   macNewLine 
   
 
   ; -------------------------------- Randame didesni ir spausdiname 10- taineje sistemoje -

   add ax, [sk1]
   add ax, [sk2]
 
   macPutString crlf, ' Suma yra: $'    
   call procPutUInt16
   macNewLine    

   ; -------------------------------- Baigiame -----------------------------------
   exit 

   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%include 'yasmlib.asm'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



section .data                   ; duomenys

 sk1:
    dw 00
 sk2:
    dw 00
 sk3:
    dw 00
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


