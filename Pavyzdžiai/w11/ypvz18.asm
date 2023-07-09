; Rezidentinė programa
; Dalybos klaidos doroklis: parašo pranšimą apie klaidą
; 
; 
; 
%include 'yasmmac.inc'          ; Pagalbiniai makrosai
%define PERTRAUKIMAS 00
;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 
    Pradzia:
      jmp     Nustatymas                           ;Pirmas paleidimas
    SenasPertraukimas:
      dw      0, 0

    procRasyk:                      ;Naudosime doroklyje 
      jmp .toliau                                  ;Praleidziame teksta
    
    .tekstas:
      db  'Problemos su dalyba  ...',0Dh, 0Ah
     .CR:
      db   0Dh, 0Ah,'$' 
    
    
    .toliau:                                     ;Pradedame apdorojima
      push ds
      push cs
      pop ds
      mov dx, .tekstas 
      mov ah, 09
      int 21h                                      ; isvedame  teksta
      pop ds
      ret                                          ; griztame is proceduros
;end procRasyk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
NaujasPertraukimas:                                      ; Doroklis prasideda cia
    
      macPushAll                                      ; Sagome registrus
      call procRasyk
      macPopAll
      cli
      pop ax
      pop bx
      pop cx
      pushf
      push bx
      push ax
      sti
      iret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Rezidentinio bloko pabaiga
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  Nustatymo (po pirmo paleidimo) blokas: jis NELIEKA atmintyje
;
;

 
Nustatymas:
        ; Gauname sena   vektoriu
        push    cs
        pop     ds
       ; macPutString "Iki ...", crlf, '$'
        mov     ah, 0x35
        mov     al, PERTRAUKIMAS                 ; gauname sena pertraukimo vektoriu
        int     0x21
        
        ; Saugome sena vektoriu 
        mov     [cs:SenasPertraukimas], bx             ; issaugome seno doroklio poslinki    
        mov     [cs:SenasPertraukimas + 2], es         ; issaugome seno doroklio segmenta
        
      ;  macPutString "Nustatome ...", crlf, '$'
        
        ; Nustatome nauja  vektoriu
        mov     dx, NaujasPertraukimas
        mov     ah, 0x25
        mov     al, PERTRAUKIMAS                       ; nustatome pertraukimo vektoriu
        int     21h
        
       ; macPutString "OK ...", crlf, '$'
        
        mov dx, Nustatymas + 1
        int     27h                       ; Padarome rezidentu

%include 'yasmlib.asm'        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


