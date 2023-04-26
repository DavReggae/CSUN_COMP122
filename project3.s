@ PROJECT 3 @
;Establish byte values of 8-Segment Display
.equ SEG_A,	0x80
.equ SEG_B,	0x40
.equ SEG_C,	0x20
.equ SEG_D,	0x08
.equ SEG_E,	0x04
.equ SEG_F,	0x02
.equ SEG_G,	0x01
.equ SEG_P,	0x10 

;Establish 0-9 Digits of 8-Segment Display
.equ ONE,	SEG_B|SEG_C
.equ TWO,	SEG_A|SEG_B|SEG_F|SEG_E|SEG_D
.equ THREE,	SEG_A|SEG_B|SEG_F|SEG_C|SEG_D
.equ FOUR,	SEG_G|SEG_F|SEG_B|SEG_C
.equ FIVE,	SEG_A|SEG_G|SEG_F|SEG_C|SEG_D 
.equ SIX,  	0x80|0x01|0x02|0x04|0x08|0x20
.equ SEVEN,	SEG_A|SEG_B|SEG_C
.equ EIGHT,	SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G
.equ NINE,	SEG_A|SEG_B|SEG_F|SEG_G|SEG_C
.equ ZERO, 	SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G

;Establish letter 'E' for 'Error' on any unassigned button pressed 
.equ E, 	0x80|0x01|0x02|0x04|0x08

;Establish blank display
.equ BLANK, 0

;LCD Screen is "refreshed"
swi 0x206

mov r0,#BLANK 
swi 0x200 		;Gives a blank display

mov r0,#4
mov r1,#3
ldr r2,=myString2
swi 0x204 		;this will print "Welcome to my Project #3" starting at row 3, column 5
mov r0,#4
mov r1,#4
ldr r2,=myString4
swi 0x204
mov r0,#4
mov r1,#5
ldr r2,=myString5
swi 0x204

mov r0,#4
mov r1,#2
mov r2,#1024
swi 0x205 		;this will print "1024" starting at row 2, column 5

mov r0, #0x01
swi 0x201 		;left LED is lit

mov r0, #0x02
swi 0x201 		;right LED is lit

mov r0, #0x03
swi 0x201 		;both LEDs are lit

LoopButtonPress:
swi 0x203 		;Check to see if any blue button is pressed

cmp r0,#0x0001 	;Position '0'
beq Display7
cmp r0,#0x0002
beq Display8
cmp r0,#0x0004
beq Display9 
cmp r0,#0x0008 
beq DisplayE 

cmp r0,#0x0010 	;Position '4'
beq Display4
cmp r0,#0x0020
beq Display5
cmp r0,#0x0040
beq Display6 
cmp r0,#0x0080
beq DisplayE

cmp r0,#0x0100 	;Position '8'
beq Display1 
cmp r0,#0x0200
beq Display2
cmp r0,#0x0400
beq Display3 
cmp r0,#0x0800
beq DisplayE

cmp r0,#0x1000 	;Position '12'
beq DisplayE 
cmp r0,#0x2000
beq Display0 
cmp r0,#0x4000
beq DisplayE 
cmp r0,#0x8000
beq DisplayE 

swi 0x202		;Check to see if either black button is pressed

cmp r0,#0x02 	;Check for left button
beq DisplayBlank
cmp r0,#0x01 	;Check for right button
beq DisplayBlank

cmp r2, #0
movle r2,#0
ble Done

b LoopButtonPress

Done:
mov r0,#2
swi 0x208	;Clear LCD value
mov r0,#4
mov r1,#2
mov r2,#0
swi 0x205	;LCD will display and remain to be 0

mov r0,#BLANK
swi 0x200
mov r0,#4
mov r1,#3
ldr r2,=myString3
swi 0x204

b DisplayBlank2

;Displays a blank 8-Segment Display and restarts LCD integer value
DisplayBlank: 
swi 0x206
mov r0,#BLANK 
swi 0x200 		 
mov r0,#2
swi 0x208
mov r0,#4
mov r1,#3
ldr r2,=myString2
swi 0x204
mov r0,#4
mov r1,#4
ldr r2,=myString4
swi 0x204
mov r0,#4
mov r1,#5
ldr r2,=myString5
swi 0x204
mov r0,#4
mov r1,#2
mov r2,#1024
swi 0x205 		;LCD restarts integer value count
b LoopButtonPress

;If decimal value is <=0, blank display on 8-Segment will occur until a black button is pressed
;Otherwise, LCD value will remain as 0
DisplayBlank2:
swi 0x202		
cmp r0,#0x02 	
beq DisplayBlank
cmp r0,#0x01 	
beq DisplayBlank

b DisplayBlank2

;Display0-9 will display 0-9 on 8-Segment display and subtract corresponding value from LCD integer value
Display1:
mov r0,#ONE 	
swi 0x200 		;8-Segment displays '1'
mov r0, #2
swi 0x208		;Clears LCD integer value every time it is updated
mov r0,#4
mov r1,#2
sub r2, r2, #1 	;Subtract '1' from LCD integer value
swi 0x205 		;Prints updated LCD value
b LoopButtonPress

Display2:
mov r0,#TWO 
swi 0x200
mov r0,#2
swi 0x208
mov r0,#4
mov r1,#2
sub r2, r2, #2
swi 0x205
b LoopButtonPress

Display3:
mov r0,#THREE 
swi 0x200
mov r0,#2
swi 0x208
mov r0,#4
mov r1,#2
sub r2, r2, #3
swi 0x205
b LoopButtonPress

Display4:
mov r0,#FOUR
swi 0x200
mov r0,#2
swi 0x208
mov r0,#4
mov r1,#2
sub r2, r2, #4
swi 0x205
b LoopButtonPress

Display5:
mov r0,#FIVE
swi 0x200
mov r0,#2
swi 0x208
mov r0,#4
mov r1,#2
sub r2, r2, #5
swi 0x205
b LoopButtonPress

Display6:
mov r0,#SIX 
swi 0x200
mov r0,#2
swi 0x208
mov r0,#4
mov r1,#2
sub r2, r2, #6
swi 0x205
b LoopButtonPress

Display7:
mov r0,#SEVEN 
swi 0x200
mov r0,#2
swi 0x208
mov r0,#4
mov r1,#2
sub r2, r2, #7
swi 0x205
b LoopButtonPress

Display8:
mov r0,#EIGHT 
swi 0x200
mov r0,#2
swi 0x208
mov r0,#4
mov r1,#2
sub r2, r2, #8
swi 0x205
b LoopButtonPress

Display9:
mov r0,#NINE 
swi 0x200
mov r0,#2
swi 0x208
mov r0,#4
mov r1,#2
sub r2, r2, #9
swi 0x205
b LoopButtonPress

Display0:
mov r0,#ZERO 
swi 0x200
b LoopButtonPress

;Displays 'E' on 8-Segment Display if any blue button other than 0-9 is pressed
DisplayE:
mov r0,#E 
swi 0x200
b LoopButtonPress

myString2: 	.asciz "Hello, welcome to my Project #3!"
myString3: 	.asciz "Thank you for visiting my Project #3!"
myString4: 	.asciz "To reset, please press one of the"
myString5:  .asciz "black buttons."