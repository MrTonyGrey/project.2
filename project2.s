.data
  empint:   .asciiz "Input is empty." # Prints out if input is empty
  lngint:    .asciiz "Input is too long." # Prints out if input is too long
  userint:    .space  500 # Reserves 500 bytes which equals 125 words
  invalint: .asciiz "Invalid base-N number." # n is invalid so change its value
.txt


exit:
  li $v0, 10
  syscall
  
#Outputs if the input is empty
err_empty_input:
  la $a0, emptint
  li $v0, 4
  syscall
  j exit
