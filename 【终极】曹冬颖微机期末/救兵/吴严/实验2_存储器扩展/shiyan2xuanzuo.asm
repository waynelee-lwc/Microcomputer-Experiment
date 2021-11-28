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
      MOV DS,AX;   初始化段地址
      MOV BX,0000H
      MOV CX,0000H
 
      AA:
      MOV [BX],CX
      ADD BX,2
      ADD CX,1
      CMP CX,000FH
      JNZ AA   ;BU等于跳转
      MOV [BX],CX
      JMP  A
     
C:    MOV AX,8000H
      MOV DS,AX;   初始化段地址
      MOV BX,0001H  ;非规则字
      MOV CX,0000H ;初始值
 
     AAA:
     MOV [BX],CX
     ADD BX,2
     ADD CX,1
     CMP CX,000FH
     JNZ AAA   ;不等于跳转
     MOV [BX],CX
     JMP A
     
D:    MOV AX,8000H
      MOV DS,AX;   初始化段地址
      MOV SI,0000H  ;非规则字
      MOV CX,0000H ;初始值
 
     AAAA:
      MOV [SI],CL
      MOV [SI+1],CH
      ADD SI,2
      ADD CX,1
      CMP CX,000FH
      JNZ AAAA   ;不等于跳转
      MOV [BX],CX
      JMP A
		
E:		MOV AH,4CH
		INT 21H


CODE	ENDS
		END START 