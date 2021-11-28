A8254 EQU 0600H
B8254 EQU 0602H 
C8254 EQU 0604H 
CON8254 EQU 0606H
SSTACK SEGMENT STACK 
    DW 32 DUP(?) 
SSTACK ENDS 
CODE SEGMENT 
    ASSUME CS:CODE
START: 
    MOV DX, CON8254
    MOV AL, 36H
    OUT DX, AL
    MOV DX, A8254
    MOV AL, 0E8H
    OUT DX, AL
    MOV AL, 03H
    OUT DX, AL
    ;8254计数器0工作在方式3，产生方波，相当于CLK
    MOV DX, CON8254
    MOV AL, 72H             ;8254计数器0工作在方式1，计数时输出低电平，到0时输出高电平 
    OUT DX, AL 
    MOV DX, B8254 
    MOV AL, 00H 
    OUT DX, AL 
    MOV AL, 0AH             ;写入计数初值0A00H
    OUT DX, AL 
AA1: 
    JMP AA1 
;将GATE1置为低电平，运行程序，在示波器中可以看到OUT1输出高电平。
;把开关闭合然后快速断开，使GATE1产生一次脉冲，在示波器中可以观察到OUT1输出低电平
;待过一段时间后（计数器减至0）输出高电平。
;重复上述过程，可以看到每次GATE1产生脉冲，8254都会开始计数（输出低电平），计数器减至0时恢复高电平。
CODE ENDS 
    END START