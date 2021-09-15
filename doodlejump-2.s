# CSC258H5S Fall 2020 Assembly Final Project
# University of Toronto, St. George
#
# Student: Lei Chen, Student Number:1005695525
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# - Milestone 1, 2, 3, 4, 5

.data 
   displayAddress: .word 0x10008000
   secondrowfirstunit: .word 0x10008080
   displayEndAddress: .word 0x10008ffc
   doodlerStartPlace: .word 0x10008c38
   platformStartPlace: .word 0x10008fb0
   lastrowfirstunit: .word 0x10008f00
   lastunit: .word 0x10008ffc
   firstunitoftherowofsecondplatform: .word 0x10008a00
   firstunitoftherowofthirdplatform: .word 0x10008500
   blue: .word 0xafd7ff
   pink: .word 0xff5faf
   green: .word 0x87d75f
   darkgreen: .word 0x5faf00
   yellow: .word 0xfff86b
   red:  .word 0xaf0000
   white: .word 0xffffff
   black : .word 0x000000
   brown: .word 0xaf5f00
   silver: .word 0xc0c0c0
   plum: .word 0xffaf00
   grey: .word 0x808080
   darkred: .word 0x5f0000
   
   receiverData: .word 0xffff0004
   gameOverPlace: .word 0x100080a8
   gameOverPlace1: .word 0x1000802c
   
   firstcloudplace: .word 0x10008300
   secondcloudplace: .word 0x10008600
   thirdcloudplace: .word 0x10008b00
   
   scorePlace: .word 0x100080d0
   
   
   jumppitch: .byte 67
   byepitch:  .byte 61
   instrument: .byte 32   #bass
   duration: .byte 100
   volume: .byte 127
   
   Cpitch: .byte 60
   Dpitch: .byte 62
   Epitch: .byte 64
   Fpitch: .byte 65
   Gpitch: .byte 67
   Apitch: .byte 69
   Bpitch: .byte 71
   
   
   
   bgmduration: .byte 100
   byeduration: .byte 128
   score: .word 0
   firstscoreletterplace: .word 0x10008084
   secondscoreletterplace: .word 0x10008094
   thirdscoreletterplace: .word 0x100080a4
   
   
  
  
   
.text 
.globl main

main:

   lw $s4, receiverData 
   add $s5, $zero, $zero
   sw $s5, ($s4)
   
   addi $t0, $zero, 0
   sw $t0, score
   

    
 
   #paintSky
     lw $t0, displayAddress # $t0 stores the base address for display
     lw $t9, displayEndAddress # $t1 stores the end address for display
          addi $t5, $t0, 0
          addi $t6, $t9, 4
    START: beq $t6, $t5, END
           lw $t4, blue
           sw $t4, ($t5)
           addi $t5, $t5, 4
           j START
    END:
    
    
    

    
    
   
 centralLoop:
    li $v0, 32
    li $a0, 50
    syscall
    
   
    
    
    
    
    lw $t5, firstunitoftherowofsecondplatform# $t5 stores the address of first unit of the row of second platform
    jal randomGenerater
    mul $a0, $a0, 4
    add $t5, $t5, $a0
    addi $t7, $t5, 0    #t7 stores the address of the first unit of the second platform
    
    
    lw $t5, firstunitoftherowofthirdplatform# $t5 stores the address of first unit of the row of second platform
    jal randomGenerater
    mul $a0, $a0, 4
    add $t5, $t5, $a0
    addi $t8, $t5, 0     #t8 stores the address of the first unit of the second platform
  
    #draw the first platform
    lw $t6, platformStartPlace # $t6 stores the start address of a platform
    addi $a0, $t6, 0
    jal drawPlatform
 
    
    
    #draw the second platform
    addi $a0, $t7, 0
    jal drawPlatform
    
    #draw the third platform
    addi $a0, $t8, 0
    jal drawPlatform
   
  
    
    #draw an original doodler
    lw $a2, doodlerStartPlace # $t9 stores the start address of a doodler
    #addi $t1, $a2, -1280
    jal drawDoodler
    
    #draw the first cloud
    lw $t0, firstcloudplace
    jal randomGenerater
    mul $a0, $a0, 4
    add $s1, $t0, $a0
    addi $a1, $s1, 0 
    jal drawmonster
    
    #draw the second cloud
    lw $t0, secondcloudplace
    jal randomGenerater
    mul $a0, $a0, 4
    add $s2, $t0, $a0
    addi $a1, $s2, 0 
    jal drawCloud
    
    #draw the third cloud
    lw $t0, thirdcloudplace
    jal randomGenerater
    mul $a0, $a0, 4
    add $s3, $t0, $a0
    addi $a1, $s3, 0 
    jal drawCloud
    
    
    #backgroundmusic
    j playbgm
    
    
    checkKeyboard_input:
    lw $s5, 0xffff0000
    beq $s5, 1 , keyboard_input
    
    keyboard_input:
    lw $s5, 0xffff0004
    checkInput:
    beq $s5, 0x73, startGame	# keyboardinput is's', jump to start the game              
    beq $s5, 0x6a, moveLeft	# keyboardinput is 'j', jump to moveLeft
    beq $s5, 0x6b, moveRight    # keyboard nput is'k', jump to moveRight

    j checkKeyboard_input	# else if no input, jump back to checkkeyboard
    
    startGame:
      
       
   lw $s4, receiverData 
   add $s5, $zero, $zero
   sw $s5, ($s4)
   jal removeCurrentDoodler
   lw $a2, doodlerStartPlace 
   jal drawDoodler

   j goUpFromStart
       
    moveLeft:
    jal removeCurrentDoodler
    
    addi $t0, $a2, -4
    add  $t1, $zero, $zero
    addi $t1, $t1, 128
    div  $t0, $t1
    mfhi $t0
    beqz $t0, moveToRight
    
    lw $t2, secondrowfirstunit
    blt  $a2, $t2, changedirection1
    
    
    jal removeCurrentDoodler
    addi $a2, $a2, -260 #  -4-384
    jal drawDoodler
    lw $s4, receiverData 
    add $s5, $zero, $zero
    sw $s5, ($s4)
    j goUpFromStart
    moveToRight:
    jal removeCurrentDoodler
    addi $a2, $a2, 108
    addi $a2, $a2, -260 #-4-384
    jal drawDoodler
    lw $s4, receiverData 
    add $s5, $zero, $zero
    sw $s5, ($s4)
    j goUpFromStart
   
   
    changedirection1:
    jal removeCurrentDoodler
    addi $a2, $a2, 124   #128-4
    jal drawDoodler
   
    #sw $a2, doodlerStartPlace
    lw $s4, receiverData 
    add $s5, $zero, $zero
    sw $s5, ($s4)
   
    j goUpFromStart
    
    moveRight:
    
    addi $t0, $a2, 20
    add  $t1, $zero, $zero
    addi $t1, $t1, 128
   
    div  $t0, $t1
    mfhi $t0
    beqz $t0, moveToLeft
    
    lw $t2, secondrowfirstunit
    blt  $a2, $t2, changedirection2
    
    jal removeCurrentDoodler
    addi $a2, $a2, -380 #+4-256  #4-384
    jal drawDoodler
    lw $s4, receiverData 
    add $s5, $zero, $zero
    sw $s5, ($s4)
    j goUpFromStart
    moveToLeft:
    jal removeCurrentDoodler
    addi $a2, $a2, -108
    addi $a2, $a2, -380#+4-256
    jal drawDoodler
    
    changedirection2:
    jal removeCurrentDoodler
    addi $a2, $a2, 132  #128+4
    jal drawDoodler
   
    
    lw $s4, receiverData 
    add $s5, $zero, $zero
    sw $s5, ($s4)
  
    j goUpFromStart
    
        
           
      
    
Exit:
    li $v0, 10 # terminate the program 
    syscall 
    
    
    
# functions
drawDoodler: 
    lw $t2, pink
    lw $t3, yellow
    lw $t4, darkgreen
    lw $t5, black
    lw $t6, white
    
    sw $t2, ($a2)
    sw $t2, 4($a2)
    sw $t2, 8($a2)
    sw $t2, 12($a2)
    sw $t6, 124($a2)
    sw $t3, 128($a2)
    sw $t5, 132($a2)
    sw $t3, 136($a2)
    sw $t5, 140($a2)
    sw $t3, 256($a2)
    sw $t3, 260($a2)
    sw $t3, 264($a2)
    sw $t3, 268($a2)
    sw $t3, 272($a2)
    sw $t6, 380($a2)
    sw $t3, 384($a2)
    sw $t3, 388($a2)
    sw $t2, 392($a2)
    sw $t3, 396($a2)
    sw $t3, 512($a2)
    sw $t3, 516($a2)
    sw $t3, 520($a2)
    sw $t3, 524($a2) 
    sw $t5, 640($a2)
    sw $t5, 652($a2)
   
    jr $ra
    
removeCurrentDoodler:
    lw $t4, blue
    
    sw $t4, ($a2)
    sw $t4, 4($a2)
    sw $t4, 8($a2)
    sw $t4, 12($a2)
    sw $t4, 124($a2)
    sw $t4, 128($a2)
    sw $t4, 132($a2)
    sw $t4, 136($a2)
    sw $t4, 140($a2)
    sw $t4, 256($a2)
    sw $t4, 260($a2)
    sw $t4, 264($a2)
    sw $t4, 268($a2)
    sw $t4, 272($a2)
    sw $t4, 380($a2)
    sw $t4, 384($a2)
    sw $t4, 388($a2)
    sw $t4, 392($a2)
    sw $t4, 396($a2)
    sw $t4, 512($a2)
    sw $t4, 516($a2)
    sw $t4, 520($a2)
    sw $t4, 524($a2) 
    sw $t4, 640($a2)
    sw $t4, 652($a2)
    jr $ra

    
drawPlatform: # length of 9 units
    lw $t3, green
    lw $t4, brown
    sw $t4, ($a0)
    sw $t4, 4($a0)
    sw $t4, 8($a0)
    sw $t4, 12($a0)
    sw $t4, 16($a0)
    sw $t4, 20($a0)
    sw $t4, 24($a0)
    sw $t4, 28($a0)
    sw $t4, 32($a0)
    
    sw $t3, -128($a0)
    sw $t3, -124($a0)
    sw $t3, -120($a0)
    sw $t3, -116($a0)
    sw $t3, -112($a0)
    sw $t3, -108($a0)
    sw $t3, -104($a0)
    sw $t3, -100($a0)
     sw $t3, -96($a0)
    jr $ra
    
drawPlatform1: # length of 9 units
    lw $t3, green
    lw $t4, grey
    sw $t4, ($a0)
    sw $t4, 4($a0)
    sw $t4, 8($a0)
    sw $t4, 12($a0)
    sw $t4, 16($a0)
    sw $t4, 20($a0)
    sw $t4, 24($a0)
    sw $t4, 28($a0)
    sw $t4, 32($a0)
    
    sw $t3, -128($a0)
    sw $t3, -124($a0)
    sw $t3, -120($a0)
    sw $t3, -116($a0)
    sw $t3, -112($a0)
    sw $t3, -108($a0)
    sw $t3, -104($a0)
    sw $t3, -100($a0)
     sw $t3, -96($a0)
    jr $ra
    

    
removeCurrentPlatform:
    lw $t4, blue
    sw $t4, ($a0)
    sw $t4, 4($a0)
    sw $t4, 8($a0)
    sw $t4, 12($a0)
    sw $t4, 16($a0)
    sw $t4, 20($a0)
    sw $t4, 24($a0)
    sw $t4, 28($a0)
    sw $t4, 32($a0)
    
    sw $t4, -128($a0)
    sw $t4, -124($a0)
    sw $t4, -120($a0)
    sw $t4, -116($a0)
    sw $t4, -112($a0)
    sw $t4, -108($a0)
    sw $t4, -104($a0)
    sw $t4, -100($a0)
    sw $t4, -96($a0)
   
    jr $ra
    
drawCloud:
    lw $t4, white
    sw $t4, ($a1)
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 12($a1)
    sw $t4, -124($a1)
    sw $t4, -120($a1)
    jr $ra
   
removeCloud:
    lw $t4, blue
    sw $t4, ($a1)
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 12($a1)
    sw $t4, -124($a1)
    sw $t4, -120($a1)
    jr $ra
    
draw0:
    lw $t4, grey
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 128($a1)
    sw $t4, 136($a1)
    sw $t4, 256($a1)
    sw $t4, 264($a1)
    sw $t4, 384($a1)
    sw $t4, 392($a1)
    sw $t4, 512($a1)
    sw $t4, 516($a1)
    sw $t4, 520($a1)
    jr $ra
delete0:
    lw $t4, blue
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 128($a1)
    sw $t4, 136($a1)
    sw $t4, 256($a1)
    sw $t4, 264($a1)
    sw $t4, 384($a1)
    sw $t4, 392($a1)
    sw $t4, 512($a1)
    sw $t4, 516($a1)
    sw $t4, 520($a1)
    jr $ra
draw1:
    lw $t4, grey
    sw $t4, ($a1) #top unit
    sw $t4, 128($a1)
    sw $t4, 256($a1)
    sw $t4, 384($a1)
    sw $t4, 512($a1)
    jr $ra
delete1:
    lw $t4, blue
    sw $t4, ($a1) #top unit
    sw $t4, 128($a1)
    sw $t4, 256($a1)
    sw $t4, 384($a1)
    sw $t4, 512($a1)
    jr $ra
draw2:
    lw $t4, grey
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 136($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 384($a1)
    sw $t4, 512($a1)
    sw $t4, 516($a1)
    sw $t4, 520($a1)
    jr $ra
delete2:
    lw $t4, blue
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 136($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 384($a1)
    sw $t4, 512($a1)
    sw $t4, 516($a1)
    sw $t4, 520($a1)
    jr $ra
draw3:
    lw $t4, grey
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 136($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 392($a1)
    sw $t4, 512($a1)
    sw $t4, 516($a1)
    sw $t4, 520($a1)
    jr $ra
delete3:
    lw $t4, blue
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 136($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 392($a1)
    sw $t4, 512($a1)
    sw $t4, 516($a1)
    sw $t4, 520($a1)
    jr $ra
    
draw4:
    lw $t4, grey
    sw $t4, ($a1) #left top unit
    sw $t4, 8($a1)
    sw $t4, 128($a1)
    sw $t4, 136($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 392($a1)
    sw $t4, 520($a1)
    jr $ra
delete4:
    lw $t4, blue
    sw $t4, ($a1) #left top unit
    sw $t4, 8($a1)
    sw $t4, 128($a1)
    sw $t4, 136($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 392($a1)
    sw $t4, 520($a1)
    jr $ra
    
 draw5:
    lw $t4, grey
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 128($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 392($a1)
    sw $t4, 512($a1)
    sw $t4, 516($a1)
    sw $t4, 520($a1)
    jr $ra
 delete5:
    lw $t4, blue
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 128($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 392($a1)
    sw $t4, 512($a1)
    sw $t4, 516($a1)
    sw $t4, 520($a1)
    jr $ra
 draw6: 
    lw $t4, grey
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 128($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 384($a1)
    sw $t4, 392($a1)
    sw $t4, 512($a1)
    sw $t4, 516($a1)
    sw $t4, 520($a1)
    jr $ra 
 delete6: 
    lw $t4, blue
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 128($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 384($a1)
    sw $t4, 392($a1)
    sw $t4, 512($a1)
    sw $t4, 516($a1)
    sw $t4, 520($a1)
    jr $ra 
     
 draw7:
    lw $t4, grey
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 136($a1)
    sw $t4, 264($a1)
    sw $t4, 392($a1)
    sw $t4, 520($a1)
    jr $ra
    
 delete7:
    lw $t4, blue
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 136($a1)
    sw $t4, 264($a1)
    sw $t4, 392($a1)
    sw $t4, 520($a1)
    jr $ra
    
 draw8:
    lw $t4, grey
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 128($a1)
    sw $t4, 136($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 384($a1)
    sw $t4, 392($a1)
    sw $t4, 512($a1)
    sw $t4, 516($a1)
    sw $t4, 520($a1)
    jr $ra
 delete8:
    lw $t4, blue
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 128($a1)
    sw $t4, 136($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 384($a1)
    sw $t4, 392($a1)
    sw $t4, 512($a1)
    sw $t4, 516($a1)
    sw $t4, 520($a1)
    jr $ra
    
 draw9:
    lw $t4, grey
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 128($a1)
    sw $t4, 136($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 392($a1) 
    sw $t4, 520($a1)
    jr $ra
  delete9:
    lw $t4, blue
    sw $t4, ($a1) #left top unit
    sw $t4, 4($a1)
    sw $t4, 8($a1)
    sw $t4, 128($a1)
    sw $t4, 136($a1)
    sw $t4, 256($a1)
    sw $t4, 260($a1)
    sw $t4, 264($a1)
    sw $t4, 392($a1)
    sw $t4, 520($a1)
    jr $ra
    

    
randomGenerater:
    li $v0, 42
    li $a0, 0
    li $a1, 23
    syscall 
    jr $ra
    
drawGameOver:
    #repaintsky
    lw $t0, displayAddress # $t0 stores the base address for display
     lw $t9, displayEndAddress # $t1 stores the end address for display
          addi $t5, $t0, 0
          addi $t6, $t9, 4
    START1: beq $t6, $t5, END1
           lw $t4, blue
           sw $t4, ($t5)
           addi $t5, $t5, 4
           j START1
    END1:
    lw $t0, gameOverPlace
    lw $t1, silver
    sw $t1, ($t0)
    sw $t1, 128($t0)
    sw $t1, 256($t0)
    sw $t1, 260($t0)
    sw $t1, 264($t0)
    sw $t1, 272($t0)
    sw $t1, 280($t0)
    sw $t1, 288($t0)
    sw $t1, 292($t0)
    sw $t1, 296($t0)
    
    #draw y
    sw $t1, 384($t0)
    sw $t1, 392($t0)
    sw $t1, 400($t0)
    sw $t1, 408($t0)
    sw $t1, 416($t0)
   # sw $t1, 420($t0)
    sw $t1, 424($t0)
    
    sw $t1, 512($t0)
    sw $t1, 516($t0)
    sw $t1, 520($t0)
    sw $t1, 528($t0)
    sw $t1, 532($t0)
    sw $t1, 536($t0)
    sw $t1, 544($t0)
    sw $t1, 548($t0)
    sw $t1, 552($t0)
    
    sw $t1, 664($t0)
    sw $t1, 792($t0)
    sw $t1, 920($t0)
    sw $t1, 916($t0)
    
    sw $t1, 672($t0)
    sw $t1, 800($t0)
    sw $t1, 804($t0)
    sw $t1, 808($t0)
    
    lw $t0, gameOverPlace1
    lw $t1, yellow
    sw $t1, ($t0)
    sw $t1, 128($t0)
    sw $t1, 256($t0)
    sw $t1, 260($t0)
    sw $t1, 264($t0)
    sw $t1, 272($t0)
    sw $t1, 280($t0)
    sw $t1, 288($t0)
    sw $t1, 292($t0)
    sw $t1, 296($t0)
    
    #draw y
    sw $t1, 384($t0)
    sw $t1, 392($t0)
    sw $t1, 400($t0)
    sw $t1, 408($t0)
    sw $t1, 416($t0)
   # sw $t1, 420($t0)
    sw $t1, 424($t0)
    
    sw $t1, 512($t0)
    sw $t1, 516($t0)
    sw $t1, 520($t0)
    sw $t1, 528($t0)
    sw $t1, 532($t0)
    sw $t1, 536($t0)
    sw $t1, 544($t0)
    sw $t1, 548($t0)
    sw $t1, 552($t0)
    
    sw $t1, 664($t0)
    sw $t1, 792($t0)
    sw $t1, 920($t0)
    sw $t1, 916($t0)
    
    sw $t1, 672($t0)
    sw $t1, 800($t0)
    sw $t1, 804($t0)
    sw $t1, 808($t0)
    
    #draw press S to retry
    lw  $t0 firstunitoftherowofsecondplatform
    addi $t0, $t0, 12
    sw $t1, 0($t0) 
    sw $t1, 4($t0) 
    sw $t1, 8($t0) 
    sw $t1, 128($t0) 
    sw $t1, 136($t0) 
    sw $t1, 256($t0)
    sw $t1, 260($t0) 
    sw $t1, 264($t0)  
    sw $t1, 384($t0) 
    sw $t1, 512($t0) 
   
    sw $t1, 16($t0) 
    sw $t1, 20($t0) 
    sw $t1, 24($t0) 
    sw $t1, 144($t0) 
    sw $t1, 152($t0) 
    sw $t1, 272($t0) 
    sw $t1, 276($t0) 
    sw $t1, 280($t0) 
    sw $t1, 400($t0) 
    sw $t1, 404($t0) 
    sw $t1, 528($t0) 
    sw $t1, 536($t0) 
    
    sw $t1, 32($t0) 
    sw $t1, 36($t0) 
    sw $t1, 40($t0) 
    sw $t1, 160($t0) 
    sw $t1, 288($t0) 
    sw $t1, 292($t0) 
    sw $t1, 296($t0) 
    sw $t1, 416($t0) 
    sw $t1, 544($t0) 
    sw $t1, 548($t0) 
    sw $t1, 552($t0) 
    
    sw $t1, 48($t0) 
    sw $t1, 52($t0) 
    sw $t1, 56($t0) 
    sw $t1, 176($t0)
    sw $t1, 304($t0)  
    sw $t1, 308($t0)
    sw $t1, 312($t0) 
    sw $t1, 440($t0)
    sw $t1, 568($t0) 
    sw $t1, 564($t0) 
    sw $t1, 560($t0) 
    
    sw $t1, 64($t0) 
    sw $t1, 68($t0) 
    sw $t1, 72($t0) 
    sw $t1, 192($t0)
    sw $t1, 320($t0)  
    sw $t1, 324($t0)
    sw $t1, 328($t0) 
    sw $t1, 456($t0)
    sw $t1, 584($t0) 
    sw $t1, 580($t0) 
    sw $t1, 576($t0) 
    
    sw $t1, 88($t0) 
    sw $t1, 92($t0) 
    sw $t1, 96($t0) 
    sw $t1, 216($t0)
    sw $t1, 344($t0)  
    sw $t1, 348($t0)
    sw $t1, 352($t0) 
    sw $t1, 480($t0)
    sw $t1, 608($t0) 
    sw $t1, 604($t0) 
    sw $t1, 600($t0) 
    
    addi $t0, $t0, 760
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 132($t0)
    sw $t1, 260($t0)
    sw $t1, 388($t0)
    sw $t1, 516($t0)
    
    sw $t1, 16($t0)
    sw $t1, 20($t0)
    sw $t1, 24($t0)
    sw $t1, 144($t0)
    sw $t1, 152($t0)
    sw $t1, 272($t0)
    sw $t1, 280($t0)
    sw $t1, 400($t0)
    sw $t1, 408($t0)
    sw $t1, 528($t0)
    sw $t1, 532($t0)
    sw $t1, 536($t0)
    
    
    
    sw $t1, 40($t0) 
    sw $t1, 44($t0) 
    sw $t1, 48($t0) 
    sw $t1, 168($t0) 
    sw $t1, 176($t0) 
    sw $t1, 296($t0) 
    sw $t1, 300($t0) 
    sw $t1, 304($t0) 
    sw $t1, 424($t0) 
    sw $t1, 428($t0) 
    sw $t1, 552($t0) 
    sw $t1, 560($t0) 
    
    sw $t1, 56($t0) 
    sw $t1, 60($t0) 
    sw $t1, 64($t0) 
    sw $t1, 184($t0) 
    sw $t1, 312($t0) 
    sw $t1, 316($t0) 
    sw $t1, 320($t0) 
    sw $t1, 440($t0) 
    sw $t1, 568($t0) 
    sw $t1, 572($t0) 
    sw $t1, 576($t0) 
    
    sw $t1, 72($t0)
    sw $t1, 76($t0)
    sw $t1, 80($t0)
    sw $t1, 204($t0)
    sw $t1, 332($t0)
    sw $t1, 460($t0)
    sw $t1, 588($t0)
    
    sw $t1, 88($t0) 
    sw $t1, 92($t0) 
    sw $t1, 96($t0) 
    sw $t1, 216($t0) 
    sw $t1, 224($t0) 
    sw $t1, 344($t0) 
    sw $t1, 348($t0) 
    sw $t1, 352($t0) 
    sw $t1, 472($t0) 
    sw $t1, 476($t0) 
    sw $t1, 600($t0) 
    sw $t1, 608($t0) 
    
    sw $t1, 104($t0) 
    sw $t1, 112($t0) 
    sw $t1, 232($t0) 
    sw $t1, 240($t0) 
    sw $t1, 360($t0) 
    sw $t1, 364($t0) 
    sw $t1, 368($t0) 
    sw $t1, 496($t0) 
    sw $t1, 624($t0) 
    sw $t1, 620($t0) 
   
    
    jr $ra
    
removeLasttwoLine:
    lw $t1, blue
    lw $t4, lastrowfirstunit 
    addi $t4, $t4, -128
    lw $t3, lastunit
    addi $t3, $t3, 4
    removeTwoLineLoop:
    beq $t4,$t3, endRemoveLastTwo
    sw $t1, ($t4)
    addi $t4, $t4, 4
    j removeTwoLineLoop
    
    endRemoveLastTwo:
    jr $ra
    
drawwow:
   lw $t1, plum
   lw $t4, secondscoreletterplace
   addi $t4, $t4, 16
   sw $t1, 0($t4)
   sw $t1, 8($t4)
   sw $t1, 16($t4)
   sw $t1, 132($t4)
   sw $t1, 140($t4)
   sw $t1, 24($t4)
   sw $t1, 28($t4)
   sw $t1, 32($t4)
   sw $t1, 152($t4) #24+128
   sw $t1, 160($t4)
   sw $t1, 280($t4)
   sw $t1, 284($t4)
   sw $t1, 288($t4)
   sw $t1, 40($t4)  #w, 32+8
   sw $t1, 48($t4)
   sw $t1, 56($t4)
   sw $t1, 172($t4)  #38+260
   sw $t1, 180($t4)
   sw $t1, 64($t4)
   sw $t1, 192($t4)
   sw $t1, 320($t4)
   sw $t1, 576($t4) 
   jr $ra
removewow:
   lw $t1, blue
   lw $t4, secondscoreletterplace
   addi $t4, $t4, 16
   sw $t1, 0($t4)
   sw $t1, 8($t4)
   sw $t1, 16($t4)
   sw $t1, 132($t4)
   sw $t1, 140($t4)
   sw $t1, 24($t4)
   sw $t1, 28($t4)
   sw $t1, 32($t4)
   sw $t1, 152($t4) #24+128
   sw $t1, 160($t4)
   sw $t1, 280($t4)
   sw $t1, 284($t4)
   sw $t1, 288($t4)
   sw $t1, 40($t4)  #w, 32+8
   sw $t1, 48($t4)
   sw $t1, 56($t4)
   sw $t1, 172($t4)  #38+260
   sw $t1, 180($t4)
   sw $t1, 64($t4)
   sw $t1, 192($t4)
   sw $t1, 320($t4)
   sw $t1, 576($t4) 
   jr $ra
   
   
drawnice:
   lw $t1, plum
   lw $t4, secondscoreletterplace
   addi $t4, $t4, 32
   sw $t1, 0($t4)
   sw $t1, 4($t4)
   sw $t1, 8($t4)
   sw $t1, 12($t4)
   sw $t1, 128($t4) 
   sw $t1, 140($t4)
   sw $t1, 256($t4)
   sw $t1, 268($t4)
   sw $t1, 384($t4) 
   sw $t1, 396($t4)
  # sw $t1, 512($t4)
  # sw $t1, 524($t4)
   
   sw $t1, 20($t4)
   sw $t1, 148($t4)
   sw $t1, 276($t4)
   sw $t1, 404($t4) 
   #sw $t1, 532($t4)
   
   sw $t1, 28($t4)
   sw $t1, 32($t4)
   sw $t1, 36($t4)
   #sw $t1, 40($t4)
   sw $t1, 156($t4)
   sw $t1, 284($t4)
   sw $t1, 412($t4) 
   sw $t1, 416($t4)
   sw $t1, 420($t4)
  # sw $t1, 552($t4) 
   
   sw $t1, 48($t4)
   sw $t1, 52($t4)
   sw $t1, 56($t4)
  # sw $t1, 60($t4) 
   sw $t1, 176($t4)
   sw $t1, 184($t4)
   sw $t1, 304($t4)
   sw $t1, 308($t4) 
   sw $t1, 312($t4)
   #sw $t1, 316($t4)
   sw $t1, 432($t4)
   sw $t1, 560($t4)
   sw $t1, 564($t4)
   sw $t1, 568($t4)
   #sw $t1, 572($t4)
   
   sw $t1, 68($t4)
   sw $t1, 196($t4)
   sw $t1, 324($t4)
   
   sw $t1, 580($t4)
  
   jr $ra

 removenice:   
   lw $t1, blue
   lw $t4, secondscoreletterplace
   addi $t4, $t4, 32
   sw $t1, 0($t4)
   sw $t1, 4($t4)
   sw $t1, 8($t4)
   sw $t1, 12($t4)
   sw $t1, 128($t4) 
   sw $t1, 140($t4)
   sw $t1, 256($t4)
   sw $t1, 268($t4)
   sw $t1, 384($t4) 
   sw $t1, 396($t4)
  # sw $t1, 512($t4)
  # sw $t1, 524($t4)
   
   sw $t1, 20($t4)
   sw $t1, 148($t4)
   sw $t1, 276($t4)
   sw $t1, 404($t4) 
   #sw $t1, 532($t4)
   
   sw $t1, 28($t4)
   sw $t1, 32($t4)
   sw $t1, 36($t4)
   #sw $t1, 40($t4)
   sw $t1, 156($t4)
   sw $t1, 284($t4)
   sw $t1, 412($t4) 
   sw $t1, 416($t4)
   sw $t1, 420($t4)
  # sw $t1, 552($t4) 
   
   sw $t1, 48($t4)
   sw $t1, 52($t4)
   sw $t1, 56($t4)
  # sw $t1, 60($t4) 
   sw $t1, 176($t4)
   sw $t1, 184($t4)
   sw $t1, 304($t4)
   sw $t1, 308($t4) 
   sw $t1, 312($t4)
   #sw $t1, 316($t4)
   sw $t1, 432($t4)
   sw $t1, 560($t4)
   sw $t1, 564($t4)
   sw $t1, 568($t4)
   #sw $t1, 572($t4)
   
   sw $t1, 68($t4)
   sw $t1, 196($t4)
   sw $t1, 324($t4)
   
   sw $t1, 580($t4)
  
   jr $ra
   
   
drawgreat:
   lw $t1, plum
   lw $t4, secondscoreletterplace
   addi $t4, $t4, 16
   sw $t1, 0($t4)
   sw $t1, 4($t4)
   sw $t1, 8($t4)
   sw $t1, 12($t4)
   sw $t1, 128($t4)
   sw $t1, 256($t4)
   sw $t1, 264($t4)
   sw $t1, 268($t4)
   sw $t1, 384($t4)
   sw $t1, 396($t4)
   sw $t1, 512($t4)
   sw $t1, 516($t4)
   sw $t1, 520($t4)
   sw $t1, 524($t4)
   
   sw $t1, 20($t4)
   sw $t1, 24($t4)
   sw $t1, 28($t4)
   sw $t1, 148($t4)
   sw $t1, 156($t4)
   sw $t1, 276($t4)
   sw $t1, 280($t4)
   sw $t1, 284($t4)
   sw $t1, 404($t4)
   sw $t1, 408($t4)
   sw $t1, 532($t4)
   sw $t1, 540($t4)
   
   sw $t1, 40($t4)
   sw $t1, 44($t4)
   sw $t1, 48($t4)
   sw $t1, 52($t4)
   sw $t1, 168($t4)
   sw $t1, 296($t4)
   sw $t1, 300($t4)
   sw $t1, 304($t4)
   sw $t1, 308($t4)
   sw $t1, 424($t4)
   sw $t1, 552($t4)
   sw $t1, 556($t4)
   sw $t1, 560($t4)
   sw $t1, 564($t4)
   
   sw $t1, 64($t4)
   sw $t1, 68($t4)
   sw $t1, 188($t4)
   sw $t1, 200($t4)
   sw $t1, 316($t4)
   sw $t1, 320($t4)
   sw $t1, 324($t4)
   sw $t1, 328($t4)
   sw $t1, 444($t4)
   sw $t1, 456($t4)
   sw $t1, 572($t4)
   sw $t1, 584($t4)
   
   sw $t1, 80($t4)
   sw $t1, 84($t4)
   sw $t1, 88($t4)
   sw $t1, 212($t4)
   sw $t1, 340($t4)
   sw $t1, 468($t4)
   sw $t1, 596($t4)
 
   jr $ra
   
 removegreat:
   lw $t1, blue
   lw $t4, secondscoreletterplace
   addi $t4, $t4, 16
   sw $t1, 0($t4)
   sw $t1, 4($t4)
   sw $t1, 8($t4)
   sw $t1, 12($t4)
   sw $t1, 128($t4)
   sw $t1, 256($t4)
   sw $t1, 264($t4)
   sw $t1, 268($t4)
   sw $t1, 384($t4)
   sw $t1, 396($t4)
   sw $t1, 512($t4)
   sw $t1, 516($t4)
   sw $t1, 520($t4)
   sw $t1, 524($t4)
   
   sw $t1, 20($t4)
   sw $t1, 24($t4)
   sw $t1, 28($t4)
   sw $t1, 148($t4)
   sw $t1, 156($t4)
   sw $t1, 276($t4)
   sw $t1, 280($t4)
   sw $t1, 284($t4)
   sw $t1, 404($t4)
   sw $t1, 408($t4)
   sw $t1, 532($t4)
   sw $t1, 540($t4)
   
   sw $t1, 40($t4)
   sw $t1, 44($t4)
   sw $t1, 48($t4)
   sw $t1, 52($t4)
   sw $t1, 168($t4)
   sw $t1, 296($t4)
   sw $t1, 300($t4)
   sw $t1, 304($t4)
   sw $t1, 308($t4)
   sw $t1, 424($t4)
   sw $t1, 552($t4)
   sw $t1, 556($t4)
   sw $t1, 560($t4)
   sw $t1, 564($t4)
   
   sw $t1, 64($t4)
   sw $t1, 68($t4)
   sw $t1, 188($t4)
   sw $t1, 200($t4)
   sw $t1, 316($t4)
   sw $t1, 320($t4)
   sw $t1, 324($t4)
   sw $t1, 328($t4)
   sw $t1, 444($t4)
   sw $t1, 456($t4)
   sw $t1, 572($t4)
   sw $t1, 584($t4)
   
   sw $t1, 80($t4)
   sw $t1, 84($t4)
   sw $t1, 88($t4)
   sw $t1, 212($t4)
   sw $t1, 340($t4)
   sw $t1, 468($t4)
   sw $t1, 596($t4)
  
   jr $ra
     
dropPlatform:
  #remove the first platform
    #lw $t4, platformStartPlace # $t6 stores the start address of a platform
    
    jal removeLasttwoLine
    
   
    #lw $a0, secondscoreletterplace
    #addi $a0, $a0, 16
    #jal removewow    #remove notification
     
     #redraw score
    lw $t9, score
    
    addi $t0, $zero, 1
    beq $t9, $t0, godraw1_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw2_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw3_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw4_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw5_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw6_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw7_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw8_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw9_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw10_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw11_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw12_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw13_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw14_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw15_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw16_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw17_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw18_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw19_2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw20_2
    
    
    godraw1_2:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal draw1
    j stardropplatform
  
    godraw2_2:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete1
    jal draw2
    j stardropplatform
   
    godraw3_2:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete2
    jal draw3
    j stardropplatform
   
    
    godraw4_2:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete3
    jal draw4
    j stardropplatform
   
    
    godraw5_2:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete4
    jal draw5
    jal drawwow
    j stardropplatform
    
    
    godraw6_2:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete5
    jal draw6
    j stardropplatform
   
    
    godraw7_2:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete6
    jal draw7
    j stardropplatform
   
    godraw8_2:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete7
    jal draw8
    j stardropplatform
    
    
    godraw9_2:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete8
    jal draw9
    j stardropplatform
    
    
    godraw10_2:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete9
    jal draw0
    addi $a1, $t1, 0
    jal draw1
    jal drawnice
    j stardropplatform
  
    
    godraw11_2:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete0
    jal draw1
    addi $a1, $t1, 0
    jal draw1
    j stardropplatform
   
    
    godraw12_2:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete1
    jal draw2
    addi $a1, $t1, 0
    jal draw1
    j stardropplatform
 
    godraw13_2:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete2
    jal draw3
    addi $a1, $t1, 0
    jal draw1
    j stardropplatform
    
    godraw14_2:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete3
    jal draw4
    addi $a1, $t1, 0
    jal draw1
    j stardropplatform
   
    
    godraw15_2:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete4
    jal draw5
    addi $a1, $t1, 0
    jal draw1
    jal drawgreat
    j stardropplatform
    
    godraw16_2:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete5
    jal draw6
    addi $a1, $t1, 0
    jal draw1
    j stardropplatform
   
    
    godraw17_2:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete6
    jal draw7
    addi $a1, $t1, 0
    jal draw1
    j stardropplatform
   
    
    godraw18_2:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete7
    jal draw8
    addi $a1, $t1, 0
    jal draw1
    j stardropplatform
  
    godraw19_2:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete8
    jal draw9
    addi $a1, $t1, 0
    jal draw1
    j stardropplatform
    
    
    godraw20_2:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete9
    jal draw0
    addi $a1, $t1, 0
    jal delete1
    jal draw2
    j stardropplatform
    
    
    
    
    stardropplatform:
    
    addi $t9, $t7, 1280
    addi $a0, $t7, 0
    jal removeCurrentPlatform
     
    addi $a0, $t8, 0
    jal removeCurrentPlatform
   
    addi $t0, $t7, 0
    addi $t1, $t8, 0
    
    
    
   
    dropNewPlatform:
    
    
    lw $t2, secondrowfirstunit
    blt  $a2, $t2, changedirection3
    jal removeCurrentDoodler
    addi $a2, $a2, -128
    jal drawDoodler
    j startdropnewplatform
    changedirection3:
    jal removeCurrentDoodler
    addi $a2, $a2, 512
    jal drawDoodler
    
 
    
    startdropnewplatform:
   
    lw $t5, firstunitoftherowofthirdplatform# $t5 stores the address of first unit of the row of second platform
    jal randomGenerater
    mul $a0, $a0, 4
    add $t5, $t5, $a0
    addi $s7, $t5, 0     #s7 stores the address of the first unit of the new platform
    
    addi $s6, $s7, 1152  # endplace of dropping the new platform
    addi $a0, $s7, 0   #$s0 store the orginal place of the new platform 
    addi $s0, $s7, 0
    addi $t8, $s0, 0
    bge $s0, $s6, endDrop
    
    #drop the new platform
   
    addi $a0, $t0, 0
    jal removeCurrentPlatform
    addi $a0, $a0, 128   
    addi $s0, $s0, 128
    jal drawPlatform
   
  
    
    
    dropTwoPlatform:
    
    bge $t0, $t9, endDrop
    
    #drop the second platform
   
    addi $a0, $t0, 0
    jal removeCurrentPlatform
    addi $a0, $a0, 128
    addi $t0, $t0, 128
    
    addi $t6, $t0, 0
    jal drawPlatform         
    
    #dropthe third platform
   
    addi $a0, $t1, 0
    jal removeCurrentPlatform
    
    add  $s5, $zero, $zero
    addi $s5, $s5, 128
    div  $t1, $s5
    mfhi $s5
    beqz $s5, movePlatformToRight
    addi $a0, $a0, 124   #move platform to left one unit 128-4
    addi $t1, $t1, 124
    addi $t7, $t1, 0
    jal drawPlatform
     
    #dropthefirstcloud and make a random cloud if it reaches the ground $s1
    lw $s4, lastrowfirstunit
    addi $a1, $s1, 0
    blt $a1, $s4, dropcloud1
    jal removemonster
    lw $s0, firstcloudplace #clouds go to the top to start
    jal randomGenerater
    mul $a0, $a0, 4
    add $s1, $s0, $a0
    addi $a1, $s1, 0 
    jal drawmonster
    dropcloud1:
    jal removemonster
    addi $a1, $a1, 128
    addi $s1, $s1, 128
    jal drawmonster
    
    #dropthesecondcloud and make a random cloud if reaches the ground $s2
    lw $s4, lastrowfirstunit
     addi $a1, $s2, 0
    blt $a1, $s4, dropcloud2
     jal removeCloud
     lw $s0, firstcloudplace #clouds go to the top to start
     jal randomGenerater
    mul $a0, $a0, 4
    add $s2, $s0, $a0
    addi $a1, $s2, 0 
    jal drawCloud
    dropcloud2:
    jal removeCloud
    addi $a1, $a1, 128
     addi $s2, $s2, 128
    jal drawCloud
    
    #dropthethirdcloud and make a random cloud if reaches the ground $s3
    lw $s4, lastrowfirstunit
     addi $a1, $s3, 0
    blt $a1, $s4, dropcloud3
    jal removeCloud
    lw $s0, firstcloudplace #clouds go to the top to start
    jal randomGenerater
    mul $a0, $a0, 4
    add $s3 $s0, $a0
    addi $a1, $s3, 0  
    jal drawCloud
    dropcloud3:
    jal removeCloud
    addi $a1, $a1, 128
     addi $s3, $s3, 128
    jal drawCloud
 
   
    li $v0, 32
    li $a0, 50
    syscall
    
    j dropNewPlatform
    
    movePlatformToRight:
    addi $a0, $a0, 92 #move platform to the right boundry next line 119+128
    addi $t1, $t1, 92
    addi $t7, $t1, 0
    jal drawPlatform
    
    #dropthefirstcloud and make a random cloud if it reaches the ground $s1
    lw $s4, lastrowfirstunit
    addi $a1, $s1, 0
    blt $a1, $s4, dropcloud1
    jal removemonster
    lw $s0, firstcloudplace #clouds go to the top to start
    jal randomGenerater
    mul $a0, $a0, 4
    add $s1, $s0, $a0
    addi $a1, $s1, 0 
    jal drawmonster
    dropcloud11:
    jal removemonster
    addi $a1, $a1, 128
    addi $s1, $s1, 128
    jal drawmonster
    
    #dropthesecondcloud and make a random cloud if reaches the ground $s2
    lw $s4, lastrowfirstunit
     addi $a1, $s2, 0
    blt $a1, $s4, dropcloud2
     jal removeCloud
     lw $s0, firstcloudplace #clouds go to the top to start
     jal randomGenerater
    mul $a0, $a0, 4
    add $s2, $s0, $a0
    addi $a1, $s2, 0 
    jal drawCloud
    dropcloud22:
    jal removeCloud
    addi $a1, $a1, 128
     addi $s2, $s2, 128
    jal drawCloud
    
    #dropthethirdcloud and make a random cloud if reaches the ground $s3
    lw $s4, lastrowfirstunit
     addi $a1, $s3, 0
    blt $a1, $s4, dropcloud3
    jal removeCloud
    lw $s0, firstcloudplace #clouds go to the top to start
    jal randomGenerater
    mul $a0, $a0, 4
    add $s3 $s0, $a0
    addi $a1, $s3, 0  
    jal drawCloud
    dropcloud33:
    jal removeCloud
    addi $a1, $a1, 128
    addi $s3, $s3, 128
    jal drawCloud
   
    li $v0, 32
    li $a0, 50
    syscall
    
    j dropNewPlatform

    endDrop:
    j goUpFromStart
  
    
drawmonster:
  lw $t4, darkred
  sw $t4, 0($a1)
  sw $t4, 4($a1) 
  sw $t4, 8($a1) 
  sw $t4, -128($a1)
  sw $t4, -120($a1)
  sw $t4, -256($a1)
  sw $t4, -252($a1)
  sw $t4, -248($a1)
  lw $t4, red
  sw $t4, -124($a1)
  jr $ra
  
removemonster:
  lw $t4, blue
  sw $t4, 0($a1)
  sw $t4, 4($a1) 
  sw $t4, 8($a1) 
  sw $t4, -128($a1)
  sw $t4, -120($a1)
  sw $t4, -256($a1)
  sw $t4, -252($a1)
  sw $t4, -248($a1)
  sw $t4, -124($a1)
  jr $ra
   
    
    
   
    
goUpFromStart:
    li $v0, 32
    li $a0, 50
    syscall
    
    lw $a0, secondscoreletterplace
    addi $a0, $a0, 16
    jal removewow    #remove notification
    
    lw $a0, secondscoreletterplace
    addi $a0, $a0, 32
    jal removenice   #remove notification
    
    lw $a0, secondscoreletterplace
    addi $a0, $a0, 16
    jal removegreat   #remove notification
   
     
     #redraw score
    lw $t9, score
    addi $t0, $zero, 0
    beq $t9, $t0, godraw1_0
    
    addi $t0, $zero, 1
    beq $t9, $t0, godraw1_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw2_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw3_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw4_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw5_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw6_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw7_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw8_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw9_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw10_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw11_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw12_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw13_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw14_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw15_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw16_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw17_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw18_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw19_1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw20_1
    
    godraw1_0:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal draw0
    j checkKeyboard_input1
 
    godraw1_1:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal draw1
    j checkKeyboard_input1
  
    godraw2_1:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete1
    jal draw2
    j checkKeyboard_input1
   
    godraw3_1:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete2
    jal draw3
    j checkKeyboard_input1
   
    
    godraw4_1:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete3
    jal draw4
    j checkKeyboard_input1
    
    godraw5_1:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete4
    jal draw5
    j checkKeyboard_input1
    
    
    godraw6_1:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete5
    jal draw6
    j checkKeyboard_input1
   
    
    godraw7_1:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete6
    jal draw7
    j checkKeyboard_input1
   
    godraw8_1:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete7
    jal draw8
    j checkKeyboard_input1
    
    
    godraw9_1:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete8
    jal draw9
    j checkKeyboard_input1
    
    
    godraw10_1:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete9
    jal draw0
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input1
  
    
    godraw11_1:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete0
    jal draw1
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input1
   
    
    godraw12_1:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete1
    jal draw2
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input1
 
    godraw13_1:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete2
    jal draw3
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input1
    
    godraw14_1:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete3
    jal draw4
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input1
   
    
    godraw15_1:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete4
    jal draw5
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input1
    
    godraw16_1:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete5
    jal draw6
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input1
   
    
    godraw17_1:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete6
    jal draw7
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input1
   
    
    godraw18_1:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete7
    jal draw8
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input1
  
    godraw19_1:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete8
    jal draw9
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input1
    
    
    godraw20_1:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete9
    jal draw0
    addi $a1, $t1, 0
    jal delete1
    jal draw2
    j checkKeyboard_input1
    
    
    
    checkKeyboard_input1:
    lw $s5, 0xffff0000
    beq $s5, 1 , keyboard_input1
    
    keyboard_input1:
    lw $s5, 0xffff0004	
    beq $s5, 0x73, goToCheckKeyboard1	           
    beq $s5, 0x6a, goToCheckKeyboard1	
    beq $s5, 0x6b, goToCheckKeyboard1  
    
 
     #draw the monster
    addi $a1, $s1, 0
    jal drawmonster
    
    #draw the second cloud
     addi $a1, $s2, 0
    jal drawCloud
    
     #draw the third cloud
     addi $a1, $s3, 0
    jal drawCloud
    
    
    
    
    lw $t0, darkred      #check if doodler is hit by monster, will jump to gameove if so
    addi $t1, $a2, -128
    lw $t2, ($t1)
    beq $t2, $t0, Gameover1
    addi $t1, $a2, -124
    lw $t2, ($t1)
    beq $t2, $t0, Gameover1
    addi $t1, $a2, -120
    lw $t2, ($t1)
    beq $t2, $t0, Gameover1
    addi $t1, $a2, -116
    lw $t2, ($t1)
    beq $t2, $t0, Gameover1
  
  
   
    lw $t9, doodlerStartPlace
    addi $t9, $t9, -768 #-1280-512-128
  
    blt $a2, $t9, goDownFromHighest
    jal removeCurrentDoodler
    addi $a2, $a2, -128
    jal drawDoodler
    
    
    
    j goUpFromStart
    
    goToCheckKeyboard1: 
    
    
    j checkInput
    
    Gameover1:
    li $v0, 33      #make sound when game over
    la $a0,byepitch
    addi $a0, $a0, 1
    lb $a0 0($a0)
    la $a1,byeduration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    
    li $v0, 33      #make sound when game over
    la $a0,byepitch
    addi $a0, $a0, 1
    lb $a0 0($a0)
    la $a1,byeduration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    
  
   j GameoverScreen
  
 
  
goDownFromHighest:
    li $v0, 32
    li $a0, 50
    syscall
    
    lw $a0, secondscoreletterplace
    addi $a0, $a0, 16
    jal removewow    #remove notification
    
    lw $a0, secondscoreletterplace
    addi $a0, $a0, 32
    jal removenice   #remove notification
    
    lw $a0, secondscoreletterplace
    addi $a0, $a0, 16
    jal removegreat   #remove notification
    
    
    
     #redraw score
    lw $t9, score
    
    addi $t0, $zero, 1
    beq $t9, $t0, godraw1_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw2_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw3_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw4_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw5_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw6_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw7_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw8_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw9_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw10_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw11_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw12_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw13_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw14_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw15_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw16_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw17_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw18_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw19_3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw20_3
    
    
    godraw1_3:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal draw1
    j checkKeyboard_input2
  
    godraw2_3:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete1
    jal draw2
    j checkKeyboard_input2
   
    godraw3_3:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete2
    jal draw3
    j checkKeyboard_input2
   
    
    godraw4_3:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete3
    jal draw4
    j checkKeyboard_input2
   
    
    godraw5_3:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete4
    jal draw5
    j checkKeyboard_input2
    
    
    godraw6_3:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete5
    jal draw6
    j checkKeyboard_input2
   
    
    godraw7_3:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete6
    jal draw7
    j checkKeyboard_input2
   
    godraw8_3:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete7
    jal draw8
    j checkKeyboard_input2
    
    
    godraw9_3:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete8
    jal draw9
    j checkKeyboard_input2
    
    
    godraw10_3:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete9
    jal draw0
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input2
  
    
    godraw11_3:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete0
    jal draw1
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input2
   
    
    godraw12_3:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete1
    jal draw2
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input2
 
    godraw13_3:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete2
    jal draw3
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input2
    
    godraw14_3:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete3
    jal draw4
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input2
   
    
    godraw15_3:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete4
    jal draw5
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input2
    
    godraw16_3:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete5
    jal draw6
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input2
   
    
    godraw17_3:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete6
    jal draw7
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input2
   
    
    godraw18_3:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete7
    jal draw8
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input2
  
    godraw19_3:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete8
    jal draw9
    addi $a1, $t1, 0
    jal draw1
    j checkKeyboard_input2
    
    
    godraw20_3:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete9
    jal draw0
    addi $a1, $t1, 0
    jal delete1
    jal draw2
    j checkKeyboard_input2
    
    
    
    
    checkKeyboard_input2:
    lw $s5, 0xffff0000
    beq $s5, 1 , keyboard_input2
    
    keyboard_input2:
    lw $s5, 0xffff0004
    beq $s5, 0x73, goToCheckKeyboard2	           
    beq $s5, 0x6a, goToCheckKeyboard2	
    beq $s5, 0x6b, goToCheckKeyboard2
    
   
    #draw the second platform
    jal removeCurrentDoodler
    addi $a0, $t7, 0
    jal drawPlatform
    
    #draw the third platform
    jal removeCurrentDoodler
    addi $a0, $t8, 0
    jal drawPlatform
    
     #draw the first cloud
    addi $a1, $s1, 0
    jal drawmonster
    
    #draw the second cloud
    addi $a1, $s2, 0
    jal drawCloud
    
     #draw the third cloud
     addi $a1, $s3, 0
    jal drawCloud
    

    
  
  lw $t0, green
  addi $t1, $a2, 768  #6*128
  lw $t2, ($t1)
  beq $t2, $t0, dropPlatformAndJump
  
  lw $t0, darkred      #check if doodler is hit by monster, will jump to gameove if so
  addi $t1, $a2, -128
  lw $t2, ($t1)
  beq $t2, $t0, GameOver
  addi $t1, $a2, -124
  lw $t2, ($t1)
  beq $t2, $t0, GameOver
  addi $t1, $a2, -120
  lw $t2, ($t1)
  beq $t2, $t0, GameOver
  addi $t1, $a2, -116
  lw $t2, ($t1)
  beq $t2, $t0, GameOver
  

    
  lw $t9, doodlerStartPlace
  addi $t9, $t9, 128
  bge $a2, $t9, GameOver
    
  
  
  jal removeCurrentDoodler
  addi $a2, $a2, 128
  jal drawDoodler
  
  j goDownFromHighest
  
   goToCheckKeyboard2:  
    j checkInput
    
   GameOver:
    li $v0, 33      #make sound when game over
    la $a0,byepitch
    addi $a0, $a0, 1
    lb $a0 0($a0)
    la $a1,byeduration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    
    li $v0, 33      #make sound when game over
    la $a0,byepitch
    addi $a0, $a0, 1
    lb $a0 0($a0)
    la $a1,byeduration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    
  
   j GameoverScreen
   
   dropPlatformAndJump:
   
    li $v0, 31      #make sound when jumps to a platform
    la $a0,jumppitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    li $v0, 31
    la $a0,byepitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    
   
    checkscore:
    lw $t9, score
    addi $t9, $t9, 1
    sw $t9, score
    
    addi $t0, $zero, 1
    beq $t9, $t0, godraw1
    addi $t0, $t0, 1
    beq $t9, $t0, godraw2
    addi $t0, $t0, 1
    beq $t9, $t0, godraw3
    addi $t0, $t0, 1
    beq $t9, $t0, godraw4
    addi $t0, $t0, 1
    beq $t9, $t0, godraw5
    addi $t0, $t0, 1
    beq $t9, $t0, godraw6
    addi $t0, $t0, 1
    beq $t9, $t0, godraw7
    addi $t0, $t0, 1
    beq $t9, $t0, godraw8
    addi $t0, $t0, 1
    beq $t9, $t0, godraw9
    addi $t0, $t0, 1
    beq $t9, $t0, godraw10
    addi $t0, $t0, 1
    beq $t9, $t0, godraw11
    addi $t0, $t0, 1
    beq $t9, $t0, godraw12
    addi $t0, $t0, 1
    beq $t9, $t0, godraw13
    addi $t0, $t0, 1
    beq $t9, $t0, godraw14
    addi $t0, $t0, 1
    beq $t9, $t0, godraw15
    addi $t0, $t0, 1
    beq $t9, $t0, godraw16
    addi $t0, $t0, 1
    beq $t9, $t0, godraw17
    addi $t0, $t0, 1
    beq $t9, $t0, godraw18
    addi $t0, $t0, 1
    beq $t9, $t0, godraw19
    addi $t0, $t0, 1
    beq $t9, $t0, godraw20
    
    
    
    godraw1:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete0
    jal draw1
    j dropPlatform
    
    godraw2:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete1
    jal draw2
    j dropPlatform
    
    godraw3:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete2
    jal draw3
    j dropPlatform
    
    godraw4:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete3
    jal draw4
    j dropPlatform
    
    godraw5:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete4
    jal draw5
    jal drawwow   # when score 5 points without dropping on the ground,  draw wow on board
    j dropPlatform
    
    godraw6:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete5
    jal draw6
    j dropPlatform
    
    godraw7:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete6
    jal draw7
    j dropPlatform
    
    godraw8:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete7
    jal draw8
    j dropPlatform
    
    godraw9:
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete8
    jal draw9
    j dropPlatform
    
    godraw10:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete9
    jal draw0
    addi $a1, $t1, 0
    jal draw1
    jal drawnice   # when score 10 points without dropping on the ground,  draw nice on board
    j dropPlatform
    
    godraw11:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete0
    jal draw1
    addi $a1, $t1, 0
    jal draw1
    j dropPlatform
    
    godraw12:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete1
    jal draw2
    addi $a1, $t1, 0
    jal draw1
    j dropPlatform
    
    godraw13:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete2
    jal draw3
    addi $a1, $t1, 0
    jal draw1
    j dropPlatform
    
    godraw14:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete3
    jal draw4
    addi $a1, $t1, 0
    jal draw1
    j dropPlatform
    
    godraw15:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete4
    jal draw5
    addi $a1, $t1, 0
    jal draw1
    jal drawgreat
    j dropPlatform
    
    godraw16:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete5
    jal draw6
    addi $a1, $t1, 0
    jal draw1
    j dropPlatform
    
    godraw17:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete6
    jal draw7
    addi $a1, $t1, 0
    jal draw1
    j dropPlatform
    
    godraw18:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete7
    jal draw8
    addi $a1, $t1, 0
    jal draw1
    j dropPlatform
    
    godraw19:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete8
    jal draw9
    addi $a1, $t1, 0
    jal draw1
    j dropPlatform
    
    godraw20:
    lw $t1 firstscoreletterplace
    lw $t9 secondscoreletterplace
    addi $a1, $t9, 0
    jal delete9
    jal draw0
    addi $a1, $t1, 0
    jal delete1
    jal draw2
    
     lw $t0, displayAddress # $t0 stores the base address for display
     lw $t9, displayEndAddress # $t1 stores the end address for display
          addi $t5, $t0, 0
          addi $t6, $t9, 4
    START_winner: beq $t6, $t5, END_winner
           lw $t4, blue
           sw $t4, ($t5)
           addi $t5, $t5, 4
           j START_winner
    END_winner:
    j winnerscreen
    
winnerscreen:
    li $v0, 32
    li $a0, 300
    syscall
    
    jal drawwinnerscreen
    
    #make sound for game over
    li $v0, 31
    la $a0,jumppitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
  checkKeyboard_input_winner:
    lw $s5, 0xffff0000
    beq $s5, 1 , keyboard_input_winner
    
    keyboard_input_winner:
    lw $s5, 0xffff0004
    checkInput_winner:
    beq $s5, 0x73, main	# the keyboard input is's', jump to main to restart the game              
   
    j winnerscreen	
    
    
drawwinnerscreen:
    lw $t0, firstunitoftherowofthirdplatform
    addi $t0, $t0, 28
    addi $t0, $t0, -384
    lw $t1, pink
    sw $t1, 0($t0)
    sw $t1, 16($t0)
    sw $t1, 128($t0)
    sw $t1, 144($t0)
    sw $t1, 256($t0)
    sw $t1, 264($t0)
    sw $t1, 272($t0)
    sw $t1, 384($t0)
    sw $t1, 388($t0)
    sw $t1, 396($t0)
    sw $t1, 400($t0)
    sw $t1, 512($t0)
    sw $t1, 528($t0)
    
    sw $t1, 28($t0)
    sw $t1, 156($t0)
    sw $t1, 284($t0)
    sw $t1, 412($t0)
    sw $t1, 540($t0)
    
    sw $t1, 40($t0)
    sw $t1, 44($t0)
    sw $t1, 64($t0)
    sw $t1, 168($t0)
    sw $t1, 176($t0)
    sw $t1, 192($t0)
    sw $t1, 296($t0)
    sw $t1, 308($t0)
    sw $t1, 320($t0)
    sw $t1, 424($t0)
    sw $t1, 440($t0)
    sw $t1, 448($t0)
    sw $t1, 552($t0)
    sw $t1, 572($t0)
    sw $t1, 576($t0)
    
    sw $t1, 76($t0)
    sw $t1, 204($t0)
    sw $t1, 332($t0)
    sw $t1, 588($t0)
    
    
    lw  $t0 firstunitoftherowofsecondplatform
    addi $t0, $t0, 12
    sw $t1, 0($t0) 
    sw $t1, 4($t0) 
    sw $t1, 8($t0) 
    sw $t1, 128($t0) 
    sw $t1, 136($t0) 
    sw $t1, 256($t0)
    sw $t1, 260($t0) 
    sw $t1, 264($t0)  
    sw $t1, 384($t0) 
    sw $t1, 512($t0) 
   
    sw $t1, 16($t0) 
    sw $t1, 20($t0) 
    sw $t1, 24($t0) 
    sw $t1, 144($t0) 
    sw $t1, 152($t0) 
    sw $t1, 272($t0) 
    sw $t1, 276($t0) 
    sw $t1, 280($t0) 
    sw $t1, 400($t0) 
    sw $t1, 404($t0) 
    sw $t1, 528($t0) 
    sw $t1, 536($t0) 
    
    sw $t1, 32($t0) 
    sw $t1, 36($t0) 
    sw $t1, 40($t0) 
    sw $t1, 160($t0) 
    sw $t1, 288($t0) 
    sw $t1, 292($t0) 
    sw $t1, 296($t0) 
    sw $t1, 416($t0) 
    sw $t1, 544($t0) 
    sw $t1, 548($t0) 
    sw $t1, 552($t0) 
    
    sw $t1, 48($t0) 
    sw $t1, 52($t0) 
    sw $t1, 56($t0) 
    sw $t1, 176($t0)
    sw $t1, 304($t0)  
    sw $t1, 308($t0)
    sw $t1, 312($t0) 
    sw $t1, 440($t0)
    sw $t1, 568($t0) 
    sw $t1, 564($t0) 
    sw $t1, 560($t0) 
    
    sw $t1, 64($t0) 
    sw $t1, 68($t0) 
    sw $t1, 72($t0) 
    sw $t1, 192($t0)
    sw $t1, 320($t0)  
    sw $t1, 324($t0)
    sw $t1, 328($t0) 
    sw $t1, 456($t0)
    sw $t1, 584($t0) 
    sw $t1, 580($t0) 
    sw $t1, 576($t0) 
    
    sw $t1, 88($t0) 
    sw $t1, 92($t0) 
    sw $t1, 96($t0) 
    sw $t1, 216($t0)
    sw $t1, 344($t0)  
    sw $t1, 348($t0)
    sw $t1, 352($t0) 
    sw $t1, 480($t0)
    sw $t1, 608($t0) 
    sw $t1, 604($t0) 
    sw $t1, 600($t0) 
    
    addi $t0, $t0, 760
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 132($t0)
    sw $t1, 260($t0)
    sw $t1, 388($t0)
    sw $t1, 516($t0)
    
    sw $t1, 16($t0)
    sw $t1, 20($t0)
    sw $t1, 24($t0)
    sw $t1, 144($t0)
    sw $t1, 152($t0)
    sw $t1, 272($t0)
    sw $t1, 280($t0)
    sw $t1, 400($t0)
    sw $t1, 408($t0)
    sw $t1, 528($t0)
    sw $t1, 532($t0)
    sw $t1, 536($t0)
    
    
    
    sw $t1, 40($t0) 
    sw $t1, 44($t0) 
    sw $t1, 48($t0) 
    sw $t1, 168($t0) 
    sw $t1, 176($t0) 
    sw $t1, 296($t0) 
    sw $t1, 300($t0) 
    sw $t1, 304($t0) 
    sw $t1, 424($t0) 
    sw $t1, 428($t0) 
    sw $t1, 552($t0) 
    sw $t1, 560($t0) 
    
    sw $t1, 56($t0) 
    sw $t1, 60($t0) 
    sw $t1, 64($t0) 
    sw $t1, 184($t0) 
    sw $t1, 312($t0) 
    sw $t1, 316($t0) 
    sw $t1, 320($t0) 
    sw $t1, 440($t0) 
    sw $t1, 568($t0) 
    sw $t1, 572($t0) 
    sw $t1, 576($t0) 
    
    sw $t1, 72($t0)
    sw $t1, 76($t0)
    sw $t1, 80($t0)
    sw $t1, 204($t0)
    sw $t1, 332($t0)
    sw $t1, 460($t0)
    sw $t1, 588($t0)
    
    sw $t1, 88($t0) 
    sw $t1, 92($t0) 
    sw $t1, 96($t0) 
    sw $t1, 216($t0) 
    sw $t1, 224($t0) 
    sw $t1, 344($t0) 
    sw $t1, 348($t0) 
    sw $t1, 352($t0) 
    sw $t1, 472($t0) 
    sw $t1, 476($t0) 
    sw $t1, 600($t0) 
    sw $t1, 608($t0) 
    
    sw $t1, 104($t0) 
    sw $t1, 112($t0) 
    sw $t1, 232($t0) 
    sw $t1, 240($t0) 
    sw $t1, 360($t0) 
    sw $t1, 364($t0) 
    sw $t1, 368($t0) 
    sw $t1, 496($t0) 
    sw $t1, 624($t0) 
    sw $t1, 620($t0) 
  
    jr $ra
  
   dropEnd:
   j goUpFromStart
   
  
goDownToTheEnd:
    li $v0, 32
    li $a0, 50
    syscall
   
    checkKeyboard_input3:
    lw $s5, 0xffff0000
    beq $s5, 1 , keyboard_input3
    
    keyboard_input3:
    lw $s5, 0xffff0004	
    beq $s5, 0x73, goToCheckKeyboard3           
    beq $s5, 0x6a, goToCheckKeyboard3	
    beq $s5, 0x6b, goToCheckKeyboard3
    
    
  lw $t0, green
  addi $t1, $a2, 768  #6*128-256
  lw $t2, ($t1)
  beq $t2, $t0, goUpFromStart
  
  jal removeCurrentDoodler
  addi $a2, $a2, 128
  jal drawDoodler
 
 
  j goDownToTheEnd
  
  goToCheckKeyboard3: 
    j checkInput
    
    
    
GameoverScreen:
    li $v0, 32
    li $a0, 300
    syscall
    
    jal drawGameOver
    
    #make sound for game over
    li $v0, 31
    la $a0,byepitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
   checkKeyboard_input_final:
    lw $s5, 0xffff0000
    beq $s5, 1 , keyboard_input_final
    
    keyboard_input_final:
    lw $s5, 0xffff0004
    checkInput_final:
    beq $s5, 0x73, main	# the keyboard input is's', jump to main to restart the game              
    
    
    j GameoverScreen	
 
checkinputfunction:
    lw $s5, 0xffff0000
    beq $s5, 1 , keyboard_input_function
    
    keyboard_input_function:
    lw $s5, 0xffff0004
    beq $s5, 0x73, startGame	# the keyboard input is's', jump to start the game              
    beq $s5, 0x6a, moveLeft	# the keyboard input == 'j', jump to moveLeft
    beq $s5, 0x6b, moveRight 
    jr $ra
playbgm:
    li $v0, 33
    la $a0,Cpitch
    lb $a0 0($a0)
    la $a1,duration
    #la $a2,instrument
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    
     
    li $v0, 33
    la $a0,Cpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Gpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    
    li $v0, 33
    la $a0,Gpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Apitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Apitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Gpitch
    lb $a0 0($a0)
    la $a1,bgmduration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
     #second part
    
    li $v0, 33
    la $a0,Fpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
  
    li $v0, 33
    la $a0,Fpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
     li $v0, 33
    la $a0,Epitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
     li $v0, 33
    la $a0,Epitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
     li $v0, 33
    la $a0,Dpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
     li $v0, 33
    la $a0,Dpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
     li $v0, 33
    la $a0,Cpitch
    lb $a0 0($a0)
    la $a1,bgmduration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    #third part
     li $v0, 33
    la $a0,Gpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Gpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Fpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Fpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Epitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Epitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Dpitch
    lb $a0 0($a0)
    la $a1, bgmduration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    #fouth part
    li $v0, 33
    la $a0,Gpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Gpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Fpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Fpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    
    li $v0, 33
    la $a0,Epitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Epitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Dpitch
    lb $a0 0($a0)
    la $a1,bgmduration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
     li $v0, 33
    la $a0,Cpitch
    lb $a0 0($a0)
    la $a1,duration
    #la $a2,instrument
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
     
    li $v0, 33
    la $a0,Cpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Gpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Gpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Apitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Apitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    li $v0, 33
    la $a0,Gpitch
    lb $a0 0($a0)
    la $a1,bgmduration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
     #second part
    
    li $v0, 33
    la $a0,Fpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
  
    li $v0, 33
    la $a0,Fpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
     li $v0, 33
    la $a0,Epitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
     li $v0, 33
    la $a0,Epitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
     li $v0, 33
    la $a0,Dpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
     li $v0, 33
    la $a0,Dpitch
    lb $a0 0($a0)
    la $a1,duration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
     li $v0, 33
    la $a0,Cpitch
    lb $a0 0($a0)
    la $a1,bgmduration
    lb $a1, 0($a1)
    la $a3, volume
    lb $a3, 0($a3)
    syscall
    jal checkinputfunction
    
    j checkKeyboard_input
     
  
  
  
  
  
  
    
    

   
    
