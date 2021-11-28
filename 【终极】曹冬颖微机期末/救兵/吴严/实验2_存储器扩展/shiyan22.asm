CODE	SEGMENT 
		ASSUME 	CS:CODE
START:
      MOV AX,8000H
      MOV DS,AX;   初始化段地址
      MOV SI,0000H  ;非规则字
      MOV CX,0000H ;初始值
 
 AA:
     MOV [SI],CL
     MOV [SI+1],CH
     ADD SI,2
     ADD CX,1
     CMP CX,000FH
     JNZ AA   ;不等于跳转
     MOV [BX],CX
     MOV AH,4CH
	 INT 21H
CODE	ENDS
		END START