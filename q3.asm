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