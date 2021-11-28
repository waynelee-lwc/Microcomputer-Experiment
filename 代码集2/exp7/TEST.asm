M8251_DATA EQU 0600H             ;8251数据端口地址
M8251_CON EQU 0602H              ;8251控制端口地址
M8254_2 EQU 06C4H                ;8254计数器2端口地址
M8254_CON EQU 06C6H              ;8254控制寄存器端口地址
M8255_CON EQU 0646H
M8255_B EQU 0642H

SSTACK  SEGMENT STACK
    DW 64 DUP(?)
SSTACK  ENDS
 
CODE SEGMENT
    ASSUME CS:CODE
START:  
	MOV DX,M8255_CON
	MOV AL,90H
	OUT DX,AL
    MOV AX, 0000H
    MOV DS, AX
    ;初始化 8254，得到收发时钟
    MOV AL, 0B6H		;10 11 011 0b 计数器2，读写高八位，方式3，二进制
    MOV DX, M8254_CON
    OUT DX, AL
    MOV AL, 0CH			;00001011 MK
    MOV DX, M8254_2
    OUT DX, AL
    MOV AL, 00
    OUT DX, AL
 
 	
    MOV DX, M8251_CON
    MOV AL, 00H
    OUT DX, AL
    CALL DELAY
    ;复位 8251
 
    MOV AL, 40H						;	0100 0000
    OUT DX, AL
    CALL DELAY
 
    MOV AL,7EH
    OUT DX, AL                   ;写入8251方式字7EH=01111110B，异步波特率系数16，1位同步/停止位，偶校验，8位长度
    CALL DELAY
 
    ;MOV AL, 34H
    ;OUT DX, AL                   ;写入8251控制字34H=00110110B，请求发送，使RTS输出0、错误标志复位、允许接收，数据终端准备好，DTR输出0
    ;CALL DELAY
 
    MOV DI, 4000H                ;写入地址
    MOV SI, 3000H                ;读入地址
    

    MOV BL,'a'
A0:
	CMP BL,'z'
    JG AA1
    MOV [SI],BL
    INC SI
    INC BL
    JMP A0
AA1:  
	MOV CX, 001AH                ;循环26次
	MOV SI,3000H  
    MOV AL, 37H     ;00110111
    MOV DX, M8251_CON
    OUT DX, AL
A1: 
    MOV AL, [SI]
    MOV DX, M8251_DATA
    OUT DX, AL                   ;发送数据
    MOV DX, M8251_CON
A2: 
    IN AL, DX                    ;判断发送缓冲是否为空
    AND AL, 01H
    JZ A2
    CALL DELAY
    ;CALL DELAY 
    ;CALL DELAY
A3: 
    IN AL, DX                    ;判断是否接收到数据
    MOV DX,M8255_B
    OUT DX,AL
    AND AL, 02H
    JZ A3
    MOV DX, M8251_DATA
    IN AL, DX                    ;读取接收到的数据
    ;MOV AL,'a'
    MOV [DI], AL
    INC DI
    INC SI
    LOOP A1                      ;循环10次
 	
    MOV AH,4CH
    INT 21H                      ;程序终止
 
DELAY:                           ;延时子程序
    PUSH CX
    MOV CX,03000H
A5: 
    PUSH AX
    POP AX
    LOOP A5
    POP CX
    RET
CODE ENDS
    END START