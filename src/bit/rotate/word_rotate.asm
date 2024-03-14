; Copyright 2024 Sage I. Hendricks <sage.message@email.com>
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
;     http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.


;**********************************************************
; procedures w$rlc/w$rrc
;   rotate bits in word(DE) 1 time 
;     DE   word to rotate
;     ret  DE
;
; procedures w$rotatel/w$rotatel(m1)
;   cycles      
;   cycles(m1)  
;**********************************************************


;**********************************************************
; procedure w$rlc
;   rotate word(DE) 1 time, to the left.
;     DE   word to rotate
;     ret  DE
;
;   cycles      
;   cycles(m1)  
;**********************************************************
w$rlc:
	mov	a,d		;cy = prev hi bit7
	ral
	mov	a,e		;shift low-order byte left
	ral			;lo bit0 = cy
	mov	e,a		;cy = prev lo bit7
	mov	a,d		;shift high-order byte left
	ral			;hi bit0 = cy
	mov	d,a		;cy = prev hi bit7
	ret


;**********************************************************
; procedure w$rrc
;   rotate word(DE) 1 time, to the right.
;     DE   word to rotate
;     ret  DE
;
;   cycles  
;   cycles(m1)  
;**********************************************************
w$rrc:
	mov	a,e		;cy = prev hi bit0
	rar
	mov	a,d		;shift low-order byte right
	rar			;lo bit7 = cy
	mov	d,a		;cy = prev lo bit0
	mov	a,e		;shift high-order byte left
	rar			;hi bit7 = cy
	mov	e,a		;cy = prev hi bit0
	ret


;**********************************************************
; procedure w$rotatel
;   dynamically rotate word(DE) N(ACC) times, to the left.
;     ACC  # of rotates
;     DE   word to rotate
;     ret  DE
;
;   cycles      0-7   37(n mod 8)+90
;   cycles(m1)  8-15  37(n mod 8)+111
;**********************************************************
w$rotatel:	;acc=n_rotate, de=word, return=de
	ani	0000$1111b	;n_rotates module 16
	cpi     7+1             ;check if remainder <= 7 
	jc	w$rotatel$0	;if it is, skip to continue
	xchg			;move de into hl
	mov	d,l		;hi = prev lo
	mov	e,h		;lo = prev hi
	ani     0000$0111b	;remainder modulo 8 (stop overflows)
w$rotatel$0:
	xri	0000$0111b	;calculate table index (7 - n_rotates)
	add	a		;calculate offset (index * 8)
	add	a
	add	a
	mvi	h,0		;move offset into HL as a 16 bit value
	mov	l,a
	lxi	b,w$rotatel$table;load the table adress into BC
	dad	b		;calculate table jump adress
	pchl			;jump to address using HL
w$rotatel$table:;de=word, return=de
	mov	a,d	;7	;cy = prev hi bit7
	ral
	mov	a,e		;shift low-order byte left
	ral			;lo bit0 = cy
	mov	e,a		;cy = prev lo bit7
	mov	a,d		;shift high-order byte left
	ral			;hi bit0 = cy
	mov	d,a		;cy = prev hi bit7
	mov	a,d	;6
	ral
	mov	a,e
	ral
	mov	e,a
	mov	a,d
	ral
	mov	d,a
	mov	a,d	;5	;note: removing this line, 'mov a,d', 
	ral			;slows mean execution time by 4.5 
	mov	a,e		;cycles. forces index*7, over x8
	ral
	mov	e,a
	mov	a,d
	ral
	mov	d,a
	mov	a,d	;4
	ral
	mov	a,e
	ral
	mov	e,a
	mov	a,d
	ral
	mov	d,a
	mov	a,d	;3
	ral
	mov	a,e
	ral
	mov	e,a
	mov	a,d
	ral
	mov	d,a
	mov	a,d	;2
	ral
	mov	a,e
	ral
	mov	e,a
	mov	a,d
	ral
	mov	d,a
	mov	a,d	;1
	ral
	mov	a,e
	ral
	mov	e,a
	mov	a,d
	ral
	mov	d,a
	ret		;0	;return



;**********************************************************
; procedure w$rotater
;   dynamically rotate word(DE) N(ACC) times, to the right.
;     ACC  # of rotates
;     DE   word to rotate
;     ret  DE
;
;   cycles      0-7   37(n mod 8)+90
;   cycles(m1)  8-15  37(n mod 8)+111
;**********************************************************
w$rotater:	;acc=n_rotate, de=word, return=de
	ani	0000$1111b	;n_rotates module 16
	cpi     7+1             ;check if remainder <= 7 
	jc	w$rotater$0	;if it is, skip to continue
	xchg			;move de into hl
	mov	d,l		;hi = prev lo
	mov	e,h		;lo = prev hi
	ani     0000$0111b	;remainder modulo 8 (stop overflows)
w$rotater$0:
	xri	0000$0111b	;calculate table index (7 - n_rotates)
	add	a		;calculate offset (index * 8)
	add	a
	add	a
	mvi	h,0		;move offset into HL as a 16 bit value
	mov	l,a
	lxi	b,w$rotater$table;load the table adress into BC
	dad	b		;calculate table jump adress
	pchl			;jump to address using HL
w$rotatel$table:;de=word, return=de
	mov	a,e	;7	;cy = prev hi bit0
	rar
	mov	a,d		;shift low-order byte left
	rar			;lo bit7 = cy
	mov	d,a		;cy = prev lo bit0
	mov	a,e		;shift high-order byte left
	rar			;hi bit7 = cy
	mov	e,a		;cy = prev hi bit0
	mov	a,e	;6
	rar
	mov	a,d
	rar
	mov	d,a
	mov	a,e
	rar
	mov	e,a
	mov	a,e	;5	;note: removing this line, 'mov a,d', 
	rar			;slows mean execution time by 4.5 
	mov	a,d		;cycles. forces index*7, over x8
	rar
	mov	d,a
	mov	a,e
	rar
	mov	e,a
	mov	a,e	;4
	rar
	mov	a,d
	rar
	mov	d,a
	mov	a,e
	rar
	mov	e,a
	mov	a,e	;3
	rar
	mov	a,d
	rar
	mov	d,a
	mov	a,e
	rar
	mov	e,a
	mov	a,e	;2
	rar
	mov	a,d
	rar
	mov	d,a
	mov	a,e
	rar
	mov	e,a
	mov	a,e	;1
	rar
	mov	a,d
	rar
	mov	d,a
	mov	a,e
	rar
	mov	e,a
	ret		;0	;return


