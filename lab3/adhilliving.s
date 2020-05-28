#NAME:      A. Dhillon
#PURPOSE:   simple program to calculate annual
#           cost based on weekly and monthly rate

#INPUT:     Monthly rent, weekly food and 
#           transportation cost, term cost
#           and misc. costs

#OUTPUT:    total annual cost

#VARIABLES: rent is monthly rent
#           fAndE is food and transportation
#           edu is term cost
#           inc is misc. cost
#           total is total cost
#           %eax,%ebx,%ecx,%edx hold various
#           variable amounts


#DATA SECTION:
.data
rent: .int 500 #montly rent
fAndE: .int 75 #weekly food and trans.
edu: .int 200  #term cost
inc: .int 300  #misc.
total: .int 0  #total price

#INSTRUCTIONS SECTION:
.text
.globl _start
_start:

movl rent, %eax # multiply rent
imul $12, %eax  # by 12 for year

movl fAndE, %ebx #multiply food
imul $52, %ebx   #by 52 for year

movl edu, %ecx   #multiply by 3
imul $3, %ecx

movl inc, %edx  #simply store inc

add %eax, %ebx  #add all of them
add %ebx, %ecx  #together by using
add %ecx, %edx  # registry addition

movl %edx, total #tranfer total to
                 # variable total

mov $1, %eax #this is the linux kernal command
             #to exit a program
             
mov $0, %ebx #sets the value in the memory register ebx to 0

int $0x80    #this sends an interrupt message to the processor
             #to run as indicated by the value in eax

.end

#END OF PROGRAM for A. Dhillon's living lab program
