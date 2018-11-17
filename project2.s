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

   


