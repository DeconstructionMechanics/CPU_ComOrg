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
andi $t3,$v0,255
addi $v0,$t3,0
jal Extension
addi $t3,$v0,0
slt $t5,$t3,$zero
beq $t5,$zero,Add0

Twinkle:
addi $v0,$zero,1
addi $a0,$zero,255
syscall
addi $v0,$zero,15
addi $a0,$zero,16395
syscall
addi $v0,$zero,1
addi $a0,$zero,0
syscall
addi $v0,$zero,15
addi $a0,$zero,16395
syscall
j Twinkle

Add0:# print
addi $t5,$t3,1
mult $t5,$t3
mflo $a0
srl $a0,$a0,1
addi $v0,$zero,1
syscall
j Finish

Test1:
addi $v0,$zero,5
syscall
andi $t3,$v0,255
addi $t7,$zero,0
addi $a0,$t3,0
addi $s0,$a0,0
addi $s1,$zero,1
addi $s2,$zero,0
addi $s3,$zero,0
jal Add1


Test2:
addi $v0,$zero,5
syscall
andi $t3,$v0,255
addi $a0,$t3,0
addi $s0,$a0,0
addi $s1,$zero,0
addi $s2,$zero,1
addi $s3,$zero,0
jal Add1


Test3:
addi $v0,$zero,5
syscall
andi $t3,$v0,255
addi $a0,$t3,0
addi $s0,$a0,0
addi $s1,$zero,0
addi $s2,$zero,0
addi $s3,$zero,1
jal Add1
 
 
Add1:
 addi $sp, $sp, -1#-4
 sw $ra, 0($sp)
 
 addi $sp, $sp, -1#-4
 sw $a0, 0($sp)
 andi $a0,$a0,255
 
beq $s1,$zero,SkipT11
  addi $t7,$t7,1
SkipT11:
 
beq $s2,$zero,SkipT2
 addi $t5,$v0,0
 addi $t6,$a0,0
 addi $t7,$ra,0
 addi $v0,$zero,1
 syscall
  #
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  #
 addi $v0,$t5,0
 addi $a0,$t6,0
 addi $ra,$t7,0
SkipT2:
 sltiu $t0, $a0, 1
 beq $t0, $zero, AddL1
 addi $v0, $zero, 0
 addi $sp, $sp, 2#8
 
 jr $ra
AddL1:
 addiu $a0, $a0, -1
 jal Add1
 lw $a0, 0($sp)
 andi $a0,$a0,255
 addi $sp, $sp, 1#4
 
beq $s3,$zero,SkipT3
 addi $t5,$v0,0
 addi $t6,$a0,0
 addi $t7,$ra,0
 addi $v0,$zero,1
 syscall
  #
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  #
 addi $v0,$t5,0
 addi $a0,$t6,0
 addi $ra,$t7,0
SkipT3:
 lw $ra, 0($sp)
 addi $sp, $sp, 1#4
 
beq $s1,$zero,SkipT12
  addi $t7,$t7,1
SkipT12:
 
 addu $v0, $a0, $v0
 beq $a0,$s0,OutRecursion
 jr $ra
 
OutRecursion:
beq $s1,$zero,Finish
addi $a0,$t7,0
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

srl $t5,$t3,7
srl $t6,$t4,7

add $a0,$t3,$t4
srl $t7,$a0,7
andi $a0,$a0,255

bne $t5,$t6,OutPut4
beq $t6,$t7,OutPut4
ori $a0,$a0,512
OutPut4:
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

srl $t5,$t3,7
srl $t6,$t4,7

sub $a0,$t3,$t4
srl $t7,$a0,7
andi $a0,$a0,255

bne $t7,$t6,OutPut5
beq $t6,$t5,OutPut5
ori $a0,$a0,512
OutPut5:
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

mult $t3,$t4
mflo $a0
sll $a0,$a0,16
srl $a0,$a0,16
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
#
  addi $v0,$zero,15
  addi $a0,$zero,16395
  syscall
  addi $v0,$zero,15
  addi $a0,$zero,4
  syscall
#
srl $s3,$t3,7
srl $s4,$t4,7
beq $s3,$zero,SkipT3div
xori $t3,$t3,255
addi $t3,$t3,1
SkipT3div:
beq $s4,$zero,SkipT4div
xori $t4,$t4,255
addi $t4,$t4,1
SkipT4div:
bne $t4,$zero,SkipErrdiv
addi $v0,$zero,15
addi $a0,$zero,2
syscall
SkipErrdiv:

addi $t5,$zero,0
addi $t6,$zero,0
ContinueDiv:
slt $t0,$t3,$t4
bne $t0,$zero,Show7
sub $t3,$t3,$t4
addi $t5,$t5,1
addi $t6,$t3,0
j ContinueDiv

Show7:
addi $v0,$zero,1
addi $a0,$t5,0
syscall
addi $t2,$zero,4
addi $t7,$zero,0
Loop75:
addi $t7,$t7,1
addi $v0,$zero,15
addi $a0,$zero,16395
syscall
bne $t7,$t2,Loop75

addi $v0,$zero,1
addi $a0,$t6,0
syscall
addi $t2,$zero,4
addi $t7,$zero,0
Loop76:
addi $t7,$t7,1
addi $v0,$zero,15
addi $a0,$zero,16395
syscall
bne $t7,$t2,Loop76
j Show7

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
