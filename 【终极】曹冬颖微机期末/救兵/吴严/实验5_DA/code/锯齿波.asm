;ABC�ӵ�GND
;D/A ��ݲ�
CODE SEGMENT
	ASSUME CS:CODE
  START:
	  MOV AL,00H   ;��Сֵ
	  MOV DX,0600H
	  OUT  DX,AL
	A1:
	  INC AL
	  OUT  DX,AL
	  CALL DELAY
	  JMP A1
	  
DELAY PROC NEAR             ;��ʱ����
		MOV AH,05H
L1:    	MOV CX,01FFH;
    	LOOP $ 
    	DEC AH
    	CMP AH,00H
    	JZ L1 
 		RET
 		ENDP DELAY
 
CODE ENDS 
    END START
	    
	  
	  