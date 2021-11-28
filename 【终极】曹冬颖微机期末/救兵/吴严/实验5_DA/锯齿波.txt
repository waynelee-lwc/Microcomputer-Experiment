;ABC接地GND
;D/A 锯齿波
CODE SEGMENT
	ASSUME CS:CODE
  START:
	  MOV AL,00H   ;最小值
	  MOV DX,0600H
	  OUT  DX,AL
	A1:
	  INC AL
	  OUT  DX,AL
	  CALL DELAY
	  JMP A1
	  
DELAY PROC NEAR             ;延时程序
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
	    
	  
	  