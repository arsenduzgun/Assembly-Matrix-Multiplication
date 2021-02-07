.data

Matrix1: .space 1000000
Matrix2: .space 1000000
Matrix2T: .space 1000000
ResultedMatrix: .space 1000000
Msg1: .asciiz "Please enter the row number of the first matrix : "
Msg2: .asciiz "Please enter the column number of the first matrix : "
Msg3: .asciiz "Please enter the row number of the second matrix(will be transposed) : "
Msg4: .asciiz "Please enter the column number of the second matrix(will be transposed) : "
Msg5: .asciiz "Please enter the elements of first matrix :\n"
Msg6: .asciiz "Please enter the elements of second matrix(will be transposed) :\n"
Msg7: .asciiz "Matrix1 x Matrix2(T) is :\n"
ErrorMsg: .asciiz "Error! In order to multiply two matrices, the column of the first matrix and the column of the second matrix which will be transposed must be equal."
Space: .asciiz " "
NewLine: .asciiz "\n"

.text

.globl main

main:

li $t4, 0 # counter
la $s7, ResultedMatrix # now the address of ResultedMatrix is in $s7
la $s3, Matrix1 # now the address of Matrix1 is in $s3
la $s4, Matrix2 # now the address of Matrix2 is in $s4
la $s5, Matrix2T # now the address of Matrix2Transpose is in $s5

j Matrix1Definition

Matrix1Definition:

li $v0, 4
la $a0, Msg1
syscall

li $v0, 5
syscall
move $t0, $v0 # now the number of rows of Matrix1 is in $t0

li $v0, 4
la $a0, Msg2
syscall

li $v0, 5
syscall
move $t1, $v0 # now the number of columns of Matrix1 is in $t1

mul $s0, $t0, $t1 # now the number of elements of Matrix1 is in $s0

j Matrix2Definition

Matrix2Definition:

li $v0, 4
la $a0, Msg3
syscall

li $v0, 5
syscall
move $t2, $v0 # now the number of rows of Matrix2 is in $t2

li $v0, 4
la $a0, Msg4
syscall

li $v0, 5
syscall
move $t3, $v0 # now the number of columns of Matrix2 is in $t3

mul $s1, $t2, $t3 # now the number of elements of Matrix2 is in $s1
bne $t1, $t3, Error

li $v0, 4
la $a0, Msg5
syscall

j Matrix1Implementation

Error:

li $v0, 4
la $a0, ErrorMsg
syscall

li $v0, 10
syscall

Matrix1Implementation:

beq $t4, $s0, RestoreMatrix1Address

li $v0, 5
syscall
move $t5, $v0

sw $t5, 0($s3)
addi $t4, $t4, 1
addi $s3, $s3, 4

j Matrix1Implementation

RestoreMatrix1Address:

beq $t4, $zero, Matrix2Msg
addi $t4, $t4, -1
addi $s3, $s3, -4

j RestoreMatrix1Address

Matrix2Msg:

li $v0, 4
la $a0, Msg6
syscall

j Matrix2Implementation

Matrix2Implementation:

beq $t4, $s1, RestoreMatrix2Address

li $v0, 5
syscall
move $t5, $v0

sw $t5, 0($s4)
addi $t4, $t4, 1
addi $s4, $s4, 4

j Matrix2Implementation

RestoreMatrix2Address:

beq $t4, $zero, Exit1
addi $t4, $t4, -1
addi $s4, $s4, -4

j RestoreMatrix2Address

Exit1:

sll $s6, $s1, 2 # 4 * size of matrix2(for addressing)
sll $t6, $t3, 2 # 4* column number of matrix2(for addressing)
li $t7, 0 # counter of loop1

jal Matrix2TransposeFunct

j Exit2

Matrix2TransposeFunct:

j TransposeLoop1

TransposeLoop1:

beq $t7, $t3, RestoreMatrix2TransposeAddress
addi $t7, $t7, 1
li $t8, 0 # counter of loop2

j TransposeLoop2

TransposeLoop2:

beq $t8, $t2, TransposeLoop3
lw $t5, 0($s4)
sw $t5, 0($s5)
add $s4, $s4, $t6
addi $s5, $s5, 4
addi $t8, $t8, 1

j TransposeLoop2

TransposeLoop3:

sub $s4, $s4, $s6
addi $s4, $s4, 4

j TransposeLoop1

RestoreMatrix2TransposeAddress: # now the row number of Matrix2(T) is in $t3 and the column number of Matrix2(T) is in $t2

sub $s5, $s5, $s6

li $s4, 0 # we don't need the address of Matrix2 anymore
li $t3, 0 # we no longer need the row number of Matrix2(T) because it equals to the column number of Matrix1 which is in $t1
sll $t6, $t2, 2 # 4 * column number of Matrix2(T)(for addressing)
li $s0, 0 # # we don't need the size of Matrix1 anymore
sll $s0, $t1, 2 # 4 * column number of Matrix1(for addressing)
li $s1, 0 # we don't need the size of Matrix2(T) anymore
mul $s1, $t0, $t2 # resulted Matrix size
sll $s2, $s1, 2 # 4 * size of resulted matrix(for addressing)
li $t7, 0 # counter loop1
li $t8, 0 # counter loop2

jr $ra

Exit2:

jal MatrixMultiplicationFunct

j Exit3

MatrixMultiplicationFunct:

j MultLoop1

MultLoop1:

beq $t7, $t0, RestoreResultedMatrixAddress
addi $t7, $t7, 1
li $t9, 0 # counter loop3

j MultLoop2

MultLoop2:

beq $t8, $t1, MultLoop3
lw $t3, 0($s3)
lw $t5, 0($s5)
mul $t3, $t3, $t5
add $s4, $s4, $t3
addi $s3, $s3, 4
add $s5, $s5, $t6
addi $t8, $t8, 1

j MultLoop2

MultLoop3:

sub $s5, $s5, $s6
addi $s5, $s5, 4
sw $s4, 0($s7)
li $s4, 0
addi $s7, $s7, 4
li $t8, 0
addi $t9, $t9, 1
beq $t9, $t2, RestoreMatrix2TransposeAddress2
sub $s3, $s3, $s0

j MultLoop2

RestoreMatrix2TransposeAddress2:

sub $s5, $s5, $t6

j MultLoop1

RestoreResultedMatrixAddress:

sub $s7, $s7, $s2
li $t7, 0

li $v0, 4
la $a0, Msg7
syscall

jr $ra

Exit3:

j PrintResultedMatrix

PrintResultedMatrix: # the row number of Resulted Matrix is in $ t0 and the column of Resulted Matrix is in $t2

beq $t4, $t2, PrintNewLine
lw $t5, 0($s7)

li $v0, 1
move $a0, $t5
syscall

li $v0, 4
la $a0, Space
syscall

addi $t4, $t4, 1
addi $s7, $s7, 4
addi $t7, $t7, 1
beq $t7, $s1, Exit4

j PrintResultedMatrix

PrintNewLine:

li $t4, 0

li $v0, 4
la $a0, NewLine
syscall

j PrintResultedMatrix

Exit4:

li $v0, 10
syscall












































