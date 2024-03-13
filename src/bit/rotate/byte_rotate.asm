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
; procedures rotatel/rotater
;   dynamically rotate bits in byte(B) N(ACC) times
;     ACC  # of rotates
;     B    byte to rotate
;     ret  ACC
;
; procedures rotatel/rotatel(m1)
;   cycles      0-255  4(n mod 8)+66
;   cycles(m1)  0-255  5(n mod 8)+73
;**********************************************************


;**********************************************************
; procedure rotatel
;   dynamically rotate byte(B) N(ACC) times, to the left.
;     ACC  # of rotates
;     B    byte to rotate
;     ret  ACC
;
;   cycles      4(n mod 8)+66
;   cycles(m1)  5(n mod 8)+73
;**********************************************************
rotatel:	;acc=n_rotates, b=byte, return=acc
	ani	0000$0111b	;n_rotates modulo 8 (stop overflows)
	xri	0000$0111b	;calculate table index/offset (7 - n_rotates)
	mvi	h,0		;move offset into HL as a 16 bit value
	mov	l,a
	lxi	d,rotatel$table	;load the table address into DE
	dad	d		;calculate table jump address
	mov	a,b		;load byte into a
	pchl			;jump to address using HL
rotatel$table:	;acc=byte, return=acc
	rlc		;index 7
	rlc		;index 6
	rlc		;index 5
	rlc		;index 4
	rlc		;index 3
	rlc		;index 2
	rlc		;index 1
	ret		;index 0


;**********************************************************
; procedure rotater
;   dynamically rotate byte(B) N(ACC) times, to the right.
;     ACC  # of rotates
;     B    byte to rotate
;     ret  ACC
;
;   cycles      4(n mod 8)+66
;   cycles(m1)  5(n mod 8)+73
;**********************************************************
rotater:	;acc=n_rotates, b=byte, return=acc
	ani	0000$0111b	;n_rotates modulo 8 (stop overflows)
	xri	0000$0111b	;calculate table index/offset (7 - n_rotates)
	mvi	h,0		;move offset into HL as a 16 bit value
	mov	l,a
	lxi	d,rotater$table	;load the table address into DE
	dad	d		;calculate table jump address
	mov	a,b		;load byte into a
	pchl			;jump to address using HL
rotater$table:	;acc=byte, return=acc
	rrc		;index 7
	rrc		;index 6
	rrc		;index 5
	rrc		;index 4
	rrc		;index 3
	rrc		;index 2
	rrc		;index 1
	ret		;index 0


