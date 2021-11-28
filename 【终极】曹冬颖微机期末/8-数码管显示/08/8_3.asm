;8255接口初始化，由CS连接的IOY端口决定。
A8255_CON EQU 0606H
A8255_A EQU 0600H
A8255_B EQU 0602H
A8255_C EQU 0604H
;数码管的数据表，分别表示0-9
DATA SEGMENT
TABLE1:
    DB 3FH
    DB 06H
    DB 5BH
    DB 4FH
    DB 66H
    DB 6DH
    DB 7DH
    DB 07H
    DB 7FH
    DB 6FH
SITE DB ?
NUM  DB ?
DATA ENDS   

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    
    LEA SI,TABLE1
    MOV CX,10
    MOV BX,0
B:
	PUSH CX
    MOV CX,6
   	MOV AL,11011111B
A:	
	MOV SITE,AL
	PUSH AX
	MOV AL,[SI+BX]
	MOV NUM,AL
	POP AX
	CALL DISP
	ROR AL,1
	LOOP A
	POP CX
	INC BX
	LOOP B
	JMP START
    ;MOV SITE,0FEH
    ;MOV NUM,06H 
    ;CALL DISP
    
DISP:
	PUSH AX
	PUSH DX
    MOV DX,A8255_CON
    MOV AL,81H
    OUT DX,AL   
    
    MOV DX,A8255_B
    MOV AL,3FH
    OUT DX,AL   
    
    MOV DX,A8255_A
    MOV AL,00H
    OUT DX,AL   
    

	MOV AL,[SITE]
    MOV DX,A8255_A
    OUT DX,AL     
    
    MOV AL,[NUM]
    MOV DX,A8255_B
    OUT DX,AL    

    CALL DELAY 
    POP DX
    POP AX
    RET  
    
DELAY:
    PUSH CX
    MOV CX,0FFFFH
X4:
    LOOP X4
    MOV CX,0FFFFH
X5:
    LOOP X5
    POP CX
    RET
CODE ENDS
     END START
