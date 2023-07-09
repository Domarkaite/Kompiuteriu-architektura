[org 0x100]
[bits 16]

%include 'yasmmac.inc'          ; Pagalbiniai makrosai
section .text                   ; kodas prasideda cia 
macPutString "Spausk klavisus ...", crlf, '$'

laukiamePaspaudimo:
  mov ah,0
  int 0x16       ; Ka paspaudeme

  cmp ah, 0x48    ; 48 yra skankodas rodyklei i virsu
  je .iVirsu
  cmp ah, 0x4B    ; 4B yra skankodas rodyklei i kaire
  je .iKaire

  cmp ah, 0x01    ; 01 yra skankodas Esc
  je .Esc

  jmp laukiamePaspaudimo  

  .iVirsu:
  macPutString  "UP $" 
  jmp laukiamePaspaudimo  

  .iKaire:
  macPutString  "LEFT $" 
  jmp laukiamePaspaudimo  


  .Esc:
  macPutString  "Esc... $" 
  jmp .pab
  
  ;jmp laukiamePaspaudimo  
  
  .pab:
  
   exit

%include 'yasmlib.asm'        


