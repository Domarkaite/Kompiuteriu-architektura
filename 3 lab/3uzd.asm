.model small

.stack 100h

.data
	msg	db "Single-step mode interruption! $"
	
	pushFormat1 db " push $"
	pushFormat2 db ";", 13, 10, "$"
	
	mem0 db "BX+SI$"
	mem1 db "BX+DI$"
	mem2 db "BP+SI$"
	mem3 db "BP+DI$"
	mem4 db "SI$"
	mem5 db "DI$"
	mem6 db "adress$"
	mem7 db "BX$"
	memBP db "BP$"
	
	byteOffset db "+byte offset$"
	wordOffset db "+word offset$"
	
	axHolder dw ?
	bxHolder dw ?
	cxHolder dw ?
	dxHolder dw ?
	bpHolder dw ?
	spHolder dw ?
	siHolder dw ?
	diHolder dw ?
	
	bxIndex db ?
	bpIndex db ?
	siIndex db ?
	diIndex db ? 
	
	bxFormat db "BX= $"
	bpFormat db "BP= $"
	siFormat db "SI= $"
	diFormat db "DI= $"
	format1 db ", $"
	format2 db "= $"
	
	offsetCheck db 0
	offsetFormat db "offset= $"
	
	stackFormat db "first word of stack: $"
	Enteris db 13, 10, "$"	

.code
	MOV	ax, @data
	MOV	ds, ax

;****************************************************************************
; Nusistatom reikalingas registru reikšmes
;****************************************************************************
	MOV	ax, 0
	MOV	es, ax
	
;****************************************************************************
; Iššisaugome tikra pertraukimo apdorojimo proceduros adresa, kad programos gale galetume ji atstatyti
;****************************************************************************
	PUSH es:[4]
	PUSH es:[6]
	
;****************************************************************************
; Pertraukimu vektoriu lenteleje suformuojame pertraukimo apdorojimo proceduros adresa
;****************************************************************************
	MOV	word ptr es:[4], offset inter
	MOV es:[6], cs

;****************************************************************************
; Testuojame pertraukimo apdorojimo procedura
;****************************************************************************
	PUSHF
	PUSHF
	POP ax
	OR ax, 0100h
	PUSH ax
	POPF
	NOP
	
	mov bx, 3
	mov bp, 6
	mov si, 9
	mov di, 4
	
	push bx
	
	push [bx + si]
	pop bx	
	push [bx + di]
	pop bx	
	push [bp + si]
	pop bx
	push [si]
	pop bx
	push [di]
	pop bx
	push [bx]
	pop bx
	push [bx + di] 
	pop bx
	push [bx + di + 56h]
	pop bx
	push [bp + si + 0202h]
	pop bx
	push [bp + 0202h]
	pop bx
	

	pop bx       
	
	;push [bx]
	;pop bx
	
	;push [bx + di + 56h]
	;pop bx            	
		          	
	;push [si + 56h]
	;pop bx       

	
	mov ax, 5
	mov bx, ax 
	
	POPF
	
;****************************************************************************
; Atstatome tikra pertraukimo apdorojimo programos adresa pertraukimu vektoriuje
;****************************************************************************
	POP	es:[6]
	POP	es:[4]

	MOV	ax, 4C00h
	INT	21h

;****************************************************************************
; Pertraukimo apdorojimo procedura
;****************************************************************************
PROC inter
    mov axHolder, ax
    mov bxHolder, bx
    mov cxHolder, cx
    mov dxHolder, dx
    mov bpHolder, bp
    mov spHolder, sp
    mov siHolder, si
    mov diHolder, di
    
    mov bxIndex, 1
	mov bpIndex, 1
	mov siIndex, 1
	mov diIndex, 1
	    
    pop si
    pop di
    push di
    push si
    
    
    ;-----------------START-----------------
    
    mov dx, cs:[si]
               
    mov ax, dx
    and ax, 038FFh
    cmp ax, 030FFh
    jne return
    
    
    mov ah, 9
    mov dx, offset msg
    int 21h
    
    mov ax, cs
    call printHex
    
    mov ah, 2
    mov dx, 58
    int 21h
    
    mov ax, si
    call printHex
    
    mov ah, 2
    mov dx, 32
    int 21h
    
    mov ah, cs:[si]
    mov al, cs:[si+1]
    call printHex
    
    mov ah, 9
    mov dx, offset pushFormat1
    int 21h
    
    call findMem
    
    mov ah, 9
    mov dx, offset pushFormat2
    int 21h    
    
    call printOp
    
    call printOffset
    
    call findMem
    
    mov ah, 9
    mov dx, offset format2
    int 21h
    
    call printValue
    
    call printStack
        
    
    ;-----------------END-----------------
    
    
    return:
    mov ax, axHolder
    mov bx, bxHolder
    mov cx, cxHolder
    mov dx, dxHolder
    mov bp, bpHolder
    mov sp, spHolder
    mov si, siHolder
    mov di, diHolder
    IRET			
inter ENDP


PROC printHex
    mov cx, 0
    mov dx, 0
    label1:
        cmp ax, 0
        je check
        
        mov bx, 16
        div bx
        push dx
        inc cx
        mov dx, 0
        jmp label1
    check:
        cmp cx, 4
        je print1
        
        mov dx, 0
        push dx
        inc cx
        jmp check        
    print1:
        cmp cx, 0
        je exit
        
        pop dx
        cmp dx, 9
        jle continue
        add dx, 7
        
        continue:
        add dx, 48
        
        mov ah, 2
        int 21h
        
        dec cx
        jmp print1
    exit:
        ret       
printHex ENDP

    
PROC findMem
    mov ah, 2
    mov dx, 91
    int 21h
    
    mov cx, 0    
    mov al, cs:[si+1]
    and al, 007h
    
    
    cmp al, 000h
    jne next1
    mov dx, offset mem0
    mov bpIndex, 0
    mov diIndex, 0
    jmp printMem
    
    next1:  
    cmp al, 001h
    jne next2
    mov dx, offset mem1
    mov bpIndex, 0
    mov siIndex, 0
    jmp printMem
    
    next2:
    cmp al, 002h
    jne next3
    mov dx, offset mem2
    mov bxIndex, 0
    mov diIndex, 0
    jmp printMem
    
    next3:
    cmp al, 003h
    jne next4
    mov dx, offset mem3
    mov bxIndex, 0
    mov siIndex, 0
    jmp printMem
    
    next4:
    cmp al, 004h
    jne next5
    mov dx, offset mem4
    mov bxIndex, 0
    mov bpIndex, 0
    mov diIndex, 0
    jmp printMem
    
    next5:
    cmp al, 005h
    jne next6
    mov dx, offset mem5
    mov bxIndex, 0
    mov bpIndex, 0
    mov siIndex, 0
    jmp printMem
    
    next6:
    cmp al, 006h
    jne next7
    mov dx, offset mem6
    mov cx, 1
    mov bpIndex, 0
    mov bxIndex, 0
    mov siIndex, 0
    mov diIndex, 0
    jmp printMem
    
    next7:
    mov dx, offset mem7
    mov bpIndex, 0
    mov diIndex, 0
    mov siIndex, 0
        
    printMem:
    cmp cx, 0
    je continueMem
    mov al, cs:[si+1]    
    and al, 0C0h
    cmp al, 000h
    je exitMem
    mov bpIndex, 1
    mov dx, offset memBP
    
    
    continueMem: 
    mov ah, 9
    int 21h
    
    mov al, cs:[si+1]    
    and al, 0C0h    
    
    cmp al, 000h
    je exitMem
    
    cmp al, 040h
    jne nextMod
    mov ah, 9
    mov dx, offset byteOffset
    int 21h
    mov offsetCheck, 1
    jmp exitMem
    
    nextMod:
    mov ah, 9
    mov dx, offset wordOffset
    int 21h
    mov offsetCheck, 2
    
    exitMem:
    mov ah, 2
    mov dx, 93
    int 21h
    ret
findMem ENDP 


PROC printOp
        cmp bxIndex, 0
        je nextOp1
        
        mov ah, 9
        mov dx, offset bxFormat
        int 21h
        
        mov ax, bxHolder
        call printHex
        
        mov ah, 9
        mov dx, offset format1
        int 21h
    
    
    nextOp1:
        cmp bpIndex, 0
        je nextOp2
        
        mov ah, 9
        mov dx, offset bpFormat
        int 21h
        
        mov ax, bpHolder
        call printHex
        
        mov ah, 9
        mov dx, offset format1
        int 21h 
    
    
    nextOp2:
        cmp siIndex, 0
        je nextOp3
        
        mov ah, 9
        mov dx, offset siFormat
        int 21h
        
        mov ax, siHolder
        call printHex
        
        mov ah, 9
        mov dx, offset format1
        int 21h
    
    
    nextOp3:
        cmp diIndex, 0
        je exitOp
        
        mov ah, 9
        mov dx, offset diFormat
        int 21h
        
        mov ax, diHolder
        call printHex
        
        mov ah, 9
        mov dx, offset format1
        int 21h
    
    exitOp:
        ret        
printOp ENDP


PROC printOffset
    cmp offsetCheck, 1
    jne checkAgain
    mov ah, 9
    mov dx, offset offsetFormat
    int 21h
    
    mov al, cs:[si+2]
    mov ah, 0
    call printHex
    
    mov ah, 9
    mov dx, offset format1
    int 21h
    jmp noOffset
    
    
    checkAgain:
    cmp offsetCheck, 2
    jne noOffset
    mov ah, 9
    mov dx, offset offsetFormat
    int 21h
    
    mov al, cs:[si+2]
    mov ah, cs:[si+3]
    call printHex
    
    mov ah, 9
    mov dx, offset format1
    int 21h
    
    noOffset:
        ret
printOffset ENDP


PROC printValue
    mov bx, 0
    
    cmp offsetCheck, 1
    jne checkWord
    mov bl, cs:[si+2]
    mov bh, 0
    jmp noOff
    
    checkWord:
    cmp offsetCheck, 2
    jne noOff
    mov bl, cs:[si+2]
    mov bh, cs:[si+3]
    
    noOff:
        cmp bxIndex, 0
        je nextAdd1
        add bx, bxHolder   
        
        nextAdd1:
        cmp bpIndex, 0
        je nextAdd2
        add bx, bpHolder
        
        nextAdd2:
        cmp siIndex, 0
        je nextAdd3
        add bx, siHolder
        
        nextAdd3:
        cmp diIndex, 0
        je skip
        add bx, diHolder
    
    skip:
    mov ax, [bx]
    call printHex
    
    mov ah, 9
    mov dx, offset format1
    int 21h
    
    ret        
printValue ENDP


PROC printStack
    mov ah, 9
    mov dx, offset stackFormat
    int 21h
    
    mov bp, spHolder
    add bp, 6
    mov ax, [bp]
    call printHex
    
    mov ah, 9
    mov dx, offset Enteris
    int 21h
    ret    
printStack ENDP

END