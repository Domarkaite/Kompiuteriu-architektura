; Rezidentinė programa: 
; 
; Dos 21 petraukimo doroklis, kuris "perrašo" 9-ą funkciją.
; Naudojama tekstinė video atmintis  
; 
; 
%include 'yasmmac.inc'          ; Pagalbiniai makrosai
%define PERTRAUKIMAS 0x21
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
      db  ' >>>>>>> Labas, kaip gyveni... >>>>>>> $' 
    
;    .ciklai:                                     ;Kiek laikmacio ciklu jau praejo
;      dw 0
    
    .toliau:                                     ;Pradedame apdorojima
      push es
      push si
      push di
      mov di, 0000 

      .isorinis:
      cld
      mov si, dx
      mov ax, 0xb860
      mov es, ax
      .kartok: 
      lodsb
      cmp al,'$'
      je .kitas
      mov ah, 0xCF
      stosw
      jmp .kartok      
   
      .kitas:
      push ds
      push cs
      pop ds
      cld
      mov si, .tekstas
      .kartok2: 
      lodsb
      cmp al,'$'
      je .toliau2
      mov ah, 0x4F
      stosw
      jmp .kartok2      
   

   
   
      
    .toliau2:    
      pop ds
      pop di
      pop si
      pop es
      ret                                          ; griztame is proceduros
;end procRasyk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
NaujasPertraukimas:                                      ; Doroklis prasideda cia
    
      macPushAll                                      ; Saugome registrus
      cmp ah, 09
      jne .toliau
      call  procRasyk                                  ; 
      macPopAll                                       ; 
      iret      
 
 
      .toliau
      macPopAll                                       ; 
      pushf
      call far [cs:SenasPertraukimas]                ;  
      iret

   

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
        
        macPutString "OK ...",  '$'
        
        mov dx, Nustatymas + 1
        int     27h                       ; Padarome rezidentu

%include 'yasmlib.asm'        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


