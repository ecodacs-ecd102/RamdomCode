GETL		EQU		0003H
LETLN		EQU		0006H
NEWLIN		EQU		0009H
PRNTS		EQU		000CH
PRNT		EQU		0012H
MSGPR		EQU		0015H
PLIST		EQU		0018H
GETKEY		EQU		001BH
BRKEY		EQU		001EH
TIMST		EQU		0033H
PRTWRD		EQU		03BAH
PRTBYT		EQU		03C3H
HLHEX		EQU		0410H
TWOHEX		EQU		041FH
ADCN		EQU		0BB9H
DISPCH		EQU		0DB5H
DPCT		EQU		0DDCH
IBUFE		EQU		10F0H
GFNAME		EQU		10F1H
EADRS		EQU		1102H
FSIZE		EQU		1102H
SADRS		EQU		1104H
EXEAD		EQU		1106H
DSPX		EQU		1171H
LBUF		EQU		11A3H
MBUF		EQU		11AEH
MONITOR_80K	EQU		0082H
MONITOR_700	EQU		00ADH
; kaokun [ ------------------------------------------------------
; MZ-NEW MONITOR
MONITOR_NEWMON	EQU		0082H			;with stack init

; Tape
;WRINF		EQU		0021H
;WRDAT		EQU		0024H
;RDINF		EQU		0027H
;RDDAT		EQU		002AH
;VERFY		EQU		002DH

TMCNT		EQU		1195H

; 8255 KEY/CASSET Controls
KEYPA		EQU		0E000H
KEYPB		EQU		0E001H
CSTR		EQU		0E002H
CSTPT		EQU		0E003H

; kaokun ] ------------------------------------------------------


;RAM_START	EQU	1200H
;RAM_END	EQU	0CFFFH
RAM_START	EQU	8F00H
RAM_END		EQU	0CFFFH

RAM_SIZE	EQU	(RAM_END + 1 - RAM_START)
STACK_BOTTOM	EQU	0F000H

VRAM		EQU	0D000H
CRAM		EQU	0D800H

	ORG	0E800H			; MZ-1200 Option ROM/RAM area
	JP	START

MSG_START:	DB	16H,"*** TEST START ***",0DH
MSG_ADDR:	DB	"ADDR :",0DH
MSG_WRITE:	DB	"WRITE:",0DH
MSG_READ:	DB	"READ :",0DH
MSG_PASS:	DB	"PASS :",0DH
MSG_FAIL:	DB	"FAIL :",0DH
MSG_END:	DB	"END",0DH
;                        0         1         2         3
;			 0123456789012345678901234567890123456789
MSG_TEST1	DB	"TEST  1 - FILL AA",0DH
MSG_TEST2	DB	"TEST  2 - CHECK AA AND FILL 55",0DH
MSG_TEST3	DB	"TEST  3 - CHECK 55 AND FILL AA",0DH
MSG_TEST4	DB	"TEST  4 - CHECK AA AND FILL FF",0DH
MSG_TEST5	DB	"TEST  5 - CHECK FF AND FILL 00",0DH
MSG_TEST6	DB	"TEST  6 - CHECK 00 AND FILL ADR",0DH
MSG_TEST7	DB	"TEST  7 - CHECK ADR AND FILL !ADR",0DH
MSG_TEST8	DB	"TEST  8 - CHECK !ADR",0DH
MSG_TEST9	DB	"TEST  9 - CHECKERBOARD AA 55",0DH
MSG_TEST10	DB	"TEST 10 - CHECKERBOARD 55 AA",0DH
MSG_TEST11	DB	"TEST 11 - CHECKERBOARD CC 33",0DH
MSG_TEST12	DB	"TEST 12 - CHECKERBOARD 33 CC",0DH
MSG_TEST13	DB	"TEST 13 - CHECKERBOARD F0 0F",0DH
MSG_TEST14	DB	"TEST 14 - CHECKERBOARD 0F F0",0DH
MSG_TEST15	DB	"TEST 15 - CHECKERBOARD FF 00",0DH
MSG_TEST16	DB	"TEST 16 - CHECKERBOARD 00 FF",0DH
MSG_TEST17	DB	"TEST 17 - SELF ADDR XOR COUNTER:",0DH
MSG_TEST18	DB	"TEST 18 - SELF ADDR LDIR",0DH
MSG_TEST19	DB	"TEST 19 - PROGRAM EXEC (1):",0DH
MSG_TEST20	DB	"TEST 20 - PROGRAM EXEC (2):",0DH
MSG_TEST21	DB	"TEST 21 - PROGRAM EXEC (4):",0DH
MSG_TEST22	DB	"TEST 22 - PROGRAM EXEC (N):",0DH

START:
	LD	SP,STACK_BOTTOM
	LD	HL,0			; L'=PASS COUNT & H'=ERROR FLAG
	EXX
	LD	DE,MSG_START
	CALL	DISPLF
	DI


TEST1:
	LD	DE,MSG_TEST1
	CALL	DISPLF
; AAで埋める
; FOR EACH "Memory Location" DO
; Write "Hexadecimals A's" to "Memory Location"
; END FOR
	LD	HL,RAM_START
	LD	BC,RAM_SIZE
TEST1_10:
	LD	(HL),0AAH
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST1_10

TEST2:
	LD	DE,MSG_TEST2
	CALL	DISPLF
; AAで埋まっているかチェックして、55で埋める
; FOR EACH "Memory Location" DO
; Verify "Hexadecimal A's" at "Memory Location"
; Immediately write "Hexadecimal 5's" to "Memory Location"
; END FOR
	LD	E,55H
	LD	HL,RAM_START
	LD	BC,RAM_SIZE
TEST2_10:
	LD	A,0AAH
	LD	D,(HL)
	CP	D
	CALL	NZ,TEST_ERROR_DISP_AD
	LD	(HL),E
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST2_10


TEST3:
	LD	DE,MSG_TEST3
	CALL	DISPLF
; 55で埋まっているかチェックして、AAで埋める
; FOR EACH "Memory Location" DO
; Verify "Hexadecimal 5's" at "Memory Location"
; Immediately write "Hexadecimal A's" to "Memory Location"
; END FOR
	LD	E,0AAH
	LD	HL,RAM_START
	LD	BC,RAM_SIZE
TEST3_10:
	LD	A,55H
	LD	D,(HL)
	CP	D
	CALL	NZ,TEST_ERROR_DISP_AD
	LD	(HL),E
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST3_10

TEST4:
	LD	DE,MSG_TEST4
	CALL	DISPLF
; AAで埋まっているかチェックして、FFで埋める
; FOR EACH "Memory Location" DO
; Verify "Hexadecimals A's" at "Memory Location"
; Immediately write "Hexadecimal F's" to "Memory Location"
; END FOR
	LD	E,0FFH
	LD	HL,RAM_START
	LD	BC,RAM_SIZE
TEST4_10:
	LD	A,0AAH
	LD	D,(HL)
	CP	D
	CALL	NZ,TEST_ERROR_DISP_AD
	LD	(HL),E
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST4_10

TEST5:
	LD	DE,MSG_TEST5
	CALL	DISPLF
; FFで埋まっているかチェックして、00で埋める
; FOR EACH "Memory Location" DO
; Verify "Hexadecimals F's" at "Memory Location"
; Immediately write "Hexadecimal 0's" to "Memory Location"
; END FOR
	LD	E,00H
	LD	HL,RAM_START
	LD	BC,RAM_SIZE
TEST5_10:
	LD	A,0FFH
	LD	D,(HL)
	CP	D
	CALL	NZ,TEST_ERROR_DISP_AD
	LD	(HL),E
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST5_10

TEST6:
	LD	DE,MSG_TEST6
	CALL	DISPLF
; 00で埋まっているかチェックして、SELF ADDRで埋める
; FOR EACH "Memory Location" DO
; Verify "Hexadecimals 0's" at "Memory Location"
; Immediately write SELF ADDRESS to "Memory Location"
; END FOR
	LD	HL,RAM_START
	LD	BC,RAM_SIZE
TEST6_10:
	XOR	A
	LD	D,(HL)
	CP	D
	CALL	NZ,TEST_ERROR_DISP_AD
	LD	(HL),L
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST6_10

TEST7:
	LD	DE,MSG_TEST7
	CALL	DISPLF
; SELF ADDRで埋まっているかチェックして、NOT(SELF ADDR)で埋める
; FOR EACH "Memory Location" DO
; Verify SELF ADDRESS at "Memory Location"
; Immediately write NOT(SELF ADDRESS) to "Memory Location"
; END FOR
	LD	HL,RAM_START
	LD	BC,RAM_SIZE
TEST7_10:
	LD	A,L
	LD	D,(HL)
	CP	D
	CALL	NZ,TEST_ERROR_DISP_AD
	CPL
	LD	(HL),A
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST7_10

TEST8:
	LD	DE,MSG_TEST8
	CALL	DISPLF
; NOT(SELF ADDR)で埋まっているかチェックして、00で埋める
; FOR EACH "Memory Location" DO
; Verify NOT(SELF ADDRESS) at "Memory Location"
; Immediately write 0 to "Memory Location"
; END FOR
	LD	HL,RAM_START
	LD	BC,RAM_SIZE
	LD	E,0
TEST8_10:
	LD	A,L
	CPL
	LD	D,(HL)
	CP	D
	CALL	NZ,TEST_ERROR_DISP_AD
	LD	(HL),E
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST8_10

TEST9:
; チェッカーボード AA 55
	LD	DE,MSG_TEST9
	CALL	DISPLF
	LD	DE,55AAH
	CALL	CHECKERBOARD

TEST10:
; チェッカーボード 55 AA
	LD	DE,MSG_TEST10
	CALL	DISPLF
	LD	DE,0AA55H
	CALL	CHECKERBOARD

TEST11:
; チェッカーボード CC 33
	LD	DE,MSG_TEST11
	CALL	DISPLF
	LD	DE,033CCH
	CALL	CHECKERBOARD

TEST12:
; チェッカーボード 33 CC
	LD	DE,MSG_TEST12
	CALL	DISPLF
	LD	DE,0CC33H
	CALL	CHECKERBOARD

TEST13:
; チェッカーボード F0 0F
	LD	DE,MSG_TEST13
	CALL	DISPLF
	LD	DE,0FF0H
	CALL	CHECKERBOARD

TEST14:
; チェッカーボード 0F F0
	LD	DE,MSG_TEST14
	CALL	DISPLF
	LD	DE,0F00FHH
	CALL	CHECKERBOARD

TEST15:
; チェッカーボード FF 00
	LD	DE,MSG_TEST15
	CALL	DISPLF
	LD	DE,00FFH
	CALL	CHECKERBOARD

TEST16:
; チェッカーボード 00 FF
	LD	DE,MSG_TEST16
	CALL	DISPLF
	LD	DE,0FF00H
	CALL	CHECKERBOARD

TEST17:
; (SELF ADDR) XOR カウンター値で埋めて、読めるかテスト
	LD	DE,MSG_TEST17
	CALL	MSGPR
	LD	E,0		; COUNTER

TEST17_10:
	PUSH	DE
	LD	A,E
	CALL	PRTBYT
	LD	A,14H			; ←
	CALL	PRNT
	LD	A,14H			; ←
	CALL	PRNT
	POP	DE

	LD	HL,RAM_START
	LD	BC,RAM_SIZE
TEST17_20:
	LD	A,L
	XOR	E
	LD	(HL),A
	LD	(VRAM),A
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST17_20

	LD	HL,RAM_START
	LD	BC,RAM_SIZE
TEST17_30:
	LD	A,L
	XOR	E
	LD	(VRAM),A
	LD	D,(HL)
	CP	D
	CALL	NZ,TEST_ERROR_DISP_AD
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST17_30
	INC	E			; COUNTER++
	JR	NZ,TEST17_10
	CALL	LETLN

TEST18:
; (SELF ADDR) LDIR
	LD	DE,MSG_TEST18
	CALL	MSGPR
	LD	HL,RAM_START
	LD	B,0
TEST18_10:
	LD	(HL),B
	INC	HL
	DJNZ	TEST18_10

	LD	HL,RAM_START
	LD	DE,RAM_START+256
	LD	BC,RAM_SIZE-256
	LDIR

	LD	HL,RAM_START
	LD	DE,RAM_SIZE
	LD	E,0
TEST18_20:
	LD	A,(VRAM)
	LD	A,(HL)
	CP	E
	CALL	NZ,TEST_ERROR_DISP_EA
	INC	HL
	DEC	DE
	LD	A,D
	OR	E
	JR	NZ,TEST18_20
	CALL	LETLN

TEST19:
; PROGRAM EXEC (1)
	LD	DE,MSG_TEST19
	CALL	MSGPR
	LD	HL,RAM_START
	LD	BC,RAM_SIZE
TEST19_10:
	CALL	TESTEXEC_PROG	; DISP ADDR<-<-<-<-
	LD	(HL),0C9H	; "RET"
	LD	DE,TEST19_20
	PUSH	DE
	JP	(HL)
TEST19_20:
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST19_10
	CALL	LETLN

TEST20:
; PROGRAM EXEC (2)
	LD	DE,MSG_TEST20
	CALL	MSGPR
	LD	HL,RAM_START
	LD	BC,RAM_SIZE-1
TEST20_10:
	CALL	TESTEXEC_PROG	; DISP ADDR<-<-<-<-
	LD	(HL),00H	; NOP
	INC	HL
	LD	(HL),0C9H	; RET
	DEC	HL
	LD	DE,TEST20_20
	PUSH	DE
	JP	(HL)
TEST20_20:
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST20_10
	CALL	LETLN

TEST21:
; PROGRAM EXEC (4)
	LD	DE,MSG_TEST21
	CALL	MSGPR
	LD	HL,RAM_START
	LD	BC,RAM_SIZE-3
TEST21_10:
	PUSH	HL
	LD	(HL),0CDH	; CALL TESTEXEC_PROG
	INC	HL
	LD	DE,TESTEXEC_PROG
	LD	(HL),E
	INC	HL
	LD	(HL),D
	INC	HL
	LD	(HL),0C9H	; RET
	POP	HL
	LD	DE,TEST21_20
	PUSH	DE
	JP	(HL)
TEST21_20:
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST21_10
	CALL	LETLN

TEST22:
; PROGRAM EXEC (N)
	LD	DE,MSG_TEST22
	CALL	MSGPR
	LD	HL,RAM_START
	LD	BC,RAM_SIZE-(TESTEXEC_PROG_E-TESTEXEC_PROG)+1
TEST22_10:
	PUSH	HL
	PUSH	BC
	EX	DE,HL
	LD	HL,TESTEXEC_PROG
	LD	BC,TESTEXEC_PROG_E-TESTEXEC_PROG
	LDIR
	POP	BC
	POP	HL
	LD	DE,TEST22_20
	PUSH	DE
	JP	(HL)
TEST22_20:
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,TEST22_10
	CALL	LETLN

;
; PASS / FAIL
;
PASSFAIL:
	EXX
	INC	L			; PASS COUNT++
	PUSH	HL
	EXX
	POP	HL
	LD	A,H
	OR	A
	JR	NZ,DISP_FAIL
	LD	DE,MSG_PASS
	CALL	MSGPR			; PASS: xx
	LD	A,L
	CALL	PRTBYT
	CALL	LETLN
	LD	A,L
	CP	255
	JR	Z,CLRMON
	JP	TEST1

DISP_FAIL:
	LD	DE,MSG_FAIL
	CALL	DISPLF

CLRMON:
; 00で埋める
	XOR	A
	LD	HL,RAM_START
	LD	BC,RAM_SIZE
FILL00_10:
	LD	(HL),A
	INC	HL
	DEC	C
	JR	NZ,FILL00_10
	DJNZ	FILL00_10

	LD	DE,MSG_END
	CALL	DISPLF
MON:
	LD	HL,014EH
	LD	A,(HL)
	CP	'P'			;014EHが'P'ならMZ-80K
	JP	Z,MONITOR_80K
	CP	'N'			;014EHが'N'ならFN-700
	JP	Z,MONITOR_80K
	CP	' '			;014EHが' 'ならMZ-NEW MONITOR MZ-80K
	JP	Z,MONITOR_NEWMON
	CP	0D5H			;014EHが0D5HならMZ-NEW MONITOR MZ-700
	JP	Z,MONITOR_NEWMON
	LD	HL,06EBH
	LD	A,(HL)
	CP	'M'			;06EBHが'M'ならMZ-700
	JP	Z,MONITOR_700
	JP	0000H			;識別できなかったら0000Hへジャンプ

;
; チェッカーボード
; DE: パターン
;
CHECKERBOARD:
	LD	HL,RAM_START
	LD	BC,RAM_SIZE / 2
CHKBRD_10:
	LD	(HL),E
	INC	HL
	LD	(HL),D
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,CHKBRD_10

	LD	HL,RAM_START
	LD	BC,RAM_SIZE / 2
CHKBRD_20:
	LD	A,(HL)
	CP	E
	CALL	NZ,TEST_ERROR_DISP_EA
	INC	HL
	LD	A,(HL)
	CP	D
	CALL	NZ,TEST_ERROR_DISP_DA
	INC	HL
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,CHKBRD_20
	RET

;
; DISP + LF
;
DISPLF:
	CALL	MSGPR
	CALL	LETLN
	RET

;
;エラー表示
;

TEST_ERROR_DISP_EA:
; HL: ADDR
;  E: WRITE
;  A: READ:
	PUSH	AF
	PUSH	DE
	LD	D,A
	LD	A,E
	CALL	TEST_ERROR_DISP_AD
	POP	DE
	POP	AF
	RET

TEST_ERROR_DISP_DA:
; HL: ADDR
;  D: WRITE
;  A: READ:
	PUSH	AF
	PUSH	DE
	LD	E,A
	LD	A,D
	LD	D,E
	CALL	TEST_ERROR_DISP_AD
	POP	DE
	POP	AF
	RET

TEST_ERROR_DISP_AD:
; HL: ADDR
;  A: WRITE
;  D: READ:
	PUSH	BC
	PUSH	DE
	PUSH	HL
	PUSH	AF

	PUSH	DE
	PUSH	AF
	PUSH	HL
	LD	DE,MSG_ADDR	; ADDR : xxxx
	CALL	MSGPR
	POP	HL
	CALL	PRTWRD
	CALL	LETLN

	LD	DE,MSG_WRITE	; WRITE: xx
	CALL	MSGPR
	POP	AF
	CALL	PRTBYT
	CALL	LETLN

	LD	DE,MSG_READ	; READ : xx
	CALL	MSGPR
	POP	DE
	LD	A,D
	CALL	PRTBYT
	CALL	LETLN

	EXX
	LD	H,1		; ERROR FLAGを立てる
	EXX

	CALL	BRKEY
	JP	Z,MON

	POP	AF
	POP	HL
	POP	DE
	POP	BC
	RET

;
; TEST19-で使うルーチン
;
TESTEXEC_PROG:
	LD	A,L
	LD	(VRAM),A
	PUSH	HL
	PUSH	DE
	PUSH	BC
	CALL	PRTWRD
	LD	B,4
TESTEXEC_PROG_10:
	LD	A,14H			; ←
	CALL	PRNT
	DJNZ	TESTEXEC_PROG_10
	POP	BC
	POP	DE
	POP	HL
	RET
TESTEXEC_PROG_E:

	END
