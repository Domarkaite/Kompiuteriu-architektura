; Įvesti tekstinę eilutę (iki 128 simbolių); 
; Parašyti  procedūrą (funkciją), kuri keičia A raidę į '*'
; Procedūros parametrą perduoti per steką pagal nuorodą
%include 'yasmmac.inc'          ; Pagalbiniai makrosai
;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 

   startas:                     ; nuo cia vykdomas kodas
   
   ; --------------------------------------------- Ivestis -------------
   macPutString 'Ivesk eilute', crlf, '$'
   mov al, 128                  ; ilgiausia eilutė
   mov dx, eilute               ; eilutės adresas    
   call procGetStr              
   macNewLine 

 
   ; -------------------------------- Kiečiame 'A'-> '*' ---------------
   
   push eilute
   call keitimas

   macPutString crlf, ' Naja eilute: $'    
   mov dx, eilute
   call procPutStr
   macNewLine    

   ; -------------------------------- Baigiame -----------------------------------
   exit 

; Pagalbinė procedūra: 
keitimas:
   ; C prototipas:
   ; void  keitimas(char* eilute)
   push bp
   mov bp, sp
   push bx               ; saugosime bx, nes naudosime
   mov bx, [bp+4]        ; bx <- eilutes adresas 
   .ciklasIki_0
      cmp byte [bx], 0      ; ar eilutės pabaiga? 
      je .pab               ; -> bagiame 
      cmp byte [bx], 'A'    ; ar 'A'?
      jne .toliau           ; -> ciklas tęsiasi 
        mov byte [bx], '*'  ; keičiame 
      .toliau:       
      inc bx                ; kito simbolio adresas
      jmp .ciklasIki_0 
   .pab:
   pop bx
   pop bp
   ret                   ; grįžtame ir valome steką (buvo panaudoti 6 baitai)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%include 'yasmlib.asm'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



section .data                   ; duomenys

 eilute:
    times 255 db 00
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


