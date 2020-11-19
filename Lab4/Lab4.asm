##########################################################################
# Created by:  Li, Yuehao
#              yli509
#              25 May 2019
#
# Assignment:  Lab 4: Roman Numeral Conversion
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Spring 2019
# 
# Description: This program converts Roman numeral to binary.
# 
# Notes:       This program is intended to be run from the MARS IDE.
##########################################################################

#This program will convert Roman numerals to binary.

#for argument
#    if contains letter except "V", "X", "I",  "C", "L","D"
#       print error message
#       ask Roman numerals again
#    else
#       return the string
#
#for i in range 0 to argument length
#    list[i]  = argument[i]
#
#if the string follow the rule
#    for i in range (0, list length - 1)
#        if list[i] bigger or equal than list[i+1]
#            result = result + list[i]
#        else 
#            result = result - list[i]
#else 
#    Error message 
#
#binary = ""
#while (result bigger than 0)
#    mod = result % 2
#    number = result / 2
#    put mod to the left of the previous number in binary String.
#    result = number



.data 
    ques:   .ascii  "You entered the Roman numerals: \0"
    blank:  .ascii  "\n\0"
    err:    .ascii  "Error: Invalid program argument. \0"
    ans:    .ascii  "The binary representation is: \0"
    address:.byte   00
# REGISTER USAGE
# $t0: Load byte to check user input.
# $t1: Length of the input.
# $t2: compartor.
# $t3: Load first byte to check order.
# $t4: Load second byte to check order.
# $t5: Extra check for order.
# $t6: Extra check for order.
# $t7: Load first byte to decide sum or minus.
# $t8: Load second byte to decide sum or minus./ Division reminder.
# $t9: Division quotient.
# $s2: Address to store final binary number.
# $s0: Decimal of the final result.

.text
    li     $v0, 4               # Print out the question.
    la     $a0, ques            
    syscall
    
    la     $a0, blank           # Print out new line.
    syscall

    lw     $s1, ($a1)           # Load word to $t1 and print out.
    move   $a0, $s1             
    li     $v0, 4 
    syscall                     # Print out argument.

    la     $a0, blank           # Load a blank line to a0.
    li     $v0, 4               # Print out 2 blank lines.
    syscall
    syscall
    
    li     $t1, 0               # Store the length of the input.
    li     $s0, 0               # Store the decimal number of result. 
    
    li     $t2, 0               # Comparator to check whether the argument is valid.
    la     $s2, address         # The start point of the result.
    j      length               # Jumping to Length method.
    
    
length:
    lb     $t0, ($s1)           # Load a byte to $t0.
    beq    $t0, 0, init         # When the byte is 0, which means the letter already be scaned. Then jump to the next step.
    add    $t1, $t1, 1          # Else, the length plus 1.
    add    $s1, $s1, 1          # The pin will move behind 1.
    j      length               # Make it as a Loop.
  
init:
    sub    $s1, $s1, $t1        # Make pin at the first letter of the argument.
    j      testletter           # Then jump to test letter.
      
testletter:
    lb     $t0, ($s1)           # Load a byte to t0.
    beq    $t0, 0,  error        # If the letter is 0, it means the argument already done. Jump to error message.
    beq    $t0, 73, plus        # If the letter is "I"  Plus one to comparator.
    beq    $t0, 88, plus        # If the letter is "X"  Plus one to comparator.
    beq    $t0, 86, plus        # If the letter is "V"  Plus one to comparator.
    beq    $t0, 67, plus        # If the letter is "C"  Plus one to comparator.
    beq    $t0, 68, plus        # If the letter is "D"  Plus one to comparator.
    beq    $t0, 76, plus        # If the letter is "L"  Plus one to comparator.
    add    $s1, $s1, 1          # Add one to get next letter
    j      testletter           # Make it to a loop.
    
    
plus:
    add    $t2, $t2, 1          # Add one on comparator. 
    add    $s1, $s1, 1          # Add one to get next letter  
    beq    $t2, $t1, caini      # If the comparator is equal to the length, Which means the word is valid, jump to cal step.
    j      testletter    
    
    
caini:
    sub    $s1, $s1, $t1        # Make pin at the first letter of the argument.
    j      order                # Jump to check order.
    
    
order:                          # This block of code check the order of the roman number.
    lb     $t3, ($s1)           # ########################################### #
    add    $s1, $s1, 1          #  Load first byte and second byte to check.  #
    lb     $t4, ($s1)           # ########################################### #
    beq    $t4, 0, clarfcal     # If t4 is 0, which means t3 is the last letter, There is no error.
    beq    $t3, 73, one         # Situation that the previous one is I, jump to the specific method to check.
    beq    $t3, 88, ten         # Situation that the previous one is "X".
    beq    $t3, 86, five        # Situation that the previous one is "V".
    beq    $t3, 68, fifhun      # Situation that the previous one is "D".
    beq    $t3, 76, fiften      # Situation that the previous one is "L".
    beq    $t3, 67, hun         # Situation that the previous one is "C".
    j      order                # Make it as a loop .

one:
    beq    $t4, 67, error       # ############################################# #
    beq    $t4, 68, error       # Letter "I" can't followed by "C", "D" and "L" #
    beq    $t4, 76, error       # ############################################# #
    beq    $t4, 88, ixspecial   # IXX is invalid, check.
    beq    $t4, 73, extra       # If there are two "I" stay together, We need a extra step to verify.
    j      order    
        
ixspecial:
    add    $s1,  $s1, 1  
    lb     $t5, ($s1)
    sub    $s1,  $s1, 1          # Return the normal value. 
    beq    $t5, 0, clarfcal      # IXX is invalid.
    j      error
    
extra:
    add    $s1,  $s1, 1          # Load another two byte to check.
    lb     $t5, ($s1)
    beq    $t5,  0  , clarfcal    # If t5 is 0, which means the string already ended. jump to next step.
    add    $s1,  $s1, 1          
    lb     $t6, ($s1) 
    sub    $s1,  $s1, 2           # Set the pin to the original point.   
    beq    $t5,  73, extrasub     # Triple "I" should be located at the last of argument.
    beq    $t5,  0, order         # There are maximum 3 "I" together. 2 "I" should located at the end of Argument.
    j      error                  # If there is anything followed by II beside I, It should be invalid.   

extrasub:                         # To Test Triple "I" an End of String.
    beq    $t6,  0,  clarfcal     # If there are three "I"s together, I should located at the end of the string.
    j      error                  # If the t6 is not 0, which means it is not vaild. 
              
ten:
    beq    $t4,  68, error        #  XD is invalid. 
    beq    $t4,  67, xcspecial    #  XCC is not valid.
    beq    $t4,  88, tenextra     #  XXXX is invalid, Check another 2 bytes.
    j      order
    
xcspecial:
    add    $s1,  $s1, 1  
    lb     $t5, ($s1)
    sub    $s1,  $s1, 1           # Return the normal value. 
    beq    $t5,  0, clarfcal      # End with XC, 
    beq    $t5,  73, order        # XCI is valid. 
    beq    $t5 , 86, order        # XCV is valid also.
    j      error
    
tenextra:
    add    $s1,  $s1, 1           # Load another two byte to check.
    lb     $t5, ($s1)
    beq    $t5, 0   , clarfcal    # If t5 is 0, which means the string already ended. jump to next step.
    add    $s1,  $s1, 1          
    lb     $t6, ($s1)
    sub    $s1,  $s1, 2           # Set the pin to the original point.
    beq    $t5,  88, tenextrasub  # test if there is four x, (XXXX) which is invalid.
    beq    $t5,  76, error        # XXL is invalid.
    beq    $t5,  67, error        # XXC is invalid.
    beq    $t5,  68, error        # XXD is invalid.
    j      order
tenextrasub:
    beq    $t6, 0, clarfcal       # If t6 is 0, which means the argument already ended, without error. 
    beq    $t6, 86, order         # XXXV and XXXI is valid.
    beq    $t6, 73, order
    j      error                 
    
five:
    beq    $t4, 73, order         # VI is valid 
    beq    $t4, 0 , clarfcal      # V at last is valid. 
    j      error                  # Else is in valid.
 
fifhun:
    beq    $t4,  68, error        # DD is invalid.   
    beq    $t4,  0,  clarfcal     # second on is 0, which means the string already done. 
    j      order
    
fiften:
    beq    $t4, 76, error         # LL is invalid situation. 
    beq    $t4, 67, error         # LC is invalid situation.
    beq    $t4, 68, error         # LD is invalid situation. 
    j      order        

hun:
    beq    $t4, 67, hunextra      # If the com bination is CC, check another 2 bytes 
    j      order

hunextra:
    add    $s1,  $s1, 1           # Load another two byte to check.
    lb     $t5, ($s1) 
    beq    $t5,  0  , clarfcal    # If t5 is 0, which means the string already ended. jump to next step.
    add    $s1,  $s1, 1          
    lb     $t6, ($s1)
    
    sub    $s1,  $s1, 2           # Set the pin to the original point.
    beq    $t5,  67, hunsub       # If CCC already, check the final byte
    beq    $t5,  68, error        # CCD is invalid. 

hunsub:
    beq    $t6, 67, error         # CCCC is invalid.
    beq    $t6, 68, error         # CCCD is invalid.
    beq    $t6, 0 , clarfcal      # CCC at end is valid.
    j      order
    
    
    
clarfcal:
    lw     $s1,  ($a1)           # Initial the pin. by load word again
    j      cal1        
      
cal1:
    lb     $t3, ($s1)           # ########################################### #
    add    $s1, $s1, 1          #  Load a bytes to check compare  (+ or -)    #
                                # ########################################### #
    beq    $t3, 0   , transfer  # When t3 is 0, the program already finish calculate. 
    beq    $t3, 73  , I1        # 
    beq    $t3, 88  , X1
    beq    $t3, 86  , V1
    beq    $t3, 76  , L1
    beq    $t3, 68  , D1
    beq    $t3, 67  , C1

       
I1:                             # Set the first letter to decimal.
    li     $t7, 1               # set number in t7 for next compare step
    j     cal2
X1:
    li     $t7, 10  
    j     cal2             
V1:
    li     $t7, 5
    j     cal2
L1:
    li     $t7, 50
    j     cal2
D1:
    li     $t7, 500  
    j     cal2
C1:
    li     $t7, 100    
    j     cal2

cal2:
    lb     $t4, ($s1)
    beq    $t4, 73  , I2           
    beq    $t4, 88  , X2
    beq    $t4, 86  , V2
    beq    $t4, 76  , L2
    beq    $t4, 68  , D2
    beq    $t4, 67  , C2   

I2:                               # Set the second letter to decimal.
    li     $t8, 1                 # Set t8 to compare to detemine whether add or minus.
    j     result
X2:
    li     $t8, 10  
    j     result             
V2:
    li     $t8, 5
    j     result
L2:
    li     $t8, 50
    j     result
D2:
    li     $t8, 500  
    j     result
C2:
    li     $t8, 100    
    j     result    
    
result:           
    bge    $t7, $t8, sum             #If tthe first bigger or equal than second, Sum it.
    j      minus                     #If tthe first less than second, minus it.
sum:
    add    $s0, $s0, $t7
    j      cal1
minus:
    sub    $s0, $s0, $t7
    j      cal1
    
    
    
transfer:
    li     $t0, 2              # Divide number

    div    $s0, $t0            # Store the 
    
    mflo   $t9                 # result 
    mfhi   $t8                 # Reset t8 to store the binay number    , reminder
    
    beq    $t8, 1  , onefirst  # 
    beq    $t8, 0  , zerofirst
                                      

onefirst:
    add    $s2, $s2, 1
    li     $t1, 49
    sb     $t1, ($s2)
    j      quotiencheck
    
zerofirst:            
    add    $s2, $s2, 1
    li     $t1, 48
    sb     $t1, ($s2)
    j      quotiencheck
    
quotiencheck:
    blt    $t9, $t0, binary     # If the quotient smaller than 2, jump to final step.
    move   $s0, $t9            # Set the t4 as the new quotient.
    j      transfer
    

binary:
    beq   $t9, 1  , addextra  # If the final result remain 1, add 1.
  
    add   $s2, $s2, 1         # load b char in s0
    la    $t1, 98              # "b" ascii is 98
    sb    $t1, ($s2)         
    
    add   $s2, $s2, 1         # Load "0" to s0
    la    $t1,  48            # ASCII for "0"
    sb    $t1, ($s2)
    j     answer
    
addextra:
    add   $s2, $s2, 1          # If there is a 1 left, store the final "1".
    la    $t1, 49              # ASCII for "1"
    sb    $t1, ($s2)
    
    add   $s2, $s2, 1         # load b char in s0
    la    $t1, 98             # "b" ascii is 98
    sb    $t1, ($s2)
    
    add   $s2, $s2, 1         # Load "0" to s0
    la    $t1,  48            # ASCII for "0"
    sb    $t1, ($s2)
    j     answer 
                                  
error:
    la     $a0, err            # Print Error message.
    li     $v0, 4
    syscall

    la     $a0, blank          # Print a Blank line.
    syscall

    li     $v0, 10            # End the program If the input is invalid.
    syscall
    

answer:
    la     $a0, ans           # String of the answer. 
    li     $v0, 4
    syscall
    la     $a0, blank          # Blank line between string and real answer
    syscall
    j      finalrst

finalrst:
    lb     $t0, ($s2)            
    beq    $t0, 0, blankline     # If the result is 0, which means the binary already finish print out, so jump to final step.
    move   $a0, $t0             
    li     $v0, 11
    syscall
    sub    $s2, $s2, 1
    
    j      finalrst
    
    
blankline:
    la     $a0, blank
    li     $v0, 4
    syscall
    
    li     $v0, 10            # End the program.
    syscall