
; Naudoajme po ypvz18 ar ypvz19 
;------------------------------------------------------------------------
%include 'yasmmac.inc'  
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 

   startas:                     ; nuo cia vykdomas kodas
      macPutString "Ivesk skaiciu $"
      call procGetUInt16
      macNewLine
      mov bl, 5
      div bl
      macPutString "Po dalybos is 5 gavome: $"
      and ax, 0x00FF
      call procPutUInt16
      macNewLine
      exit
      

%include 'yasmlib.asm'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data                   ; duomenys

   pranesimas:
      db 'Labas, bandome naudoti int 0x88... ', 0x0D, 0x0A, '$'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


