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
locate: .long 0              #current index location
search: .byte 'h'           #The constant we are searching for


stringA: .ascii "Helicopters fly over the beach , same time everyday, same routine\0"
stringB: .ascii "With the holograms beside me, I'll dance alone tonight\0"

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
mov search, %al                 #set %al to search value
orb $32, %al                    #lowercase search value just in case
searchA:                        #now we look through A
    mov locate, %esi
    movb (%ecx,%esi,1), %bl     #we parse through the array placing 
    cmp $0, %bl                 #each letter in bl and making sure its 
    je resetB                   #not null, if it is we exit
    cmp %al, %bl                #now we check if the letter is the search
    je incsA                    #if not we go to the next letter and loop
    incl locate                 #if it is then increse search counter
    jmp searchA                 #go to next letter and loop back
    incsA:
        incl searchAv
        incl locate
        jmp searchA
    
    
    
resetB:
    movl $0, locate             #THIS SECTION REPEATS THE LAST BUT FOR ARRAY B
mov search, %bl                 #set %bl to search value
orb $32, %bl                    #lowercase search value just in case
searchB:                        #now we look throught B
    mov locate, %esi
    movb (%edx,%esi,1), %al     #we parse through the array placing
    cmp $0, %al                 #each letter in al and making sure its
    je searchT                  #not null, if it is we exit
    cmp %bl, %al                #now we check if the letter is the search
    je incsB                    #if not we go to the next letter and loop
    incl locate                 #if it is then increse search counter
    jmp searchB                 #go to next letter and loop back
    incsB:
        incl searchBv
        incl locate
        jmp searchB

searchT:                        #resets back to start of array
    movl $0, locate             #adds the two totals together
    mov searchAv, %esi
    add searchBv, %esi
    mov %esi, searchTotal
    

movb $'a', %al                  #places 'a' into al similiar to placing search
aSearchA:                       #THIS SECTION IS THE SAME AS THE SEARCH
    mov locate, %esi            #THROUGH ARRAY A
    movb (%ecx,%esi,1), %bl     #BUT INSTEAD OF A SEARCH VARIABLE IT IS
    cmp $0, %bl                 #HARDCODED TO LOOK FOR 'a'
    je resetEA
    cmp %al, %bl
    je incaVowelA
    incl locate
    jmp aSearchA
    incaVowelA:
        incl aVowelA
        incl locate
        jmp aSearchA

resetEA:                        #resets back to start of array
movl $0, locate
movb $'e', %al
eSearchA:                       #THIS SECTION IS THE SAME AS THE LAST
    mov locate, %esi            #BUT WITH 'e' INSTEAD OF 'a'
    movb (%ecx,%esi,1), %bl
    cmp $0, %bl
    je resetIA
    cmp %al, %bl
    je inceVowelA
    incl locate
    jmp eSearchA
    inceVowelA:
        incl eVowelA
        incl locate
        jmp eSearchA
        
        
        
resetIA:                        #resets back to start of array
movl $0, locate                 
movb $'i', %al
iSearchA:                       #THIS SECTION IS THE SAME AS THE LAST
    mov locate, %esi            #BUT WITH 'i' INSTEAD OF 'e'
    movb (%ecx,%esi,1), %bl
    cmp $0, %bl
    je resetOA
    cmp %al, %bl
    je inciVowelA
    incl locate
    jmp iSearchA
    inciVowelA:
        incl iVowelA
        incl locate
        jmp iSearchA


resetOA:                        #resets back to start of array
movl $0, locate
movb $'o', %al
oSearchA:                       #THIS SECTION IS THE SAME AS THE LAST
    mov locate, %esi            #BUT WITH 'o' INSTEAD OF 'i'
    movb (%ecx,%esi,1), %bl
    cmp $0, %bl
    je resetUA
    cmp %al, %bl
    je incoVowelA
    incl locate
    jmp oSearchA
    incoVowelA:
        incl oVowelA
        incl locate
        jmp oSearchA


resetUA:                        #resets back to start of array
movl $0, locate
movb $'u', %al
uSearchA:                       #THIS SECTION IS THE SAME AS THE LAST
    mov locate, %esi            #BUT WITH 'u' INSTEAD OF 'o'
    movb (%ecx,%esi,1), %bl
    cmp $0, %bl
    je resetAB
    cmp %al, %bl
    je incuVowelA
    incl locate
    jmp uSearchA
    incuVowelA:
        incl uVowelA
        incl locate
        jmp uSearchA




resetAB:                        #resets back to start of array
    movl $0, locate             
    movb $'a', %bl
aSearchB:                       #THIS SECTION IS THE SAME AS THE LAST
    mov locate, %esi            #BUT THROUGH B AND WITH 'a' INSTEAD OF 'u'
    movb (%edx,%esi,1), %al
    cmp $0, %al
    je resetEB
    cmp %bl, %al
    je incaVowelB
    incl locate
    jmp aSearchB
    incaVowelB:
        incl aVowelB
        incl locate
        jmp aSearchB

resetEB:                        #resets back to start of array
movl $0, locate
movb $'e', %bl
eSearchB:                       #THIS SECTION IS THE SAME AS THE LAST
    mov locate, %esi            #BUT WITH 'e' INSTEAD OF 'a'
    movb (%edx,%esi,1), %al
    cmp $0, %al
    je resetIB
    cmp %bl, %al
    je inceVowelB
    incl locate
    jmp eSearchB
    inceVowelB:
        incl eVowelB
        incl locate
        jmp eSearchB
        
        
        
resetIB:                        #resets back to start of array
movl $0, locate
movb $'i', %bl
iSearchB:                       #THIS SECTION IS THE SAME AS THE LAST
    mov locate, %esi            #BUT WITH 'i' INSTEAD OF 'e'
    movb (%edx,%esi,1), %al
    cmp $0, %al
    je resetOB
    cmp %bl, %al
    je inciVowelB
    incl locate
    jmp iSearchB
    inciVowelB:
        incl iVowelB
        incl locate
        jmp iSearchB


resetOB:                        #resets back to start of array
movl $0, locate
movb $'o', %bl
oSearchB:                       #THIS SECTION IS THE SAME AS THE LAST
    mov locate, %esi            #BUT WITH 'o' INSTEAD OF 'i'
    movb (%edx,%esi,1), %al
    cmp $0, %al
    je resetUB
    cmp %bl, %al
    je incoVowelB
    incl locate
    jmp oSearchB
    incoVowelB:
        incl oVowelB
        incl locate
        jmp oSearchB


resetUB:                        #resets back to start of array
movl $0, locate
movb $'u', %bl
uSearchB:                       #THIS SECTION IS THE SAME AS THE LAST
    mov locate, %esi            #BUT WITH 'u' INSTEAD OF 'o'
    movb (%edx,%esi,1), %al
    cmp $0, %al
    je totalVowels
    cmp %bl, %al
    je incuVowelB
    incl locate
    jmp uSearchB
    incuVowelB:
        incl uVowelB
        incl locate
        jmp uSearchB

totalVowels:                    #add the two vowels counts together
mov aVowelA, %esi               #add the two 'a' counts together
add aVowelB, %esi
mov %esi, aTotal

mov eVowelA, %esi               #add the two 'e' counts together
add eVowelB, %esi
mov %esi, eTotal

mov iVowelA, %esi               #add the two 'i' counts together
add iVowelB, %esi
mov %esi, iTotal

mov oVowelA, %esi               #add the two 'o' counts together
add oVowelB, %esi
mov %esi, oTotal

mov uVowelA, %esi               #add the two 'u' counts together
add uVowelB, %esi
mov %esi, uTotal


resetUqA:                       #resets back to start of array
    movl $0, locate
    movb $'a', %al              #place first letter of alphabet into al
uniqueA:                        #compares each character to alphabet
    cmp $'z', %al               #make sure we haven't gone past 'z'
    ja resetUqB                 #if we have move on to next section
    mov locate, %esi            #move letter in string to bl
    mov (%ecx,%esi,1), %bl
    cmp $0, %bl                 #make sure we haven't reached the end
    je notUniqueA               #if we have then that the alphabetical letter
    cmp %al,%bl                 #did not appear so we go to notUniueA
    je isUniqueA                #otherwise compare the alphabetical letter to the string
    incl locate                 #if it does match then it is unique so we go to isUniqueA
    jmp uniqueA                 #if it is not the end and it does not match we move on and loop
    notUniqueA:                 #so if we reach the end of the string that letter in the alphabet
        movl $0, locate         #did not appear in the string once so we just go back to the start
        inc %al                 #of the string and move on to the next letter of the alphabet
        jmp uniqueA             #and then loop
    isUniqueA:                  #if the alphabetical letter does appear
        incl uniqueAv           #we increase the counter, move back to the 
        movl $0, locate         #start of the string, move on to the next
        inc %al                 #letter in the alphabet and loops back
        jmp uniqueA



resetUqB:                       #resets back to start of array
    movl $0, locate
    movb $'a', %bl
uniqueB:                        #THIS SECTION IS THE SAME AS THE PREVIOUS
    cmp $'z', %bl               #BUT GOES THROUGH B INSTEAD OF A
    ja resetUqT
    mov locate, %esi
    mov (%edx,%esi,1), %al
    cmp $0, %al
    je notUniqueB
    cmp %bl,%al
    je isUniqueB
    incl locate
    jmp uniqueB
    notUniqueB:
        movl $0, locate
        inc %bl
        jmp uniqueB
    isUniqueB:
        incl uniqueBv
        movl $0, locate
        inc %bl
        jmp uniqueB

resetUqT:                       #resets back to start of array
    movl $0, locate
    movb $'a', %al
uniqueTA:                       #THIS SECTION IS LOGICALLY THE SAME
    cmp $'z', %al               #BUT IT IGNORES THE FIRST NULL CHARACTER
    ja done                     #AND JUST CONTINUES ON TO B BEFORE MOVING
    mov locate, %esi            #ON TO THE NEXT LETTER IN THE ALPHABET
    mov (%ecx,%esi,1), %bl
    cmp $0, %bl
    je nextString
    cmp %al,%bl
    je isUniqueTA
    incl locate
    jmp uniqueTA
    notUniqueTA:
        movl $0, locate
        inc %al
        jmp uniqueTA
    isUniqueTA:
        incl uniqueTotal
        movl $0, locate
        inc %al
        jmp uniqueTA

nextString:
    movl $0, locate
uniqueTB:
    mov locate, %esi
    mov (%edx,%esi,1), %bl
    cmp $0, %bl
    je notUniqueTB
    cmp %al, %bl
    je isUniqueTB
    incl locate
    jmp uniqueTB
    notUniqueTB:
        movl $0, locate
        inc %al
        jmp uniqueTA
    isUniqueTB:
        incl uniqueTotal
        movl $0, locate
        inc %al
        jmp uniqueTA


done:
mov $1, %eax #this is the linux kernal command
             #to exit a program
             
mov $0, %ebx #sets the value in the memory register ebx to 0

int $0x80    #this sends an interrupt message to the processor
             #to run as indicated by the value in eax

.end

#END OF PROGRAM for A. Dhillon's array lab program
