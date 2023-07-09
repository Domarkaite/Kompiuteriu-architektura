; Įvesti 3 neneigiamus sveikus  skaičius nuo 0 iki 65535; 
; Parašyti  procedūrą (funkciją), kuri randa jų paskutiniųjų skaitmenų sumą
; Procedūros parametrus perduoti per steką pagal reikšmę

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
   push word [sk3]
   push word [sk2]
   push word [sk1]
   call paskutiniuSkaitmenuSuma

   macPutString crlf, ' Paskutiniu suma yra: $'    
   call procPutUInt16
   macNewLine    

   ; -------------------------------- Baigiame -----------------------------------
   exit 

; Pagalbinė procedūra: 
paskutiniuSkaitmenuSuma:
   ; C prototipas:
   ; uint16  paskutiniuSkaitmenuSuma(uint16 sk1, uint16 sk2, uint16 sk3)
   push bp
   mov bp, sp
   sub sp, 2            ; čia saugosime tarpinį rezultatą
   %define SK_SUMA word [bp-2] 
   mov SK_SUMA, 0    ; pradžioje skaitmenų suma yra 0
   push dx               ; saugosime dx, nes naudosime

   ; 1 skaičiaus paskutinis skaitmuo:
   mov ax, [bp+4]
   mov dx, 0
   mov cx, 10
   div cx
   add SK_SUMA, dx    ; dx -liekana nuo dalybos iš 10
    
   ; 2 skaičiaus paskutinis skaitmuo:
   mov ax, [bp+6]
   mov dx, 0
   mov cx, 10
   div cx
   add SK_SUMA, dx    ; dx -liekana nuo dalybos iš 10
    
   ; 3 skaičiaus paskutinis skaitmuo:
   mov ax, [bp+8]
   mov dx, 0
   mov cx, 10
   div cx
   add SK_SUMA, dx    ; dx -liekana nuo dalybos iš 10

   mov ax, SK_SUMA         ; ax -rezultatas   
   pop dx
   add sp, 2              ; atstatome sp
   pop bp
   ret 6                  ; grįžtame ir valome steką (buvo panaudoti 6 baitai)
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


