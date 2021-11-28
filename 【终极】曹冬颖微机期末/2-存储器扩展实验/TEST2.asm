CODE SEGMENT
START: 
       ASSUME CS:CODE
       MOV AX,8000H
       MOV DS,AX
       
       
AA1:   MOV SI,0000H
       MOV DX,0000H
       MOV [SI],DX
       INC SI
       INC SI
       INC DX
       LOOP AA1
     
       MOV AX,4C00H
       INT 21H    
CODE   ENDS
       END START