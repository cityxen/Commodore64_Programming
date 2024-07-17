; PLAYSOUND FX	
; MALCOLM BAMBER
; CODE IN C64ASM  			
* = $0800 
.byte $00,$0c,$08,$0a,$00,$9e,$31,$36,$35,$30,$30,$00,$00,$00,$00

* = 16500    

	sid	= $D400
	raster = 50
	lda #$0f
	sta $d418     ; Select Filter Mode and Volume

	lda #1
	sta 649       ; disable keyboard buffering

	lda #0
	sta 204       ; turn cursor on during a GET

	lda #127
	sta 650	      ; no keys repeat
	jsr soundinterrupts
					

mainloop			
	; PRESS A NUMBER FROM 0 TO 3 and 9 to quit
_wait
	jsr $ffe4     ; GETIN Get a byte from channel A=0 if buffer empty
	beq _wait
	eor #$30      ; convert key numbet to a real number
	cmp #9
	beq _brk
	cmp #4            ; number you press must be less than 4
	bcs _clearbuffer  ; if number greater than 4 then jump to clear buffer
	sta effect        ; store in fx byte
_clearbuffer
	lda #0
	sta 198       ; clear keyboard buffer
	jmp _wait     ; wait for next key
_brk
	rts

soundinterrupts	
	SEI     		
	LDA #$01
	STA $D01A      ; VIC Interrupt Mask Register (IMR)
	LDA #<intsoundcode
	LDX #>intsoundcode
	STA $0314      ; irq address 
	STX $0315      ; irq address 
	LDY #raster    ; 251 raster position 
	STY $D012      ; Raster Position
	LDA #$7F
	STA $DC0D      ; CIA Interrupt Control Register
	LDA $DC0D      ; CIA Interrupt Control Register
	CLI
	rts
       			
intsoundcode	
	ldy #0
	lda effect      ; LOAD FX NUMBER
	cmp #128        ; 128 MEANS NO NEW EFFECT NUMBER WAS ASK FOR
	beq _playsounds ; PLAY SOUNDS 
	jmp _resetsound ; RESET SOUND DATA          							
; PLAY SOUNDS          			        			 			         			
_playsounds		
	ldy #0
_loop			
	lda voicearray,y   ; CHECK IF SOUND IS STILL PLAYING
	cmp #128           ; 128 MEANS NO
	beq _nextvoice     ; TRY NEXT SOUND VOICE
	jmp _continuesound
_nextvoice
	iny                ; SET Y TO NEXT SOUND VIOCE 
	iny
	iny
	iny
	iny
	iny
	iny
	cpy #21            ; HAVE WE DONE ALL FOUR VOICES 
	beq _irqjmp        ; YES
	jmp _loop          ; NO
         			
_irqjmp
	lda #$ff           ; QUIT OUT AND WAIT
	sta $D019          ; VIC Interrupt Request Register (IRR)	
	jmp $ea31          ; quit out
          			         			
; OVER WRITE SOUND DATA FROM ARRAY TO SID CHIP					
_resetsound
	inc $d020          ; LET YOU KNOW THAT SOUND IS WORKING 
	tax                ; COPY EFFECT NUMBER  TO X FOR ARRAY VALUES OF SOUND				
	lda ivoice,x       ; GET WHICH VOICE NUMBER TO USE
	tay                ; STORE VOICE NUMBER IN Y
				
	; RUN FROM HERE IS SOUND IS NOT PLAYING YET
	lda voicearray,y   ; HAS SOUND STOPPED
	cmp #128
	beq _miss2         ; SOUND NOT PLAYING 
				
	; CHECK IF WE CAN OVER WRITE A SOUND THAT IS ALLREADY PLAYING
	lda iwrite,x       ; LOAD REWRITE FLAG
	cmp #1             ; IF ONE THEN WE MUST WAIT FOR SOUND TO STOP
	beq _playsounds    ; GO TO PLAY SOUNDS
	
_miss2
	lda ivoice,x       ; GET WHICH VOICE TO USE
	sta voicearray+1,y ; SET VOICEARRAY TO VOICE NUMBER BEING USED

	lda istep,x        ; GET LOW BYTE STEP FREQUENCY PER CYCLE
	sta voicearray+2,y ; SET VOICEARRAY TO FREQUENCY NUMBER BEING USED

	lda istep+1,x      ; GET HI BYTE STEP FREQUENCY PER CYCLE
	sta voicearray+3,y ; SET VOICEARRAY TO FREQUENCY NUMBER BEING USED

	lda istepway,x     ; GET IF WE ARE ADDING OR SUBBING STEP FREQUENCY
	sta voicearray+4,y ; SET VOICEARRAY TO STEPWAY BEING USED

	lda icount,x       ; GET HOW LONG SOUND SHOULD PLAY FOR
	sta voicearray+5,y ; SET VOICEARRAY TO HOW LONG SOUND WILL PLAY FOR

	lda ifrq,x         ; LOAD LOW BYTE FREQUENCY VALUE 
	sta sid,y          ; WRITE TO SID CHIP

	lda ifrq+1,x       ; GET HIGH BYTE FREQUENCY VALUE 
	sta sid+1,y        ; WRITE TO SID CHIP

	lda ipulse,x       ; LOAD LOW BYTE PULSE FREQUENCY VALUE
	sta sid+2,y        ; WRITE TO SID CHIP

	lda ipulse+1,x     ; LOAD HIGH BYTE PULSE FREQUENCY VALUE
	sta sid+3,y        ; WRITE TO SID CHIP

	lda iatdk,x        ; LOAD THE ATDK VALUES
	sta sid+5,y        ; WRITE TO SID CHIP 
   
	lda isurl,x        ; LOAD THE SUSAIN /RELEASE VALUES
	sta sid+6,y        ; WRITE TO SID CHIP

	; SET FILTER MODE
	lda ifilterl       ; LOW BYTE OF FILTER FREQUENCY VALUE
	sta sid+21         ; WRITE TO SID CHIP

	lda ifilterh       ; HIGH BYTE OF FILTER FREQUENCY VALUE
	sta sid+22         ; WRITE TO SID CHIP

	lda ifiltercon     ; SET TO FILTER ONLY
	sta sid+23         ; WRITE TO SID CHIP

	clc
	lda ifiltermode    ; SELECT FILTER BAND-PASS MODE AND MAXIMUM VOLUME
	adc #15
	sta sid+24         ; WRITE TO SID CHIP

	lda icreg,x        ; LOAD VALUE FOR CONTROL REGISTER
	sta sid+4,y        ; WRITE TO SID CHIP CONTROL REGISTER
	lda #0
	sta voicearray,y   ; SET TO ZERO FOR SOUND RUNNING
	lda #128
	sta effect         ; CLEAR THE FX NUMBER 
	jmp _playsounds
     			
; CONTINUE WITH SOUND FX
_continuesound
	lda voicearray+5,y  ; HOW LONG SOUND SHOULD PLAY FOR
	cmp #0              ; SHOULD SOUND STOP
	bne _minusone       ; NO
	lda #0
	sta sid+4,y         ; CLEAR SID VOICE CONTROL REGISTER  
	lda #128
	sta voicearray,y    ; SET THE FX NUMBER WE WHERE PLAYING BACK TO 128
	jmp _nextvoice      ; QUIT BACK TO PLAY SOUNDS 
         			
_minusone
	sec                 ; REMOVE ONE FROM VOICEARRAY+5
	lda voicearray+5,y
	sbc #1
	sta voicearray+5,y  ; STORE IT

	lda voicearray+2,y  ; CHECK STEP VALUE
	cmp #0              ; IS IT ZERO
	bne _stepit         ; NO SO GO TO STEP FREQUENCY VALUE
	jmp _nextvoice      ; QUIT BACK TO PLAY SOUNDS 	
         			
_stepit
	; CHANGE FREQ VALUE OF SOUND
	lda voicearray+4,y  ; CHECK IF WE ARE MINUSING OR ADDING A STEP VALUE TO NOTE
	cmp #1              ; ARE WE ADDING THE STEP FREQUENCY VALUE
	bne _subit          ; NO THEN WE MUST MINUS THE STEP FREQUENCY VALUE
	clc
	lda sid,y           ; GET CURRENT LOW BYTE FREQUENCY VALUE WE ARE USING
	adc voicearray+2,y  ; ADD LOW BYTE STEP FREQUENCY VALUE 
	sta sid,y           ; WRITE NEW LOW BYTE FREQUENCY BACK TO SID
	lda sid+1,y         ; GET CURRENT HIGH BYTE FREQUENCY VALUE WE ARE USING
	adc voicearray+3,y  ; ADD HIGH BYTE STEP FREQUENCY VALUE
	sta sid+1,y         ; WRITE NEW HIGH BYTE FREQUENCY BACK TO SID
	jmp _nextvoice      ; QUIT BACK TO PLAY SOUNDS 
         			
_subit
	sec
	lda sid,y           ; GET CURRENT LOW BYTE FREQUENCY VALUE WE ARE USING
	sbc voicearray+2,y  ; MINUS LOW BYTE STEP FREQUENCY VALUE 
	sta sid,y           ; WRITE NEW LOW BYTE FREQUENCY BACK TO SID
	lda sid+1,y         ; GET CURRENT HIGH BYTE FREQUENCY VALUE WE ARE USING
	sbc voicearray+3,y  ; MINUS HIGH BYTE STEP FREQUENCY VALUE
	sta sid+1,y         ; WRITE NEW HIGH BYTE FREQUENCY BACK TO SID        			
	jmp _nextvoice      ; QUIT BACK TO PLAY SOUNDS 
         			
         			
effect
	.byte 128     ; WERE FX NUMBER IS WRITEN TO
         			
; VOICE 1
voicearray
	.byte 128     ; 0 	128 MEANING NO SOUND FX IS BEING USED	
	.byte 0       ; 1 	VOICE NUMBER BEING USED
	.byte 0       ; 2  	LOW BYTE FREQUENCY VALUE 
	.byte 0       ; 3		HIGH BYTE FREQUENCY VALUE 
	.byte 0       ; 4 	ARE WE ADDING A STEP FREQUENCY VALUE  
	.byte 0       ; 5 	HOW LONG SOUND WILL PLAY FOR 
	.byte 0       ; 6 	FREE
; VOICE 2			
	.byte 128     ; 0 	128 MEANING NO SOUND FX IS BEING USED	
	.byte 0       ; 1 	VOICE NUMBER BEING USED
	.byte 0       ; 2  	LOW BYTE FREQUENCY VALUE 
	.byte 0       ; 3		HIGH BYTE FREQUENCY VALUE 
	.byte 0       ; 4 	ARE WE ADDING A STEP FREQUENCY VALUE  
	.byte 0       ; 5 	HOW LONG SOUND WILL PLAY FOR 
	.byte 0       ; 6 	FREE
					
; VOICE 3			
	.byte 128     ; 0 	128 MEANING NO SOUND FX IS BEING USED	
	.byte 0       ; 1 	VOICE NUMBER BEING USED
	.byte 0       ; 2  	LOW BYTE FREQUENCY VALUE 
	.byte 0       ; 3	HIGH BYTE FREQUENCY VALUE 
	.byte 0       ; 4 	ARE WE ADDING A STEP FREQUENCY VALUE  
	.byte 0       ; 5 	HOW LONG SOUND WILL PLAY FOR 
	.byte 0       ; 6 	FREE

; WHICH VOICE
; VOICE 1	0
; VOICE 2	7
; VOICE 3	14
ivoice
	.byte 0   ; PLAYERS GUN SHOT				
	.byte 7   ; ENEMY SHOOT AT PLAYER
	.byte 14  ; EXPLOSION
	.byte 0
										
; HOW LONG SOUND WILL PLAY FOR
icount
	.byte 25							
	.byte 25						
	.byte 100							
	.byte 25							
         							
         			
; START NOTE FREQUENCY RANGE (268 to 64814 )
ifrq
	.word 6000								
	.word 9000							
	.word 6000							
	.word 9000							
         			         								
; PULSE NOTE FREQUENCY     
; $D402 IS THE LOW BYTE OF THE PULSE WIDTH (LPW = 0 THROUGH 255). 
; $D403 IS THE HIGH 4 BITS (HPW = 0 THROUGH 15).      			
ipulse
	.word 3000						
	.word 0
	.word 0
	.word 0
										      			
; UP SCALE OR DOWN SCALE
istep
	.word 0								
	.word 0							
	.word 1000							
	.word 0							
         			         											
; PLUS=1 OR MINUS=2  
istepway
	.byte 0						
	.byte 0
	.byte 2
	.byte 0
					
;SID-ADR-Table:
;
;     VALUE    ATTACK    DECAY/RELEASE
;   +-------+----------+---------------+
;   |   0   |    2 ms  |      6 ms     |
;   |   1   |    8 ms  |     24 ms     |
;   |   2   |   16 ms  |     48 ms     |
;   |   3   |   24 ms  |     72 ms     |
;   |   4   |   38 ms  |    114 ms     |
;   |   5   |   56 ms  |    168 ms     |
;   |   6   |   68 ms  |    204 ms     |
;   |   7   |   80 ms  |    240 ms     |
;   |   8   |  100 ms  |    300 ms     |
;   |   9   |  240 ms  |    720 ms     |
;   |   A   |  500 ms  |    1.5 s      |
;   |   B   |  800 ms  |    2.4 s      |
;   |   C   |    1 s   |      3 s      |
;   |   D   |    3 s   |      9 s      |
;   |   E   |    5 s   |     15 s      |
;   |   F   |    8 s   |     24 s      |
;   +-------+----------+---------------+					
										
; ATTACK / DECAY CYCLE CONTROL
; Bits 7-4 Select ATTACK Cycle Duration: 0-15             
; Bits 3-0 Select DECAY Cycle Duration: 0-15  
iatdk
	.byte $06 						
	.byte $7f						
	.byte $bf							
	.byte $7f						
         			
; SUSTAIN / RELEASE CYCLE CONTROL
; Bits 7-4 Select Sustain Cycle Duration: 0-15             
; Bits 3-0 Select Release Cycle Duration: 0-15             	
isurl
	.byte $10						
	.byte $f9 						
	.byte $31 						
	.byte $f3	
       								
; WAVEFORM/GATE BIT SET		
; BIT 7 SELECT RANDOM NOISE WAVEFORM, 	1 = ON 
; BIT 6 SELECT PULSE WAVEFORM, 			1 = ON
; BIT 5 SELECT SAWTOOTH WAVEFORM, 		1 = ON
; BIT 4 SELECT TRIANGLE WAVEFORM, 		1 = ON 
; BIT 3 TEST BIT: 1 = DISABLE OSCILLATOR 
; BIT 2 RING MODULATE OSC. 1 WITH OSC. 3 OUTPUT, 1 = ON 
; BIT 1 SYNCHRONIZE OSC. 1 WITH OSC. 3 FREQUENCY, 1 = ON 
; BIT 0 GATE BIT: 1 = START ATT/DEC/SUS, 0 = START RELEASE
; TRIANGLE 				ON 17 	OFF	16
; SAWTOOTH 		 		ON 33 	OFF	32
; PULSE 				ON 65 	OFF 64
; NOISE WAVEFORM 		ON 129 	OFF 128
icreg
	.byte 65						 
	.byte 33  						 
	.byte 129						 
	.byte 17						 
		         			

;$D415	FILTER CUTOFF FREQUENCY: LOW-NYBBLE	(BITS 2-0) (0 to 7)
ifilterl
	.byte 0							
	.byte 0
	.byte 0
	.byte 0
						
;$D416	FILTER CUTOFF FREQUENCY: HIGH-BYTE 					
ifilterh
	.byte 0							
	.byte 0
	.byte 100
	.byte 0
					
; FILTERCON 7-4
; $D417	FILTER RESONANCE CONTROL / VOICE INPUT CONTROL
; 7-4	SELECT FILTER RESONANCE: 0-15
; 3		FILTER EXTERNAL INPUT: 1 = YES, 0 = NO
; 2		FILTER VOICE 3 OUTPUT: 1 = YES, 0 = NO	
; 1		FILTER VOICE 2 OUTPUT: 1 = YES, 0 = NO	
; 0		FILTER VOICE 1 OUTPUT: 1 = YES, 0 = NO				
ifiltercon
	.byte 0							
	.byte 0
	.byte %1100 0010
	.byte 0
					
; FILTERMODE		
; $D418	SELECT FILTER MODE AND VOLUME
; 7		CUT-OFF VOICE 3 OUTPUT: 1 = OFF, 0 = ON  	
; 6		SELECT FILTER HIGH-PASS MODE: 1 = ON				
; 5		SELECT FILTER BAND-PASS MODE: 1 = ON		
; 4		SELECT FILTER LOW-PASS MODE: 1 = ON			
; 3-0	SELECT OUTPUT VOLUME: 0-15			
							
ifiltermode
	.byte 0						        			
	.byte 0
	.byte %0010 0000
	.byte 0
										
; OVER WRITE SOUND VALUES WITH NEW SOUND VALUES	0=rewrite 1=not to rewrite				
iwrite
	.byte 1						        			
	.byte 1
	.byte 0
	.byte 1