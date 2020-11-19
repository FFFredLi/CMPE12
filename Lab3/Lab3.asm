##########################################################################
# Created by:  Li, Yuehao
#              yli509
#              11 March 2019
#
# Assignment:  Lab 3: MIPS!
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Spring 2019
# 
# Description: This program calculates the ?factorial? of a number.
# 
# Notes:       This program is intended to be run from the MARS IDE.
##########################################################################

# REGISTER USAGE
# $t0: user input / final result
# $t1: Maximum value that user can input.
# $t2: Store (input - 1) to calculate factorial.
# $t3: Store the number that stop calculte factorial.
# $t4: Store initial number which will be used when priting result. 

.data 
 qes :   .ascii  "Enter an integer between 0 and 10: \0"
 err :   .ascii  "Invalid entry! \0"
 empty : .ascii  " \n\0"

 
.text
li     $t1, 10             # set maximum number as 10 in t1.
li     $t3, 2              # Calculation counter.
 
la     $a0, qes            # Print out sentence to notice the user.
li     $v0, 4 
syscall 
  
li     $v0, 5              # Let user input a number.
syscall
move   $t0, $v0          # User input store in t0.


check:
  bgt  $t0, $t1, wrong        # If input bigger than 10 jump to wrong section.
  blt  $t0, $zero, wrong     # If input smaller than 0 jump to wrong section.
  la   $t4, ($t0)            # Load initial value to $t3.
  beqz $t0, special          # 0! is 1, so set a special condition.
  la   $t2, ($t0)
  j calculate                # If meet these two requirement, jump to calculate section.
 
 
special:                     # Directly set the result to 1.
  li   $t0, 1
  j end
  
  
calculate:             # Calculation part.
  sub   $t2, $t2, 1
  mul   $t0, $t0, $t2
  bgt   $t2, $t3, calculate
  j end
  
  
end:
  la   $a0, empty        # Print a new line.
  li   $v0, 4
  syscall
  
  move $a0, $t4       # Print initial value.
  li   $v0, 1
  syscall
  
  li   $a0, 33           # "!" character.
  li   $v0, 11           # service 11 to print character.
  syscall
  
  li   $a0, 32          # " "(space) character.
  syscall
  
  li   $a0, 61          # "=" character.
  syscall
  
  li   $a0, 32          #  " "(space) character.
  syscall
  
  move $a0, $t0       # Result.
  li   $v0, 1
  syscall
  
  la   $a0, empty        # Print a new line.
  li   $v0, 4
  syscall
  
  li   $v0, 10          # End the program.
  syscall
 
    
wrong:
  la   $a0, empty        # Print a new line.
  li   $v0, 4
  syscall
  
  la   $a0, err          # Print Error message.
  li   $v0, 4
  syscall
  
  la   $a0, empty        # Print 2 new line.
  li   $v0, 4
  syscall
  syscall
  
  la   $a0, qes          # Print out sentence to notice the user again.
  li   $v0, 4 
  syscall   
  
  li   $v0, 5            # Let user input a number.
  syscall
  move $t0, $v0        # User input store in t0.
  j check

  
  
  
  


  
  

 







 
