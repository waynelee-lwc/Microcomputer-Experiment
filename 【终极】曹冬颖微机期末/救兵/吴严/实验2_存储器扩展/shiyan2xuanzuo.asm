CODE	SEGMENT 
		ASSUME 	CS:CODE
START: 	MOV AL,90H
		MOV DX,0646H
		OUT DX,AL
		
A:		MOV DX,0640H
		IN  AL,DX
		
		MOV DX,0642H
		OUT DX,AL
		
		CMP AL,000H
		JZ B
		
		CMP AL,001H
		JZ C
		
		CMP AL,002H
		JZ D
		
		CMP AL,003H
		JZ E
		
		JMP A

B:    MOV AX,8000H
      MOV DS,AX;   ��ʼ���ε�ַ
      MOV BX,0000H
      MOV CX,0000H
 
      AA:
      MOV [BX],CX
      ADD BX,2
      ADD CX,1
      CMP CX,000FH
      JNZ AA   ;BU������ת
      MOV [BX],CX
      JMP  A
     
C:    MOV AX,8000H
      MOV DS,AX;   ��ʼ���ε�ַ
      MOV BX,0001H  ;�ǹ�����
      MOV CX,0000H ;��ʼֵ
 
     AAA:
     MOV [BX],CX
     ADD BX,2
     ADD CX,1
     CMP CX,000FH
     JNZ AAA   ;��������ת
     MOV [BX],CX
     JMP A
     
D:    MOV AX,8000H
      MOV DS,AX;   ��ʼ���ε�ַ
      MOV SI,0000H  ;�ǹ�����
      MOV CX,0000H ;��ʼֵ
 
     AAAA:
      MOV [SI],CL
      MOV [SI+1],CH
      ADD SI,2
      ADD CX,1
      CMP CX,000FH
      JNZ AAAA   ;��������ת
      MOV [BX],CX
      JMP A
		
E:		MOV AH,4CH
		INT 21H


CODE	ENDS
		END START 