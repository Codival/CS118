#NAME:      A. Dhillon
#PURPOSE:   A program to take string arrays and search for specific 
#           characters among those strings, along count unique characters
#           and vowels

#INPUT:     String Arrays

#OUTPUT:    number of certains letter, number of vowels
#           number of unique letters

#VARIABLES: 


#DATA SECTION:
.data
asciiForA: .byte $97

arrayA: .long 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
arrayB: .long 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
arrayAB: .long 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

locate: .long 0              #current index location
search: .byte 'l'           #The constant we are searching for


stringA: .ascii "I ain't happy, I'm feeling glad\0"
stringB: .ascii "Windmill for the land, turn forever, hand in hand\0"

searchAv: .long 0 #the number of seached constants in string A
searchBv: .long 0 #the number of seached constants in string B
searchTotal: .long 0 #sum of searchA and searchB


aVowelA: .long 0 #number of 'a' in array A
eVowelA: .long 0 #number of 'e' in array A
iVowelA: .long 0 #number of 'i' in array A
oVowelA: .long 0 #number of 'o' in array A
uVowelA: .long 0 #number of 'u' in array A


aVowelB: .long 0 #number of 'a' in array B
eVowelB: .long 0 #number of 'e' in array B
iVowelB: .long 0 #number of 'i' in array B
oVowelB: .long 0 #number of 'o' in array B
uVowelB: .long 0 #number of 'u' in array B

aTotal: .long 0 #total number of 'a'
eTotal: .long 0 #total number of 'e'
iTotal: .long 0 #total number of 'i'
oTotal: .long 0 #total number of 'o'
uTotal: .long 0 #total number of 'u'

uniqueAv: .long 0 #number of unique characters in array A
uniqueBv: .long 0 #number of unique characters in array B
uniqueTotal: .long 0 #number of unique characters among array A and B

#INSTRUCTIONS SECTION:
.text
.globl _start
_start:


lea stringA, %ecx       #copying the array A into ecx
lea stringB, %edx       #copying the array B into edx
mov $0, %eax            #resting eax and ebx
mov $0, %ebx            #just to be safe

lowerA:                         #This lower cases all the letters in
    mov locate, %esi            #array A
    mov (%ecx, %esi, 1), %al    #we place the each letter into al starting
    cmp $0, %al                 #from the first all the way to null
    je reset                    #when we reach the end of the string
    incl locate                 #we exit otherwise we increment locate now
    orb $32, %al                #since we know al is not null we can 
    cmp $97, %al                #lowercase it and make sure it is within
    jb lowerA                   #the ascii range for 'a' - 'z'
    cmp $122, %al               #if it is we put it into the array
    ja lowerA                   #if not we move on without changing it
    movb %al, (%ecx, %esi, 1)   #loop until you reach the end of string
    jmp lowerA

reset:
    movl $0, locate             #reset the location to the beginning
                                #THIS SECTION REPEATS THE LAST BUT FOR ARRAY B
lowerB:                         #This lower cases all the letters in
    mov locate, %esi            #array b
    mov (%edx, %esi, 1), %bl    #we place the each letter into al starting
    cmp $0, %bl                 #from the first all the way to null
    je resetA                   #when we reach the end of the string
    incl locate                 #we exit otherwise we increment locate now
    orb $32, %bl                #since we know al is not null we can
    cmp $97, %bl                #lowercase it and make sure it is within
    jb lowerB                   #the ascii range for 'a' - 'z'
    cmp $112, %bl               #if it is we put it into the array
    ja lowerB                   #if not we move on without changing it
    movb %bl, (%edx, %esi, 1)   #loop until you reach the end of string
    jmp lowerB

resetA:                         #move back to the start of the array
    movl $0, locate
    movb 'a', %al

countingA:
    cmp 'z', %al
    ja done
    lea stringA, %ecx
    movl $97, asciiForA
    movl locate, %esi
    mov (%ecx, %esi, 1), %bl
    cmp $0, %bl
    je endOfStringA
    cmp %al, %bl
    je appearsInA
    jne nextLetterA
    appearsInA:
        sub %al, asciiForA
        negl asciiForA
        mov asciiForA, %edi
        lea arrayA, %ecx
        incl (%ecx, %edi, 1)
        incl locate
        jmp countingA
    nextLetterA:
        incl locate
        jmp countingA
    endOfStringA:
        movl $0, locate
        inc %al
        jmp countingA




done:
lea arrayA, %ecx
mov $0, %eax
movl (%ecx, %eax, 1), %edx

mov $1, %eax #this is the linux kernal command
             #to exit a program
             
mov $0, %ebx #sets the value in the memory register ebx to 0

int $0x80    #this sends an interrupt message to the processor
             #to run as indicated by the value in eax

.end

#END OF PROGRAM for A. Dhillon's array lab program
