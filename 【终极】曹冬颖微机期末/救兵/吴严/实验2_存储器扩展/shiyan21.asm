CODE	SEGMENT 
		ASSUME 	CS:CODE
START:
      MOV AX,8000H
      MOV DS,AX;   ��ʼ���ε�ַ
      MOV BX,0000H  ;�ǹ�����
      MOV CX,0000H ;��ʼֵ
 
 AA:
     MOV [BX],CX
     ADD BX,1
     ADD CX,1
     CMP CX,000FH
     JNZ AA   ;��������ת
     MOV [BX],CX
     MOV AH,4CH
	 INT 21H
CODE	ENDS
		END START