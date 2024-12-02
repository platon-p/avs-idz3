.macro strlen(%str, %res)
    mv a0 %str
    jal strlen
    mv %res a0
.end_macro 

.macro read_str(%dest, %size)
    li a7 8
    mv a0 %dest
    mv a1 %size
    ecall
.end_macro

.macro drop_trailing_sym(%str)
    addi sp sp -4
    sw s0 (sp)
    mv s0 %str
    
    jal strlen
    add t0 s0 a0
    addi t0 t0 -1
    sb zero (t0)
    
    lw s0 (sp)
    addi sp sp 4
.end_macro 

.macro itoa(%int, %buff)
    li t0 0
    li t1 10
    
    begItoa1:
    blez %int endItoa1
    rem t2 %int t1 # t2 = num % 10
    div %int %int t1 # num //= 10
    addi t2 t2 '0'
    addi sp sp -1
    addi t0 t0 1
    sb t2 (sp)
    j begItoa1
    endItoa1:
    
    begItoa2:
    blez t0 endItoa2
    lb t1 (sp)
    addi sp sp 1
    sb t1 (%buff)
    addi %buff %buff 1
    addi t0 t0 -1
    j begItoa2
    endItoa2:
    sb zero (%buff)
.end_macro 

.text
j endStr
strlen: # a0 = str, a0 = len(str)
    li t0 0 # res
    begLen:
    lb t1 (a0)
    beqz t1 endLen
    addi t0 t0 1
    addi a0 a0 1
    j begLen
    endLen:
    mv a0 t0
    ret
endStr:
