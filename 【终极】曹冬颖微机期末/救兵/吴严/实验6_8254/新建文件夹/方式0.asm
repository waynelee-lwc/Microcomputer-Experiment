A8254 EQU 0600H
B8254 EQU 0602H 
C8254 EQU 0604H 
CON8254 EQU 0606H
;8254������012�Լ����ƶ˿ڵĵ�ַ����IOY����
SSTACK SEGMENT STACK 
    DW 32 DUP(?) 
SSTACK ENDS 
CODE SEGMENT 
    ASSUME CS:CODE
START: 
    MOV DX, CON8254
    MOV AL, 36H             ;8254������0�����ڷ�ʽ3�������������൱��CLK
    OUT DX, AL
    MOV DX, A8254
    MOV AL, 0E8H      ;�Ͱ�λ
    OUT DX, AL
    MOV AL, 03H             ;�ֱ�д���8λ�͸�8λ��������ֵ����������3E8H=1000
    OUT DX, AL
 
    MOV DX, CON8254
    MOV AL, 70H             ;8254������1�����ڷ�ʽ0������ʱ����͵�ƽ����0ʱ����ߵ�ƽ 
    OUT DX, AL 
    MOV DX, B8254 
    MOV AL, 00H 
    OUT DX, AL 
    MOV AL, 0AH             ;д�������ֵ0A00H
    OUT DX, AL 
AA1: 
    JMP AA1 
;��GATE1��Ϊ�͵�ƽ�����г���
;��GATE1��Ϊ�ߵ�ƽ����ʾ�����п��Թ۲쵽OUT1����͵�ƽ������һ��ʱ��󣨼���������0������ߵ�ƽ��
CODE ENDS 
    END START
