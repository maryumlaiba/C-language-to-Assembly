.model small
.stack 100h

.data
arrA db 2,4,6,8,10,12,14,16,18,20        ; input array A (8-bit unsigned)
arrC db 4,6,8,10,12,14,16,18,20,22       ; input array C (8-bit unsigned)
arrB db 10 dup(?)                        ; output array B

; Register plan
; SI = index i      DL = A[i]     DH = C[i]
; BL = 3 (multiplier)   BH = 2 (multiplier and divisor)
; CX = running sum of terms 1 and 2
; AX = working register for mul/div
.code
main proc
    mov  ax, @data
    mov  ds, ax

    xor  si, si             ; i = 0
    mov  bl, 3              ; constants set once, outside the loop
    mov  bh, 2

L1:
    mov  dl, arrA[si]       ; load A[i] once
    mov  dh, arrC[si]       ; load C[i] once

    ; term 1: A[i]*3 + 1
    mov  al, dl
    mul  bl                 ; AX = A[i] * 3 (16-bit, cannot overflow)
    inc  ax
    mov  cx, ax             ; CX = term 1

    ; term 2: C[i]*2 + 1
    mov  al, dh
    mul  bh                 ; AX = C[i] * 2
    inc  ax
    add  cx, ax             ; CX = term 1 + term 2
 ; term 3: (A[i] + C[i]) / 2 using unsigned div
    mov  al, dl
    add  al, dh             ; dividend low byte (max 42, fits in 8 bits)
    xor  ah, ah             ; clear AH so AX = full unsigned dividend
    div  bh                 ; AL = quotient, AH = remainder (0)

    ; combine and store
    xor  ah, ah             ; discard remainder
    add  ax, cx             ; sum of all three terms
    mov  arrB[si], al       ; result max is 127, fits in a byte

    inc  si                 ; i++
    cmp  si, 10
    jb   L1                 ; repeats while i < 10, so exactly 10 iterations

    mov  ah, 4Ch            ; exit to DOS
    int  21h
main endp
end main