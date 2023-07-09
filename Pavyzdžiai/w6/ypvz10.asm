; Įvesti dviejų failų pavadinimus: skaitymui ir rašymui; 
; Parašyti  procedūrą (funkciją), kuri skaito pirmojo failo simbplius,
; keičia  'a' raidę į '*' ir rašo į kitą failą
; Procedūros parametrus (failų vardus) perduoti per steką pagal nuorodą
%include 'yasmmac.inc'          ; Pagalbiniai makrosai
;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 

   startas:                     ; nuo cia vykdomas kodas
   
   ; --------------------------------------------- Ivestis -------------
   macPutString 'Ivesk skaitomo failo vardą', crlf, '$'
   mov al, 128                  ; ilgiausia eilutė
   mov dx, skaitymoFailas      ; 
   call procGetStr              
   macNewLine 

   macPutString 'Ivesk rasomo failo vardą', crlf, '$'
   mov al, 128                  ; ilgiausia eilutė
   mov dx, rasymoFailas      ; 
   call procGetStr              
   macNewLine 
 
   ; -------------------------------- Kiečiame 'A'-> '*' ---------------
   push skaitymoFailas
   push rasymoFailas
   call failoFiltravimas

   macPutString crlf, ' Baigiame... $'    
   macNewLine    

   ; -------------------------------- Baigiame -----------------------------------
   exit 

; Pagalbinė procedūra: 
failoFiltravimas:
   ; C prototipas:
   ; void  failoFiltravimas(char* skaitymoFailas, char* rasymoFailas)
   push bp
   mov bp, sp
   sub sp, 4             ; deskriptoriams saugoti
   push dx               ; saugosime dx, nes naudosime
   push bx               ; saugosime bx, nes naudosime
   push ax               ; saugosime ax, nes naudosime
   
   
   mov dx, [bp+6]
   call procFOpenForReading
   jnc .kitoFailoAtidarymas
   macPutString 'Klaida atidarant faila skaitymui', crlf, '$' 
   jmp .pab
   
   
   .kitoFailoAtidarymas:
   mov [bp-2], bx              ; saugome pirmo  failo deskriptorių
   
   mov dx, [bp+4]
   call procFCreateOrTruncate
   jnc .filtravimas
   macPutString 'Klaida atidarant faila rasymui', crlf, '$' 
   jmp .uzdarymasSkaitymo
   
   .filtravimas:
   mov [bp-4], bx              ; saugome antro  failo deskriptorių
   
   .kolNeFailoPabaiga:
      mov bx, [bp-2]
      call procFGetChar
      jnc .t1
      macPutString 'Klaida skaitant faila', crlf, '$' 
      jmp .uzdarymas
     
      .t1:
      cmp ax, 0
      jne .rasymas
      jmp .uzdarymas
   
      .rasymas:
      mov al, cl                   ; perduosime rašymui
      cmp al, 'a'
      jne .t2
      mov al, '*'
      .t2:
      mov bx,[bp-4] 
      call procFPutChar
      jnc .t3
      macPutString 'Klaida rasant faila', crlf, '$' 
      jmp .uzdarymas
      .t3:
      cmp ax, 0
      jne .kitaIteracija
      jmp .uzdarymas
   
     .kitaIteracija:
     jmp .kolNeFailoPabaiga
   
    
   .uzdarymas: 
   mov bx, [bp-4]
   call procFClose
   .uzdarymasSkaitymo: 
   mov bx, [bp-2]
   call procFClose
   
   
   .pab:
   
   pop ax
   pop dx
   pop bx
   add sp, 4   
   pop bp
   ret 4                 ; grįžtame ir valome steką (buvo panaudoti 4 baitai)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%include 'yasmlib.asm'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



section .data                   ; duomenys

 skaitymoFailas:
    times 255 db 00
 rasymoFailas:
    times 255 db 00
 
 eilute:
    times 255 db 00
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


