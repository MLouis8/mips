	.data
input_buffer: .space 45
str_begin:   .asciiz 	"\nHello, this is a simple Polish calculator.\n"
str_input:   .asciiz	"\nenter integer or operation (+): "
print_char:  .asciiz	'p'
add_char:    .asciiz	'+'
sub_char:    .asciiz	'-'
str_end:     .asciiz	"\nHere is the result: "
custom_text: .asciiz	"\nyou entered an integer"

	.text
	#- $t0 pour le res
	#- $t1 pour l'adresse du string
	#- $t2 le cpt pour savoir si string fini
	#- $t3 l'adresse du debut de la stack
	#- $t4-$t7 pour load des bits et effectuer calculs depuis 
	
	li $t0, 0
	la $t3, 0($sp)
		
	# printing presentation
pres:
	la $a0, str_begin
	li $v0, 4
	syscall
		
	# asking for input then save it
input:
	la $a0, str_input
	li $v0, 4
	syscall

	la $a0, input_buffer
	li $a1, 3
	li $v0, 8
	syscall
	la $t1, input_buffer #load input adress in reg $t1
	li $t2, 0 #start cpt
	
load_char:
	lb $t4, ($t1)
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	
	#check if string is done (TODO: change 40)
	beq $t2, 40, input

	#check if input == p
	la $t5, print_char
	lb $t5, ($t5)
	beq $t4, $t5, end
		
	# if not p, check if add
	la $t5, add_char
	lb $t5, ($t5)
	beq $t4, $t5, addition
		
	# if not add, then transform to int and stack the number
	# TODO: transform to int
	sw $t4, ($sp)
	sub $sp, $sp, 4
	j load_char
		
addition:
	# add every stack element to result
	beq $sp, $t3, end #if stack empty: stop
	lw $t4, ($sp)
	addi $sp, $sp, 4
	add $t0, $t4, $t0
	j addition
	
end:
	# print end message
	la $a0, str_end
	li $v0, 4
	syscall
	# print result
	move $a0, $t0
	li $v0, 1
	syscall
