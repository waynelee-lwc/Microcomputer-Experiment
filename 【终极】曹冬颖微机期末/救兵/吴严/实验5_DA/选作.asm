;MIR6����KK1

CODE SEGMENT 
    ASSUME CS:CODE
START: 
   ; MOV AX, 0000H
  ;  MOV DS, AX     ;�ֶ�ָ���û�����������ʼλ�ã����Բ�ָ����Ĭ��Ϊ0000H
MOV AX,0000H
	MOV DS,AX
	MOV DX,0646H
	MOV AL,90H
	OUT DX,AL

	;�����ж�����
	MOV AX,OFFSET MIR6
	MOV SI,0038H
	MOV [SI],AX
	INC SI
	INC SI
	MOV AX,CS
	MOV [SI],AX
	
	CLI
    MOV AL, 11H
    OUT 20H, AL
    MOV AL, 08H
    OUT 21H, AL
    MOV AL, 04H
    OUT 21H, AL
    MOV AL, 07H
    OUT 21H, AL
    MOV AL,0AFH
    OUT 21H, AL
    STI

	
	;BL=00H ��ݲ�
	;BL=01H ���β�
	;BL=02H ���ǲ�
	;BL=03H ���ݲ�
	
	MOV BL,00H
	MOV DX,0600H
	
  JUCHI:
      MOV AL,00H   ;��Сֵ
	  MOV DX,0600H
	  OUT  DX,AL
	A1:
	  INC AL
	  OUT  DX,AL
	  CALL DELAY
	  JMP A1
	  
  JUXING:
    B1: 
	  MOV AL,80H   ;��Сֵ 00��80H
	  OUT DX,AL
	  CALL DELAY1    ;��ʱ�ӳ���
	  MOV AL,0FFH
	  OUT DX,AL
	  CALL DELAY1    ;��ʱ�ӳ���
	  JMP B1
	  
   SANJIAO:
      MOV DX,0600H
	  MOV AL,00H   ;��Сֵ
	C1:
	  OUT DX,AL
	  CALL DELAY    ;��ʱ�ӳ���
	  INC AL
	  JNZ C1
	  DEC AL   ;AL=0FFH
	  DEC AL   ;��ƽ��
	C2:
	  OUT DX,AL
	  CALL DELAY
	  DEC AL
	  JNZ C2
	  JMP C1
	  

	  

	  
   JIETI:
     MOV DX,0600H 
    D2: 
	  MOV AL,00H   ;��Сֵ 00��80H
	D1: 
	  OUT DX,AL
	  CALL DELAY1    ;��ʱ�ӳ���
	  ADD AL,16
	  CMP AL,00H
	  JNZ D1
	  JMP D2

DELAY PROC NEAR             ;��ʱ����
		MOV AH,05H
L1:    	MOV CX,01FFH;
    	LOOP $ 
    	DEC AH
    	CMP AH,00H
    	JNZ L1 
 		RET
 		ENDP DELAY
 		
 		
	  
DELAY1 PROC NEAR             ;��ʱ����
		MOV AH,02H
L2:    	MOV CX,0FFFFH;
    	LOOP $ 
    	DEC AH
    	CMP AH,00H
    	JNZ L2
 		RET
 		ENDP DELAY1
 
	
	;BL=00H ��ݲ�
	;BL=01H ���β�
	;BL=02H ���ǲ�
	;BL=03H ���ݲ�
  MIR6:
	STI
	MOV AL,20H
	OUT 20H,AL
	INC BL
	CMP BL,01H
	JZ JUXING
	CMP BL,02H
	JZ SANJIAO
	CMP BL,03H
	JZ JIETI
	MOV BL,00H
	JMP JUCHI
	IRET
	
CODE ENDS
	END START
	
	
	
	