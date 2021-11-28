;ABC接地GND
;D/A 矩形波
CODE SEGMENT
	ASSUME CS:CODE
  START:
    MOV DX,0600H
	A1: 
	  MOV AL,80H   ;最小值 00或80H
	  OUT DX,AL
	  CALL DELAY    ;延时子程序
	  MOV AL,0FFH
	  OUT DX,AL
	  CALL DELAY    ;延时子程序
	JMP A1
	
DELAY PROC NEAR             ;延时程序
		MOV AH,05H
L1:    	MOV CX,0FFFFH;
    	LOOP $ 
    	DEC AH
    	CMP AH,00H
    	JNZ L1 
 		RET
 		ENDP DELAY
 
CODE ENDS 
    END START
	    
	  
	  