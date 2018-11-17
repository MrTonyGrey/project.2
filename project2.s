# N = 32
.data
  empint:   .asciiz "Input is empty." # Prints out if input is empty
  lngint:    .asciiz "Input is too long." # Prints out if input is too long
  userint:    .space  500 # Reserves 500 bytes which equals 125 words
  invalint: .asciiz "Invalid N number." # n is invalid so change its value
.txt


exit:
  li $v0, 10
  syscall
  
#Outputs if the input is empty
empty_input:
  la $a0, empint
  li $v0, 4
  syscall
  j exit
#Outputs if the input is invalid
invalid_input:
  la $a0, invalint
  li $v0, 4
  syscall
  j exit
#0utput if the the user input is too long
too_long_input:
  la $a0, lngint
  li $v0, 4
  syscall
  j exit
#Loads user input
main:
  li $v0, 8
  la $a0, userint
  li $a1, 250
  syscall
  
del_left_pad:
   li $t8, 32 # space
   lb $t9, 0($a0)
   beq $t8, $t9, delete_first_char
   move $t9, $a0 #Copies $t9 to $a0
   j input_len #jump to the input len
   
delete_first_char:
   addi $a0, $a0, 1
   j del_left_pad

input_len:
  addi $t0, $t0, 0
  addi $t1, $t1, 10
  add $t4, $t4, $a0
size_iter:
   lb $t2, 0($a0)
   beqz $t2, after_size_found
   beq $t2, $t1, after_size_found
   addi $a0, $a0, 1
   addi $t0, $t0, 1
   j size_iter
   
len_found:
   beqz $t0, empty_input
   slti $t3, $t0, 5
   beqz $t3, too_long_input
   move $a0, $t4
   j check_str
   
check_str:
   lb $t5, 0($a0)
   beqz $t5, convert
   beq $t5, $t1, convert
   slti $t6, $t5, 48
   bne $t6, $zero,invalid_input
   slti $t6, $t5, 58
   bne $t6, $zero,forward
   slti $t6, $t5, 65
   bne $t6, $zero,invalid_input
   slti $t6, $t5, 87                
   bne $t6, $zero, forward
   slti $t6, $t5, 97
   bne $t6, $zero, invalid_input
   slti $t6, $t5, 119    
   bne $t6, $zero, forward
   bgt $t5, 119, invalid_input
forward:
   addi $a0, $a0, 1
   j check_str
   
convert:
	move $a0, $t4
	addi $t7, $t7, 0
	add $s0, $s0, $t0
	addi $s0, $s0, -1
	li $s3, 3
	li $s2, 2
	li $s1, 1
	li $s5, 0
	
convert_int:
   lb $s4, 0($a0)
   beqz $s4, print_result
   beq $s4, $t1, print_result
   slti $t6, $s4, 58
   bne $t6, $zero, ten_conv
   slti $t6, $s4, 88
   bne $t6, $zero, 33_upper_conv
   slti $t6, $s4, 120
   bne $t6, $zero, 33_lower_conv
	
ten_conv:
   addi $s4, $s4, -48
   j result

33_upper_conv:
   addi $s4, $s4, -55
   j result
   
33_lower_conv:
   addi $s4, $s4, -87

result:
  beq $s0, $s3, first_digit
  beq $s0, $s2, second_digit
  beq $s0, $s1, third_digit
  beq $s0, $s5, fourth_digit

first_digit:
   li $s6, 32768 # (base 32)^3
   mult $s4, $s6
   mflo $s7
   add $t7, $t7, $s7
   addi $s0, $s0, -1
   addi $a0, $a0, 1
   j convert_int
second_digit:
       li $s6, 1024 # (base N)^2
       mult $s4, $s6
       mflo $s7
       add $t7, $t7, $s7
       addi $s0, $s0, -1
       addi $a0, $a0, 1
       j convert_input
      


