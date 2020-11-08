     AREA     factorial, CODE, READONLY
     EXPORT __main
     IMPORT printMsg1
     IMPORT printMsg2
	 IMPORT printMsg3
	 IMPORT printMsg4
	 IMPORT printMsg5
	 IMPORT printMsg6
	 IMPORT printMsg7
     IMPORT printMsg4p		 
     ENTRY 
__main    FUNCTION
	MOV R4,#1; Counting Variable 'i'	
    MOV R5,#25; Holding the Number of Terms in Series 'n'
        
				
	VLDR.F32 S0,=1 ; Used to store the final sum of the exponent(e^x)  
	VLDR.F32 S1,=1; Temp variable to store intermediate multiplication result
	VLDR.F32 S6,=1; Temp variable to store the result of the factorial
	
	VLDR.F32 S4,=1; Storing constant 1 in reg s4
	VLDR.F32 S25,=0.5; Value to compare for deciding logic value 0 or 1 

; Registers S7 to S10 will hold weights and bias value

AND_logic	BL printMsg1
	VLDR.F32 S7,=-0.1  ;Initializing values as per the data given in python file
	VLDR.F32 S8,=0.2
	VLDR.F32 S9,=0.2
	VLDR.F32 S10,=-0.2
	B compute
		
OR_logic	BL printMsg2
	VLDR.F32 S7,=-0.1  ;Initializing values as per the data given in python file
	VLDR.F32 S8,=0.7
	VLDR.F32 S9,=0.7
	VLDR.F32 S10,=-0.1
	B compute
		
NOT_logic	BL printMsg3
	VLDR.F32 S7,=0.5  ;Initializing values as per the data given in python file
	VLDR.F32 S8,=-0.7
	VLDR.F32 S9,=0
	VLDR.F32 S10,=0.1
	B compute
		
NAND_logic	BL printMsg4
	VLDR.F32 S7,=0.6  ;Initializing values as per the data given in python file
	VLDR.F32 S8,=-0.8
	VLDR.F32 S9,=-0.8
	VLDR.F32 S10,=0.3
	B compute
		
NOR_logic	BL printMsg5
	VLDR.F32 S7,=0.5  ;Initializing values as per the data given in python file
	VLDR.F32 S8,=-0.7
	VLDR.F32 S9,=-0.7
	VLDR.F32 S10,=0.1
	B compute


		
compute	BL Data_Set1

Data_Set1	MOV R0, #1; input A
			VMOV.F32 S16,R0
			VCVT.F32.S32 S16,S16; converting input A to signed fp number
			
			MOV R1, #0; input B
			VMOV.F32 S17, R1
			VCVT.F32.S32 S17,S17; converting input B to signed fp number
			
			MOV R2, #0; input C
			VMOV.F32 S18,R2
			VCVT.F32.S32 S18,S18; converting input C to signed fp number
			B WEIGHT_CALCULATION
			
Data_Set2	MOV R0, #1; input A 
			VMOV.F32 S16,R0
			VCVT.F32.S32 S16,S16; converting input A to signed fp number
			MOV R1, #0; input B
			VMOV.F32 S17, R1
			VCVT.F32.S32 S17,S17; converting input B to signed fp number
			MOV R2, #1; input C
			VMOV.F32 S18,R2
			VCVT.F32.S32 S18,S18; converting input C to signed fp number
			B WEIGHT_CALCULATION
			
Data_Set3	MOV R0, #1; input A
			VMOV.F32 S16,R0
			VCVT.F32.S32 S16,S16; converting input A to signed fp number
			MOV R1, #1; input B 
			VMOV.F32 S17, R1
			VCVT.F32.S32 S17,S17; converting input B to signed fp number
			MOV R2, #0; input C
			VMOV.F32 S18,R2
			VCVT.F32.S32 S18,S18; converting input C to signed fp number
			B WEIGHT_CALCULATION
			
Data_Set4	MOV R0, #1; input A
			VMOV.F32 S16,R0
			VCVT.F32.S32 S16,S16; converting input A to signed fp number
			MOV R1, #1; input B
			VMOV.F32 S17, R1
			VCVT.F32.S32 S17,S17; converting input B to signed fp number
			MOV R2, #1; input C
			VMOV.F32 S18,R2
			VCVT.F32.S32 S18,S18; converting input C to signed fp number
			B WEIGHT_CALCULATION

WEIGHT_CALCULATION	VMUL.F32 S19,S7,S16;
					VMOV.F32 S22,S19
					VMUL.F32 S20,S8,S17
					VADD.F32 S22, S22, S20
					VMUL.F32 S21,S9,S18
					VADD.F32 S22, S22, S21
					VADD.F32 S22, S22, S10; Final value is computed and stored in S22		
					B exp
				
exp   CMP R4,R5; 	Compare values of 'i' and 'n' 
      BLE loop; 	if i < n goto loop
      B sigmoid_func; if i >= n, then goto sigmoid function
		
loop  VMUL.F32 S1,S1,S22; temp = temp*x
	  VMOV.F32 S3,S1;
      VMOV.F32 S5,R4
      VCVT.F32.S32 S5, S5;	Converting bitstream into floating point number
		
	VMUL.F32 S6,S6,S5;	Computing factorial and storing the result in S6
    VDIV.F32 S3,S3,S6
    VADD.F32 S0,S0,S3;	Final result of exp series is stored in S0
		
    ADD R4,R4,#1;	Increment the counter value by 1
    B exp

sigmoid_func 
	VADD.F32 S14,S4,S0 ;	Calculating (1 + e^x)
	VDIV.F32 S15,S0,S14;	Calculating value of sigmoid (e^x/(1+e^x))
	VCMP.F32 S15,S25;	Comparing the result of sigmoid function with 0.5
	VMRS.F32 APSR_NZCV, FPSCR
	ITE HI
	MOVHI R3,#1
	MOVLS R3,#0
	BL printMsg4p
	
	; Need to initialize the below four values as the data set will be changed four times for each LOGIC GATE 
	
	MOV R4,#1
	VLDR.F32 S0,=1 ; Used to store the final sum of the exponent(e^x)  
	VLDR.F32 S1,=1; Temp variable to store intermediate multiplication result
	VLDR.F32 S6,=1; Temp variable to store the result of the factorial

	;Iterations for further three sets of inputs
	ADD R9, R9,#1
	CMP R9,#1
	BEQ Data_Set2
	CMP R9,#2
	BEQ Data_Set3
	CMP R9,#3
	BEQ Data_Set4
	MOV R9,#0
	ADD R10, R10,#1
	
	;Iterations for LOGIC GATES
	CMP R10,#1	;Go to logic OR 
	BEQ OR_logic

	CMP R10,#2	;Go to logic NOT 
	BEQ NOT_logic

	CMP R10,#3	;Go to logic NAND 
	BEQ NAND_logic

	CMP R10,#4	;Go to logic NOR 
	BEQ NOR_logic
	

	B stop
		
stop    B stop
        ENDFUNC
        END