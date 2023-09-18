.data
	result:        .word	0
	input_buffer:  .word	0
	
	start_stack:  .byte	0
	
	str_begin:   .asciiz 	"\nHello, this is a simple Polish calculator.\n"
	str_input:   .asciiz	"\nenter integer or operation (+, -): "
	print_char:  .asciiz	"p"
	add_char:    .asciiz	"+"
	sub_char:    .asciiz	"-"
	str_end:     .asciiz	"\nHere is the result: "
	custom_text: .asciiz"\nyou entered an integer"

.text 
	li $t0, 20
	li $t1, 3
	la $t0, ($sp)
	sw $t0, start_stack
		
	# printing presentation
	pres:
		la $a0, str_begin
		li $v0, 4
		syscall
		
	# asking for input
	ask_input:
		la $a0, str_input
		li $v0, 4
		syscall
	
	# reading input
	read_input:
		# read user input
		la $a0, input_buffer
		li $a1, 3
		li $v0, 8
		syscall

		#check if input == p
		la $t0, input_buffer
		lb $t1, ($t0)
		la $t2, print_char
		lb $t2, ($t2)
		beq $t1, $t2, end
		
		# if not p, check if operation (TODO: add substraction)
		la $t2, add_char
		lb $t2, ($t2)
		beq $t1, $t2, end
		
		# if not operation, then stack the number
		lw $t1, ($t0)
		sw $t1, ($sp)
		sub $sp, $sp, 4
		j custom
		#j read_input
		
	# for test purposes
	custom:	
		la $a0, custom_text
		li $v0, 8
		syscall
		j end
		
	addition:
		# add every stack element to result
		lw $t0, start_stack
		beq $sp, $t0, end # if stack empty
		lw $t0, ($sp)
		sub $sp, $sp, 4
		lw $t1, result
		add $t1, $t1, $t0
		sw $t1, result
		
	end:
		# print end message
		la $a0, str_end
		li $v0, 4
		syscall
		# print result
		lw $a0, result
		li $v0, 1
		syscall
