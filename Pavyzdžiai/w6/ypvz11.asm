; Įvesti ilgą sveiką teigiamą skaičių N (iki 128 simbolių); 
; Parašyti  procedūras (funkcijas):
; a) kuri prideda prie N 1, t.y. incr(N,Npp)
; b) kuri sukskaičiuoja N * K, t.y. timesK(N,NK,K), K - skaitmuo nuo 1 iki 9 
; Procedūros parametrą perduoti per steką pagal nuorodą
%include 'yasmmac.inc'          ; Pagalbiniai makrosai
;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 

   startas:                     ; nuo cia vykdomas kodas
   
   ; --------------------------------------------- Ivestis -------------
   macPutString 'Ivesk skaiciu', crlf, '$'
   mov al, 128                  ; ilgiausia eilutė
   mov dx, bigN                 ; eilutės adresas       
   call procGetStr              
   macNewLine 

 
   ; -------------------------------- N++ ---------------
   push bigNpp   
   push bigN
   call incr

   macPutString crlf, ' N++ yra: $'    
   mov dx, bigNpp
   call procPutStr
   macNewLine    

   macPutString 'Ivesk skaitmeni nuo 1 iki 9', crlf, '$'
   call procGetUInt16              
   macNewLine 

   push ax
   push bigNK   
   push bigN
   call timesK


   macPutString crlf, ' N * skaitmuo yra: $'    
   mov dx, bigNK
   call procPutStr
   macNewLine    

   ; -------------------------------- Baigiame -----------------------------------
   exit 

; Pagalbinė procedūra a): 
incr:
   ; C prototipas:
   ; void  incr(char* N, char* Npp)
   push bp
   mov bp, sp
   push cx               ; saugosime cx, nes naudosime
   push di               ; saugosime di, nes naudosime
   push si
   push ax
   mov al, 0             ; ieškosime \0
   mov di, [bp+4]        ; adresas N
   mov si, [bp+6]        ; adresas N++
   mov cx, 255
   cld                   ; priekin 
   repne scasb           ; kol nesuradome
   mov ax, di
   sub ax, [bp+4]
   mov cx, ax
   add si, cx
   dec si
   dec di
   dec di
   dec cx
   mov [si+1], byte 0
   mov ah, 1
   .ciklasIkiPirmoSkaitmens:
      mov al, [di]
      sub al, '0'
      ;call procPutHexWord
      add al, ah
      aaa
      jc .t1              ; buvo pernešimas 
      mov ah, 0       
      jmp .t2

      .t1: 
      mov ah, 1
      .t2:
      add al, '0'

      mov byte [si], al
      dec si
      dec di
      loop  .ciklasIkiPirmoSkaitmens
   cmp ah, 1
   jne .tarpas
   mov [si], byte '1'
   jmp .pab
   .tarpas:
   mov [si], byte ' '
 
   .pab:
   pop ax
   pop si
   pop di
   pop cx
   
   pop bp
   ret  4                 ; grįžtame 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Pagalbinė procedūra b): 
timesK:
   ; C prototipas:
   ; void  times5(char* N, char* NK, unsigned char K)
   push bp
   mov bp, sp
   push cx               ; saugosime cx, nes naudosime
   push di               ; saugosime di, nes naudosime
   push si
   push ax
   push dx
   mov al, 0             ; ieškosime \0
   mov di, [bp+4]        ; adresas N
   mov si, [bp+6]        ; adresas NK
   mov dx, [bp+8]        ; k
   mov cx, 255
   cld                   ; priekin 
   repne scasb           ; kol nesuradome
   mov ax, di
   sub ax, [bp+4]
   mov cx, ax
   add si, cx
   dec si
   dec di
   dec di
   dec cx
   mov [si+1], byte 0
   mov dh, 0              ; laikysime pernešimą
   .ciklasIkiPirmoSkaitmens:
      mov al, [di]
      sub al, '0'
      ;call procPutHexWord
      mul dl
      add al, dh      
      aam
      mov dh, ah
      add al, '0'

      mov byte [si], al
      dec si
      dec di
      loop  .ciklasIkiPirmoSkaitmens
   cmp dh, 0
   je .tarpas
   add dh, '0'
   mov [si], dh
   jmp .pab
   .tarpas:
   mov [si], byte ' '
 
   .pab:
   pop dx 
   pop ax
   pop si
   pop di
   pop cx
   
   pop bp
   ret  4                 ; grįžtame ir valome steką 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%include 'yasmlib.asm'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



section .data                   ; duomenys

 bigN:
    times 255 db 00
 bigNpp:
    times 255 db '*'
    db 0
 bigNK:
    times 255 db '*'
    db 0
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


