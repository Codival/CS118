#Name: Amuldeep Dhillon, Arlan Prado
#Purpose: Learn to use extern to allow inputs and outputs
#Inputs: Any positive inpber
#Outputs: The square root of the inpber

.extern _getDouble          #receives the double after prompting the user
.extern _printString        #prints a string that was pushed onto the system stack
.extern _printFloat        #prints a double that was pushed onto the system stack

.data

inpPrompt: .ascii "Please input Number: \0"
rootPrompt: .ascii "Your Square Root is: \0"

div2: .float 2.0            # 2, to be stored in the fpu stack
inp: .float 0.0             # the input from the user
guess: .float 0.0           # the guess the computer makes
rootOld: .float 0.0         # the previous rootNew
rootNew: .float 0.0         # the most recent calculated root
error: .float 0.00000000001          # the error range we want to be in

.text
.globl _asmMain, _root, _guess
_asmMain:
push %ebp
movl %esp, %ebp

finit

push $inpPrompt      #pushes string to system stack to be printed by _printString
call _printString
addl $4, %esp           #clears stack

call _getDouble         #gets the user's input number and puts it in the system and FPU stack
                        #st(0) = input

fst inp                 #store the input into variable "inp"

movl inp, %eax
cmp $0, %eax
je exit
movl $0, %eax

#calculate the "guess", guess = inp(radicand) / 2

fstp guess            
flds div2
flds guess
fdivp
fsts guess

babylonian:

calll _root             #root = inp/guess
flds error
flds rootNew            #load rootNew
flds rootOld            #load rootOld, (the previous rootNew)
fsubp                   
fabs
fcomi                   #compare the difference of rootNew and rootOld
jb exit                 #if the difference is less than 0.01 error, then jump out of algorithm
movl rootNew, %eax      #if the error margin is greater than 0.01, keep going
movl %eax, rootOld      #rootNew is now rootOld
calll _guess            #guess = (guess + rootOld) / 2
jmp babylonian

exit:
push $rootPrompt      
call _printString       
addl $4, %esp           #prints the root prompt and empties the system stack

pushl rootNew+4
pushl rootNew
call _printFloat
addl $8, %esp           #prints the root and empties the system stack


pop %ebp
ret                     #clear stack
####################################################

_root:
pushl %ebp
movl %esp,%ebp

flds inp            #load inp 
fdivp               #divide inp by guess
fstp rootNew        #the new value is the rootNew

pop %ebp
retl

_guess:
pushl %ebp
movl %esp, %ebp

finit               #clear fpu stack
flds div2           #load 2
flds guess          
flds rootOld
faddp               #add guess & rootOld and stores in st(1) then pop st(0) so st(1) is now st(0) 
fdivp               #divide st(0) by st(1) (= 2)
fsts guess          #store the new value in guess

pop %ebp
retl


