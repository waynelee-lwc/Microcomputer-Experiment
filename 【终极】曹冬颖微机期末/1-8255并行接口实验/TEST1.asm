DATA SEGMENT
DATA ENDS
CODE  SEGMENT
      ASSUME   CS:CODE,DS:DATA
START :
       MOV AL,90H
       MOV DX,0646H
       OUT DX,AL
 PP:   MOV DX,0640H
       IN AL,DX
      
       CMP AL,80H
       MOV DX,0642H
       JZ PP4
 PP3:
       MOV AL,0FH
       OUT DX,AL
       CMP AL,0FFH
       JZ PP2
       JMP PP
       
 PP4:      
       MOV AL,0F0H      
       OUT DX,AL
       
 PP5:      
       CMP AL,0FFH
       JZ PP2
       JMP PP
       
 PP2:
     MOV AH,4CH
     INT 21H
     
 CODE  ENDS
       END START
       

       

