A8254 EQU 0600H
B8254 EQU 0602H 
C8254 EQU 0604H 
CON8254 EQU 0606H
;8254计数器012以及控制端口的地址，由IOY决定
CODE SEGMENT 
    ASSUME CS:CODE
START: 
 
    MOV DX, CON8254
    MOV AL, 50H             ;8254计数器1工作在方式0，计数时输出低电平，到0时输出高电平 
    OUT DX, AL 
    MOV DX, B8254 
    MOV AL, 01H 
    OUT DX, AL 
AA1: 
    JMP AA1 
;将GATE1置为低电平，运行程序。
;将GATE1置为高电平，在示波器中可以观察到OUT1输出低电平，待过一段时间后（计数器减至0）输出高电平。
CODE ENDS 
    END START
