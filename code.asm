;<Micro Project> 
;40 CMD (8155_2) 
;41 PA (8155_2) 
;80 CMD (8155_1) 
;81 PA (8155_1) 
;82 PB (8155_1) 
 
;Data 
sin0 EQU 80h	;128 
sin30 EQU C0h 	;192 
sin60 EQU EEh 	;238 
sin90 EQU FFh 	;255 
sin120 EQU EEh  ;238 
sin150 EQU C0h 	;192 
sin180 EQU 80h  ;128 
sin210 EQU 40h  ;64 
sin240 EQU 11h  ;17 
sin270 EQU 00h  ;0 
sin300 EQU 11h  ;17 
sin330 EQU 40h  ;64 
sin360 EQU 80h  ;128 
 
squ0 EQU FFh    ;255  
squ1 EQU 0h     ;0 
 
swt0 EQU 0h     ;0 
swt1 EQU 33h    ;51 
swt2 EQU 66h    ;102 
swt3 EQU 9Ah    ;154 
swt4 EQU CDh    ;205 
swt5 EQU FFh    ;255 
 
KV EQU 0FFFh 
 
;Code 
jmp INIT 
jmp SRV65        ;SRV 6.5 
ORG 100 
 
INIT: LXI SP,0000 
 MVI A,00h 
 OUT 81h         ;8155_1 PORT A 
 OUT 82h         ;8155_1 PORT B 
 MVI A,02 
 OUT 80           ;8155_1 CMD 
 MVI A,10 
 OUT 40          ;8155_2 CMD 
 MVI A,00001101 
 SIM 
 EI 
 
BEGIN: LDA KV 
 CPI 0Ah 
 JZ START 
 CPI FFh 
 JZ STOP 
 
STOP: MVI A,00h 
 OUT 81h        ;8155_1 PORTA 
 OUT 82h        ;8155_1 PORTB 
 JMP BEGIN 

 
START: LDA KV 
 CPI 01h 
 JZ MODEH 
 CPI 02h 
 JZ MODEI 
 CPI 03h 
 JZ MODES 
 JMP BEGIN 
 
MODEH:MVI A,01101110           ;7-SEG formatýnda 'H' 
 OUT 82h   ;8155_1 PORTB 
H1: MVI A,squ0 
 OUT 81h  
 CALL delaySQUARE 
 MVI A,squ1 
 OUT 81h 
 CALL delaySQUARE 
 jmp H1 
 
MODEI: MVI A,01100000          ;7-SEG formatýnda 'I' 
 OUT 82h                        ;8155_1 PORTB 
I1: MVI A,swt0 
 OUT 81h 
 CALL delaySawTooth 
 MVI A,swt1 
 OUT 81h 
 CALL delaySawTooth 
 MVI A,swt2 
 OUT 81h 
 CALL delaySawTooth 
 MVI A,swt3 
 OUT 81h 
 CALL delaySawTooth 
 MVI A,swt4 
 OUT 81h 
 CALL delaySawTooth 
 MVI A,swt5 
 OUT 81h 
 CALL delaySawTooth 
 JMP I1 
 
MODES:MVI A,10110110  ;7-SEG formatýnda 'S' 
 OUT 82h   ;8155_1 PORTB 
S1: MVI A,sin0 
 OUT 81h 
 NOP       ;delay 4 cycle 
 MVI A,sin30 
 OUT 81h 
 NOP   	   ;delay 4 cycle 
 MVI A,sin60 
 OUT 81h 
 NOP       ;delay 4 cycle 
 MVI A,sin90 
 OUT 81h 
 NOP       ;delay 4 cycle 
 MVI A,sin120 
 OUT 81h 
 NOP       ;delay 4 cycle 
 MVI A,sin150 
 OUT 81h 
 NOP       ;delay 4 cycle 
 MVI A,sin180 
 OUT 81h 
 NOP       ;delay 4 cycle 
 MVI A,sin210 
 OUT 81h 
 NOP       ;delay 4 cycle 
 MVI A,sin240 
 OUT 81h 
 NOP       ;delay 4 cycle 
 MVI A,sin270 
 OUT 81h 
 NOP       ;delay 4 cycle 
 MVI A,sin300 
 OUT 81h 
 NOP       ;delay 4 cycle 
 MVI A,sin330 
 OUT 81h 
 NOP       ;delay 4 cycle 
 MVI A,sin360 
 OUT 81h 
 NOP       ;delay 4 cycle 
 JMP S1 
 
delaySawTooth:MVI C,2 
  DCR C 
  JNZ delaySawTooth 
  RET 
 
delaySQUARE: MVI C,5  
             DCR C 
            JNZ delaySQUARE 
            RET 
 
SRV65: PUSH PSW 
 IN 41    ;8155_1 PA (Keypad) 
 STA KV 
 POP PSW 
 EI 
 RET 