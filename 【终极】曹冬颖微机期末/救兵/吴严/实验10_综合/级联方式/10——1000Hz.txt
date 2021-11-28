M8255A EQU 0600H;A口，列输出端口，数码样式端口
M8255B EQU 0602H;B口，数码管显示位端口
M8255C EQU 0604H;C口，行输出端口
M8255CON  EQU 0606H
M82540 EQU 0640H;计数器0
M82541 EQU 0642H;计数器1
M8254CON EQU 0646H
DATA SEGMENT
    LIST	DB 	3FH;0
    		DB	06H;1
    		DB	5BH;2
    		DB	4FH;3
    		DB	66H;4
    		DB	6DH;5
    		DB	7DH;6
    		DB	07H;7
    		DB	7FH;8
    		DB	6FH;9
    		DB	77H;A
    		DB	7CH;B
    		DB	39H;C
    		DB	5EH;D
    		DB	79H;E
    		DB	71H;F
    		DB  00H;空
    		
    TABLER 	DB	11101110B;00,0
			DB	11011110B;10,1
			DB	10111110B;20,2
			DB	01111110B;30,3
			DB	11101101B;01,4
			DB	11011101B;11,5
			DB	10111101B;21,6
			DB	01111101B;31,7
			DB	11101011B;02,8
			DB	11011011B;12,9
			DB	10111011B;22,A
			DB	01111011B;32,B
			DB	11100111B;03,C
			DB	11010111B;13,D
			DB	10110111B;23,E
			DB	01110111B;33,F
			
    TIME 	DB 00H, 00H;输入时间
    FLAGS 	DB 00H;控制数码管的计时和显示，1为显示，0为不显示
    FLAGI 	DB 00H;记录初始化是输入的第一个数还是第二个数
    FLAGB 	DB 00H;记录B键是第一次按还是第二次按 
    FLAGA 	DB 00H;记录A键是第几次按下
    SHUMA 	DB 00H, 00H, 00H, 00H;当前时间
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA
    
START: 	CALL INIT

L1: 	CALL SHOW
    	CALL DELAY
    	CALL CLEAR
    	
    	MOV DX,M8255A;查询
    	MOV AL,00H
   	 	OUT DX,AL
   	 	
    	MOV DX,M8255C
    	IN AL,DX
    	
    	AND AL,0FH
    	CMP AL,0FH
    	JZ L1;按键全部为高电平，没有键按下
    	
    	CALL DELAY;消除前沿抖动
    	
    	MOV DX,M8255A;消抖后再次查询
    	MOV AL,00H
    	OUT DX,AL
    	MOV DX,M8255C
    	IN AL,DX
    	
   	 	AND AL,0FH
    	CMP AL,0FH
    	JZ L1;消抖前的按键是由于干扰
    	
    	;到此说明有按键输入
    	MOV AH,11111110B
    	MOV CX,04H
    	
L3:     MOV AL,AH;逐行扫描
    	MOV DX,M8255A
    	OUT DX,AL
    	MOV DX,M8255C
    	IN AL,DX
    	
    	AND AL,0FH
    	CMP AL,0FH
    	JNZ L2           ;L2是行扫描成功，确定了行数
    	
    	ROL AH,1
    	LOOP L3
    	
    	JMP L1           ;行扫描没成功的处理
    	
L2:		MOV CL,4
    	SHL AH,CL;AH的高四位是行数
    	OR AL,AH;此时AL的高四位为行数，低四位为列数
    	
    	LEA SI,TABLER
    	MOV BL,00H 
    	MOV BH,00H
    	
L5: 	CMP AL,[SI+BX]
    	JZ L4;确定了AL代表的是哪个键码，值在BL中，进行数码管显示
    	
    	INC BL
    	CMP BL,10H
    	JNZ L5;键码小于16个
    	
    	JMP L1;键码值大于16个，但还是没找到，放弃本次显示，重新按键输入

L4:     ;此时键码的偏移量已经在BL中了
    	CMP BL,0AH ;分别按下ABC之后的处理情况
    	JE CALLA   ;JZ
    	
    	CMP BL,0BH
    	JE CALLB
    	
    	CMP BL,0CH
    	JE CALLC
    	
    	;FLAGI 保存按下的数是第一个数还是第二个数
    	LEA SI,FLAGI
    	MOV AL,[SI]
    	CMP AL,01H
    	JBE INPUT;小于等于则跳转
    	
    	JMP L1;初始化之后按键无效
    	
CALLA:	CALL CALLA1
L6:     MOV DX,M8255A;按键是否松开
    	MOV AL,00H
    	OUT DX,AL
    	MOV DX,M8255C
    	IN AL,DX
    	
    	AND AL,0FH
    	CMP AL,0FH
    	JE LBACK;未按下则返回
    	
    	CALL SHOW
    	JMP L6

CALLB:	CALL CALLB1
L7:     MOV DX,M8255A;按键是否松开
    	MOV AL,00H
    	OUT DX,AL
    	MOV DX,M8255C
    	IN AL,DX
    	
    	AND AL,0FH
    	CMP AL,0FH
    	JE LBACK
    	
    	CALL SHOW
    	JMP L7
    	
INPUT:	CALL INPUT1
L8:     MOV DX,M8255A;按键是否松开
    	MOV AL,00H
    	OUT DX,AL
    	MOV DX,M8255C
    	IN AL,DX
    	
    	AND AL,0FH
    	CMP AL,0FH
    	JE LBACK
    	
    	CALL SHOW
    	CALL DELAY
    	CALL CLEAR
    	JMP L8
    	
LBACK:  JMP L1
;===================================================================
CALLC:	CALL CLEAR
    	MOV AH,4CH
    	INT 21H
;================================================================================    
INIT:	PUSH AX
    	PUSH BX
    	PUSH CX
    	PUSH DX
    	PUSH SI
    	PUSH DI
    	
     	;设置中断向量
    	MOV AX,0000H
    	MOV DS,AX
    	
		MOV AX,OFFSET MIR6
		MOV SI,0038H
		MOV [SI],AX
		
		MOV AX,CS
		MOV SI,003AH
		MOV [SI],AX
		
		CLI
		MOV AL,11H
    	OUT 20H,AL    ;命令字ICW1，11H=00010001B
    	
    	MOV AL,08H
    	OUT 21H,AL    ;命令字ICW2，08H=00001000B
    	
    	MOV AL,04H
    	OUT 21H,AL    ;命令字ICW3，04H=00000100B
    	
    	MOV AL,01H
    	OUT 21H,AL    ;命令字ICW4，01H=00000001B
    	
    	MOV AL,2FH    ;OCW1
    	OUT 21H,AL
    	STI
	    
	    MOV AX,DATA
		MOV DS,AX 
		
		MOV AL,00H
		
		LEA SI,FLAGA
		MOV [SI],AL
		 
		LEA SI,FLAGB
		MOV [SI],AL
		
		LEA SI,FLAGS
		MOV [SI],AL
		
		LEA SI,FLAGI
		MOV [SI],AL
		
		LEA SI,TIME
		MOV [SI],AL
		MOV [SI+1],AL
		
		LEA SI,SHUMA
		MOV AL,16
		MOV [SI],AL
		MOV [SI+1],AL
		MOV [SI+2],AL
		MOV [SI+3],AL
	
		MOV DX, M8254CON;8254计数器0工作在方式3，产生方波，相当于CLK
	    MOV AL, 36H
	    OUT DX, AL
	    
	    MOV DX, M82540
	    MOV AL, 0E8H
	    OUT DX, AL
	    MOV AL, 03H
	    OUT DX, AL
	    
	    MOV DX, M8254CON;8254计数器1工作在方式3，产生方波。 
	    MOV AL, 76H
	    OUT DX, AL
	    
	    MOV DX, M82541
	    MOV AL, 0E8H
	    OUT DX, AL
	    MOV AL, 03H;写入计数初值03E8H
	    OUT DX, AL 

	    MOV DX,M8255CON
	    MOV AL,89H
	    OUT DX,AL;设置8255控制字，使得A,B口和C口低四位进行输入
	    
	    MOV DX,M8255A
	    MOV AL,00H
	    OUT DX,AL
	    
	    MOV DX,M8255B
	    MOV AL,00H
	    OUT DX,AL;开始时数码管不显示
	    
	   	CALL DELAY
	   	CALL CLEAR

		POP DI
		POP SI
		POP DX
		POP CX
		POP BX
		POP AX
		RET
;=============================================================
CALLA1:	PUSH AX
	    PUSH BX
	    PUSH CX
	    PUSH DX
	    PUSH SI
	    PUSH DI
	    
	    LEA SI,FLAGA           ;记录A键是第几次按下
	    MOV AL,[SI]
	    CMP AL,00H
	    JNE CA1                ;不是第一次按下则回到初始状态
	    
	    LEA SI,FLAGS
	    MOV AL,01H
	    MOV [SI],AL            ;通知中断可以开始显示倒计时了
	    
	    LEA SI,FLAGI
	    MOV AL,[SI]
	    CMP AL,01H
	    JA CA2                 ;输入时输入了两个数，那么数码管1也要显示值   JA 大于
	    
	    ;只输入了一个数
	    LEA SI,TIME            ;输入的分钟
	    LEA DI,SHUMA           ;保存当前时间
	    
	    MOV AL,00H             ;只输入了一个数，开始显示为0X00
	    MOV [DI],AL
	    
	    MOV AL,[SI]
	    MOV [DI+1],AL
	    
	    MOV AL,00H;秒数为0
	    MOV [DI+2],AL
	    MOV [DI+3],AL
	    
	    LEA SI,FLAGA           ;表示第一次按下A键
	    MOV AL,01H
	    MOV [SI],AL
	    JMP CABACK 
     
CA2:   ;初始时输入两个数
	    LEA SI,TIME
	    LEA DI,SHUMA
	    
	    MOV AL,[SI]          ;并且开始显示数为XX00
	    MOV [DI],AL
	    
	    MOV AL,[SI+1]
	    MOV [DI+1],AL
	    
	    MOV AL,00H
	    MOV [DI+2],AL
	    MOV [DI+3],AL
	    
	    LEA SI,FLAGA;表示第一次按下A键
	    MOV AL,01H
	    MOV [SI],AL
	    JMP CABACK 
	    
CA1:	CALL INIT

CABACK:	POP DI
	    POP SI
	    POP DX
	    POP CX
	    POP BX
	    POP AX
	    RET
;==================================================================
CALLB1: ;按下B
	    PUSH AX
	    PUSH BX
	    PUSH CX
	    PUSH DX
	    PUSH SI
	    PUSH DI
	    
	    LEA SI,FLAGB
	    MOV AL,[SI]
	    CMP AL,00H
	    JNE CB1;说明是第一次按下B键
	    
	    INC AL
	    MOV [SI],AL
	    
	    LEA SI,FLAGS;暂停
	    MOV AL,00H
	    MOV [SI],AL
	    JMP CBBACK
	    
CB1:    ;第二次按下B
	    LEA SI,FLAGB
	    MOV AL,00H
	    MOV [SI],AL
	    
	    LEA SI,FLAGS;继续
	    MOV AL,01H
	    MOV [SI],AL
	    
CBBACK:	POP DI
		POP SI
		POP DX
		POP CX
		POP BX
		POP AX 
	    RET
;====================================================================
INPUT1: ;输入数
   		PUSH AX
	    PUSH BX
	    PUSH CX
	    PUSH DX
	    PUSH SI
	    PUSH DI
	    
	    LEA SI,FLAGI
	    MOV AL,[SI]
	    CMP AL,00H
	    JNE I1
	    
	    ;处理第一个数
	    LEA SI,TIME;记录时间的十位
	    MOV [SI],BL
	    
	    LEA SI,SHUMA;第一个数放数到数码管3
	    MOV [SI+2],BL
	    
	    MOV AL,01H;第一个数输入完成
	    LEA SI,FLAGI
	    MOV [SI],AL
	    
	    JMP IBACK
	    
	    ;处理第二个数
I1:		LEA SI,TIME;记录时间的个位
	    MOV [SI+1],BL
	    
	    LEA SI,SHUMA;第二个数放到数码管4
	    MOV [SI+3],BL
	    
	    MOV AL,02H;第二个数输入完成
	    LEA SI,FLAGI
	    MOV [SI],AL
	    
IBACK:	POP DI
	    POP SI
	    POP DX
	    POP CX
	    POP BX
	    POP AX 
	    RET
;=====================================================================
MIR6:   ;每秒减1
	    PUSH AX ;先show之后检测是否是0000
	    PUSH BX
	    PUSH CX
	    PUSH DX
	    PUSH SI
	    PUSH DI
	    
	    LEA SI,FLAGS
	    MOV AL,[SI]
	    CMP AL,01H
	    JE M9                ;数码管标志位是0不让显示
	    
MBACK:  MOV AL,20H;返回
		OUT 20H,AL
	    POP DI
	    POP SI
	    POP DX
	    POP CX
	    POP BX
	    POP AX
	    IRET
	    
M9:   	CALL SHOW

	    LEA SI,SHUMA
	    MOV AL,[SI+3];数码管4，秒的个位
	    CMP AL,00H
	    JE M2;秒的个位是0
	    
	    ;秒个位不为0
	    DEC AL;秒个位
	    MOV [SI+3],AL
	    JMP MBACK
	    
M2:		LEA SI,SHUMA
	    MOV AL,[SI+2]
	    CMP AL,00H
	    JE M3;秒的个位十位都为0，向分借位
	    
	    ;到这里是秒的十位不为0，个位为0
	    DEC AL;秒十位
	    MOV [SI+2],AL
	    
	    MOV AL,09H;秒个位
	    MOV [SI+3],AL
	    JMP MBACK

M3:		LEA SI,SHUMA
	    MOV AL,[SI+1]
	    CMP AL,00H
	    JE M4;分的个位，秒的十位和个位均为零
	    
	    ;分的个位不为0
	    DEC AL;分个位
	    MOV [SI+1],AL
	    
	    MOV AL,05H;秒十位
	    MOV [SI+2],AL
	    
	    MOV AL,09H;秒个位
	    MOV [SI+3],AL
	    JMP MBACK
	    
M4:		LEA SI,SHUMA
	    MOV AL,[SI]
	    CMP AL,00H
	    JE M5;分和秒都是0
	    
	    ;分的十位不为0
	    DEC AL;分十位
	    MOV [SI],AL
	    
	    MOV AL,09H;分个位
	    MOV [SI+1],AL
	    
	    MOV AL,05H;秒十位
	    MOV [SI+2],AL
	    
	    MOV AL,09H;秒个位
	    MOV [SI+3],AL
	    
	    JMP MBACK
	    
M5:		MOV CX,0FFH;到这里说明是0000了，计时结束，闪烁三次，回到初始状态
	    
M6:		CALL SHOW
	    LOOP M6
	    CALL LDELAY;时间长一些，看出来是在闪烁
	    
	    MOV CX,0FFH
M7:		CALL SHOW
	    LOOP M7
	   	CALL LDELAY;时间长一些，看出来是在闪烁
	   	
	    MOV CX,0FFH
M8:		CALL SHOW
	    LOOP M8
	    
	    CALL INIT;回到初始状态
	    JMP MBACK
;======================================================================
SHOW:	PUSH AX
	    PUSH BX
	    PUSH CX
	    PUSH DX
	    PUSH SI
	    PUSH DI
	    
	    MOV CX,4
	    
S1:	    MOV DX,M8255A
	    MOV AL,11111110B
	    
	    MOV AH,4
	    SUB AH,CL
	    PUSH CX
	    MOV CL,AH
	    MOV BX,CX
	    
	    ROL AL,CL
	    OUT DX,AL
	    
	    LEA DI,SHUMA
	    MOV AL,[DI+BX]
	    MOV AH,00H
	    MOV BX,AX
	    LEA DI,LIST
	    MOV AL,[DI+BX]
	    
	    MOV DX,M8255B
	    OUT DX,AL
	    CALL DELAY
	    CALL CLEAR
	    
	    POP CX
	    LOOP S1
	    
	    POP DI
	    POP SI
	    POP DX
	    POP CX
	    POP BX
	    POP AX
	    RET  
;==========================================================
CLEAR:	PUSH AX
	    PUSH BX
	    PUSH CX
	    PUSH DX
	    PUSH SI
	    PUSH DI
	    
	    MOV DX,M8255A
	    MOV AL,0FFH
	    OUT DX,AL
	    
	    MOV DX,M8255B
	    MOV AL,00H
	    OUT DX,AL
	    
	    POP DI
	    POP SI
	    POP DX
	    POP CX
	    POP BX
	    POP AX
	    RET
;=============================================================
DELAY:	PUSH CX
	    MOV CX,00FFH
D1:		LOOP D1
	    POP CX
	    RET 
;=================================================================
LDELAY: PUSH CX
	    MOV  CX,0FFFFH
LD1:	LOOP LD1 
	    MOV  CX,0FFFFH
LD2:	LOOP LD2
		MOV  CX,0FFFFH
LD3:	LOOP LD3
        MOV  CX,0FFFFH
LD4:	LOOP LD4
        MOV  CX,0FFFFH
LD5:	LOOP LD5
        MOV  CX,0FFFFH
LD6:	LOOP LD6
	    POP CX
	    RET
	    
CODE ENDS
    	END START
    	