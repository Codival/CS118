
















































#NAME:      A. Dhillon
#PURPOSE:   To learn how to write and use functions while also using
#           string instructions

#INPUT:     2 strings that we will be analyzing
#           3 consonants that we will be searching for

#OUTPUT:    The count for the 3 consonants in each string, and total
#           The count of unique characters in each string, and total

#REQUI.:    Search 3 consonants and give counts individual and total
#           unique count individual and total
#           2 string instructions
#           1 function
#DATA SECTION
.data
count1A: .long 0
count1B: .long 0
count1C: .long 0
count2A: .long 0
count2B: .long 0
count2C: .long 0
unique1: .long 0
unique2: .long 0
locate: .long 0
searchC: .ascii "abc\0"


letterCount1: .int 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
letterCount2: .int 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
letterCountT: .int 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


string1: .ascii " a b c a q\0"
.equ len1, (.-string1)
string2: .ascii "Windmill for the LAND, TRUN forever, hand IN hand\0"
.equ len2, (.-string2)

#INSTRUCTIONS SECTION
.text
.globl _start, _lower, _count
_start:

leal string1, %esi
leal string1, %edi
cld
pushl locate
calll _lower
addl $4, %esp



movl $0, %eax
movl $0, %ebx

movl $'a', %ebx
movb %bl, %al
subl $'a', %ebx

pushl $string1
pushl $len1
pushl $letterCount1
calll _count
addl $8, %esp















done:
mov $1, %eax #this is the linux kernal command
             #to exit a program
             
mov $0, %ebx #sets the value in the memory register ebx to 0

int $0x80    #this sends an interrupt message to the processor
             #to run as indicated by the value in eax




_lower:
    pushl %ebp                  #function prologue
    movl %esp, %ebp
    
    movl 8(%ebp), %ebx
lower:
    lodsb
    cmp $0, %al
    je exit1
    orb $32, %al
    movb %al, (%edi,%ebx,1)
    incl %ebx
    jmp lower

exit1:
    pop %ebp
    retl



_count:
    pushl %ebp                  #function prologue
    movl %esp, %ebp
mov 8(%ebp), %edx
reset:
mov 16(%ebp), %edi
movl 12(%ebp), %ecx
cld
search:
repne scasb
jz incr
jmp nextLetter

incr:
incl (%edx,%ebx,4)
pushl %ecx
leal letterCountT, %ecx
incl (%ecx,%ebx,4)
popl %ecx
jmp search

nextLetter:
incb %al
incl %ebx
cmp $'{', %al
jne reset

pop %ebp
retl









.end
#END OF PROGRAM for A. Dhillon's function lab program

