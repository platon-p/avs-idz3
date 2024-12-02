.macro open_file(%filename, %mode, %res)
    li a7 1024 # open
    mv a0 %filename
    li a1 %mode # 0 = read mode, 1 = write mode
    ecall
    mv %res a0
.end_macro 

.macro read_descriptor(%descriptor, %buffer, %size, %res)
    li a7 63
    mv a0 %descriptor
    mv a1 %buffer
    mv a2 %size
    ecall
    mv %res a0
.end_macro

.macro write_descriptor(%descriptor, %buffer, %size, %res)
    li a7 64
    mv a0 %descriptor
    mv a1 %buffer
    mv a2 %size
    ecall
    mv %res a0
.end_macro

.macro close_file(%descriptor)
    li a7 57
    mv a0 %descriptor
    ecall
.end_macro 
