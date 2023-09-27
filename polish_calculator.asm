	.data
input_buffer: .space 11
str_begin:   .asciiz 	"\nHello, this is a simple Polish calculator.\n"
str_input:   .asciiz	"\nenter integer or operation (+, *): "
print_char:  .asciiz	"p"
add_char:    .asciiz	"+"
space_char:  .asciiz	" "
mul_char:    .asciiz    "*"
str_end:     .asciiz	"\nHere is the result: "
custom_text: .asciiz	"\nyou entered an integer"

	.text
	#- $t0 pour le res
	#- $t1 pour l'adresse du string
	#- $t2 le cpt pour savoir si string fini
	#- $t3 l'adresse du debut de la stack
	#- $t4 pour charger des octets depuis le string
	#  $t5-$t7 pour load des bits et effectuer calculs depuis 
	
	li $t0, 0
	la $t3, ($sp)
	addi $t3, $t3, 4 # move pointer up for comparison
		
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
	li $a1, 11
	li $v0, 8
	syscall
	la $t1, input_buffer #load input adress in reg $t1
	li $t2, 0 #start cpt
	
load_char:
	lb $t4, ($t1)
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	
	# check if string is done
	beq $t2, 10, input

	# check if input == p
	la $t5, print_char
	lb $t5, ($t5)
	beq $t4, $t5, end
		
	# check if input == +
	la $t5, add_char
	lb $t5, ($t5)
	beq $t4, $t5, addition
	
	# check if input == *
	la $t5, mul_char
	lb $t5, ($t5)
	beq $t4, $t5, multiplication
	
	# check if input == " "
	la $t5, space_char
	lb $t5, ($t5)
	beq $t4, $t5, load_char
		
	# char -> int
	andi $t4, $t4, 0x0F

	# stack
	sw $t4, ($sp)
	sub $sp, $sp, 4
	j load_char
		
addition:
	# add every stack element to result
	beq $sp, $t3, load_char
	lw $t4, 0($sp)
	addi $sp, $sp, 4
	add $t0, $t0, $t4
	j addition
	
multiplication:
	# multiply every stack element to result
	beqz $t0, change_starter
	beq $sp, $t3, load_char
	lw $t4, 0($sp)
	addi $sp, $sp, 4
	mul $t0, $t0, $t4
	j multiplication

change_starter:
	# change first result value for multiplication
	li $t0, 1
	j multiplication
end:
	# print end message
	la $a0, str_end
	li $v0, 4
	syscall
	# print result
	move $a0, $t0
	li $v0, 1
	syscall
