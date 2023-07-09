; Skaitomas failas, nuo galo spausdinant i ekrana tik skaitmenis.
.model small
	BUF_DYDIS equ 16
.stack 100h
.data
	
	duom_vardas db "duom.txt", 0 ;duomenu failo vardas, besibaigiantis nuliniu baitu (toks reikalavimas atidarymo interupte failo vardui)
	duom_deskriptorius dw ? ; file handle'as
	
	klaidos_tekstas db "Ivyko kazkokia klaida$"
	
	skaitymo_buferis db BUF_DYDIS dup (?)
		
	kiek_skaitoma dw ? ; kiek baitu skaityti su dabartine iteracija i buferi?
	
	pozicija dw ?, ? ; du zodziai sudaro pozicija faile (grazinami dx,ax paduodami cx,dx, zr int 21h konspekte ah=42h funkcija)
.code
; tipine pradzia
	mov ax, @data
	mov ds, ax

	; Atsidarom duomenu faila
	mov ah, 3Dh ; konspektuke apie INT 21h, paskaitykite kas kur paduodama
	mov al, 0
	mov dx, offset duom_vardas
	int 21h
	jc spausdink_klaida ;klaida atidarymo metu
	mov duom_deskriptorius, ax
	
	; Suzinom maksimalia pozicija
	mov ah, 42h ; konspektuke apie INT 21h, paskaitykite kas kur paduodama
	mov al, 2
	mov bx, duom_deskriptorius
	mov cx, 0
	mov dx, 0
	int 21h
	jc spausdink_klaida
	mov pozicija[0], dx
	mov pozicija[2], ax

	;Paskutinio gabaliuko faile, kuri skaitysime paty pirma, dydis (failo ilgio padalinto is buferio dydzio liekana)
	mov kiek_skaitoma, ax
	and kiek_skaitoma, 000Fh ;paliekam tik paskutini skaitmeni, realiai dalybos is 10h liekana
									;suzinau maziausio gabaliuko dydi (pvz 57 simboliuose 16,16,16,9 tai cia gautume 9)
									; jus panasiai galit suzaisti su paprasta DIV dalyba (as panaudojau gudrybe kaip dalinti is 16
									;- t.y. paimu paskutini skaitmeni).
	
skaitymo_ciklas:
	cmp pozicija[0], 0
	jne skaitymo_ciklo_veiksmai
	cmp pozicija[2], 0 ;tricky, bet adresuojant zodzius reikia nepamirst kad lauztinuose rasomas poslinkis baitais
											;o ne indeksas, todel norint dirbt kaip su zodziu masyvu imama kas antra pozicija
	jne skaitymo_ciklo_veiksmai
	jmp uzdaryk_faila ;baigesi skaitymo ciklas, failo nebeliko, ateita iki jo nulines pozicijos (pradzios)

skaitymo_ciklo_veiksmai:
		call sumazink_pozicija
		call uzpildyk_buferi
		call spausdink_skaitmenis
	mov word ptr[kiek_skaitoma], BUF_DYDIS ;sekanciam prasukime pozicija mazinsime per buferio dydzio kieki baitu
jmp skaitymo_ciklas
	
	; Uzdarom duomenu faila
uzdaryk_faila:
	mov ah, 3Eh
	mov bx, duom_deskriptorius
	int 21h
jmp pabaiga

spausdink_klaida:
	mov ah, 9
	mov dx, offset klaidos_tekstas
	int 21h
jmp pabaiga
	
pabaiga:
	mov ah, 4Ch
	int 21h
;------------------------------------------------
; Dvieju zodziu dydzio pozicijos reiksme sumazinama per 'kiek_skaitoma' nurodyta kieki baitu
; tam kad faile pasitrauktume atgal.
PROC sumazink_pozicija
	push ax
	push bx
		mov ax,  pozicija[0]
		mov bx, pozicija[2]
		cmp bx, kiek_skaitoma
		jb mazinsim_ax ;prasisuko pilnas bx, kad net reikes mazinti ax (pozicija saugoma per 2 zodzius, pvz ax=1234h, bx=5678h, tai pozicija 12345678-toji)
		jmp nemazinsim_ax
		mazinsim_ax:
			dec ax
		nemazinsim_ax:
			sub bx, kiek_skaitoma ;bet kokiu atveju mazinam bx
		sumazink_pozicija_end:
			mov pozicija[0], ax
			mov pozicija[2], bx
	pop bx
	pop ax
RET
ENDP sumazink_pozicija
;------------------------------------------------
; paduodam cx, kiek simboliu nuskaityti, tiek ir nuskaitoma is buferio
; procedura uztikrina, kad zymeklis pastatomas i "pozicija" nurodyta pozicija faile
PROC uzpildyk_buferi
	push ax
	push bx
	push cx
	push dx
		; pastatom failo cursoriu i tinkama pozicija jame
		mov ah, 42h
		mov al, 0
		mov bx, duom_deskriptorius
		mov cx, pozicija[0]
		mov dx, pozicija[2]
		int 21h
		
		;uzpildom buferi nuskaitytais baitais
		mov ah, 3Fh
		mov bx, duom_deskriptorius
		mov cx, kiek_skaitoma
		mov dx, offset skaitymo_buferis
		int 21h
	pop dx
	pop cx
	pop bx
	pop ax
RET
ENDP uzpildyk_buferi
;-------------------------------------------------
;
;
PROC spausdink_skaitmenis
	push ax
	push bx
	push cx
	push dx
		mov bx, offset skaitymo_buferis
		add bx, kiek_skaitoma
		cikliukas_spausd:
			cmp bx, offset skaitymo_buferis ;ciklas kol negrizo iki buferio pradzios
			je spausdink_skaitmenis_end
			dec bx
			
			mov dh, [bx]
			cmp dh, 30h ; simbolis '0'
			jb cikliukas_spausd ;praleisti jei maziau uz '0' ascii koda
			cmp dh, 39h ; simbolis '9'
			ja cikliukas_spausd ; praleisti jei daugiau uz '9' ascii koda
			
			mov ah, 2 ;spausdins simboli i ekrana
			mov dl, dh
			int 21h
			
		jmp cikliukas_spausd
	spausdink_skaitmenis_end:
	pop dx
	pop cx
	pop bx
	pop ax
RET
ENDP spausdink_skaitmenis

END
