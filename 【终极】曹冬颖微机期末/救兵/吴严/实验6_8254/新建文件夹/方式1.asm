A8254 EQU 0600H
B8254 EQU 0602H 
C8254 EQU 0604H 
CON8254 EQU 0606H
SSTACK SEGMENT STACK 
    DW 32 DUP(?) 
SSTACK ENDS 
CODE SEGMENT 
    ASSUME CS:CODE
START: 
    MOV DX, CON8254
    MOV AL, 36H
    OUT DX, AL
    MOV DX, A8254
    MOV AL, 0E8H
    OUT DX, AL
    MOV AL, 03H
    OUT DX, AL
    ;8254������0�����ڷ�ʽ3�������������൱��CLK
    MOV DX, CON8254
    MOV AL, 72H             ;8254������0�����ڷ�ʽ1������ʱ����͵�ƽ����0ʱ����ߵ�ƽ 
    OUT DX, AL 
    MOV DX, B8254 
    MOV AL, 00H 
    OUT DX, AL 
    MOV AL, 0AH             ;д�������ֵ0A00H
    OUT DX, AL 
AA1: 
    JMP AA1 
;��GATE1��Ϊ�͵�ƽ�����г�����ʾ�����п��Կ���OUT1����ߵ�ƽ��
;�ѿ��رպ�Ȼ����ٶϿ���ʹGATE1����һ�����壬��ʾ�����п��Թ۲쵽OUT1����͵�ƽ
;����һ��ʱ��󣨼���������0������ߵ�ƽ��
;�ظ��������̣����Կ���ÿ��GATE1�������壬8254���Ὺʼ����������͵�ƽ��������������0ʱ�ָ��ߵ�ƽ��
CODE ENDS 
    END START