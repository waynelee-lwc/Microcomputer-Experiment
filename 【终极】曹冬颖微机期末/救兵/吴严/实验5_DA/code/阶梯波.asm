;ABC接地GND
;D/A 阶梯波
CODE SEGMENT
	ASSUME CS:CODE
  START:
    MOV DX,0600H 
	A2: 
	  MOV AL,00H   ;最小值 00或80H
	A1: 
	  OUT DX,AL
	  CALL DELAY    ;延时子程序
	  ADD AL,16
	  CMP AL,00H
	  JNZ A1
	  JMP A2
	 
	  
DELAY PROC NEAR             ;延时程序
		MOV AH,02H
L1:    	MOV CX,0FFFFH;
    	LOOP $ 
    	DEC AH
    	CMP AH,00H
    	JNZ L1 
 		RET
 		ENDP DELAY
 
CODE ENDS 
    END START
	    
	  
	  