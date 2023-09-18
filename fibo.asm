.text
li $t1, 0
li $t2, 1

# printing instructions
la $a0, str_begin
li $v0, 4
syscall
# reading fibonacci arg from user
li $v0, 5
syscall
move $t4, $v0
fibo_loop:
	beqz $t4, fibo_end
	move $t3, $t2
	add $t2, $t2, $t1
	move $t1, $t3
	subu $t4, $t4, 1
	j fibo_loop
fibo_end:
	la $a0, str_end
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall 
.data
	str_begin: .asciiz	"Hello, please enter a positive integer: "
	str_end:   .asciiz	"\nHere fibonacci of your number: "
	