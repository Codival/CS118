.data
OG: .ascii "This is a test string!!!\0\0\0"   #String has 3 null characters
                                            #to make it easy to stripe
.equ End, (.-OG)
.bss
.lcomm Disk1, End
.lcomm Disk2, End
.lcomm Disk3, End
.lcomm Parity, End
.lcomm Restripe, End

.text
.globl _start, _Justin, _Amuldeep, _unstriper, _diskUnstr
_start:
    leal OG, %edi           #move original string to edi
    movl $0, %ebx           #resets ebx
    xor %edx, %edx          #resets edx fancily
    pushl $Disk1            #push Disk1 address to the stack
    calll _Justin           #calls the Justin function
    addl $4, %esp           #resets the system stack
    movl $1, %ebx           #moves 1 into ebx
    xor %edx, %edx          #resets edx
    pushl $Disk2            #push Disk2 address to the stack
    calll _Justin           #re-calls the Justin function
    addl $4, %esp           #resets system stack
    movl $2, %ebx           #moves 2 into ebx
    xor %edx, %edx          #resets edx
    pushl $Disk3            #push Disk3 address
    calll _Justin           #call Justin function
    addl $4, %esp           #resets system stack
    
pushl $Parity               #pushes the address of the Parity
pushl $Disk3                #pushes the address of Disk3
pushl $Disk2                #pushes the address of Disk2
pushl $Disk1                #pushes the address of Disk1

calll _Amuldeep             #calls Amuldeep function

addl $16, %esp              #resets system stack


movl %edi, %ecx             #index of last letter into ecx
incl %ecx                   #increment ecx, so ecx now represets length
lea Disk1, %edi             #moves the disk to be corrupted into edi
movl $'*', %eax             #moves '*' for string store command
rep stosb                   #replaces every character in Disk with '*'

pushl $Disk1                #Disk that will be recovered
pushl $Parity               #Rest of the Disks(order irrelevant)
pushl $Disk2
pushl $Disk3

calll _Amuldeep             #Calls Amuldeep function

addl $16, %esp              #resets system stack

calll _unstriper

done:                       #Ends program
    movl $1, %eax
    movl $0, %ebx
    int $0x80




_Justin:
    push %ebp                       #Function prologue
    mov %esp, %ebp
    movl 8(%ebp), %esi              #moves Original string to esi
    moving:
        movb (%edi,%ebx,1), %al     #takes letter in index ebx into al
        cmp $0, %al                 #checks if end of string
        je finish                   #if so exit
        movb %al, (%esi,%edx,1)     #if not mov character into Disk string
        incl %edx                   #increments disk index
        addl $3, %ebx               #moves the original string index by 3
        jmp moving                  #if not repeat
    finish:                         #function epilogue
        pop %ebp
        retl

_Amuldeep:                          #xors individual letters and stores into Disk
                                    #used to make Parity and un-corrupt
    push %ebp
    movl %esp, %ebp                 #function prologue
    xor %edi,%edi                   #reset edi
    movl 8(%ebp), %eax              #moves Disks into 3 different registers
    movl 12(%ebp), %ebx
    movl 16(%ebp), %esi
    result:
        movb (%eax,%edi,1), %cl     #moves letter from first disk into cl
        movb (%ebx,%edi,1), %dl     #moves letter from second disk into cl
        xor %cl,%dl                 #xors the two letters with result in dl
        movb (%esi,%edi,1), %cl     #moves letter from thrid disk into cl
        cmp $0, %cl                 #checks if cl is the end
        je quit                     #if so exit
        xor %cl,%dl                 #if not xor the previous result and letter
        movl 20(%ebp), %ecx         #moves final Disk into ecx (Parity/corrupted disk)
        movb %dl, (%ecx,%edi,1)     #store into final Disk (Parity/corrupted disk)
        xor %ecx,%ecx               #resets ecx for next iteration
        incl %edi                   #increments final disks index
        jmp result                  #repeat
quit:
    movl 20(%ebp), %ecx             #copies last letter into final disk
    movb %dl, (%ecx,%edi,1)
    pop %ebp                        #function epilogue
    retl

_unstriper:
    push %ebp
    movl %esp, %ebp
    movl $0, %ebx       #counter for Disk 
    movl $0, %ecx       #counter for unstriper (will increment by 3 to accomodate for the 3 disks
    mov $0, %eax            # %al will carry the character
    leal Restripe, %edi
    leal Disk1, %esi

    calll _diskUnstr
    
    nextD2:
        movl $0, %ebx
        movl $1, %ecx
        leal Disk2, %esi

        calll _diskUnstr
    
    nextD3:
        movl $0, %ebx
        movl $2, %ecx
        leal Disk3, %esi
    
        calll _diskUnstr
    
    out1:
    pop %ebp
    retl

_diskUnstr:     #we functionalized this to take up less lines
    push %ebp
    movl %esp, %ebp
    
    diskU:
        movb (%esi, %ebx, 1), %al   #copy character from Disk (%esi) at index (%ebx), to %al
        cmp $0, %al                 #if %al is a null character, it is done
        je finish1                  
        movb %al, (%edi, %ecx, 1)   #put the character from %al to the Restripe lcomm
        incl %ebx                   #increment counter for Disk to next character
        addl $3, %ecx               #increment counter for Restripe by 3 for the next spot 
        jmp diskU
        
    finish1:   
    pop %ebp
    retl
