;ABC接地GND
;D/A 三角波
CODE SEGMENT
	ASSUME CS:CODE
  START:
      MOV DX,0600H
	  MOV AL,00H   ;最小值
	A1:
	  OUT DX,AL
	  
	  CALL DELAY    ;延时子程序
	  INC AL
	  JNZ A1
	  DEC AL   ;AL=0FFH
	  DEC AL   ;削平顶
	A2:
	  OUT DX,AL
	  CALL DELAY
	  DEC AL
	  JNZ A2
	  JMP A1
	  
DELAY PROC NEAR             ;延时程序
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
	    
	  
	  