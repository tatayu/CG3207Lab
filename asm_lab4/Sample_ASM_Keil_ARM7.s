;----------------------------------------------------------------------------------
;--	License terms :
;--	You are free to use this code as long as you
;--		(i) DO NOT post it on any public repository;
;--		(ii) use it only for educational purposes;
;--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
;--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
;--		(v) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
;--		(vi) retain this notice in this file or any files derived from this.
;----------------------------------------------------------------------------------

	AREA    MYCODE, CODE, READONLY, ALIGN=9 
   	  ENTRY
	  
; ------- <code memory (ROM mapped to Instruction Memory) begins>
; Total number of instructions should not exceed 127 (126 excluding the last line 'halt B halt').
			
		LDR R1, DIPS ; Load the address of DIPS to R1 C04
		LDR R2, LEDS ; Load the address of LEDS to R2  C00
		LDR R3, SEVEN_SEG ; Load the address of SEVEN_SEG to R3 C18
		
		LDR R7, constant1 ; 0100 0001
		LDR R8, constant2 ; 1100 1001
		LDR R9, constant3 ; 0
		LDR R12, constant4 ; 7FFFFFFF
		LDR R13, constant5 ; FFFFFFFF
		LDR R14, constant6 ; 1100 (C)
		
		LDR R10, [R2, R7, LSR #4] ;LOAD DIPS
		
		EOR R10, R7, R8 ;0x00000088
		STR R10, [R2]
		STR R10, [R3]

		RSB R10, R7, R8 ;0x00000088
		STR R10, [R2]
		STR R10, [R3]
		
		TST R7, R8, LSR #2 ; Z=1 (0100 0001 & 0011 0010)
		
		TEQEQ R7, R8 ; Z=0 (1000 1000)
		
		MOV R10, #0xFF0 ; FF0(255)
		STR R10, [R2]
		STR R10, [R3]
		
		MVN R10, R7 ; 1011 1110 (FFFFFFBE)
		STR R10, [R2]
		STR R10, [R3]

		BICS R10, R8, R8, LSR #4 ; C=1, 1100 0001 (000000C1)
		STR R10, [R2]
		STR R10, [R3]
		
		SBC R10, R8, R7 ; 1000 0111 (00000088)
		STR R10, [R2]
		STR R10, [R3]
		
		ADCS R10, R7, R8, LSL R14 ; C=0 1100 1101 0010 (000C9042)
		STR R10, [R2]
		STR R10, [R3]
		
		RSC R10, R7, R8 ;1000 0111 (00000087)
		STR R10, [R2]
		STR R10, [R3]
		
		MULS R10, R7, R9 ; Z=1, 0
		STR R10, [R2]
		STR R10, [R3]
		
		SMULLEQ R10, R11, R12, R13 ;R10 = 80000001, R11 = FFFFFFFFF
		STR R10, [R2]
		STR R10, [R3]
		STR R11, [R2]
		STR R11, [R3]
		
		UMULL R10, R11, R12, R13 ;R10 = 800000001, R11 = 7FFFFFFE
		STR R10, [R2]
		STR R10, [R3]
		STR R11, [R2]
		STR R11, [R3]
		
		STR R7, [R2, R14, LSL #1] ;R14 = 1001 (9) Store R7 to [R3](41)
		SWP R10, R8, [R3] ; LDR R10(41), [R3], STR R8(C9), [R3] (7-seg show R8)
		STR R10, [R2]
		STR R10, [R3]
	
LOOP_ANDS
		LDR R4, [R1] ; Load the value of DIPS 1010 (A)
		STR R4, [R1, #-4] ; Store the value of R4 into LEDS
		STR R4, [R1, #20] ; Store the value of R4 into SEVEN_SEG
		
		LDR R5, DELAY_VAL ; Load the delay value to R5 (2)
		STR R5, [R2] ; Store the value of R5 into LEDS
		STR R5, [R3] ; Store the value of R5 into SEVEN_SEG
		
		MUL R10, R4, R5; 10x2 = 20 (14)
		STR R10, [R2] ; Store the value of R10 into LEDS
		STR R10, [R3] ; Store the value of R10 into SEVEN_SEG
		
		MLA R10, R4, R5, R5; 10/2 = 5
		STR R10, [R2] ; Store the value of R10 into LEDS
		STR R10, [R3] ; Store the value of R10 into SEVEN_SEG
		
		ADD R4, R4, R5 ; R4 + R5 1100 (12) (C)
		STR R4, [R2] ; Store the value of R4 into LEDS
		STR R4, [R3] ; Store the value of R4 into SEVEN_SEG
		
		ORR R4, R4, R5 ; R4 | R5 1110 (14) (E)
		STR R4, [R2] ; Store the value of R4 into LEDS
		STR R4, [R3] ; Store the value of R4 into SEVEN_SEG
		
		ADD R6, R5, R4, LSR #2 ; R6 = 2 + 3 (1110 >> 2) (5)
		STR R6, [R2] ; Store the value of R6 into LEDS
		STR R6, [R3] ; Store the value of R6 into SEVEN_SEG
		
LOOP_SUBS
		SUBS R5, R5, #1 ; Decrease the dalay counter by 1 (1) (0)
		STR R5, [R2] ; Store the value of R5 into LEDS
		STR R5, [R3] ; Store the value of R5 into SEVEN_SEG
		BNE LOOP_SUBS
		
		LDR R5, DELAY_VAL ; Load the delay value to R5 (2)
		STR R5, [R2] ; Store the value of R5 into LEDS
		STR R5, [R3] ; Store the value of R5 into SEVEN_SEG
		
		CMP R5, #2 ; R5 unchanged (2)
		STR R5, [R2] ; Store the value of R5 into LEDS
		STR R5, [R3] ; Store the value of R5 into SEVEN_SEG
		
		SUBSEQ R5, R5, #2 ; R5 = 2 - 2 (0)
		STR R5, [R2] ; Store the value of R5 into LEDS
		STR R5, [R3] ; Store the value of R5 into SEVEN_SEG
		
		ORREQ R5, R5, #2 ; R5 = 00|10 (2)
		STR R5, [R2] ; Store the value of R5 into LEDS
		STR R5, [R3] ; Store the value of R5 into SEVEN_SEG
		
		CMN R5, #-2 ; R5 unchanged (2)
		ANDSEQ R5, R5, #0 ; R5 = 10&00 (0)
		STR R5, [R2] ; Store the value of R5 into LEDS
		STR R5, [R3] ; Store the value of R5 into SEVEN_SEG
		BEQ LOOP_ANDS
		
halt	
		B    halt           ; infinite loop to halt computation. // A program should not "terminate" without an operating system to return control to
							; keep halt	B halt as the last line of your code.
; ------- <\code memory (ROM mapped to Instruction Memory) ends>


	AREA    CONSTANTS, DATA, READONLY, ALIGN=9 
; ------- <constant memory (ROM mapped to Data Memory) begins>
; All constants should be declared in this section. This section is read only (Only LDR, no STR).
; Total number of constants should not exceed 128 (124 excluding the 4 used for peripheral pointers).
; If a variable is accessed multiple times, it is better to store the address in a register and use it rather than load it repeatedly.

;Peripheral pointers
LEDS
		DCD 0x00000C00		; Address of LEDs. //volatile unsigned int * const LEDS = (unsigned int*)0x00000C00;  
DIPS
		DCD 0x00000C04		; Address of DIP switches. //volatile unsigned int * const DIPS = (unsigned int*)0x00000C04;
PBS
		DCD 0x00000C08		; Address of Push Buttons. Used only in Lab 2
UART
		DCD 0x00000C0C		; Address of UART. Used only in Lab 2
SEVEN_SEG
		DCD 0x00000C18      ; Address of Seven segment

; Rest of the constants should be declared below.
DELAY_VAL   
		DCD  0x2			; The number of steps of delay // const unsigned int DELAY_VAL = 4;
variable1_addr
		DCD variable1		; address of variable1. Required since we are avoiding pseudo-instructions // unsigned int * const variable1_addr = &variable1;
variable2_addr
		DCD variable2
constant1
		DCD 0x00000041		; // const unsigned int constant1 = 0xABCD1234;
constant2
		DCD 0x000000C9
constant3
		DCD 0x00000000
constant4
		DCD 0x7FFFFFFF
constant5
		DCD 0xFFFFFFFF
constant6
		DCD 0x0000000C

string1   
		DCB  "Hello World!!!!",0	; // unsigned char string1[] = "Hello World!"; // assembler will issue a warning if the string size is not a multiple of 4, but the warning is safe to ignore
		
; ------- <constant memory (ROM mapped to Data Memory) ends>	


	AREA   VARIABLES, DATA, READWRITE, ALIGN=9
; ------- <variable memory (RAM mapped to Data Memory) begins>
; All variables should be declared in this section. This section is read-write.
; Total number of variables should not exceed 128. 
; No initialization possible in this region. In other words, you should write to a location before you can read from it (i.e., write to a location using STR before reading using LDR).

variable1
		DCD 0x00000800		;  // unsigned int variable1;

variable2
		DCD 0x00000804
		
; ------- <variable memory (RAM mapped to Data Memory) ends>	

		END	
		
;const int* x;         // x is a non-constant pointer to constant data
;int const* x;         // x is a non-constant pointer to constant data 
;int*const x;          // x is a constant pointer to non-constant data
		