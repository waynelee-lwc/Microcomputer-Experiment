A8255_CON EQU 0646H
A8255_A EQU 0640H
A8255_B EQU 0642H
A8255_C EQU 0644H
 
DATA SEGMENT
TABLE1:    ;500371
    DB 3FH
    DB 5BH
    DB 66H
    DB 06H
    DB 4FH
    DB 06H
DATA ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
	
    LEA SI,TABLE1
	
    MOV DX,A8255_CON       
    MOV AL,89H
    OUT DX,AL
	
    MOV DX,A8255_B
    MOV AL,3FH        ;0�Ķ���
    OUT DX,AL
	
    MOV DX,A8255_A
    MOV AL,00H        
    OUT DX,AL
	
X2: 
    MOV DX,A8255_C
    IN AL,DX   
	MOV DI,AX           ;DI���濪��ֵ
    MOV CX,06H          ;������
    MOV BX,0000H
    MOV AL,11011111B     ;��ʾ����λ
X1: 
    PUSH AX
    MOV AX,DI
	MOV AH,00H
	
	PUSH BX
	MOV BL,02H
	DIV BL
	POP BX
	
	MOV DI,AX
	
	POP AX;
	
	MOV DX,DI
	
	MOV AH,AL
	CMP DH,00H   ;����
	JNZ    XX        ;����ʾ
	

	
	MOV AL,11111111B 
	
 XX:   MOV DX,A8255_A
    OUT DX,AL
    
	MOV AL,AH
;	MOV AX,DI
    ROR AL,1
	
    PUSH AX           ;������һ�ε�λ��
	
    MOV AL,[BX+SI]
    MOV DX,A8255_B
    OUT DX,AL
	
    POP AX             ;
	
    CALL DELAY
    INC BX
    LOOP X1
    JMP X2 
	
DELAY PROC NEAR
    PUSH CX
    MOV CX,0FFH
X4:
    LOOP X4
    POP CX
    RET
	ENDP DELAY
CODE ENDS
     END START