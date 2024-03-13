
;**********************************************************
; procedures shiftl/shiftr
;   dynamically shift bits in byte(B) N(ACC) times
;     ACC  # of shifts
;     B    byte to shift
;     ret  ACC
;
; procedures shiftl/shiftr
;   n_shifts  cycles(m1)
;   cycles      0-7  8n+87
;               8+   34
;   cycles(m1)  0-7  10n+97
;               8+   38
;**********************************************************


;**********************************************************
;   shared procedure(s) + constant(s) for bit shift
;   procedures
;
; cycles      17
; cycles(m1)  19
;**********************************************************
BITSHIFTMAX	equ	7
shift$overflow:	;return=acc=0
	mvi	a,0
	ret


;**********************************************************
; procedure shiftl
;   dynamically shift byte(B) N(ACC) times, to the left.
;     ACC  # of shifts 0-7
;     B    byte to shift 
;     ret  ACC
;
;   cycles      0-7  8n+87
;               8+   34
;   cycles(m1)  0-7  10n+97
;               8+   38
;**********************************************************
shiftl:		;acc=n_shifts, b=byte, return=acc
	cpi	BITSHIFTMAX+1	;check n_shifts <= BITSHIFTMAX
	jnc	shift$overflow	;if not, return 0
	xri	0000$0111b	;calculate table index (7 - n_shifts) 
	add	a		;calculate offset (2 bytes per index)
	mvi	h,0		;move offset into HL as a 16 bit value
	mov	l,a
	lxi	d,shiftl$table	;load the table address into DE
	dad	d		;calculate table jump address
	mov	a,b		;load byte into a
	mvi	b,1111$1110b	;load bitmask into b
	pchl			;jump to address using HL
shiftl$table:	;acc=byte, b=bitmask, return=acc
	ral		;index 7
	ana	b
	ral		;index 6
	ana	b
	ral		;index 5
	ana	b
	ral		;index 4
	ana	b
	ral		;index 3
	ana	b
	ral		;index 2
	ana	b
	ral		;index 1
	ana	b
	ret		;index 0


;**********************************************************
; procedure shiftr
;   dynamically shift byte(B) N(ACC) times, to the right.
;     ACC  # of shifts 0-7
;     B    byte to shift 
;     ret  ACC
;
;   cycles      0-7  8n+87
;               8+   34
;   cycles(m1)  0-7  10n+97
;               8+   38
;**********************************************************
shiftr:		;acc=n_shifts, b=byte, return=acc
	cpi	BITSHIFTMAX+1	;check n_shifts <= BITSHIFTMAX
	jnc	shift$overflow	;if not, return 0
	xri	0000$0111b	;calculate table index (7 - n_shifts) 
	add	a		;calculate offset (2 bytes per index)
	mvi	h,0		;move offset into HL as a 16 bit value
	mov	l,a
	lxi	d,shiftr$table	;load the table address into DE
	dad	d		;calculate table jump address
	mov	a,b		;load byte into a
	mvi	b,0111$1111b	;load bitmask into b
	pchl			;jump to address using HL
shiftr$table:	;acc=byte, b=bitmask, return=acc
	rar		;index 7
	ana	b
	rar		;index 6
	ana	b
	rar		;index 5
	ana	b
	rar		;index 4
	ana	b
	rar		;index 3
	ana	b
	rar		;index 2
	ana	b
	rar		;index 1
	ana	b
	ret		;index 0


