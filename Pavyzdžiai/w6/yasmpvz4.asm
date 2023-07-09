; Įsvesti sveiką  skaičių; 
; Atspasdinti jo 16-tainį kodą ir aštunto, penkto ir nulinio bitų sumą;
%include 'yasmmac.inc'          ; Pagalbiniai makrosai
;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 

   startas:                     ; nuo cia vykdomas kodas
   
   ; --------------------------------------------- Ivestis -------------
   macPutString 'Ivesk skaiciu', crlf, '$'
   call procGetInt16
   mov [sk1], ax
   macNewLine 
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; -------------------------------- Spausdinimas 16- taineje sistemoje -
   macPutString 'Ivesta: $'   
   mov ax, [sk1]
   call procPutHexWord
 
   ; -------------------------------- Nurodytų bitų suma ir spausdinimas 10- taineje sistemoje -

   mov ax, [sk1]

   mov bx, ax
   and bx, 0x0100                         ; lieka nepakeistas tik 8-as bitas 
   mov cl, 8                              ; reikės „stumti“ bx tiek kartų
   shr bx, cl                             ; ... dešinėn
   add word [bitu_8_5_0_suma], bx         ; didiname atsakymą

   mov bx, ax
   and bx, 0x0020                         ; lieka nepakeistas tik 5-as bitas 
   mov cl, 5                              ; reikės „stumti“ bx tiek kartų
   shr bx, cl                             ; ... dešinėn
   add word [bitu_8_5_0_suma], bx         ; didiname atsakymą

   mov bx, ax
   and bx, 0x0001                         ; lieka nepakeistas tik nulinis bitas 
   add word [bitu_8_5_0_suma], bx         ; didiname atsakymą

   mov ax, [bitu_8_5_0_suma]

   macPutString crlf, ' Nulinio, penkto ir astunto bitu suma: ', crlf, '$'    
   call procPutInt16
   ; -------------------------------- Baigiame -----------------------------------
   exit 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%include 'yasmlib.asm'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



section .data                   ; duomenys

 sk1:
    dw 00
 bitu_8_5_0_suma:
    dw 00
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


