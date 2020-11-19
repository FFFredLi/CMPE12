------------------------ 
 Lab 4: Roman Numeral Conversion 
 CMPE 012 Spring 2019 
 Li , Yuehao
 yli509 
------------------------- 
 Can you validly represent the decimal value 1098 with Roman numerals using only I, V, X, and C? 
 No, because 1000 is represented by letter "M", but it is invalid in this lab. 

 What was your approach for recognizing an invalid program argument? 
      I test 2 letters in the argument ( user input ) every time. And list some invalid situation, such as "III" is the maximum time "I" can 
 used in the argument and it should located at the end of the argument. So If there is another character after "III", it should invalid.
 Same as "II", the definition of roman number says that we can only substract "I" one time, So If any character after"II" which means invalid. 
 
 What did you learn in this lab? 
     I learned how to load bytes and store bytes in this lab. Also, I learned more about how register working.

 Did you encounter any issues? Were there parts of this lab you found enjoyable? 
       Yes. When I want to convert decimal to binary, I don't know how to store the result into a register. So, I searched YouTube videos
to study this part. Also, I searched stackoverflow.com to understand basic steps stroing result. After I resolve this problem and got the 
right answer, I feel that the process to reslove problem is super meaningful.

 How would you redesign this lab to make it better?
       I would write more comments. 

 What resources did you use to complete this lab? 
     Youtube video, WiKi, reddit, stackoverflow

 Did you work with anyone on the labs? Describe the level of collaboration. 
     No, I did it by myself.
