.data
.text
Start:
addi $v0,$zero,5
syscall
srl $t1,$v0,8
andi $t1,$t1,7

addi $t2,$zero,0
beq $t1,$t2,Test0
addi $t2,$zero,1
beq $t1,$t2,Test1
addi $t2,$zero,2
beq $t1,$t2,Test2
addi $t2,$zero,3
beq $t1,$t2,Test3
addi $t2,$zero,4
beq $t1,$t2,Test4
addi $t2,$zero,5
beq $t1,$t2,Test5
addi $t2,$zero,6
beq $t1,$t2,Test6
addi $t2,$zero,7
beq $t1,$t2,Test7


Test0:
addi $v0,$zero,5
syscall
andi $t3,$v0,127
addi $t5,$t3,0

andi $t6,$t5,1
srl $t5,$t5,1
andi $t7,$t5,1
add $t6,$t6,$t7

srl $t5,$t5,1
andi $t7,$t5,1
add $t6,$t6,$t7

srl $t5,$t5,1
andi $t7,$t5,1
add $t6,$t6,$t7

srl $t5,$t5,1
andi $t7,$t5,1
add $t6,$t6,$t7

srl $t5,$t5,1
andi $t7,$t5,1
add $t6,$t6,$t7

srl $t5,$t5,1
andi $t7,$t5,1
add $t6,$t6,$t7

andi $t6,$t6,1
sll $t6,$t6,7
or $a0,$t3,$t6
addi $v0,$zero,1
syscall

j Finish

Test1:
addi $v0,$zero,5
syscall
andi $t3,$v0,255
addi $t5,$t3,0

andi $t6,$t5,1
srl $t5,$t5,1
andi $t7,$t5,1
add $t6,$t6,$t7

srl $t5,$t5,1
andi $t7,$t5,1
add $t6,$t6,$t7

srl $t5,$t5,1
andi $t7,$t5,1
add $t6,$t6,$t7

srl $t5,$t5,1
andi $t7,$t5,1
add $t6,$t6,$t7

srl $t5,$t5,1
andi $t7,$t5,1
add $t6,$t6,$t7

srl $t5,$t5,1
andi $t7,$t5,1
add $t6,$t6,$t7

srl $t5,$t5,1
andi $t7,$t5,1
add $t6,$t6,$t7

andi $t6,$t6,1
sll $t6,$t6,8
or $a0,$t3,$t6
addi $v0,$zero,1
syscall

j Finish

Test2:
addi $v0,$zero,5
syscall
andi $t3,$v0,255
sll $a0,$t3,8
addi $v0,$zero,1
syscall
#
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,4
  syscall
#
addi $v0,$zero,5
syscall
andi $t4,$v0,255

sll $a0,$t3,8
or $a0,$a0,$t4
addi $v0,$zero,1
syscall

#
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,4
  syscall
#

nor $a0,$t3,$t4
addi $v0,$zero,1
syscall
j Finish

Test3:
addi $v0,$zero,5
syscall
andi $t3,$v0,255
sll $a0,$t3,8
addi $v0,$zero,1
syscall
#
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,4
  syscall
#
addi $v0,$zero,5
syscall
andi $t4,$v0,255

sll $a0,$t3,8
or $a0,$a0,$t4
addi $v0,$zero,1
syscall

#
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,4
  syscall
#

or $a0,$t3,$t4
addi $v0,$zero,1
syscall
j Finish

Test4:
addi $v0,$zero,5
syscall
andi $t3,$v0,255
sll $a0,$t3,8
addi $v0,$zero,1
syscall
#
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,4
  syscall
#
addi $v0,$zero,5
syscall
andi $t4,$v0,255

sll $a0,$t3,8
or $a0,$a0,$t4
addi $v0,$zero,1
syscall

#
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,4
  syscall
#

xor $a0,$t3,$t4
addi $v0,$zero,1
syscall
j Finish

Test5:
addi $v0,$zero,5
syscall
andi $t3,$v0,255
sll $a0,$t3,8
addi $v0,$zero,1
syscall
#
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,4
  syscall
#
addi $v0,$zero,5
syscall
andi $t4,$v0,255

sll $a0,$t3,8
or $a0,$a0,$t4
addi $v0,$zero,1
syscall

#
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,4
  syscall
#

sltu $a0,$t3,$t4
addi $v0,$zero,1
syscall
j Finish

Test6:
addi $v0,$zero,5
syscall
andi $t3,$v0,255
sll $a0,$t3,8
addi $v0,$zero,1
syscall
#
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,4
  syscall
#
addi $v0,$zero,5
syscall
andi $t4,$v0,255

sll $a0,$t3,8
or $a0,$a0,$t4
addi $v0,$zero,1
syscall

#
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,4
  syscall
#
addi $v0,$t3,0
jal Extension
addi $t3,$v0,0
addi $v0,$t4,0
jal Extension
addi $t4,$v0,0

slt $a0,$t3,$t4
addi $v0,$zero,1
syscall
j Finish

Test7:
addi $v0,$zero,5
syscall
andi $t3,$v0,255
sll $a0,$t3,8
addi $v0,$zero,1
syscall
#
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,4
  syscall
#
addi $v0,$zero,5
syscall
andi $t4,$v0,255

sll $a0,$t3,8
or $a0,$a0,$t4
addi $v0,$zero,1
syscall

j Finish

Finish:
addi $v0,$zero,15
addi $a0,$zero,16395
syscall
addi $v0,$zero,10
syscall

Extension: # $v0
srl $a1,$v0,7
beq $a1,$zero,EndExtension
lui $a1,-1#65535#-1
ori $a1,$a1,-256#65280#-256
or $v0,$v0,$a1
EndExtension:
jr $ra
