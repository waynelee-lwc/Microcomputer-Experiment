A8254 EQU 0600H
B8254 EQU 0602H 
C8254 EQU 0604H 
CON8254 EQU 0606H
;8254������012�Լ����ƶ˿ڵĵ�ַ����IOY����
CODE SEGMENT 
    ASSUME CS:CODE
START: 
 
    MOV DX, CON8254
    MOV AL, 50H             ;8254������1�����ڷ�ʽ0������ʱ����͵�ƽ����0ʱ����ߵ�ƽ 
    OUT DX, AL 
    MOV DX, B8254 
    MOV AL, 01H 
    OUT DX, AL 
AA1: 
    JMP AA1 
;��GATE1��Ϊ�͵�ƽ�����г���
;��GATE1��Ϊ�ߵ�ƽ����ʾ�����п��Թ۲쵽OUT1����͵�ƽ������һ��ʱ��󣨼���������0������ߵ�ƽ��
CODE ENDS 
    END START
