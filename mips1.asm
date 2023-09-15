.data
fileName: .space 1024
fileDecom: .space 256
fileCom: .space 256
hex_form: .asciiz"0x0000"
digits:     .asciiz     "0123456789ABCDEF"
file_uncompressed: .asciiz "C:\\Users\\Lenovo\\Desktop\\uncom.txt"
file_compressed: .asciiz"C:\\Users\\Lenovo\\Desktop\\compressed.txt"
fileNameOut: .asciiz"C:\\Users\\Lenovo\\Desktop\\dictionary.txt"
buffer: .space 1024
bufferDe: .space 256
bufferCom: .space 256
buffer1: .space 100
buffer2: .space 100
buffer3: .space 100
buffer4: .space 256
buffer5: .space 1024
buffer6: .space 256
Space:.asciiz" "
space: .asciiz"space' '"
match: .asciiz": "
fullstopp: .asciiz"."
comaa: .asciiz","
newlineComp: .asciiz"\\n"

open_file_success: .asciiz"\nfile opened successfully, here is the file's content\n"
open_file_error: .asciiz"Error! opening the file"
codeNotExist: .asciiz"  does not exist in the dictionary file"
fileEmpty: .asciiz"\nthis file is Empty!!\n"
myMessage1: .asciiz "\nDoes 'dictionary.txt' file exist or not(yes/no)\n"
myMessage2: .asciiz "\n Please enter the path of the file: \n" 
compress: .asciiz "\n\nc - compress, or compression your file\n"
decompress: .asciiz "d - decompress or decompression your file\n"
#this statment to end the program
quit: .asciiz "q - quit the program\n"
select:.asciiz "Please choose c,d or q: " 
c: .asciiz "c\n"
d: .asciiz "d\n"
q: .asciiz "q\n"
choice: .space 10
#if the user input  does not c or d or q
error: .asciiz "invalid input, try again\n"
newLine: .asciiz "\n"
myMessage5: .asciiz "Please Enter the path of the file:\n"
myMessage6: .asciiz "\n Hope You enjoy this program,Bye!!......\n"
myMessage7: .asciiz "\n please enter the path of the file to be compressed\n"
myMessage8: .asciiz "\n enter the path of the file to be decompressed\n"
myMessage9: .asciiz"\n compresion processing....\n\n"
myMessage10: .asciiz"\n decompresion processing....\n\n"
yes:	.asciiz "yes\n"
no:	.asciiz "no\n"
yesNo: 	.space 10		#

result1: .float 0.0                       # Variable to store the result of the first equation
result2: .float 0.0                       # Variable to store the result of the second equation
result3: .float 0.0                       # Variable to store the result of the third equation

sentence3: .asciiz "The uncompressed file size: "
sentence4: .asciiz "The compressed file size: "
sentence5: .asciiz "File Compression Ratio: "

################################ code segment################################
.text
.globl main 
main:
	j START 
	
START:
	#load the sting(myMessage1)to a0 to ask the user if the file exist or not
    	la $a0,  myMessage1 		
    	li $a1, 30
    	# system call 4 to print the string
    	li $v0, 4			
    	syscall
    	# system call for reading string
   	li $v0, 8  	
   	# address of input bu		
	la $a0, yesNo 
	# maximum length of input 	
	li $a1, 256		
	syscall
	#loads the memory address of the label yes into register $a1
	la $a1,yes
	# jal:jump and link,jumps to the strcmp	
	#and saves the return address (the address of the instruction immediately following the jal instruction) in register $ra (the return address register).	
	jal strcmp			
		
	#go to the label read path if register v0 equal zero 				
	beq $v0,$zero, readPath	
	#loads the memory address of the label no into register $a1
	la $a1, no			
	jal strcmp			
	beq $v0, $zero, creatDic	
	#instruction jumps to the labele START 
   	j START 			
#---------------------------------------------------------------------------------
readPath:
	#ask the user to enter the file path 
	la $a0, myMessage5		
	li $a1, 256
	#4 is system call to print the string
	li $v0, 4			
	syscall
	# Reading the filename and storing it into filename variable.
	la $a0, fileName
	#8 is system call to read the string	
	li $v0, 8				
	syscall
	
	la $a0,fileName
	jal remove_newline
	
	la $a0,fileName
	la $a1,buffer
	jal print_file_content
	
	j menue
#---------------------------------------------------------------------------	
creatDic:	
	#If user input no ,the program creates a new empty dictionary.txt
	#write on file 
	#the file must  be open first in order to be read or write on it 
	 #the code(syscall) to open file is 13 
	li $v0,13      
	# get the name of file      
	la $a0,fileNameOut   
	 #file flag for write on the file is 1   
	li $a1,1             
	syscall
	# save the file  descriptor on s1    
	move $s0,$v0
		     	     	     
	#close the file 
	#the code(syscall) to close the file is 16
	li $v0,16		
	#file descriptor to close 
	move $a0,$s0	
	syscall 
	
	#copy the path of the created dictionary
	la $a0,fileNameOut
	la $a1,fileName
	jal strcpy
	j menue
#--------------------------------------------------------------------	
menue:
	#printing the menue 
	# load the addrees of the string compress (which define in .data section) to a0
	la $a0, compress		
	li $a1, 256
	li $v0, 4
	syscall
	
	# load the addrees of the string decompress (which define in .data section) to a0		
	la $a0, decompress		
	li $a1, 256
	li $v0, 4
	syscall
	
	# load the addrees of the string quit(which define in .data section) to a0
	la $a0, quit					
	li $a1, 256
	li $v0, 4
	syscall

#---------------------------------------------------------	
selection:
	#load the addrees of the string select(which define in .data section) to a0	
	la $a0, select			
	li $a1, 256
	li $v0, 4
	syscall
	
	# get the choice from the user
	la $a0, choice
	li $v0, 8
	syscall
	
	# if the user chice c 
	la $a1,c		
	jal strcmp
	beq $v0,$zero, compre
	
	# if the user chice d
	la $a1,d		
	jal strcmp
	beq $v0,$zero, decompre
	
	# if the user chice q
	la $a1,q		
	jal strcmp
	beq $v0,$zero, exit
	
	#if the code reach here then the choice is not valid
	la $a0, error		
	li $a1, 256
	li $v0, 4
	syscall
	j selection
	
#----------------------------------------------					
repeat:	j menue

#----------------------------------------------	
compre:
	#ask the user to enter the file path 
	la $a0, myMessage7		
	li $a1, 256
	#4 is system call to print the string
	li $v0, 4			
	syscall
	
	# Reading the filename and storing it into filename variable.
	la $a0, fileCom
	#8 is system call to read the string	
	li $v0, 8				
	syscall
	
	#remove '\n' charachter from the end of the string
	la $a0,fileCom
	jal remove_newline
	
	#opening the file,store its conetent and print it 
	la $a0,fileCom
	la $a1,bufferCom
	jal print_file_content
	
	#a counter for number of binary codes compressed
	li $v1,0
	#do compresion process
	jal compresion
	
	#counting number of charachters of the file to be compressed
	la $a0,bufferCom
	jal countCharacters
	move $t1,$v0
	subi $t1,$t1,1
	
	#number of binary codes
	move $t2,$v1
	
	# Calculate and store the result of the first equation
        # Load the constant 16 to register $t0
    	li $t0, 16
    	# Multiply the character count by 16                              
    	mul $t1, $t1, $t0 
    	# Move the integer result to $f0                      
    	mtc1 $t1, $f0   
    	# Convert the integer result to a float in $f0                        
    	cvt.s.w $f0, $f0
    	# Store the floating-point result in the 'result1' variable                        
    	swc1 $f0, result1                       
		
	# Calculate and store the result of the second equation
	# Multiply the binary code count by 16
    	mul $t2, $t2, $t0 
    	# Move the integer result to $f0                      
    	mtc1 $t2, $f0  
    	# Convert the integer result to a float in $f0                        
    	cvt.s.w $f0, $f0 
    	# Store the floating-point result in the 'result2' variable                       
    	swc1 $f0, result2                       

    	# Calculate and store the result of the third equation (compression ratio)
    	# Load the value of result1 into $f0
   	lwc1 $f0, result1
   	# Load the value of result2 into $f2                   
	lwc1 $f2, result2  
	# Divide the value of result1 by the value of result2                   
	div.s $f12, $f0, $f2  
	# Store the floating-point result in the 'result3' variable	                
	swc1 $f12, result3                   
	
	
	# Print the results
	# System call code 4 for printing a string
    	li $v0, 4 
    	# Load the address of the sentence3 string                              
    	la $a0, sentence3   
    	# Print the sentence3                    
    	syscall                                 

   	 # Print the result of the first equation
   	 # Load the floating-point result1 from 'result1' variable
    	lwc1 $f12, result1
    	 # System call code 2 for printing a float                      
   	 li $v0, 2   
   	 # Print the result of the first equation                           
    	syscall                                 

   	 # Print a new line
   	 # System call code 4 for printing a string
   	 li $v0, 4 
   	 # Load the address of the newline string                              
   	 la $a0, newLine   
   	 # Print a new line                     
    	syscall                                 

    	# Print the sentence before displaying the result of the second equation
    	 # System call code 4 for printing a string
   	 li $v0, 4  
   	 # Load the address of the sentence4 string                            
   	 la $a0, sentence4   
   	 # Print the sentence4                    
   	 syscall                          

    	# Print the result of the second equation
    	# Load the floating-point result2 from 'result2' variable
  	 lwc1 $f12, result2  
  	 # System call code 2 for printing a float                   
  	 li $v0, 2 
  	 # Print the result of the second equation                              
    	 syscall                                 

   	 # Print a new line
   	 # System call code 4 for printing a string
   	 li $v0, 4      
   	 # Load the address of the newline string                         
   	 la $a0, newLine   
   	 # Print a new line                      
    	syscall                                 

   	 # Print the sentence before displaying the result of the third equation
   	 # System call code 4 for printing a string
   	 li $v0, 4  
   	 # Load the address of the sentence5 string                             
   	 la $a0, sentence5
   	 # Print the sentence5                       
   	 syscall                                 

    	# Print the result of the third equation
    	# Load the floating-point result3 from 'result3' variable
   	 lwc1 $f12, result3 
   	 # System call code 2 for printing a float                     
   	 li $v0, 2  
   	 # Print the result of the third equation                             
    	syscall                                 
    
	j menue
	
#----------------------------------------------------------------------------------------------

decompre:
	#read the path of the file
	#ask the user to enter the file path 
	la $a0, myMessage8		
	li $a1, 256
	#4 is system call to print the string
	li $v0, 4			
	syscall
	# Reading the filename and storing it into filename variable.
	la $a0, fileDecom
	#8 is system call to read the string
	li $v0, 8					
	syscall
	
	la $a0,fileDecom
	jal remove_newline
    	
    	la $a0,fileDecom
    	la $a1,bufferDe
    	jal print_file_content
	
	li $v0,4
	la $a0,newLine
	syscall
	
	#doning decompresion process
	move $t5,$a1
	la $a0,fileDecom
	jal decom
	j menue	

#---------------------------------------------------------------------------------------------	

exit:
	la $a0, myMessage6
	li $v0, 4
	syscall
	li $v0, 10
	syscall

#--------------------------------------------------------------------
strcmp:  		
	loop1:
		# Load byte from string1
 		lb $s5, ($a0)   
 		# Load byte from string2  	
		lb $s6, ($a1)    
		#If end of string1, strings are equal 	
		beqz $s5, equal   
		# If end of string2, strings are not equal	
		beqz $s6, notequal 
		# If bytes are not equal, strings are not equal
		bne $s5, $s6, notequal 
		# Increment string1 pointer
		addi $a0, $a0, 1 
		# Increment string2 pointer	
		addi $a1, $a1, 1 	
		# Jump to loop1
		j loop1           	
	equal:
		# Set return value to 1
		li $v0, 0  
		#Jump to done      	
		j done
		
		           	           	
	notequal:
		# Set return value to 0
		li $v0, 1  
		      	
	done:
		# Exit function
		jr $ra
		
#---------------------------------------------------		
remove_newline:
	# Allocate space on the stack for $ra
	addi $sp, $sp, -4  
	# Save $ra on the stack    
	sw   $ra, 0($sp)   
	    
	 # Copy the address of the string to $t0
	addi $s5, $a0, 0   
	# Initialize counter to 0    
	addi $s6, $zero, 0     

	loop6:
	        # Load a byte from memory
		lbu  $s7, ($s5)   
		# If byte is newline character, exit loop     
		beq  $s7, 10, done3  
		# Increment address to next byte   
		addi $s5, $s5, 1   
		# Increment counter    
		addi $s6, $s6, 1       
		j    loop6

	done3:
	        # If the string is empty, exit function
		beq  $s6, $zero, end4   	
     		# Decrement counter to account for removed newline character
     		addi $s6, $s6, -1      
        	        # Set $t2 to 0 to explicitly set null terminator
        		addi $s7, $zero, 0
        		# Replace newline character with null terminator     
        		sb   $s7, ($s5)       

    	end4:
    	# Restore $ra from the stack
        	lw   $ra, 0($sp)
        	# Deallocate space on the stack
        	addi $sp, $sp, 4
        	jr   $ra
#-------------------------------------------------------------------------   	
count_lines:
         	# Allocate space on the stack for $ra and $v0
	addi $sp, $sp, -4 
	# Save $ra on the stack     
	sw   $ra, 0($sp)        

	move $a3,$a0
	li $s7,0	 #counter
	loopBuffer:
		lbu $t3,($a3)
		beqz $t3, done6
		addi $a3,$a3,1
		beq $t3,10, increase
		j loopBuffer
	
	increase:	addi $s7,$s7,1
		j loopBuffer

	done6:
		move $v0,$s7
		
		# Restore $ra from the stack
		lw   $ra, 0($sp)   
		# Deallocate space on the stack    
        		addi $sp, $sp, 4
        		jr   $ra
#-------------------------------------------------------------------------
decom:
	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	
    	li $v0,4
    	la $a0,myMessage10
    	syscall
    	
	la $s2,bufferDe
	la $s3,buffer1
	loopBuffer1:
		# Load a byte from the memory address stored in $s2 and store it in $t0
		lbu $t0,($s2)
		beqz $t0, done5
		addi $s2,$s2,1
		# 10 is the ASCCII code for /r/n
		beq $t0,10,found 
		# Store the byte in $t0 to the memory address stored in $s3
		sb $t0,($s3)
		addi $s3,$s3,1
		j loopBuffer1
	
	found:
		addi $s3,$s3,1
		# Store null character at the end of buffer1
		sb $zero, ($s3)  
		j search_dic_code
		
	continue:
		la $s3,buffer1
		j loopBuffer1
	
	done5:	
		lw $ra, 0($sp)
    		addi $sp, $sp, 4
		jr   $ra
 #--------------------------------------------------------------
        	
print_file_content:
	move $t2,$a1
	#the file must  be open first in order to be read or write on it 
	#the code(syscall) to open file is 13 
	li $v0,13  
	#file flag for read the file is 0          
	li $a1,0             
	li $a2,0
	syscall
	
	# Check if the file was opened successfully
	# if $v0 is non-zero, then the file was opened successfully, jump to read_file_content
	bnez $v0, read_file_content 
	li $v0, 4
	la $a0, open_file_error
	syscall
	
	li $v0,4
	la $a0, newLine
	syscall
	jr $ra 
	
	read_file_content:
		move $t0, $v0
	
		li $v0, 14
		move $a0, $t0
		move $a1,$t2
		li $a2, 1024
		syscall
			
		beqz $v0, empty

		li $v0,4
		la $a0,open_file_success
		syscall
		
		# Print the line to the console
		li $v0, 4
		move $a0, $t2
		syscall
		j closeFile
		
	empty:	li $v0,4
		la $a0,fileEmpty
		syscall
		
	closeFile:
		# Close the input file
		li $v0, 16
		move $a0, $t0
		syscall
		
		li $v0,4
		la $a0, newLine
		syscall
		jr $ra

		
#--------------------------------------------------		
search_dic_code:
	#flag to check if we found the code
	li $a3,0
	la $t4,buffer
	la $t5,buffer1
	la $t7,buffer2
	loopDic:
		lbu $t6,($t4)
		beqz $t6,done7
		addi $t4,$t4,1
		beq $t6,' ',found2
		sb $t6,($t7)
		addi $t7,$t7,1
		j loopDic
	
	found2:
		la $a0,buffer2
		la $a1,buffer1
		jal strcmp
		beqz $v0,found3
		la $t7,buffer2
	goNextLine:
		lbu $t6,($t4)
		beqz $t6,done7
		addi $t4,$t4,1
		bne $t6,10,goNextLine
		j loopDic
		
	found3:	la $t7,buffer3
	found3Loop:	
	      #change the flag that we found the code
		li $a3,1
		lbu $t6,($t4)
		beqz $t6,done7
		addi $t4,$t4,1
		beq $t6,10,found4
		sb $t6,($t7)
		addi $t7,$t7,1
		j found3Loop
	
	found4:
		li $v0,4
		la $a0,newLine
		syscall
		
		li $v0,4
		la $a0,buffer1
		syscall
		
		li $v0,4
		la $a0,match
		syscall
		
		li $v0,4
		la $a0,buffer3
		syscall
		
		#append the word to the uncompressed file
		li $v0,13
		la $a0,file_uncompressed
		 # 9 = O_WRONLY | O_APPEND
		li $a1, 9     
		 # Mode parameter not used (set to 0)                  
		li $a2, 0                       
		syscall
		
		# Save the file descriptor for later use
		move $s0, $v0                    
    
		#Write the contents of buffer3 to the file
		# syscall code for writing to a file
		li $v0, 15   
		# File descriptor                   
		move $a0, $s0 
		# Load the address of buffer3                  
		la $a1,buffer3   
		 # Number of bytes to write (assuming buffer3 is 256 bytes)              
		li $a2, 15
		 # Write to the file                  
		syscall   
		
		 #Write a new line to the file
		# syscall code for writing to a file
		li $v0, 15   
		# File descriptor                   
		move $a0, $s0 
		# Load the address of buffer3                  
		la $a1,newLine   
		 # Number of bytes to write (assuming buffer3 is 256 bytes)              
		li $a2, 1
		 # Write to the file                  
		syscall                        

		# Close the file
		 # syscall code for closing a file
		li $v0, 16      
		# File descriptor                
		move $a0, $s0     
		# Close the file               
		syscall                          
		
		la $a0,buffer3
		jal clear_string	
		la $a0,buffer2
		jal clear_string
	
	done7:
		beqz $a3,notFoundCode
		j continue
	
	notFoundCode:
		li $v0,4
		la $a0,newLine
		syscall
		
		li $v0,4
		la $a0,buffer1
		syscall
		
		li $v0,4
		la $a0,match
		syscall
		
		li $v0,4
		la $a0,codeNotExist
		syscall
		
		j continue
		
#------------------------------------------------------

clear_string:
	# Allocate space on the stack for the temporary address
	addi $sp, $sp, -4   
	# Save the return address on the stack  
	sw $ra, ($sp)         
	
	# Load the first character of the string
	lb $s5, 0($a0)   
	# If the character is null, we are done     
	beqz $s5, doneclear        

	loopclear:
		# Store null byte at the current address
		sb $zero, 0($a0)    
		# Increment the address by 1  
		addiu $a0, $a0, 1   
		# Load the next character  
		lb $s5, 0($a0)       
		# If the character is not null, continue looping
		bnez $s5, loopclear        

	doneclear:
	        # Restore the return address from the stack
		lw $ra, ($sp) 
		# Deallocate space on the stack        
		addi $sp, $sp, 4      
		# Return from the function
		jr $ra               
#------------------------------------------------------------------------------------
compresion:

	# Allocate space on the stack for the temporary address
	addi $sp, $sp, -4    
	# Save the return address on the stack 
	sw $ra, ($sp)        
	
	li $v0,4
	la $a0,myMessage9
	syscall
	
	la $a0,buffer1
	jal clear_string
	la $a0,buffer2
	jal clear_string
	la $a0,buffer3
	jal clear_string
	
	la $s2, bufferCom
	#store for word
	la $s3, buffer1 
	
	loopBufferCom:
		lbu $t0,($s2)
		beqz $t0,done8
		addi $s2,$s2,1
		beq $t0,10,goSearch
		beq $t0,'.',goSearch
		beq $t0,',',goSearch
		beq $t0,' ',goSearch
		sb $t0,($s3)
		addi $s3,$s3,1
		j loopBufferCom
	goSearch:	
		sb $zero,($s3)
		la $a0,buffer1
		j searchForCom
	continue2:
		la $a0,buffer1
		jal clear_string
		la $s3,buffer1
		addi $s2,$s2,-1
		j loopBufferCom
		
	done8:
		# Restore the return address from the stack
		lw $ra, ($sp)    
		# Deallocate space on the stack     
		addi $sp, $sp, 4   
		# Return from the function   
		jr $ra   
		
#-----------------------------------------------------------------------------             

searchForCom:
	#flag to check if we found the word
	li $t7,0
	move $t6,$a0
	# contine dictionary
	la $s4,buffer
	# contine code
	la $t2,buffer2
	#contiune word
	la $t3, buffer3
	
	loopBufferDic:
		lbu $t4,($s4)
		beqz $t4,done9
		addi $s4,$s4,1
		beq $t4,' ',found5
		sb $t4,($t2)
		addi $t2,$t2,1
		j loopBufferDic
	
	found5:
		lbu $t4,($s4)
		beqz $t4,done9
		addi $s4,$s4,1
		beq $t4,10,found6
		sb $t4,($t3)
		addi $t3,$t3,1
		j found5
		
	found6:
		move $a0,$t6
		la $a1,buffer3
		jal strcmp
		beqz $v0,found7
		la $a0,buffer2
		jal clear_string
		la $a0,buffer3
		jal clear_string
		la $t2,buffer2
		la $t3,buffer3
		j loopBufferDic
	
	found7:
		li $t7,1
		
		li $v0,4
		move $a0,$t6
		syscall
		
		li $v0,4
		la $a0,match
		syscall
		
		li $v0,4
		la $a0,buffer2
		syscall
		
		li $v0,4
		la $a0, newLine
		syscall
		# Load the address of buffer2
		la $a1, buffer2                  
	writeOncomp:	
		move $s7,$a1
		#append the word to the uncompressed file
		li $v0,13
		la $a0,file_compressed
		li $a1, 9
		 # Mode parameter not used (set to 0)                   
		li $a2, 0                       
		syscall
		 # Save the file descriptor for later use
		move $s0, $v0                        
    	
		#Write the contents of buffer3 to the file
		 # syscall code for writing to a file
		li $v0, 15      
		 # File descriptor                
		move $a0, $s0                   
		move $a1,$s7  
		li $a2,7            
		syscall   
		
		#Write a new line to the file
		 # syscall code for writing to a file
		li $v0, 15      
		 # File descriptor                
		move $a0, $s0           
		la $a1,newLine    
		li $a2,1             
		syscall                        

		# Close the file
		li $v0, 16                       # syscall code for closing a file
		move $a0, $s0                    # File descriptor
		syscall                          # Close the file
		
		addi $v1,$v1,1	
	done9:
		# Branch to notFound if $t7 is equal to zero
		beqz $t7,notFound
		# Branch to searchNewLine if $t0 is equal to 10(10 ASCII code for /r/n)
		beq $t0,10,searchNewLine
		beq $t0,'.',searchFullstop
		beq $t0,',',searchComma
		beq $t0,' ',searchSpace
		j continue2
		
	notFound:
		la $a0,buffer
		jal count_lines
		move $a0,$v0
		jal convert_to_hex
		
		li $v0,4
		move $a0,$t6
		syscall
		
		li $v0,4
		la $a0,match
		syscall
		
		li $v0,4
		la $a0,hex_form
		syscall
		
		li $v0,4
		la $a0,newLine
		syscall
	
		la $s4,hex_form
		la $t2,buffer4
	
	loopHex:
		lbu $t3,($s4)
		beqz $t3,addSpace
		addi $s4,$s4,1
		sb $t3,($t2)
		addi $t2,$t2,1
		j loopHex
		
	addSpace:
		la $s4,Space
		lbu $t3,($s4)
		sb $t3,($t2)
		addi $t2,$t2,1
		move $s4,$t6
	
	addword:
		lbu $t3,($s4)
		beqz $t3,addNewLine
		addi $s4,$s4,1
		sb $t3,($t2)
		addi $t2,$t2,1
		j addword
	
	addNewLine:	
		la $a0,buffer4
		la $a1,buffer6
		jal strcpy
		la $s4,newLine
		lbu $t3,($s4)
		sb $t3,($t2)
		la $s7,buffer
		la $t2,buffer4
		
	loopDic2:
		lbu $t3,($s7)
		beqz $t3,updateBuffer
		addi $s7,$s7,1
		j loopDic2
	
	updateBuffer:
		lbu $t3,($t2)
		beqz $t3,updateFile
		addi $t2,$t2,1
		sb $t3,($s7)
		addi $s7,$s7,1
		j updateBuffer
	updateFile:	
		#append the word to the uncompressed file
		li $v0,13
		la $a0,fileName
		li $a1, 9
		 # Mode parameter not used (set to 0)                   
		li $a2, 0                       
		syscall
		
		 # Save the file descriptor for later use
		move $s0, $v0                        
    	
		#Write the contents of buffer3 to the file
		 # syscall code for writing to a file
		li $v0, 15      
		 # File descriptor                
		move $a0, $s0                   
		la $a1,buffer6
		li $a2,32            
		syscall   
		
		#Write a new line to the file
		 # syscall code for writing to a file
		li $v0, 15      
		 # File descriptor                
		move $a0, $s0           
		la $a1,newLine    
		li $a2,1             
		syscall                        

		# Close the file
		li $v0, 16                       
		move $a0, $s0                    
		syscall                          
		
		la $a0,buffer4
		jal clear_string
		
		la $a0,buffer6
		jal clear_string
		
		la $a1,hex_form
		j writeOncomp	
									
		beq $t0,10,searchNewLine
		beq $t0,'.',searchFullstop
		beq $t0,',',searchComma
		beq $t0,' ',searchSpace
		
		j continue2
		
	searchNewLine:	
		la $a0,newlineComp
		lbu $t0,($s2)
		addi $s2,$s2,1
		j searchForCom
		
	searchSpace:	
		
		la $a0,space
		lbu $t0,($s2)
		addi $s2,$s2,1
		j searchForCom
		
	searchFullstop:
		la $a0,fullstopp
		lbu $t0,($s2)
		addi $s2,$s2,1
		j searchForCom
		
	searchComma:
		la $a0,comaa
		lbu $t0,($s2)
		addi $s2,$s2,1
		j searchForCom

#--------------------------------------------------------------------------------------------------------

convert_to_hex:
	# Allocate space on the stack for the temporary address
	addi $sp, $sp, -4  
	# Save the return address on the stack   
	sw $ra, ($sp)         
        	 # Move the input number to $t0
        	move    $t7, $a0          
        # Initialize a counter for 4 hexadecimal digits (excluding "0x")
	li      $t5, 5   
	# Initialize a counter for hex_form         
	li      $t2, 0             
        
	# Loop to convert the number to hexadecimal digits
	convert_loop:
	# Divide $t0 by 16 to obtain the quotient and remainder
		div     $t7, $t7, 16  
		# Move the remainder to $t3     
		mfhi    $t3                
        
		#Convert the remainder to a hexadecimal digit
		# Convert $t3 to a positive value
		add     $t3, $t3, $zero    
		subi $s7,$t3,9
		subi $t9,$t3,16
		bgtz $s7,greater
		addiu $t3,$t3,48
		j complete
		greater:
			bltz $t9,less
			j complete
		less:
			addiu $t3,$t3,55
        
	complete:	
		# Store the ASCII value in hex_form
		sb      $t3, hex_form($t5) 
        	 # Decrement the counter
		subi    $t5, $t5, 1       
      		# If the counter is greater than zero, go to convert_loop
		bgtz    $t5, convert_loop  
    	li $t5,0x78
    	li $t7,1
    	sb $t5,hex_form($t7)
    	# Restore $ra from the stack	    
    	lw      $ra, 0($sp)  
    	# Deallocate the stack space      	
    	addi    $sp, $sp, 4      	  
        
    	jr      $ra
    	
    	
    	
#------------------------------------------------------------
#count number of char
# countCharacters - Takes the address of a file content in $a0 and 
#returns the number of characters in $t2
countCharacters:
	# Move the address of the filee to $t1
    	move $t1, $a0  
    	# Initialize register $t2 to store the character count                         
   	 move $t2, $zero                         

	count_loop:
	        	# Load a character from memory
    		lb $t3, ($t1)
    		# If the character is zero, end the loop                          
    		beqz $t3, count_end                     
		# Increment the character count
    		addi $t2, $t2, 1  
    		# Move to the next character                      
    		addi $t1, $t1, 1
    		# Jump to the next iteration                        
   		 j count_loop                        

	count_end:
		move $v0,$t2
 	  	 jr $ra     

#--------------------------------------------------------------------------------------------------------
#copy of a string it address stored in $a0 
#to a string its address stored in $a1
strcpy:
	loopCopy:
		lbu $t3,($a0)
		beqz $t3,addNull
		addi $a0,$a0,1
		sb $t3,($a1)
		addi $a1,$a1,1
		j loopCopy
		
	addNull:
		#add null terminater to the end of the string
		sb $zero,($a1)
		jr $ra
		
#------------------------------------------------------------------------------------------------
