; 2 lab. d. 18 uzd
; Milda Domarkaite 3gr.

;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 

   startas:                     ; nuo cia vykdomas kodas

	mov bx, 0x82
	mov si, 0x00
	jmp .skaitymas

	.skaitymas:
	mov cl, [bx + si]
	cmp cl, 0x20
	jl .skaitymoPab
	inc si
	jmp .skaitymas

	.skaitymoPab:
	mov byte [bx + si], 0

	mov al, 0x0
	mov dx, 0x82
	mov ah, 0x3d
	int 0x21

	mov bx, ax
	push bx
	mov cx, 0xffff
	mov dx, Buferis
	mov ah, 0x3f
	int 0x21
	mov bx, ax
	
	mov si, 0x0
	.ikiNaujosEil
	cmp bx, si
	jz .pab    
	mov ah, [Buferis + si]
	inc si
	mov ch, 0x0
	cmp ah, 0x0a
	jnz .ikiNaujosEil
	jz .arTrizenklisPenkiazenklis

	; Tikrinimas ar skaicius trizenklis/penkiazenklis
	.arTrizenklisPenkiazenklis
	mov cl, 0x0
	.tikrinama 
	inc cl
	mov ah, [Buferis + si]
	inc si
	cmp ah, 0x30
	jge .daugiau
	jl .kasnutiko
	.daugiau
	cmp ah, 0x39
	jle .maziau
	jg .kasnutiko
	.maziau
	cmp cl, 0x3
	jz .kiekisTrizenkliu
	jg .galPenki
	jl .tikrinama
	
	.galPenki
	cmp cl, 0x5
	jz .kiekisPenkiazenkliu
	jnz .tikrinama

	;tikrina ar skaicius po kabliataskio
	.poKabliataskio
	inc ch
	cmp ch, 0x1
	jz .arTrizenklisPenkiazenklis
	jnz .ikiPirmo

	.kasnutiko
	cmp ah, 0x20
	jz .arTrizenklisPenkiazenklis
	jnz .toliau
	.toliau
	cmp ah, 0x3b
	jz .poKabliataskio
	jnz .ikitarpo

	.ikitarpo
	mov ah, [Buferis + si]
	inc si
	cmp ah, 0x20
	jz .arTrizenklisPenkiazenklis
	jnz .toliau

	;Trizenkliai
	.kiekisTrizenkliu:
	mov ah, [Buferis + si]
	inc si
	inc cl
	cmp ah, 0x20
	jz .didinam
	jnz .kabl
	.kabl
	cmp ah, 0x3b
	jz .didinam
	jnz .tikrinama
	.didinam
	mov dx, [RezultatasTrizenkliu]
	inc dx      
	mov [RezultatasTrizenkliu], dx
	jmp .arTrizenklisPenkiazenklis

	;Penkiazenkliai
	.kiekisPenkiazenkliu:
	mov ah, [Buferis + si]
	inc si
	cmp ah, 0x20
	jz .didinam2
	jnz .kabl2
	.kabl2
	cmp ah, 0x3b
	jz .didinam2
	jnz .ikitarpo
	.didinam2
	mov dx, [RezultatasPenkiazenkliu]
	inc dx    
	mov [RezultatasPenkiazenkliu], dx
	jmp .arTrizenklisPenkiazenklis

	.ikiPirmo
	mov ah, [Buferis + si]
	inc si
	cmp bx, si
	jz .pab   
	mov ch, 0x0
	cmp ah, 0x0a
	jnz .ikiPirmo
	jz .arTrizenklisPenkiazenklis

	; uzdaroma
	.pab
	pop bx
	mov ah, 0x3e
	int 0x21

	mov dx, Info
	mov ah, 0x9
	int 0x21
	mov dx, Tekstas
	mov ah, 0x9
	int 0x21

	mov dx, Vardas
	mov al, 0xff
	call procGetStr

	; atidaroma
	mov cx, 1
	mov ah, 0x3c
	int 0x21
	mov bx, ax

	mov dx, PenkiazenkliuZinute
	mov cx, 0x19
	mov ah, 0x40
	int 0x21

	mov ax, [RezultatasPenkiazenkliu]
	mov dx, RezultatasPenkiazenkliu
	call procUInt16ToStr

	mov di, 0x0
	mov cx, 0x0
	.darPenkiazenkliu
	mov al, [RezultatasPenkiazenkliu + di]
	inc di
	add cx, 0x1
	cmp al, 0x00
	jnz .darPenkiazenkliu
	mov ah, 0x40
	int 0x21

	mov dx, NaujaEilute
	mov cx, 0x2
	mov ah, 0x40
	int 0x21

	mov dx, TrizenkliuZinute
	mov cx, 0x17
	mov ah, 0x40
	int 0x21

	mov ax, [RezultatasTrizenkliu]
	mov dx, RezultatasTrizenkliu
	call procUInt16ToStr

	mov di, 0x0
	mov cx, 0x0
	.darTrizenkliu
	mov al, [RezultatasTrizenkliu + di]
	inc di
	add cx, 0x1
	cmp al, 0x00
	jnz .darTrizenkliu
	mov ah, 0x40
	int 0x21

	mov dx, NaujaEilute
	mov cx, 0x2
	mov ah, 0x40
	int 0x21

	; Uzdaromas failas
	mov ah, 0x3e
	int 0x21

 	; Baigiame programą:
	mov ah, 0x4c            
	int 0x21

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%include 'yasmlib.asm'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .data                   ; duomenys

TrizenkliuZinute:
	db 'Trizenkliu skaicius: ', 0x0D, 0x0A, '$'

PenkiazenkliuZinute:
	db 'Penkiazenkliu skaicius: ', 0x0D, 0x0A, '$'

NaujaEilute:
	db 0x0D, 0x0A

RezultatasPenkiazenkliu:
	times 2 db 0x00

RezultatasTrizenkliu:
	times 2 db 0x00

Info:
	db 'Milda Domarkaite 1 kursas 3 grupe', 0x0D, 0x0A, '$'

Tekstas:
	db 'Iveskite isvedamu duomenu (output) failo varda:', 0x0D, 0x0A, '$', 0

Vardas:
	times 255 db 0x00

Buferis:
	times 10000 db 0x00


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  
