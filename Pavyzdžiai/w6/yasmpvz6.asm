; Įvesti 3 neneigiamus sveikus  skaičius nuo 0 iki 65535; 
; Atspausdinti didžiausią iš jų;
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

   mov ax, [sk1]
   mov bx, [sk2]
   call procMaxUInt16
   mov bx, [sk3]
   call procMaxUInt16
 
   macPutString crlf, ' Didziausias yra: $'    
   call procPutUInt16
   macNewLine    

   ; -------------------------------- Baigiame -----------------------------------
   exit 

; Pagalbinė procedūra: 
procMaxUInt16:
   ; išdėsto AX ir BX  didėjančiai:
   cmp ax, bx
   ja .pab
   xchg ax, bx
   .pab:
   ret

   
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


