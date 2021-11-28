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
 MOV AL,90H
	MOV DX,0646H
	OUT DX,AL
		
MOV CL,0H               ;初值

	CLI			;关中断
	MOV DX,20H
	MOV AL,13H
	OUT DX,AL
	MOV DX,21H
	MOV AL,08H
	OUT DX,AL
	MOV AL,07H
	OUT DX,AL  
	MOV AL,2FH
	OUT DX,AL	;初始化主片		
	
	MOV AX,0
	MOV ES,AX	;中断向量表段地址
	MOV DI,38H	;中断向量表偏移地址
	MOV AX,OFFSET IR6
	CLD
	STOSW
	MOV AX,SEG IR6
	STOSW
	STI
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
    MOV AL, 76H             ;8254计数器1工作在方式3，产生方波。 
    OUT DX, AL 
    MOV DX, B8254 
    MOV AL, 0E8H
    OUT DX, AL 
    MOV AL, 03H             ;写入计数初值0E8H
    OUT DX, AL 

AA1:
   JMP AA1

	IR6:
	CLI
	PUSH AX
	PUSH DX
	MOV DX,0642H
	SHL CL,1
	ADD CL,1
	MOV AL,CL
	OUT DX,AL
	MOV DX,20H  ;中断结束
	MOV AL,20H
	OUT DX,AL
	POP DX
	POP AX
	STI
	IRET
	


;将GATE1置为高电平，运行程序，在示波器中可以看到OUT1规律输出方波。
;CLK0输入为1MHz的计数脉冲，周期为1μs，产生1s周期的方波需要1s/1μs=1000000个计数
;由于单个计数器的上限为2的16次方为65536远小于所需计数值
;因此将1000000拆分成1000*1000，计数器0的计数初值为1000，产生1ms的计数脉冲输入到CLK1
;计数器1的计数初值为1000，最终计数器1产生1s的方波。
CODE ENDS 
    END START