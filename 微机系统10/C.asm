A8255 EQU 0640H
B8255 EQU 0642H
C8255 EQU 0644H
CON8255 EQU 0646H

CT08254 EQU 0600H
CT18254 EQU 0602H
CT28254 EQU 0604H
CON8254 EQU 0606H

DATA SEGMENT
	
	TB:
		DB 03FH
		DB 006H
		DB 05BH
		DB 04FH
		DB 066H
		DB 06DH
		DB 07DH
		DB 007H
		DB 07FH
		DB 06FH
		DB 077H
		DB 07CH
		DB 039H
		DB 05EH
		DB 079H
		DB 071H
		DB 000H
		
	
	NUM_LIGHT DB 00H
	CON_LIGHT DB 00H
	
	
	PRINTS:
		DB 00H
		DB 01H
		DB 02H
		DB 03H
		DB 10H
		DB 10H
		
	SECONDS DB 3
	MINUTS  DB 0
	
	KB_FLAG DB 0
	KB_VAL DB 0
	
	MODE DB 2   ;0 READ/ 2 COUNT / 3 SUSPEND / 4 FLASH
	
DATA ENDS
CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:



	MOV DX,CON8254 
	MOV AL,76H 
	OUT DX,AL
	
	MOV DX,CT18254
	MOV AL,00H
	OUT DX,AL
	
	MOV AL,48H
	OUT DX,AL

	
	MOV AX,OFFSET DMIR6
	MOV SI,0038H
	MOV [SI],AX
	MOV AX,CS
	MOV SI,003AH
	MOV [SI],AX
	
	MOV AX,OFFSET DMIR7
	MOV SI,003CH
	MOV [SI],AX
	MOV AX,CS
	MOV SI,003EH
	MOV [SI],AX
	

	CLI
	MOV AL,11H
	OUT 20H,AL
	
	MOV AL,08H
	OUT 21H,AL
	
	MOV AL,04H
	OUT 21H,AL
	
	MOV AL,07H
	OUT 21H,AL
	
	MOV AL,2FH
	OUT 21H,AL
	STI
	
	MOV AX,DATA
	MOV DS,AX
	
	MOV AH,0FH
	
		
	MOV DX,CON8255
	MOV AL,10000001B
	OUT DX,AL
	

	MOV DX,A8255
	MOV AL,0H
	OUT DX,AL

	
LP:
	CMP MODE,5
	JE ED
	
	
	CALL SCAN_KEYBOARD
	
	MOV AL,KB_FLAG
	CMP AL,0
	JE LPNEXT1
	
	CALL READ_KEYBOARD

	CMP KB_VAL,0CH
	JNE LPNEXT1
	CALL SUSPEND
LPNEXT1:
	CMP MODE,3
	JNE LPNEXT2
	
	CALL PARSETIME
	CALL PRINT_LINE
	JMP LP
	
LPNEXT2:
	CALL WORK
	JMP LP

ED:
;	CALL CLEAR_LINE
;	CALL PRINT_LINE
	INT 21H
	
;--------------------------------------------
SUSPEND:
	PUSH AX
	MOV AL,MODE
	XOR AL,00000001B
	MOV MODE,AL
	POP AX
	RET
;--------------------------------------------

WORK:
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

WKBG:
WK0:
	; MODE 0 READ NUMBER
	CMP MODE,0
	JNE WK2
	
	
	
	JMP WKED
WK2:
	CMP MODE,2
	JNE WK3
	
		CALL PARSETIME
		CALL PRINT_LINE
		CALL DELAY1
	
	JMP WKED
WK3:
	CMP MODE,3
	JNE WK4
		
	JMP WKED
WK4:
		
	MOV CX,3
	WK3LP:		
	
		CALL PARSETIME
		CALL PRINT_LINE
		
		CALL DELAY2
		CALL DELAY2
		
		LOOP WK3LP
		
	MOV MODE,5
	JMP WKED

WKED:
	POP DX
	POP CX
	POP BX
	POP AX
	RET
	
	
	
	
;--------------------------------------------
READ_KEYBOARD:

	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	CALL CLEAR_LINE
	
	MOV AH,11111110B
	MOV BH,0
	
RK1:
	MOV DX,A8255
	MOV AL,AH
	OUT DX,AL
	
	MOV DX,C8255
	IN AL,DX
	
	AND AL,00001111B
	
	MOV BL,BH
	
RK2:
	MOV CL,AL
	AND CL,00000001H
	CMP CL,0
	JE RKBACK
	SHR AL,1
	ADD BL,4
	
	CMP BL,0FH
	JB RK2
	
	ROL AH,1
	INC BH
	
	CMP BH,4
	JNE RK1
	
	
RKBACK:
	MOV KB_VAL,BL
	
RKLP:
	CALL SCAN_KEYBOARD
	CMP KB_FLAG,1
	JE RKLP
	
	POP DX
	POP CX
	POP BX
	POP AX
	RET

;--------------------------------------------
SCAN_KEYBOARD:
	
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	CALL CLEAR_LINE
	
	MOV KB_FLAG,0
	
	MOV DX,A8255
	MOV AL,00H
	OUT DX,AL
	
	MOV DX,C8255
	IN AL,DX
	
	AND AL,00001111B
	
	CMP AL,00001111B
	JE SKBACK
	
	MOV KB_FLAG,1
SKBACK:
	
	POP DX
	POP CX
	POP BX
	POP AX
	RET
	
;--------------------------------------------	

PRINT_CLEAR:
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH SI
	
	MOV DX,B8255
	MOV AL,0
	OUT DX,AL
	
	MOV DX,A8255
	MOV AL,0
	OUT DX,AL
	
	POP SI
	POP CX
	POP BX
	POP AX
	RET
	
;------------------------------------------
PRINT_LINE:
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH SI
	
	MOV AH,11011111B
	LEA SI,PRINTS
	MOV BX,00H
	
PTL:
	MOV AL,[SI+BX]
	MOV NUM_LIGHT,AL
	MOV CON_LIGHT,AH
	CALL PRINT_SINGLE
	CALL DELAY1
	INC BX
	ROR AH,1
	CMP BX,06H
	JNE PTL
	
	POP SI
	POP CX
	POP BX
	POP AX
	RET

;-----------------------------------------
	
PRINT_SINGLE:
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH SI
	
	MOV DX,A8255
	MOV AL,CON_LIGHT
	OUT DX,AL
	
	MOV DX,B8255
	MOV BH,0
	MOV BL,NUM_LIGHT
	LEA SI,TB
	MOV AL,[SI+BX]
	OUT DX,AL
	
	POP SI
	POP CX
	POP BX
	POP AX
	RET

;-----------------------------------------------------
DMIR6:
	
	
	PUSH AX
	
	CMP MODE,3
	JAE MIR6END
	
	
	CALL TIMEDEC
	
	
	MOV AL,SECONDS
	MOV AH,MINUTS
	OR AL,AH
	
	CMP AL,0
	JNE MIR6END
	MOV MODE,4
	
MIR6END:	
	POP AX

	STI
	IRET

DMIR7:
	
	CALL CLEAR_LINE
	
	STI
	IRET

;----------------------------------------------------
CLEAR_LINE:
	PUSH AX
	PUSH SI
	PUSH BX
	
	LEA SI,PRINTS
	MOV BX,0
CLINE:
	MOV AL,10H
	MOV [SI+BX],AL
	INC BX
	CMP BX,6
	JNE CLINE
	
	POP BX
	POP SI
	POP AX
	RET

;----------------------------------------------------
PARSETIME:
	PUSH AX
	PUSH BX
	PUSH SI
	
	LEA SI,PRINTS
	
	MOV BL,10
	MOV AL,MINUTS
	MOV AH,0
	DIV BL
	
	MOV [SI+2],AH
	MOV [SI+3],AL
	
	MOV AL,SECONDS
	MOV AH,0
	DIV BL
	
	MOV [SI+0],AH
	MOV [SI+1],AL
	
	
	POP SI
	POP BX
	POP AX
	RET

;-----------------------------------------------------
TIMEDEC:
	PUSH AX
	PUSH SI
	
	MOV AL,SECONDS
	DEC AL
	
	CMP AL,0FFH
	JNE CDBACK
	MOV AH,MINUTS
	DEC AH
	MOV MINUTS,AH
	MOV AL,59

CDBACK:
	MOV SECONDS,AL	
	POP SI
	POP AX
	RET

;---------------------------------------------------------------
DELAY2:
	PUSH AX
	PUSH CX
	
	MOV CX,001FH
DL2:
	CALL DELAY1
	LOOP DL2
	
	POP CX
	POP AX
	RET

DELAY1:

	PUSH AX
	PUSH CX
	
	MOV CX,04FFH
DL1:
	LOOP DL1
	
	POP CX
	POP AX
	RET

CODE ENDS
	END START