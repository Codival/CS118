#NAME:      A. Dhillon
#PURPOSE:   simple program to try out basic asm
#           and the Gnnu Debugger (gdb)

#INPUT:     NONE

#OUTPUT:    returns a status code which can be
#           checked by using gdb

#VARIABLES: %eax holds the system call number
#           %ebx holds the return status


#DATA SECTION . NONE TO DECLARE
.data

#INSTRUCTIONS SECTION
.text
.globl _start
_start:

mov $1, %eax #this is the linux kernal command
             #to exit a program
             
mov $0, %ebx #sets the value in the memory register ebx to 0

int $0x80    #this sends an interrupt message to the processor
             #to run as indicated by the value in eax

#END OF PROGRAM for A. Dhillon's gdbtest lab program
