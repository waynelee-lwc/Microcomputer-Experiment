M8255A EQU 0600H;A�ڣ�������˿ڣ�������ʽ�˿�
M8255B EQU 0602H;B�ڣ��������ʾλ�˿�
M8255C EQU 0604H;C�ڣ�������˿�
M8255CON  EQU 0606H
M82540 EQU 0640H;������0
M82541 EQU 0642H;������1
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
    		DB  00H;��
    		
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
			
    TIME 	DB 00H, 00H;����ʱ��
    FLAGS 	DB 00H;��������ܵļ�ʱ����ʾ��1Ϊ��ʾ��0Ϊ����ʾ
    FLAGI 	DB 00H;��¼��ʼ��������ĵ�һ�������ǵڶ�����
    FLAGB 	DB 00H;��¼B���ǵ�һ�ΰ����ǵڶ��ΰ� 
    FLAGA 	DB 00H;��¼A���ǵڼ��ΰ���
    SHUMA 	DB 00H, 00H, 00H, 00H;��ǰʱ��
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA
    
START: 	CALL INIT

L1: 	CALL SHOW
    	CALL DELAY
    	CALL CLEAR
    	
    	MOV DX,M8255A;��ѯ
    	MOV AL,00H
   	 	OUT DX,AL
   	 	
    	MOV DX,M8255C
    	IN AL,DX
    	
    	AND AL,0FH
    	CMP AL,0FH
    	JZ L1;����ȫ��Ϊ�ߵ�ƽ��û�м�����
    	
    	CALL DELAY;����ǰ�ض���
    	
    	MOV DX,M8255A;�������ٴβ�ѯ
    	MOV AL,00H
    	OUT DX,AL
    	MOV DX,M8255C
    	IN AL,DX
    	
   	 	AND AL,0FH
    	CMP AL,0FH
    	JZ L1;����ǰ�İ��������ڸ���
    	
    	;����˵���а�������
    	MOV AH,11111110B
    	MOV CX,04H
    	
L3:     MOV AL,AH;����ɨ��
    	MOV DX,M8255A
    	OUT DX,AL
    	MOV DX,M8255C
    	IN AL,DX
    	
    	AND AL,0FH
    	CMP AL,0FH
    	JNZ L2           ;L2����ɨ��ɹ���ȷ��������
    	
    	ROL AH,1
    	LOOP L3
    	
    	JMP L1           ;��ɨ��û�ɹ��Ĵ���
    	
L2:		MOV CL,4
    	SHL AH,CL;AH�ĸ���λ������
    	OR AL,AH;��ʱAL�ĸ���λΪ����������λΪ����
    	
    	LEA SI,TABLER
    	MOV BL,00H 
    	MOV BH,00H
    	
L5: 	CMP AL,[SI+BX]
    	JZ L4;ȷ����AL��������ĸ����룬ֵ��BL�У������������ʾ
    	
    	INC BL
    	CMP BL,10H
    	JNZ L5;����С��16��
    	
    	JMP L1;����ֵ����16����������û�ҵ�������������ʾ�����°�������

L4:     ;��ʱ�����ƫ�����Ѿ���BL����
    	CMP BL,0AH ;�ֱ���ABC֮��Ĵ������
    	JE CALLA   ;JZ
    	
    	CMP BL,0BH
    	JE CALLB
    	
    	CMP BL,0CH
    	JE CALLC
    	
    	;FLAGI ���水�µ����ǵ�һ�������ǵڶ�����
    	LEA SI,FLAGI
    	MOV AL,[SI]
    	CMP AL,01H
    	JBE INPUT;С�ڵ�������ת
    	
    	JMP L1;��ʼ��֮�󰴼���Ч
    	
CALLA:	CALL CALLA1
L6:     MOV DX,M8255A;�����Ƿ��ɿ�
    	MOV AL,00H
    	OUT DX,AL
    	MOV DX,M8255C
    	IN AL,DX
    	
    	AND AL,0FH
    	CMP AL,0FH
    	JE LBACK;δ�����򷵻�
    	
    	CALL SHOW
    	JMP L6

CALLB:	CALL CALLB1
L7:     MOV DX,M8255A;�����Ƿ��ɿ�
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
L8:     MOV DX,M8255A;�����Ƿ��ɿ�
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
    	
     	;�����ж�����
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
    	OUT 20H,AL    ;������ICW1��11H=00010001B
    	
    	MOV AL,08H
    	OUT 21H,AL    ;������ICW2��08H=00001000B
    	
    	MOV AL,04H
    	OUT 21H,AL    ;������ICW3��04H=00000100B
    	
    	MOV AL,01H
    	OUT 21H,AL    ;������ICW4��01H=00000001B
    	
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
	
		MOV DX, M8254CON;8254������0�����ڷ�ʽ3�������������൱��CLK
	    MOV AL, 36H
	    OUT DX, AL
	    
	    MOV DX, M82540
	    MOV AL, 0E8H
	    OUT DX, AL
	    MOV AL, 03H
	    OUT DX, AL
	    
	    MOV DX, M8254CON;8254������1�����ڷ�ʽ3������������ 
	    MOV AL, 76H
	    OUT DX, AL
	    
	    MOV DX, M82541
	    MOV AL, 0E8H
	    OUT DX, AL
	    MOV AL, 03H;д�������ֵ03E8H
	    OUT DX, AL 

	    MOV DX,M8255CON
	    MOV AL,89H
	    OUT DX,AL;����8255�����֣�ʹ��A,B�ں�C�ڵ���λ��������
	    
	    MOV DX,M8255A
	    MOV AL,00H
	    OUT DX,AL
	    
	    MOV DX,M8255B
	    MOV AL,00H
	    OUT DX,AL;��ʼʱ����ܲ���ʾ
	    
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
	    
	    LEA SI,FLAGA           ;��¼A���ǵڼ��ΰ���
	    MOV AL,[SI]
	    CMP AL,00H
	    JNE CA1                ;���ǵ�һ�ΰ�����ص���ʼ״̬
	    
	    LEA SI,FLAGS
	    MOV AL,01H
	    MOV [SI],AL            ;֪ͨ�жϿ��Կ�ʼ��ʾ����ʱ��
	    
	    LEA SI,FLAGI
	    MOV AL,[SI]
	    CMP AL,01H
	    JA CA2                 ;����ʱ����������������ô�����1ҲҪ��ʾֵ   JA ����
	    
	    ;ֻ������һ����
	    LEA SI,TIME            ;����ķ���
	    LEA DI,SHUMA           ;���浱ǰʱ��
	    
	    MOV AL,00H             ;ֻ������һ��������ʼ��ʾΪ0X00
	    MOV [DI],AL
	    
	    MOV AL,[SI]
	    MOV [DI+1],AL
	    
	    MOV AL,00H;����Ϊ0
	    MOV [DI+2],AL
	    MOV [DI+3],AL
	    
	    LEA SI,FLAGA           ;��ʾ��һ�ΰ���A��
	    MOV AL,01H
	    MOV [SI],AL
	    JMP CABACK 
     
CA2:   ;��ʼʱ����������
	    LEA SI,TIME
	    LEA DI,SHUMA
	    
	    MOV AL,[SI]          ;���ҿ�ʼ��ʾ��ΪXX00
	    MOV [DI],AL
	    
	    MOV AL,[SI+1]
	    MOV [DI+1],AL
	    
	    MOV AL,00H
	    MOV [DI+2],AL
	    MOV [DI+3],AL
	    
	    LEA SI,FLAGA;��ʾ��һ�ΰ���A��
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
CALLB1: ;����B
	    PUSH AX
	    PUSH BX
	    PUSH CX
	    PUSH DX
	    PUSH SI
	    PUSH DI
	    
	    LEA SI,FLAGB
	    MOV AL,[SI]
	    CMP AL,00H
	    JNE CB1;˵���ǵ�һ�ΰ���B��
	    
	    INC AL
	    MOV [SI],AL
	    
	    LEA SI,FLAGS;��ͣ
	    MOV AL,00H
	    MOV [SI],AL
	    JMP CBBACK
	    
CB1:    ;�ڶ��ΰ���B
	    LEA SI,FLAGB
	    MOV AL,00H
	    MOV [SI],AL
	    
	    LEA SI,FLAGS;����
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
INPUT1: ;������
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
	    
	    ;�����һ����
	    LEA SI,TIME;��¼ʱ���ʮλ
	    MOV [SI],BL
	    
	    LEA SI,SHUMA;��һ���������������3
	    MOV [SI+2],BL
	    
	    MOV AL,01H;��һ�����������
	    LEA SI,FLAGI
	    MOV [SI],AL
	    
	    JMP IBACK
	    
	    ;����ڶ�����
I1:		LEA SI,TIME;��¼ʱ��ĸ�λ
	    MOV [SI+1],BL
	    
	    LEA SI,SHUMA;�ڶ������ŵ������4
	    MOV [SI+3],BL
	    
	    MOV AL,02H;�ڶ������������
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
MIR6:   ;ÿ���1
	    PUSH AX ;��show֮�����Ƿ���0000
	    PUSH BX
	    PUSH CX
	    PUSH DX
	    PUSH SI
	    PUSH DI
	    
	    LEA SI,FLAGS
	    MOV AL,[SI]
	    CMP AL,01H
	    JE M9                ;����ܱ�־λ��0������ʾ
	    
MBACK:  MOV AL,20H;����
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
	    MOV AL,[SI+3];�����4����ĸ�λ
	    CMP AL,00H
	    JE M2;��ĸ�λ��0
	    
	    ;���λ��Ϊ0
	    DEC AL;���λ
	    MOV [SI+3],AL
	    JMP MBACK
	    
M2:		LEA SI,SHUMA
	    MOV AL,[SI+2]
	    CMP AL,00H
	    JE M3;��ĸ�λʮλ��Ϊ0����ֽ�λ
	    
	    ;�����������ʮλ��Ϊ0����λΪ0
	    DEC AL;��ʮλ
	    MOV [SI+2],AL
	    
	    MOV AL,09H;���λ
	    MOV [SI+3],AL
	    JMP MBACK

M3:		LEA SI,SHUMA
	    MOV AL,[SI+1]
	    CMP AL,00H
	    JE M4;�ֵĸ�λ�����ʮλ�͸�λ��Ϊ��
	    
	    ;�ֵĸ�λ��Ϊ0
	    DEC AL;�ָ�λ
	    MOV [SI+1],AL
	    
	    MOV AL,05H;��ʮλ
	    MOV [SI+2],AL
	    
	    MOV AL,09H;���λ
	    MOV [SI+3],AL
	    JMP MBACK
	    
M4:		LEA SI,SHUMA
	    MOV AL,[SI]
	    CMP AL,00H
	    JE M5;�ֺ��붼��0
	    
	    ;�ֵ�ʮλ��Ϊ0
	    DEC AL;��ʮλ
	    MOV [SI],AL
	    
	    MOV AL,09H;�ָ�λ
	    MOV [SI+1],AL
	    
	    MOV AL,05H;��ʮλ
	    MOV [SI+2],AL
	    
	    MOV AL,09H;���λ
	    MOV [SI+3],AL
	    
	    JMP MBACK
	    
M5:		MOV CX,0FFH;������˵����0000�ˣ���ʱ��������˸���Σ��ص���ʼ״̬
	    
M6:		CALL SHOW
	    LOOP M6
	    CALL LDELAY;ʱ�䳤һЩ��������������˸
	    
	    MOV CX,0FFH
M7:		CALL SHOW
	    LOOP M7
	   	CALL LDELAY;ʱ�䳤һЩ��������������˸
	   	
	    MOV CX,0FFH
M8:		CALL SHOW
	    LOOP M8
	    
	    CALL INIT;�ص���ʼ״̬
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
    	