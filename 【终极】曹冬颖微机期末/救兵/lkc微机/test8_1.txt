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
DATA ENDS   

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX 
    
    LEA SI,TABLE1 
    
    MOV DX,A8255_CON
    MOV AL,81H
    OUT DX,AL    
    
    MOV DX,A8255_B
    MOV AL,3FH
    OUT DX,AL  
    
    MOV DX,A8255_A
    MOV AL,00H
    OUT DX,AL   
    
    MOV CX,0AH
    MOV BX,0000H
X1: 
    PUSH CX    
    MOV CX,06H    
    
    MOV AL,11011111B
X2:
    MOV DX,A8255_A
    OUT DX,AL 
    
    ROR AL,1   
    
    PUSH AX  
    
    MOV AL,[BX+SI]
    MOV DX,A8255_B
    OUT DX,AL     
    
    POP AX    
    CALL DELAY
    LOOP X2
    POP CX  
    
    INC BX
    LOOP X1 
    
    JMP START  
    
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
