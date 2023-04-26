;.the first integer value x (R4)
;the second integer value y (R5)
;the number of integers less than or equal to x (R6)
;the number of occurences of y (R7)
;the total number of integers (R8)

.global _start

start:

	ldr r0, =MyInputFile
	mov r1, #0
	swi 0x66 				;open file
	bcs FileEmpty

	mov r3, r0				;save file handle

	swi 0x6c				;read integer x
	bcs FileEmpty

	mov r4, r0				;save first integer
	mov r6, #1				;set the number of integers less than or equal to x = 1

	mov r0, r3
	swi 0x6c				;read integer y
	bcs FileEmpty

	mov r5, r0				;save second integer
	mov r7, #1				;set the number of occurences of y = 1

	cmp r5, r4
	addle r6, r6, #1
	addeq r7, r7, #1

	mov r8, #2				;set number of total integers = 1

	Loop:
	mov r0, r3
	swi 0x6c				;read integer
	bcs Done

	cmp r0, r4
	addle r6, r6, #1 		;add one if current integer is less than or equal to x

	cmp r0, r5
	addeq r7, r7, #1 		;add one if current integer is the same as y

	add r8, r8, #1 			;add one to total number of integers
	bal Loop

	Done:
	mov r0, #1 				;printing results to standard output

	ldr r1, =Message1
	swi 0x69				;print string
	mov r1, r4
	swi 0x6b				;print integer x

	ldr r1, =Message2
	swi 0x69				;print string
	mov r1, r5
	swi 0x6b				;print integer y

	ldr r1, =Message3
	swi 0x69				;print string
	mov r1, r6
	swi 0x6b				;print number of integers less than or equal to x

	ldr r1, =Message4
	swi 0x69				;print string
	mov r1, r7
	swi 0x6b				;print number of occurences of y

	ldr r1, =Message5
	swi 0x69				;print string
	mov r1, r8
	swi 0x6b				;print total number of integers

	CloseFile:
	ldr r0, =MyInputFile
	ldr r0, [r0]
	swi 0x68				;close file

	Exit:
	swi 0x11

	FileEmpty:
	mov r0, #1
	ldr r1, =FileEmptyError
	swi 0x69				;print string
	b CloseFile


	.data
	MyInputFile: .asciz "integers.dat"
	NewLine: .asciz	"\n"

	Message1: .asciz "First integer in file: "
	Message2: .asciz "\nSecond integer in file: "
	Message3: .asciz "\nNumber of integers less than or equal to first integer: "
	Message4: .asciz "\nNumber of occurences of second integer: "
	Message5: .asciz "\nTotal number of integers in file: "

	FileNotFound: .asciz "Error, File not found. Terminating program."
	FileEmptyError: .asciz "Error. Not enough integers found in file. Terminating program."
