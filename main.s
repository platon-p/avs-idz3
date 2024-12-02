.eqv BUFFER_SIZE 512
.eqv FILENAME_SIZE 512
.data
nl: .string "\n"
filename: .space FILENAME_SIZE
buff: .space BUFFER_SIZE
prompt_in_f: "Enter input file name: "
prompt_out_f: "Enter output file name: "
error_handle_file: "Cannot handle file"
ask_console: "Print to console? Y/N: "
.include "string.s"
.include "file.s"
.macro print_label(%str_addr)
    li a7 4
    la a0 %str_addr
    ecall
.end_macro

.macro solve(%str, %size, %res)
    mv a0 %str
    mv a1 %size
    jal solve
    mv %res a0
.end_macro

.macro read_and_solve(%filename, %res)
    addi sp sp -8
    sw s0 (sp)
    sw s1 4(sp)
    open_file(%filename, 0, a0) # 0 = read mode
    mv %res a0
    bltz a0 endRFS
    
    mv s0 a0 # descriptor
    li s1 0 # result
    
    loopBeg:
    la t0 buff
    li t1 BUFFER_SIZE
    read_descriptor(s0, t0, t1, a0)
    mv %res a0
    bltz a0 endRFS
    beqz a0 loopEnd
    
    la a0 buff
    li a1 BUFFER_SIZE
    jal solve # check is ra saving needed
    add s1 s1 a0
    j loopBeg
    loopEnd:
    
    close_file(s0)
    mv %res a0
    bltz a0 endRFS
    mv %res s1
    endRFS:
    lw s0 (sp)
    lw s1 4(sp)
    addi sp sp 8
.end_macro

.macro export_file(%filename, %solution)
    addi sp sp -8
    sw s0 (sp)
    sw s1 4(sp)
    mv s0 %solution
    open_file(%filename, 1, a0)
    mv s1 a0 # descriptor
    strlen(s0, t1)
    write_descriptor(s1, s0, t1, t0)
    close_file(s1)
    
    lw s0 (sp)
    lw s1 4(sp)
    addi sp sp 8 
.end_macro

.macro export_console(%solution)
    print_label(ask_console)
    li a7 12
    ecall
    li t0 'Y'
    print_label(nl)
    bne t0 a0 skip
    mv a0 %solution
    li a7 4
    ecall
    print_label(nl)
    skip:
.end_macro

.text
    print_label(prompt_in_f)
    li t1 FILENAME_SIZE
    la t0 filename
    read_str(t0, t1)
    drop_trailing_sym(a0)
    
    la a0 filename
    read_and_solve(a0, a0)
    bgez a0 solvedOk
    print_label(error_handle_file)
    j mainEnd
    solvedOk:
    # now a0 = sum of all digits in file
    
    la a1 buff
    itoa(a0, a1) # a1 = str(a0) = str(solution)
    
    print_label(prompt_out_f)
    li t1 FILENAME_SIZE
    la t0 filename
    read_str(t0, t1)
    drop_trailing_sym(a0)
    
    la s1 buff
    la a0 filename
    export_file(a0, s1)
    
    la s1 buff
    export_console(s1)
    
    mainEnd:
    li a7 10
    ecall

# a0 - str addr, a1 = size, a0 = res
solve:
    li t0 0 # t0 = res
    li t2 '0'
    li t6 9
    
    begCSS:
    beqz a1 endCSS
    lb t1 (a0)
    beqz t1 endCSS
    sub t1 t1 t2
    bgt t1 t6 skipadd # skip > '9'
    bltz t1 skipadd # skip < '0'
    add t0 t0 t1
    skipadd:
    addi a0 a0 1
    addi a1 a1 -1
    j begCSS
    endCSS:
    
    mv a0 t0
    ret
