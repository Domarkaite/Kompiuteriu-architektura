; Įsvesti du sveikus  skaičius; 
; Atspasdinti didesnį iš jų;
%include 'yasmmac.inc'          ; Pagalbiniai makrosai
;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 

   startas:                     ; nuo cia vykdomas kodas
   
   ; --------------------------------------------- Ivestis -------------
   macPutString 'Ivesk pirma skaiciu', crlf, '$'
   call procGetInt16
   mov [sk1], ax
   macNewLine 
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   macPutString 'Ivesk antra skaiciu', crlf, '$'
   call procGetInt16
   mov [sk2], ax
   macNewLine 
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 
   ; -------------------------------- Randame didesni ir spausdiname 10- taineje sistemoje -

   mov bx, [sk1]
   mov ax, [sk2]
   cmp ax, bx
   jge .rezultatas
   mov ax, bx
   
   .rezultatas: 
   macPutString crlf, ' Didesnis yra: $'    
   call procPutInt16
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
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


