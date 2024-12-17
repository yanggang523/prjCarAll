
;CodeVisionAVR C Compiler V3.49a Evaluation
;(C) Copyright 1998-2022 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPMCSR=0x68
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x80

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _ch=R5
	.DEF _obstacleDetected=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_msg_ready:
	.DB  0x55,0x41,0x52,0x54,0x20,0x43,0x6F,0x6D
	.DB  0x6D,0x75,0x6E,0x69,0x63,0x61,0x74,0x69
	.DB  0x6F,0x6E,0x20,0x52,0x65,0x61,0x64,0x79
	.DB  0xA,0x0
_msg_invalid:
	.DB  0x49,0x6E,0x76,0x61,0x6C,0x69,0x64,0x20
	.DB  0x43,0x6F,0x6D,0x6D,0x61,0x6E,0x64,0xA
	.DB  0x0
_msg_prompt:
	.DB  0x54,0x79,0x70,0x65,0x20,0x61,0x20,0x6D
	.DB  0x65,0x73,0x73,0x61,0x67,0x65,0x3A,0x20
	.DB  0x0
_msg_hello:
	.DB  0x4D,0x65,0x73,0x73,0x61,0x67,0x65,0x20
	.DB  0x52,0x65,0x63,0x65,0x69,0x76,0x65,0x64
	.DB  0x3A,0x20,0x48,0x45,0x4C,0x4C,0x4F,0xA
	.DB  0x0
_msg_unknown:
	.DB  0x55,0x6E,0x6B,0x6E,0x6F,0x77,0x6E,0x20
	.DB  0x4D,0x65,0x73,0x73,0x61,0x67,0x65,0xA
	.DB  0x0
_msg_hello_flash:
	.DB  0x48,0x45,0x4C,0x4C,0x4F,0x0
_msg_go_straight:
	.DB  0x67,0x6F,0x5F,0x73,0x74,0x72,0x61,0x69
	.DB  0x67,0x68,0x74,0x0
_msg_back:
	.DB  0x62,0x61,0x63,0x6B,0x0
_msg_turn_right:
	.DB  0x74,0x75,0x72,0x6E,0x5F,0x72,0x69,0x67
	.DB  0x68,0x74,0x0
_msg_turn_left:
	.DB  0x74,0x75,0x72,0x6E,0x5F,0x6C,0x65,0x66
	.DB  0x74,0x0
_msg_stop:
	.DB  0x73,0x74,0x6F,0x70,0x0
_msg_obstacle_detected:
	.DB  0x4F,0x62,0x73,0x74,0x61,0x63,0x6C,0x65
	.DB  0x20,0x44,0x65,0x74,0x65,0x63,0x74,0x65
	.DB  0x64,0x3A,0x20,0x57,0x69,0x74,0x68,0x69
	.DB  0x6E,0x20,0x31,0x35,0x63,0x6D,0xA,0x0
_msg_obstacle_cleared:
	.DB  0x4F,0x62,0x73,0x74,0x61,0x63,0x6C,0x65
	.DB  0x20,0x43,0x6C,0x65,0x61,0x72,0x65,0x64
	.DB  0x3A,0x20,0x42,0x65,0x79,0x6F,0x6E,0x64
	.DB  0x20,0x31,0x35,0x63,0x6D,0xA,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x0:
	.DB  0x59,0x6F,0x75,0x20,0x65,0x6E,0x74,0x65
	.DB  0x72,0x65,0x64,0x3A,0x20,0x0,0x57,0x0
	.DB  0x77,0x0,0x53,0x0,0x73,0x0,0x41,0x0
	.DB  0x61,0x0,0x44,0x0,0x64,0x0,0x52,0x0
	.DB  0x72,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0E
	.DW  _0x22
	.DW  _0x0*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x500

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;void timer0_init(void);
;void timer2_init(void);
;void USART0_Init(unsigned int ubrr);
;char USART0_Receive(void);
;void USART0_Transmit(char data);
;void USART0_ReceiveString(char *buffer, int maxLength);
;void removeNewline(char *str);
;void USART0_SendFlashString(const flash char *str);
;void Go_Straight(void);
;void Turn_Left(void);
;void Turn_Right(void);
;void Back(void);
;void Stop(void);
;uint16_t measureDistance(void);
;interrupt [13] void timer1_compa_isr(void) {
; 0000 0055 interrupt [13] void timer1_compa_isr(void) {

	.CSEG
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0056 total_count++;
	LDI  R26,LOW(_total_count)
	LDI  R27,HIGH(_total_count)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0057 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;void USART0_Init(unsigned int ubrr) {
; 0000 0073 void USART0_Init(unsigned int ubrr) {
_USART0_Init:
; .FSTART _USART0_Init
; 0000 0074 UBRR0H = (unsigned char)(ubrr >> 8);   // 상위 8비트 설정
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	ubrr -> R16,R17
	STS  144,R17
; 0000 0075 UBRR0L = (unsigned char)ubrr;          // 하위 8비트 설정
	OUT  0x9,R16
; 0000 0076 UCSR0A = (1 << U2X0);                  // 더블 속도 모드 활성화
	LDI  R30,LOW(2)
	OUT  0xB,R30
; 0000 0077 UCSR0B = (1 << RXEN0) | (1 << TXEN0);  // 송신 및 수신 활성화
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0078 UCSR0C = (1 << UCSZ01) | (1 << UCSZ00); // 8비트 데이터 설정
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0079 }
	RJMP _0x2060004
; .FEND
;char USART0_Receive(void) {
; 0000 007D char USART0_Receive(void) {
_USART0_Receive:
; .FSTART _USART0_Receive
; 0000 007E while (!(UCSR0A & (1 << RXC0)));
_0x3:
	SBIS 0xB,7
	RJMP _0x3
; 0000 007F return UDR0;
	IN   R30,0xC
	RET
; 0000 0080 }
; .FEND
;void USART0_Transmit(char data) {
; 0000 0083 void USART0_Transmit(char data) {
_USART0_Transmit:
; .FSTART _USART0_Transmit
; 0000 0084 while (!(UCSR0A & (1 << UDRE0)));
	ST   -Y,R17
	MOV  R17,R26
;	data -> R17
_0x6:
	SBIS 0xB,5
	RJMP _0x6
; 0000 0085 UDR0 = data;
	OUT  0xC,R17
; 0000 0086 }
	LD   R17,Y+
	RET
; .FEND
;void USART0_SendString(const char *str) {
; 0000 008A void USART0_SendString(const char *str) {
_USART0_SendString:
; .FSTART _USART0_SendString
; 0000 008B while (*str) {
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*str -> R16,R17
_0x9:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BREQ _0xB
; 0000 008C USART0_Transmit(*str++);
	__ADDWRN 16,17,1
	LD   R26,X
	RCALL _USART0_Transmit
; 0000 008D }
	RJMP _0x9
_0xB:
; 0000 008E }
_0x2060004:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;void USART0_SendFlashString(const flash char *str) {
; 0000 0091 void USART0_SendFlashString(const flash char *str) {
_USART0_SendFlashString:
; .FSTART _USART0_SendFlashString
; 0000 0092 char c;
; 0000 0093 while ((c = *str++)!= '\0') {
	RCALL __SAVELOCR4
	MOVW R18,R26
;	*str -> R18,R19
;	c -> R17
_0xC:
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0xE
; 0000 0094 USART0_Transmit(c);
	MOV  R26,R17
	RCALL _USART0_Transmit
; 0000 0095 }
	RJMP _0xC
_0xE:
; 0000 0096 }
	RJMP _0x2060001
; .FEND
;void USART0_ReceiveString(char *buffer, int maxLength) {
; 0000 0099 void USART0_ReceiveString(char *buffer, int maxLength) {
_USART0_ReceiveString:
; .FSTART _USART0_ReceiveString
; 0000 009A int i = 0;
; 0000 009B char ch;
; 0000 009C 
; 0000 009D while (1) {
	RCALL __SAVELOCR6
	MOVW R20,R26
;	*buffer -> Y+6
;	maxLength -> R20,R21
;	i -> R16,R17
;	ch -> R19
	__GETWRN 16,17,0
_0xF:
; 0000 009E ch = USART0_Receive();
	RCALL _USART0_Receive
	MOV  R19,R30
; 0000 009F 
; 0000 00A0 if (ch == '\r' || ch == '\n') {
	CPI  R19,13
	BREQ _0x13
	CPI  R19,10
	BRNE _0x12
_0x13:
; 0000 00A1 buffer[i] = '\0';
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00A2 break;
	RJMP _0x11
; 0000 00A3 }
; 0000 00A4 
; 0000 00A5 if (i < maxLength - 1) {
_0x12:
	MOVW R30,R20
	SBIW R30,1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x15
; 0000 00A6 buffer[i++] = ch;
	MOVW R30,R16
	__ADDWRN 16,17,1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R19
; 0000 00A7 }
; 0000 00A8 }
_0x15:
	RJMP _0xF
_0x11:
; 0000 00A9 }
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
;void removeNewline(char *str) {
; 0000 00AB void removeNewline(char *str) {
_removeNewline:
; .FSTART _removeNewline
; 0000 00AC char *pos;
; 0000 00AD if ((pos = strchr(str, '\r')) != NULL) *pos = '\0';
	RCALL __SAVELOCR4
	MOVW R18,R26
;	*str -> R18,R19
;	*pos -> R16,R17
	ST   -Y,R19
	ST   -Y,R18
	LDI  R26,LOW(13)
	RCALL _strchr
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x16
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00AE if ((pos = strchr(str, '\n')) != NULL) *pos = '\0';
_0x16:
	ST   -Y,R19
	ST   -Y,R18
	LDI  R26,LOW(10)
	RCALL _strchr
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x17
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00AF }
_0x17:
	RJMP _0x2060001
; .FEND
;void timer0_init(void) {
; 0000 00B2 void timer0_init(void) {
_timer0_init:
; .FSTART _timer0_init
; 0000 00B3 TCCR0 = 0b01101100;  // Fast PWM 모드 설정
	LDI  R30,LOW(108)
	OUT  0x33,R30
; 0000 00B4 }
	RET
; .FEND
;void timer2_init(void) {
; 0000 00B7 void timer2_init(void) {
_timer2_init:
; .FSTART _timer2_init
; 0000 00B8 TCCR2 = 0b01101100;  // Fast PWM 모드 설정
	LDI  R30,LOW(108)
	OUT  0x25,R30
; 0000 00B9 }
	RET
; .FEND
;void Go_Straight(void) {
; 0000 00BC void Go_Straight(void) {
_Go_Straight:
; .FSTART _Go_Straight
; 0000 00BD OCR0 = 90;
	RCALL SUBOPT_0x0
; 0000 00BE PORTB &= ~(1 << 5);
; 0000 00BF PORTB |= (1 << 6);
; 0000 00C0 
; 0000 00C1 OCR2 = 90;
	RJMP _0x2060003
; 0000 00C2 PORTB &= ~(1 << 2);
; 0000 00C3 PORTB |= (1 << 3);
; 0000 00C4 }
; .FEND
;void Back(void) {
; 0000 00C7 void Back(void) {
_Back:
; .FSTART _Back
; 0000 00C8 OCR0 = 90;
	RCALL SUBOPT_0x1
; 0000 00C9 PORTB |= (1 << 5);
; 0000 00CA PORTB &= ~(1 << 6);
; 0000 00CB 
; 0000 00CC OCR2 = 90;
	LDI  R30,LOW(90)
	OUT  0x23,R30
; 0000 00CD PORTB |= (1 << 2);
	SBI  0x18,2
; 0000 00CE PORTB &= ~(1 << 3);
	RJMP _0x2060002
; 0000 00CF }
; .FEND
;void Turn_Right(void) {
; 0000 00D2 void Turn_Right(void) {
_Turn_Right:
; .FSTART _Turn_Right
; 0000 00D3 OCR0 = 90;
	RCALL SUBOPT_0x1
; 0000 00D4 PORTB |= (1 << 5);
; 0000 00D5 PORTB &= ~(1 << 6);
; 0000 00D6 
; 0000 00D7 OCR2 = 90;
_0x2060003:
	LDI  R30,LOW(90)
	OUT  0x23,R30
; 0000 00D8 PORTB &= ~(1 << 2);
	CBI  0x18,2
; 0000 00D9 PORTB |= (1 << 3);
	SBI  0x18,3
; 0000 00DA }
	RET
; .FEND
;void Turn_Left(void) {
; 0000 00DD void Turn_Left(void) {
_Turn_Left:
; .FSTART _Turn_Left
; 0000 00DE OCR0 = 90;
	RCALL SUBOPT_0x0
; 0000 00DF PORTB &= ~(1 << 5);
; 0000 00E0 PORTB |= (1 << 6);
; 0000 00E1 
; 0000 00E2 OCR2 = 90;
	LDI  R30,LOW(90)
	OUT  0x23,R30
; 0000 00E3 PORTB |= (1 << 2);
	SBI  0x18,2
; 0000 00E4 PORTB &= ~(1 << 3);
	RJMP _0x2060002
; 0000 00E5 }
; .FEND
;void Stop(void) {
; 0000 00E8 void Stop(void) {
_Stop:
; .FSTART _Stop
; 0000 00E9 OCR0 = 0;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 00EA PORTB &= ~(1 << 5);
	CBI  0x18,5
; 0000 00EB PORTB &= ~(1 << 6);
	CBI  0x18,6
; 0000 00EC 
; 0000 00ED OCR2 = 0;
	OUT  0x23,R30
; 0000 00EE PORTB &= ~(1 << 2);
	CBI  0x18,2
; 0000 00EF PORTB &= ~(1 << 3);
_0x2060002:
	CBI  0x18,3
; 0000 00F0 }
	RET
; .FEND
;uint16_t measureDistance(void) {
; 0000 00F4 uint16_t measureDistance(void) {
_measureDistance:
; .FSTART _measureDistance
; 0000 00F5 uint16_t count = 0;
; 0000 00F6 uint16_t distance = 0;
; 0000 00F7 
; 0000 00F8 // 트리거 핀으로 펄스 발생 (10us)
; 0000 00F9 PORTB |= (1 << 0); // 트리거 핀 HIGH (예: PB0)
	RCALL __SAVELOCR4
;	count -> R16,R17
;	distance -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	SBI  0x18,0
; 0000 00FA delay_us(10);
	__DELAY_USB 53
; 0000 00FB PORTB &= ~(1 << 0); // 트리거 핀 LOW
	CBI  0x18,0
; 0000 00FC 
; 0000 00FD // 에코 핀의 상승 에지 대기
; 0000 00FE while (!(PINB & (1 << 1))); // 에코 핀 HIGH 대기 (예: PB1)
_0x18:
	SBIS 0x16,1
	RJMP _0x18
; 0000 00FF 
; 0000 0100 // 에코 핀의 펄스 폭 측정
; 0000 0101 while (PINB & (1 << 1)) {
_0x1B:
	SBIS 0x16,1
	RJMP _0x1D
; 0000 0102 count++;
	__ADDWRN 16,17,1
; 0000 0103 delay_us(1);
	__DELAY_USB 5
; 0000 0104 }
	RJMP _0x1B
_0x1D:
; 0000 0105 
; 0000 0106 // 거리 계산: (음속 * 시간) / 2
; 0000 0107 distance = count * 0.0343 / 2;
	MOVW R30,R16
	CLR  R22
	CLR  R23
	RCALL __CDF1
	__GETD2N 0x3D0C7E28
	RCALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40000000
	RCALL __DIVF21
	RCALL __CFD1U
	MOVW R18,R30
; 0000 0108 
; 0000 0109 return distance;
_0x2060001:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; 0000 010A }
; .FEND
;void main(void) {
; 0000 010F void main(void) {
_main:
; .FSTART _main
; 0000 0110 DDRB = 0xFF;      // PORTB를 출력으로 설정
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0111 timer0_init();    // 타이머0 초기화
	RCALL _timer0_init
; 0000 0112 timer2_init();    // 타이머2 초기화
	RCALL _timer2_init
; 0000 0113 USART0_Init(MYUBRR);  // USART0 초기화
	LDI  R26,LOW(207)
	LDI  R27,0
	RCALL _USART0_Init
; 0000 0114 
; 0000 0115 
; 0000 0116 
; 0000 0117 // 타이머1 초기화 (60ms마다 인터럽트 발생)
; 0000 0118 TCCR1B = (1 << WGM12) | (1 << CS12); // CTC 모드, 256 분주
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 0119 OCR1A = 3749;  // 60ms 주기 (16MHz / 256 / (3749 + 1) = 60ms)
	LDI  R30,LOW(3749)
	LDI  R31,HIGH(3749)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 011A TIMSK = (1 << OCIE1A);  // 타이머1 컴페어 매치 인터럽트 활성화
	LDI  R30,LOW(16)
	OUT  0x37,R30
; 0000 011B #asm("sei")  // 전역 인터럽트 활성화
	SEI
; 0000 011C 
; 0000 011D Go_Straight();  // 모터 직진 테스트
	RCALL _Go_Straight
; 0000 011E delay_ms(2000); // 2초 동안 직진
	RCALL SUBOPT_0x2
; 0000 011F Stop();         // 모터 정지
; 0000 0120 delay_ms(1000); // 1초 동안 정지
; 0000 0121 
; 0000 0122 Back();         // 모터 후진 테스트
	RCALL _Back
; 0000 0123 delay_ms(2000); // 2초 동안 후진
	RCALL SUBOPT_0x2
; 0000 0124 Stop();
; 0000 0125 delay_ms(1000);
; 0000 0126 
; 0000 0127 
; 0000 0128 while (1) {
_0x1E:
; 0000 0129 uint16_t distance = measureDistance();
; 0000 012A memset(receivedString, 0, sizeof(receivedString));
	SBIW R28,2
;	distance -> Y+0
	RCALL _measureDistance
	ST   Y,R30
	STD  Y+1,R31
	RCALL SUBOPT_0x3
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _memset
; 0000 012B 
; 0000 012C // 문자열 수신 및 처리 반복
; 0000 012D USART0_SendFlashString(msg_prompt);
	LDI  R26,LOW(_msg_prompt*2)
	LDI  R27,HIGH(_msg_prompt*2)
	RCALL _USART0_SendFlashString
; 0000 012E USART0_ReceiveString(receivedString, sizeof(receivedString));
	RCALL SUBOPT_0x3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _USART0_ReceiveString
; 0000 012F 
; 0000 0130 // 입력받은 문자열이 비어있지 않으면 출력
; 0000 0131 if (receivedString[0] != '\0') {
	LDS  R30,_receivedString
	CPI  R30,0
	BREQ _0x21
; 0000 0132 USART0_SendString("You entered: ");
	__POINTW2MN _0x22,0
	RCALL _USART0_SendString
; 0000 0133 USART0_SendString(receivedString);
	LDI  R26,LOW(_receivedString)
	LDI  R27,HIGH(_receivedString)
	RCALL _USART0_SendString
; 0000 0134 USART0_Transmit('\n');
	LDI  R26,LOW(10)
	RCALL _USART0_Transmit
; 0000 0135 }
; 0000 0136 
; 0000 0137 // 개행 문자 제거 후 처리
; 0000 0138 removeNewline(receivedString);
_0x21:
	LDI  R26,LOW(_receivedString)
	LDI  R27,HIGH(_receivedString)
	RCALL _removeNewline
; 0000 0139 
; 0000 013A if (strcmp_P(receivedString, msg_hello_flash) == 0) {
	RCALL SUBOPT_0x3
	LDI  R26,LOW(_msg_hello_flash*2)
	LDI  R27,HIGH(_msg_hello_flash*2)
	RCALL _strcmpf
	CPI  R30,0
	BRNE _0x23
; 0000 013B USART0_SendFlashString(msg_hello);
	LDI  R26,LOW(_msg_hello*2)
	LDI  R27,HIGH(_msg_hello*2)
	RJMP _0x42
; 0000 013C } else {
_0x23:
; 0000 013D USART0_SendFlashString(msg_unknown);
	LDI  R26,LOW(_msg_unknown*2)
	LDI  R27,HIGH(_msg_unknown*2)
_0x42:
	RCALL _USART0_SendFlashString
; 0000 013E }
; 0000 013F 
; 0000 0140 // 리셋 메시지 출력
; 0000 0141 USART0_SendFlashString(msg_ready);
	LDI  R26,LOW(_msg_ready*2)
	LDI  R27,HIGH(_msg_ready*2)
	RCALL _USART0_SendFlashString
; 0000 0142 
; 0000 0143 // 입력 문자열에 따라 처리
; 0000 0144 if (strcmp_P(receivedString, PSTR("W")) == 0 || strcmp_P(receivedString, PSTR("w")) == 0) {
	RCALL SUBOPT_0x3
	__POINTW2FN _0x0,14
	RCALL _strcmpf
	CPI  R30,0
	BREQ _0x26
	RCALL SUBOPT_0x3
	__POINTW2FN _0x0,16
	RCALL _strcmpf
	CPI  R30,0
	BRNE _0x25
_0x26:
; 0000 0145 Go_Straight();
	RCALL _Go_Straight
; 0000 0146 USART0_SendFlashString(msg_go_straight);
	LDI  R26,LOW(_msg_go_straight*2)
	LDI  R27,HIGH(_msg_go_straight*2)
	RJMP _0x43
; 0000 0147 }
; 0000 0148 else if (strcmp_P(receivedString, PSTR("S")) == 0 || strcmp_P(receivedString, PSTR("s")) == 0) {
_0x25:
	RCALL SUBOPT_0x3
	__POINTW2FN _0x0,18
	RCALL _strcmpf
	CPI  R30,0
	BREQ _0x2A
	RCALL SUBOPT_0x3
	__POINTW2FN _0x0,20
	RCALL _strcmpf
	CPI  R30,0
	BRNE _0x29
_0x2A:
; 0000 0149 Back();
	RCALL _Back
; 0000 014A USART0_SendFlashString(msg_back);
	LDI  R26,LOW(_msg_back*2)
	LDI  R27,HIGH(_msg_back*2)
	RJMP _0x43
; 0000 014B }
; 0000 014C else if (strcmp_P(receivedString, PSTR("A")) == 0 || strcmp_P(receivedString, PSTR("a")) == 0) {
_0x29:
	RCALL SUBOPT_0x3
	__POINTW2FN _0x0,22
	RCALL _strcmpf
	CPI  R30,0
	BREQ _0x2E
	RCALL SUBOPT_0x3
	__POINTW2FN _0x0,24
	RCALL _strcmpf
	CPI  R30,0
	BRNE _0x2D
_0x2E:
; 0000 014D Turn_Left();
	RCALL _Turn_Left
; 0000 014E USART0_SendFlashString(msg_turn_left);
	LDI  R26,LOW(_msg_turn_left*2)
	LDI  R27,HIGH(_msg_turn_left*2)
	RJMP _0x43
; 0000 014F }
; 0000 0150 else if (strcmp_P(receivedString, PSTR("D")) == 0 || strcmp_P(receivedString, PSTR("d")) == 0) {
_0x2D:
	RCALL SUBOPT_0x3
	__POINTW2FN _0x0,26
	RCALL _strcmpf
	CPI  R30,0
	BREQ _0x32
	RCALL SUBOPT_0x3
	__POINTW2FN _0x0,28
	RCALL _strcmpf
	CPI  R30,0
	BRNE _0x31
_0x32:
; 0000 0151 Turn_Right();
	RCALL _Turn_Right
; 0000 0152 USART0_SendFlashString(msg_turn_right);
	LDI  R26,LOW(_msg_turn_right*2)
	LDI  R27,HIGH(_msg_turn_right*2)
	RJMP _0x43
; 0000 0153 }
; 0000 0154 else if (strcmp_P(receivedString, PSTR("R")) == 0 || strcmp_P(receivedString, PSTR("r")) == 0) {
_0x31:
	RCALL SUBOPT_0x3
	__POINTW2FN _0x0,30
	RCALL _strcmpf
	CPI  R30,0
	BREQ _0x36
	RCALL SUBOPT_0x3
	__POINTW2FN _0x0,32
	RCALL _strcmpf
	CPI  R30,0
	BRNE _0x35
_0x36:
; 0000 0155 Stop();
	RCALL _Stop
; 0000 0156 USART0_SendFlashString(msg_stop);
	LDI  R26,LOW(_msg_stop*2)
	LDI  R27,HIGH(_msg_stop*2)
	RJMP _0x43
; 0000 0157 }
; 0000 0158 else {
_0x35:
; 0000 0159 USART0_SendFlashString(msg_invalid);
	LDI  R26,LOW(_msg_invalid*2)
	LDI  R27,HIGH(_msg_invalid*2)
_0x43:
	RCALL _USART0_SendFlashString
; 0000 015A }
; 0000 015B 
; 0000 015C 
; 0000 015D distance = measureDistance();
	RCALL _measureDistance
	ST   Y,R30
	STD  Y+1,R31
; 0000 015E if (obstacleDetected) {
	TST  R4
	BREQ _0x39
; 0000 015F obstacleDetected = 0;  // 플래그 리셋
	CLR  R4
; 0000 0160 
; 0000 0161 if (distance <= 15 && !obstacleDetected) {
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,16
	BRSH _0x3B
	TST  R4
	BREQ _0x3C
_0x3B:
	RJMP _0x3A
_0x3C:
; 0000 0162 obstacleDetected = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0163 USART0_SendFlashString(msg_obstacle_detected);
	LDI  R26,LOW(_msg_obstacle_detected*2)
	LDI  R27,HIGH(_msg_obstacle_detected*2)
	RJMP _0x44
; 0000 0164 } else if (distance > 15 && obstacleDetected) {
_0x3A:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,16
	BRLO _0x3F
	TST  R4
	BRNE _0x40
_0x3F:
	RJMP _0x3E
_0x40:
; 0000 0165 obstacleDetected = 0;
	CLR  R4
; 0000 0166 USART0_SendFlashString(msg_obstacle_cleared);
	LDI  R26,LOW(_msg_obstacle_cleared*2)
	LDI  R27,HIGH(_msg_obstacle_cleared*2)
_0x44:
	RCALL _USART0_SendFlashString
; 0000 0167 }
; 0000 0168 }
_0x3E:
; 0000 0169 
; 0000 016A 
; 0000 016B 
; 0000 016C 
; 0000 016D }
_0x39:
	ADIW R28,2
	RJMP _0x1E
; 0000 016E }
_0x41:
	RJMP _0x41
; .FEND

	.DSEG
_0x22:
	.BYTE 0xE
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	ADIW R28,5
	RET
; .FEND
_strchr:
; .FSTART _strchr
	ST   -Y,R26
    ld   r26,y+
    ld   r30,y+
    ld   r31,y+
strchr0:
    ld   r27,z
    cp   r26,r27
    breq strchr1
    adiw r30,1
    tst  r27
    brne strchr0
    clr  r30
    clr  r31
strchr1:
    ret
; .FEND
_strcmpf:
; .FSTART _strcmpf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmpf0:
    ld   r1,x+
	lpm  r0,z+
    cp   r0,r1
    brne strcmpf1
    tst  r0
    brne strcmpf0
strcmpf3:
    clr  r30
    ret
strcmpf1:
    sub  r1,r0
    breq strcmpf3
    ldi  r30,1
    brcc strcmpf2
    subi r30,2
strcmpf2:
    ret
; .FEND

	.CSEG

	.DSEG
_total_count:
	.BYTE 0x2
_receivedString:
	.BYTE 0x14

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(90)
	OUT  0x31,R30
	CBI  0x18,5
	SBI  0x18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(90)
	OUT  0x31,R30
	SBI  0x18,5
	CBI  0x18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
	RCALL _Stop
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(_receivedString)
	LDI  R31,HIGH(_receivedString)
	ST   -Y,R31
	ST   -Y,R30
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	MOVW R22,R30
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	MOVW R20,R18
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
