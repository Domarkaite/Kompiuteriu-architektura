; Rezidentinė programa: 
; 
; Taimerio petraukimo doroklis 
; 
; 
%include 'yasmmac.inc'          ; Pagalbiniai makrosai
%define PERTRAUKIMAS 0x1C
;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 
    Pradzia:
      jmp     Nustatymas                           ;Pirmas paleidimas
    SenasPertraukimas:
      dw      0, 0

    procRasyk:                      ;Nadosime doroklyje 
      jmp .toliau                                  ;Praleidziame teksta
    
    .tekstas:
      db  'Labas, kaip gyveni... ',0Dh, 0Ah,'$' 
    
    .ciklai:                                     ;Kiek laikmacio ciklu jau praejo
      dw 0
    
    .toliau:                                     ;Pradedame apdorojima
      push ds
      push cs
      pop ds
      inc word  [.ciklai]                          ; ciklai++
      cmp word  [.ciklai],  0060                   ; ciklai >= 60?
      jl .toliau2                                   ; jeigu ne - iseiname
      mov word [.ciklai], 0000                    ; ciklai = 0  
      mov ah, 09
      mov dx, .tekstas
      int 21h                                      ; isvedame  teksta
    .toliau2:    
      pop ds
      ret                                          ; griztame is proceduros
;end procRasyk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
NaujasPertraukimas:                                      ; Doroklis prasideda cia
    
      macPushAll                                      ; Sagome registrus
      call  procRasyk                                  ; Tikriname ciklus ir rasome 
      macPopAll                                       ; 
      jmp far [cs:SenasPertraukimas]                ;  

   

;
;
;  Rezidentinio bloko pabaiga
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  Nustatymo (po pirmo paleidimo) blokas: jis NELIEKA atmintyje
;
;

 
Nustatymas:
        ; Gauname sena  vektoriu
        push    cs
        pop     ds
        mov     ah, 0x35
        mov     al, PERTRAUKIMAS              ; gauname sena pertraukimo vektoriu
        int     21h

        
        ; Saugome sena vektoriu 
        mov     [cs:SenasPertraukimas], bx             ; issaugome seno doroklio poslinki    
        mov     [cs:SenasPertraukimas + 2], es         ; issaugome seno doroklio segmenta
        
        ; Nustatome nauja  vektoriu
        mov     dx, NaujasPertraukimas
        mov     ah, 0x25
        mov     al, PERTRAUKIMAS                       ; nustatome pertraukimo vektoriu
        int     21h
        
        macPutString "OK ...", crlf, '$'
        
        mov dx, Nustatymas + 1
        int     27h                       ; Padarome rezidentu

%include 'yasmlib.asm'        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


