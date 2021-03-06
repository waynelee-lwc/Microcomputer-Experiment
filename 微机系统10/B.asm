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
		
	SECONDS DB 25
	MINUTS  DB 10
	
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
	MOV AL,10000000B
	OUT DX,AL
	

	MOV DX,A8255
	MOV AL,0H
	OUT DX,AL

	
LP:
	CALL PARSETIME
	CALL PRINT_LINE
	CALL DELAY2
;	CALL PRINT_CLEAR
	
	JMP LP
	
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
	
DMIR6:
	
	CALL TIMEDEC

	STI
	IRET


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


DELAY2:
	PUSH AX
	PUSH CX
	
	MOV CX,005H
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