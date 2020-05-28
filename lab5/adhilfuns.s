#NAME:      A. Dhillon
#PURPOSE:   To learn how to write and use functions while also using
#           string instructions

#INPUT:     2 strings that we will be analyzing
#           3 consonants that we will be searching for

#OUTPUT:    The count for the 3 consonants in each string, and total
#           The count of unique characters in each string, and total

#DATA SECTION
.data
count1A: .long 0        #count of first searched letter in string1
count1B: .long 0        #count of second searched letter in string1
count1C: .long 0        #count of third searched letter in string1
count2A: .long 0        #count of first searched letter in string2
count2B: .long 0        #count of second searched letter in string2
count2C: .long 0        #count of third searched letter in string2
countTA: .long 0        #count of first searched letter in total
countTB: .long 0        #count of second searched letter in total
countTC: .long 0        #count of third searched letter in total
unique1: .long 0        #count of unique characters in string1
unique2: .long 0        #count of unique characters in string2
uniqueT: .long 0        #count of unique characters in total
locate: .long 0         #variable used as a index when needed
searchC: .ascii "lnp\0" #a string with the 3 characters we want to search


letterCount1: .int 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
#array with count of each letter from a-z in string1
letterCount2: .int 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
#array with count of each letter from a-z in string1
letterCountT: .int 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
#array with count of each letter from a-z in total

#the strings we want to search through
string1: .ascii "My reach is Global, My Power is Pure\0"
.equ len1, (.-string1)
string2: .ascii "But we're too damn sober, for Mistakes Like This\0"
.equ len2, (.-string2)

#INSTRUCTIONS SECTION
.text
.globl _start, _lower, _count
_start:

leal string1, %esi              #string1 is put in esi
leal string1, %edi              #string1 is put in edi
cld                             #clear direction flag to go left to right
pushl locate                    #push index of 0 to stack
calll _lower                    #calls _lower function
addl $4, %esp                   #clears the stack



movl $0, %eax                   #reset eax for safety
movl $0, %ebx                   #reset ebx for safety

movl $'a', %ebx                 #places 'a' into ebx
movb %bl, %al                   #places 'a' into al
subl $'a', %ebx                 #turn ebx into index for count array


pushl $string1                  #pushes string1 array address to stack
pushl $len1                     #pushes length of string1 to stack
pushl $letterCount1             #pushes count array address to stack
calll _count                    #calls count function
addl $12, %esp                  #clears stack


pushl locate                    #pushes zero index into stack
calll _lower                    #calls lower but with string2 now
addl $4, %esp                   #clears the stack


movl $'a', %ebx                 #places 'a' into ebx
movb %bl, %al                   #places 'a' into al
subl $'a', %ebx                 #turns ebx into index for count array

pushl $string2                  #pushes string2 array to stack
pushl $len2                     #pushes length of string2 to stack
pushl $letterCount2             #pushes count array to stack
calll _count                    #calls count function
addl $12, %esp                  #clear stack

movl $0, %eax                   #resets eax
pushl $letterCount1             #pushes first count array into stack
calll _answer                   #calls _answer function
addl $4, %esp                   #clears stack
movl %edx, count1A              #saves count1A
movl %ecx, count1B              #saves count1B
movl %ebx, count1C              #saves count1C

movl $0,%eax                    #resets eax
pushl $letterCount2             #pushes first count array into stack
calll _answer                   #calls _answer function
addl $4, %esp                   #clears stack
movl %edx, count2A              #saves count2A
movl %ecx, count2B              #saves count2B
movl %ebx, count2C              #saves count2C

addl count1A, %edx              #adds count1A and count2A into edx
addl count1B, %ecx              #adds count1B and count2B into ecx
addl count1C, %ebx              #adds count1C and count2C into ebx

movl %edx, countTA              #saves countTA
movl %ecx, countTB              #saves countTB
movl %ebx, countTC              #saves countTC

push $letterCount1              #pushes letterCount1 to stack
calll _unique                   #calls _unique function
addl $4, %esp                   #clear stack
movl %ecx, unique1              #saves unique1

push $letterCount2              #pushes letterCount2 to stack
calll _unique                   #calls _unique function
addl $4, %esp                   #clear stack
movl %ecx, unique2              #saves unique2

push $letterCountT              #pushes letterCountT to stack
calll _unique                   #calls _unique function
addl $4, %esp                   #clear stack
movl %ecx, uniqueT              #saves uniqueT


done:
mov $1, %eax #this is the linux kernal command
             #to exit a program
             
mov $0, %ebx #sets the value in the memory register ebx to 0

int $0x80    #this sends an interrupt message to the processor
             #to run as indicated by the value in eax




_lower:
    pushl %ebp                  #function prologue
    movl %esp, %ebp
    
    movl 8(%ebp), %ebx          #puts zero index into ebx
lower:
    lodsb                       #takes first character of string into al
    cmp $0, %al                 #check if al is the end of string
    je exit1                    #if it is we exit
    orb $32, %al                #otherwise lower case it
    movb %al, (%edi,%ebx,1)     #put it back into the array
    incl %ebx                   #increment the index
    jmp lower                   #go back repeat until it reaches the end

exit1:
    pop %ebp                    #function epilogue
    retl




_count:
    pushl %ebp                  #function prologue
    movl %esp, %ebp

mov 8(%ebp), %edx               #move count array to edx
reset:
mov 16(%ebp), %edi              #move string to edi
movl 12(%ebp), %ecx             #move string's length to ecx
cld                             #clear direction flag for safety
search:
repne scasb                     #scan string for letters of alphabet
jz incr                         #if found we go to incr
jmp nextLetter                  #otherwise we move onto the next letter
                                #in the alphabet
incr:
incl (%edx,%ebx,4)              #increments the appropriate index for string count
pushl %ecx                      #saves ecx into stack
leal letterCountT, %ecx         #save total letter count array to ecx
incl (%ecx,%ebx,4)              #increments the appropriate index for total count
popl %ecx                       #restore ecx to previous value
jmp search                      #continue searching string

nextLetter:
incb %al                        #increment letter of alphabet
incl %ebx                       #increment count array index
cmp $'{', %al                   #check if at the end of alphabet if it is
jne reset                       #not then we restart search with new letter
                                #if it is the end we exit function
pop %ebp                        #function epilogue
retl




_answer:
    pushl %ebp                      #function prologue
    movl %esp, %ebp


mov 8(%ebp), %edx                   #saves counter array into edx
movl $3, %ecx                       #set counter to 3 since 3 searches
leal searchC, %esi                  #could use another length for flexibility
cld                                 #saves search characters to esi and
repeat:                             #clear direction flag
lodsb                               #saves string letter into al
subl $'a', %eax                     #turn al into index for count array
movl (%edx,%eax,4), %ebx            #goes to count array and saves the 
pushl %ebx                          #respetive value into ebx and pushes
loop repeat                         #to stack to save at the end

exit3:
    pop %ebx                        #save third chracter count to ebx
    pop %ecx                        #save second chracter count to ebx
    pop %edx                        #save first chracter count to ebx
    pop %ebp                        #function epilogue
    retl

_unique:
    push %ebp                       #function prologue
    movl %esp, %ebp

movl $0, %eax                       #reset eax "the index"
movl $0, %ecx                       #resets ecx "the counter"
mov 8(%ebp), %esi                   #moves count array to esi
look:
movl (%esi,%eax,4), %ebx            #move a count value into ebx
cmp $0, %ebx                        #checks if ebx is zero
je notFound                         #if it is then that character does
incl %ecx                           #not appear and we move to next count
notFound:                           #it it is not zero that letter appears
incl %eax                           #so it increments the counter
cmp $25, %eax                       #check if index is above 25 it it is
ja exit4                            #then we stop other wise move to next
jmp look                            #letter count in the count array

exit4:
    pop %ebp                        #function epilogue
    retl

.end
#END OF PROGRAM for A. Dhillon's function lab program

