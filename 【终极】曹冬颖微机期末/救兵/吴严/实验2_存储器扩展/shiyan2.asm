CODE	SEGMENT 
		ASSUME 	CS:CODE
START:
      MOV AX,8000H
      MOV DS,AX;   ��ʼ���ε�ַ
      MOV BX,0000H;0000H�����֣�0001H�ǹ�����
      MOV CX,0000H
 
 AA:
     MOV [BX],CX
     ADD BX,2
     ADD CX,1
     CMP CX,000FH
     JNZ AA   ;BU������ת
     MOV [BX],CX
     MOV AH,4CH
	 INT 21H
CODE	ENDS
		END START