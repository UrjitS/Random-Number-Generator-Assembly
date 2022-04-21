.model small
.stack 100h

.data                                   ;Data segment (global variables)
    outputMsg db "Random Number between (0-9): $"
    randomNum db 0
.code                                   ;Code segment
main proc                               ;Start of the main procedure declaration

    mov ax, @data                       ;@data locates the addresses of the
                                        ;global variables in .data
    mov ds, ax                          ;This is basically declaring where the
                                        ;program should access the global variables

    mov ah, 09h                         ;09 is in hex, this is a DOS command code
                                        ;for writing a string to stdout
    mov dx,offset outputMsg             ;Offset gets the address of outputMsg and
                                        ;puts it in dx
    int 21h                             ;Signals DOS to write
                                        ;the string in dx to the console

    call generateRandomNumber           ;Calls a procedure named generateRandomNumber

    mov ah,02h                          ;02 is in hex, this is a DOS command code
                                        ;for writing a character to stdout
    mov dl,randomNum                    ;This moves the number stored in randomNum into dl
    add dl, '0'                         ;Adds the ASCII value of '0'=30 to randomNum
                                        ;converting the random number to ASCII
    int 21h                             ;Signals DOS to write
                                        ;the character in dl to the console

    mov ah, 4ch                         ;4c is in hex, this is a DOS command
                                        ;code for exiting the program
    mov al, 0                           ;Exit code 0 means it ended without errors
    int 21h                             ;Signals DOS to exit the program

main endp                               ;End of the main procedure declaration

generateRandomNumber proc               ;Start of the generateRandomNumber procedure declaration

    mov ah, 0h                          ;0h is in hex, this is the system clock command code for
                                        ;getting the number of clock ticks since midnight
    int 1ah                             ;Passes control to system clock, which will put the number
                                        ;of ticks into dx (low) and cx (high)

    mov ax, dx                          ;We just need the low bits stored in dx so we put it in
                                        ;ax for division
    mov dx,0                            ;In division the dividend is split into
                                        ;two registers, dx,ax. At the end we reset to 0
    mov bx,10                           ;Move 10 to bx, this way
                                        ;the remainder is between 0-9
    div bx                              ;Value in ax divided by the operand (bx)
                                        ;will store the quotient in ax and remainder in dx

    mov randomNum, dl                   ;We put dl into our global variable randomNum,
                                        ;dl is just a part of dx (the remainder between 0-9)
    ret                                 ;We return to the caller of this procedure

generateRandomNumber endp               ;End of the generateRandomNumber procedure declaration

end main                                ;This signifies the end of the program