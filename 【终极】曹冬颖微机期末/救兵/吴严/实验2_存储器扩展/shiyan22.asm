CODE	SEGMENT 
		ASSUME 	CS:CODE
START:
      MOV AX,8000H
      MOV DS,AX;   ��ʼ���ε�ַ
      MOV SI,0000H  ;�ǹ�����
      MOV CX,0000H ;��ʼֵ
 
 AA:
     MOV [SI],CL
     MOV [SI+1],CH
     ADD SI,2
     ADD CX,1
     CMP CX,000FH
     JNZ AA   ;��������ת
     MOV [BX],CX
     MOV AH,4CH
	 INT 21H
CODE	ENDS
		END START