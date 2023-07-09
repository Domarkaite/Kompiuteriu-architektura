; Uzduotis: nuskaityti komandines eilutes argumenta (failo vardas be pletinio), 
; atidaryti atitinkama faila skaitymui, perra6yti jo turini pagal
; dizasemblerio schema 
;  
%macro writeln   1
          push ax
          push dx
          mov ah, 09
          mov dx, %1
          int 21h
          mov ah, 09
          mov dx, naujaEilute
          int 21h
          pop dx
          pop ax          

%endmacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro readln    1
          mov ah, 0Ah
          mov dx, %1
          int 21h
          mov ah, 09
          mov dx, naujaEilute
          int 21h
      
%endmacro

    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
org 100h   
section .text
    main:
       ; pradzioje ds ir es rodo i PSP;
       ; PSP+80h -> kiek baitu uzima komandine eilute (be programos pavadinimo)
       ; 
       call skaitykArgumenta
       jnc .rasykArgumenta
       writeln klaidosPranesimas
       jmp .Ok

       .rasykArgumenta: 
       mov dx, komEilutesArgumentas      
       call writeASCIIZ 
       
       ;Atidarome faila
       mov dx, komEilutesArgumentas      
       call atverkFaila
       jnc .skaitomeFaila
       writeln klaidosApieFailoAtidarymaPranesimas
       jmp .Ok

       .skaitomeFaila:
       mov bx, [skaitomasFailas]          
       mov dx, nuskaitytas          
       call skaitomeFaila
       jnc .failoUzdarymas
       writeln klaidosApieFailoSkaitymaPranesimas
       ;jmp .Ok

       .failoUzdarymas:
       mov bx, [skaitomasFailas]          
       call uzdarykFaila
       .Ok:
       mov ah,     4ch                            ; baigimo funkcijos numeris
       int 21h
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  atverkFaila:  
        ; dx - failo vardo adresas
        ; CF yra 1 jeigu klaida 
        push ax
        push dx

        mov ah, 3Dh
        mov al, 00h       ; skaitymui
        int 21h

        jc .pab
        mov [skaitomasFailas], ax

        .pab:  
        pop dx
        pop ax
        ret   

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  uzdarykFaila:  
        ; dx - failo vardo adresas
        ; CF yra 1 jeigu klaida 
        push ax
        push bx

        mov ah, 3Eh
        int 21h

        .pab:  
        pop dx
        pop ax
        ret     


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    rasykSimboli:  
        ; al - simbolis 
        push ax
        push dx
        mov dl, al
        mov ah, 02h
        int 21h
        pop dx
        pop ax
        ret   
  
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   konvertuokI16taine:  
        ; al - baitas
        ; ax - rezultatas
        mov ah, al
        and ah, 0F0h
        shr ah, 1
        shr ah, 1
        shr ah, 1
        shr ah, 1
        and al, 0Fh

        cmp al, 09
        jle .plius0
        sub al, 10
        add al, 'A'
        jmp .AH
        .plius0:
        add al, '0'
        .AH:
             
        cmp ah, 09
        jle .darplius0
        sub ah, 10
        add ah, 'A'
        jmp .pab
        .darplius0:
        add ah, '0'
        .pab:
        xchg ah, al 
        ret     
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    analizuokKoda:  
         ; INPUT: 
         ;    al - nuskaitytas baitas
         ;    bx - failo deskriptorius - cia nenaudojas, bet potencialiai reikalingas  :)
         
         push bx
         push ax
         ; Labai ribota versija disasemblerio: tik RET, RETF be argumentu, bei CLC, STC, CMC)  

         cmp al, 0xF8                            ; CLC
         jne .galCMC
         writeln strCLC
         jmp .pab
                 
         .galCMC:
         cmp al, 0xF5                            ; CMC
         jne .galSTC
         writeln strCMC
         jmp .pab

         .galSTC:
         cmp al, 0F9h                            ; STC
         jne .galRET
         writeln strSTC
         jmp .pab
         
         .galRET:
         cmp al, 0C3h                            ; RET
         jne .galRETF
         writeln strRET
         jmp .pab
         
                  
         .galRETF:
         cmp al, 0CBh                            ; RETF
         jne .tiesiogDB
         writeln strRETF
         jmp .pab
         
         ;......


         .tiesiogDB:
         call konvertuokI16taine                 ; DB
         mov [nuskaitytas],  ax
         writeln strDB
         
         
         
         
         
         
         .pab:
         pop ax
         pop bx
         ret 
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    skaitykArgumenta:  
         ; nuskaito ir paruosia argumenta
         ; jeigu jo nerasta, tai CF <- 1, prisingu atveju - 0

         push bx
         push di
         push si 
         push ax

         xor bx, bx
         xor si, si
         xor di, di

         mov bl, [80h]         ;
         mov [komEilIlgis], bl
         mov si, 0081h  
         mov di, komEilutesArgumentas
         push cx
         mov cx, bx
         mov ah,00
         cmp cx, 0000
         jne .pagalVisus
         stc 
         jmp .pab
   
         .pagalVisus:
         mov al, [si]     ;
         cmp al, ' '
         je .toliau
         cmp al, 0Dh
         je .toliau
         cmp al, 0Ah
         je .toliau
         mov [di],al
         ; call rasykSimboli  
         mov ah, 01                  ; ah - pozymis, kad buvo bent vienas "netarpas"
         inc di     
         jmp .kitasZingsnis
         .toliau:
         cmp ah, 01                  ; gal jau buvo "netarpu"?  
         je .isejimas 
         .kitasZingsnis:
         inc si
     
         loop .pagalVisus
         .isejimas: 
         cmp ah, 01                  ; ar buvo "netarpu"?  
         je .pridetCOM
         stc                         ; klaida!   
         jmp .pab 
         .pridetCOM:
         mov [di], byte '.'
         mov [di+1], byte 'C'
         mov [di+2], byte 'O'
         mov [di+3], byte 'M'
         clc                         ; klaidos nerasta
         .pab:
         pop cx
         pop ax
         pop si
         pop di 
         pop dx
         ret
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    skaitomeFaila:  
        ; skaitome faila po viena baita 
        ; bx - failo deskriptorius
        ; dx - buferis 
        push ax
        push dx
        push bx
        push cx
        push si
                
        mov si, dx 
        .kartok:
        mov cx, 01
        mov ah, 3Fh 
        int 21h
        jc .isejimas           ; skaitymo klaida
        cmp ax, 00
        je .isejimas           ; skaitymo pabaiga

        mov al,[si]            ; is buferio
        
        call analizuokKoda     ; bandome dekoduoti

        jmp .kartok
        
        .isejimas:
        pop si
        pop cx
        pop bx
        pop dx
        pop ax
        ret   
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    writeASCIIZ:  
         ; spausdina eilute su nuline pabaiga, dx - jos adresas
         ; 

         push si
         push ax
         push dx
 
         mov  si, dx
 
         .pagalVisus:
         mov dl, [si]  ; krauname simboli
         cmp dl, 00             ; gal jau eilutes pabaiga?
         je .pab

         mov ah, 02
         int 21h
         inc si
         jmp .pagalVisus
         .pab:
         
         writeln naujaEilute
  
         pop dx
         pop ax
         pop si
         ret
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


section .data                   ; duomenys
  
    
    strCMC:
       db '      cmc $'  
    strSTC:
       db '      stc $'  
    strCLC:
       db '      clc $'  
    strRET:
       db '      ret $'  
    strRETF:
       db '      retf $'  
  
    
    
    strDB:
       db '      db ' 
    nuskaitytas:
       db 00, 00, 'h$' 
   
    klaidosPranesimas:
       db 'Klaida skaitant argumenta $'

    klaidosApieFailoAtidarymaPranesimas:
       db 'Klaida atidarant faila $'

    klaidosApieFailoSkaitymaPranesimas:
       db 'Klaida skaitant faila $'

    labas:
       db 'Labas', 0x0D, 0x0A, '$'

    naujaEilute:   
       db 0x0D, 0x0A, '$'  ; tekstas ant ekrano
 
    komEilIlgis:
       db 00
    komEilutesArgumentas:
       times 255 db 00
    skaitomasFailas:
       dw 0FFFh 
    

