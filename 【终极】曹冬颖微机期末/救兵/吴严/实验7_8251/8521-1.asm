M8251_DATA EQU 0600H             ;8251数据端口地址
M8251_CON EQU 0602H              ;8251控制端口地址
M8254_2 EQU 06C4H                ;8254计数器2端口地址
M8254_CON EQU 06C6H              ;8254控制寄存器端口地址
 
SSTACK  SEGMENT STACK
    DW 64 DUP(?)
SSTACK  ENDS
 
CODE SEGMENT
    ASSUME CS:CODE
START:  
    MOV AX, 0000H
    MOV DS, AX
 
    ;初始化 8254，得到收发时钟
    MOV AL, 0B6H
    MOV DX, M8254_CON
    OUT DX, AL
    MOV AL, 0CH
    MOV DX, M8254_2
    OUT DX, AL
    MOV AL, 00
    OUT DX, AL
 
    MOV DX, M8251_CON
    MOV AL, 00H
    OUT DX, AL
    CALL DELAY
    ;复位 8251
 
    MOV AL, 40H
    OUT DX, AL
    CALL DELAY
 
    MOV AL,7EH
    OUT DX, AL                   ;写入8251方式字7EH=01111110B，详见实验讲义P59
    CALL DELAY
 
    MOV AL, 34H
    OUT DX, AL                   ;写入8251控制字34H=00110110B，详见实验讲义P60
    CALL DELAY
 
    MOV DI, 4000H                ;写入地址
    MOV SI, 3000H                ;读入地址
    MOV CX, 000AH                ;循环10次
A1: 
    MOV AL, [SI]
    PUSH AX
    MOV AL, 37H
    MOV DX, M8251_CON
    OUT DX, AL
    POP AX
    MOV DX, M8251_DATA
    OUT DX, AL                   ;发送数据
    MOV DX, M8251_CON
A2: 
    IN AL, DX                    ;判断发送缓冲是否为空
    AND AL, 01H
    JZ A2
    CALL DELAY
A3: 
    IN AL, DX                    ;判断是否接收到数据
    AND AL, 02H
    JZ A3
    MOV DX, M8251_DATA
    IN AL, DX                    ;读取接收到的数据
    MOV [DI], AL
    INC DI
    INC SI
    LOOP A1                      ;循环10次
 
    MOV AH,4CH
    INT 21H                      ;程序终止
 
DELAY PROC NEAR                           ;延时子程序
    PUSH CX
    MOV CX,3000H
A5: 
    PUSH AX
    POP AX
    LOOP A5
    POP CX
    RET
    ENDP DELAY
CODE ENDS
    END START