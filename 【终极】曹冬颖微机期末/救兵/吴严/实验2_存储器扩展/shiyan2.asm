CODE	SEGMENT 
		ASSUME 	CS:CODE
START:
      MOV AX,8000H
      MOV DS,AX;   初始化段地址
      MOV BX,0000H;0000H规则字，0001H非规则字
      MOV CX,0000H
 
 AA:
     MOV [BX],CX
     ADD BX,2
     ADD CX,1
     CMP CX,000FH
     JNZ AA   ;BU等于跳转
     MOV [BX],CX
     MOV AH,4CH
	 INT 21H
CODE	ENDS
		END START