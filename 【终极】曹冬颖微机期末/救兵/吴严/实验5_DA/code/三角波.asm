;ABC�ӵ�GND
;D/A ���ǲ�
CODE SEGMENT
	ASSUME CS:CODE
  START:
      MOV DX,0600H
	  MOV AL,00H   ;��Сֵ
	A1:
	  OUT DX,AL
	  
	  CALL DELAY    ;��ʱ�ӳ���
	  INC AL
	  JNZ A1
	  DEC AL   ;AL=0FFH
	  DEC AL   ;��ƽ��
	A2:
	  OUT DX,AL
	  CALL DELAY
	  DEC AL
	  JNZ A2
	  JMP A1
	  
DELAY PROC NEAR             ;��ʱ����
		MOV AH,05H
L1:    	MOV CX,01FFH;
    	LOOP $ 
    	DEC AH
    	CMP AH,00H
    	JZ L1 
 		RET
DELAY	ENDP
 
CODE ENDS 
    END START
	    
	  
	  