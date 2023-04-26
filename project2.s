; Read the text from a file called "input.txt" as a string of characters
; Uppercase every vowel
; Replace all punctuation and symbols with an asterisk (*)
; Output the new string from memory to a file called "output.txt"

;SWI_Open,	0x66    @ open a file
;SWI_Close,	0x68    @ close a file
;SWI_PrStr,	0x69    @ Write a null-ending string 
;SWI_RdStr,	0x6a    @ read a string from file
;SWI_PrInt,	0x6b    @ Write an Integer
;Stdout, 	1       @ Set output target to be Stdout
;SWI_Exit,	0x11    @ Stop execution

.global _start

_start:
	
	;OPEN FILE FOR INPUT
	ldr r0, =TextFile
	mov r1, #0 			
	swi 0x66 				;open file
	bcs Exit
	ldr r1,=TextFileHandle 
	str r0,[r1]

	;OPEN FILE FOR OUTPUT
	ldr r0, =OutputFile
	mov r1, #1 			
	swi 0x66 				;open file
	bcs Exit
	ldr r1,=OutFileHandle 
	str r0,[r1]

	;READS STRING FROM FILE TO CONSOLE
	ldr r4,=TextFileHandle
	ldr r0,[r4] 			
	ldr r1,=MyString		;r1 set to location in memory for string to be copied
	mov r2,#1000 			;r2 set to max # of characters to be read

	swi 0x6a 				;r0, r1, and r2 is set -> read string
	bcs Exit

	;PRINT STRING FROM FILE TO STDOUT
	mov r0, #1 				;file handle 1 is standard output
	ldr r1, =Message1
	swi 0x69
	ldr r1, =MyString		;r1 set to location in memory for string to be printed
	swi 0x69 				;r0 and r1 is set -> print string to file
	bcs Exit

	mov r5, r1				;copy # of characters into r5

	;LOOP(S) TO NAVIGATE THROUGH STRING
	Loop: 		
							;TODO lowercase to uppercase vowel
	ldrb r7, [r1]			;load first character into r7

	cmp r7, #0 				;if character count reaches zero or end of string, exit loop #1
	beq Break

	cmp r7, #'a'			;compare character with a lowercase vowel
	subeq r7, r7, #32		;character is replaced from lowercase to uppercase
			
	cmp r7, #'e'
	subeq r7, r7, #32				
			
	cmp r7, #'i'
	subeq r7, r7, #32		
					
	cmp r7, #'o'
	subeq r7, r7, #32		
				
	cmp r7, #'u'
	subeq r7, r7, #32

	strb r7, [r1]			;Store modified string into memory
	add r1, r1, #1 			;if not a lowercase vowel and is a consonant or number, ignore and move to the next
							;character
	b Loop

	Break:
	ldr r1, =MyString

	Loop2:
							;TODO punctuation to asterix '*'
	ldrb r7, [r1]			;load first character from the modified string into r7

	cmp r7, #0 				;if character count reaches zero, exit loop
	beq Done

	cmp r7, #'!'			;compare character with a symbol
	moveq r7, #'*'			;if character is designated symbol, replace with an asterisk

	cmp r7, #'"'
	moveq r7, #'*'

	cmp r7, #'#'
	moveq r7, #'*'

	cmp r7, #'$'
	moveq r7, #'*'
	
	cmp r7, #'%'
	moveq r7, #'*'
	
	cmp r7, #'&'
	moveq r7, #'*'
	
	cmp r7, #39
	moveq r7, #'*'
	
	cmp r7, #'('
	moveq r7, #'*'
	
	cmp r7, #')'
	moveq r7, #'*'
	
	cmp r7, #'+'
	moveq r7, #'*'
	
	cmp r7, #','
	moveq r7, #'*'
	
	cmp r7, #'-'
	moveq r7, #'*'
	
	cmp r7, #'.'
	moveq r7, #'*'
	
	cmp r7, #'/'
	moveq r7, #'*'

	cmp r7, #':'
	moveq r7, #'*'

	cmp r7, #';'
	moveq r7, #'*'

	cmp r7, #'<'
	moveq r7, #'*'

	cmp r7, #'='
	moveq r7, #'*'

	cmp r7, #'>'
	moveq r7, #'*'

	cmp r7, #'?'
	moveq r7, #'*'

	cmp r7, #'@'
	moveq r7, #'*'

	cmp r7, #'['
	moveq r7, #'*'

	cmp r7, #'\'
	moveq r7, #'*'

	cmp r7, #']'
	moveq r7, #'*'

	cmp r7, #'^'
	moveq r7, #'*'

	cmp r7, #'_'
	moveq r7, #'*'

	cmp r7, #'`'
	moveq r7, #'*'

	cmp r7, #'{'
	moveq r7, #'*'

	cmp r7, #'|'
	moveq r7, #'*'

	cmp r7, #'}'
	moveq r7, #'*'

	cmp r7, #'~'
	moveq r7, #'*'

	strb r7, [r1]			;Store modified string into memory
	add r1, r1, #1 			;if not a symbol, ignore and move to the next
							;character
	b Loop2


	Done:
	mov r0, #1

	ldr r0, =OutFileHandle
	ldr r0, [r0]
	ldr r1, =MyString		;r1 set to location in memory for revised string to be printed to new file
	swi 0x69 				;r0 and r1 is set -> print REVISED string to output file
	bcs Exit

	ldr r0, =OutFileHandle
	ldr r0, [r0]
	ldr r1, =Message2		
	swi 0x69 				
	bcs Exit

	CloseFile:
	ldr r0, =TextFile
	ldr r0, [r0]
	swi 0x68				;close input file

	ldr r0, =OutFileHandle
	ldr r0,[r0]
	swi 0x68				;close output file

	Exit:
	swi 0x11

	FileEmpty:
	mov r0, #1
	ldr r1, =TextFileError
	swi 0x69
	b CloseFile


	.data
	OutFileHandle: .skip 4
	TextFileHandle: .skip 4 ; file handle is an integer

	OutputFile: .asciz "output.txt"
	TextFile: .asciz "input.txt"

	OutFileError: .asciz "Unable to open output file\n"
	TextFileError: .asciz "Error. File incomplete or unreadable. Terminating program."
	FileNotFound: .asciz "Error. File not found. Terminating program."

	MyString: .skip 1000 ;allocate room for 50 characters ;a string is treated like an array of characters
	MyInteger: .skip 4
	
	NewLine: .asciz "\n"
	Message1: .asciz "Original input: "
	Message2: .asciz "\nRevised output: "

