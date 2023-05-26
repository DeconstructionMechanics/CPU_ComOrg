.data
.text
Start:
addi $v0,$zero,5
syscall

bne $v0,$zero,Test1

Test0:
addi $v0,$zero,14
syscall
addi $v0,$zero,13
syscall
addi $a0,$v0,0
addi $v0,$zero,1
syscall

addi $t0,$zero,400
addi $a0,$zero,0
SimdStart:
addi $v0,$zero,11
addi $a1,$zero,0
syscall
addi $a0,$a0,4
addi $a1,$zero,1
syscall
addi $v0,$zero,12
syscall
addi $a0,$a0,4

slt $t1,$a0,$t0
bne $t1,$zero,SimdStart

addi $v0,$zero,13
syscall
addi $a0,$zero,560
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

# ord
addi $v0,$zero,14
syscall

addi $t0,$zero,400
addi $a0,$zero,0
OriStart:

lw $t0,0($a0)
addi $a0,$a0,1
lw $t1,0($a0)
add $t1,$t0,$t1
sw $t1,0($a0)
addi $a0,$a0,1

slt $t1,$a0,$t0
bne $t1,$zero,OriStart

addi $v0,$zero,13
syscall
addi $a0,$zero,1604
addi $v0,$zero,1
syscall

j Finish

Test1:
addi $v0,$zero,15
addi $a0,$zero,16384
syscall
add $a0,$v0,$zero
addi $v0,$zero,1
syscall
j Test1

Finish:
addi $v0,$zero,15
addi $a0,$zero,16395
syscall
addi $v0,$zero,10
syscall
