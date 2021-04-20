 
 
 .data  # Ketu i kemi të gjitha te dhenat e programit tone,  si psh variablat
 #Me poshte kemi deklaruar variabla te tipit string qe ne MIPS jane asciiz

 
 cout1: .asciiz "Enter the number of terms of series : " ## Mesazhi ne cout-in e pare ne main
 cout2: .asciiz "\nFibonnaci series : " ### Mesazhi ne cout-in e dyte ne main
 MesPerfundimtare: .asciiz "Seria u perfundua me sukses"
KercimPer2Rreshta: .asciiz "\n\n" #Ndarja e hapesires mes numrave ne serine Fibonacci


.text #Pjesa e kodit
.globl	main
main: #Funksioni Kryesor

 
 #_______________________Funksioni printo ___________________
 
 jal printo #thirrja e funsionit printo, ku jane te shtypura te dhenat nga useri
 

addi $t1, $zero, 0 # inicializimi i i me 0 (int i = 0)

 
 whileloop:
  bge $t1, $s3, Perfundimi # bge - branch on greater than or equal (if($1>=$2)), pra eshte bere testimi
#kur ne momentin qe t1 eshte me i madh ose barabart me s3 (Vlera e dhene permes inputit - cin
#dmth te kushti i < x, dalim nga loop-a
  
  li $v0, 4 # i ben me dije sistemit se do te printoje nje string(text)
  la $a0, KercimPer2Rreshta #ketu sistemi do i paraqet(printon) numrat e ndare nga dy rresha ndermejt
  syscall #printo

  
  move $a0, $t1 #e vendosim vleren e t1 ne argumentin a0, mund te behet edhe permes add
  jal fib #thirret funskioni fib
  
  add $s1, $v0, $zero   ## e vendosim vleren e v0 ne regjistrin s1, 

  li $v0, 1  # i tregon sistemit se do te shtypet nje integer 
  move $a0, $s1  # e vendosim vleren  
  syscall #printo

  addi $t1, $t1, 1 #ketu behet iterimi ne loop, pra pjese i++

  j whileloop # jump in loop dmth eshte instrukcion qe kercen ne target adress
  
  jal MesazhiperPerfundim #thirrja e funsionit per mesazhin e perfundimit
  
  
  
Perfundimi:
  li $v0, 10 # Ky instrukcion tregon se funskioni main ka perfunduar dhe duhet te jete cdo here ne menyre qe te mos lejohet infinite recursion
  syscall
  
  
printo:
 li $v0, 4 # i ben me dije sistemit se do te printoje nje string(text)
 la $a0, cout1 #Ne kete pjese printohet variabla(ne rastin tone) string
 syscall #printo

 li $v0, 5 #Instruksioni per marrjen e inputit te nje integeri(pra cin ne C++)
 syscall
 
 add $s3, $v0, $zero # E vendosim inputin(vleren e dhene permes tastiere) ne regjistrin $s3

 li $v0, 4 #Ne kete pjese do te shtypet mesazhi i dyte, i dhene ne .data dhe pastaj printohet seria
 la $a0, cout2
 syscall #printimi
 
jr $ra #shkon back to function ose vendin qe e ka thirre ket label(funskion ne kete rast), pra ne ate adrese
 


MesazhiperPerfundim:
li $v0, 4 # i ben me dije sistemit se do te printoje nje string(text)
 la $a0, mes12 #Ne kete pjese printohet variabla(ne rastin tone) string, mes12 ne .data
 syscall
jr $ra #shkon back to function ose vendin qe e ka thirre ket label(funskion ne kete rast), pra ne ate adrese


fib:
  
 subu $sp, $sp, 12 #Alokimi i hapesires prej 12 bajt-esh - #I ben store 12 bajt ne Stack per 3 variabla - ne kete rast mund te perdoret edhe addi por pastaj duhet -12.
 
 #Ne rastet kur kemi me thirre funksion ne funksion(ose label), duhet me rujt adresen e vjeter ne stack, pra duhet me dite
 #ku adresa do te jete
 

 
 sw $a0, ($sp) #Tash rezervon vendet per variabla, tash per x 
 sw $ra, 4($sp) #sp eshte stack pointer, pra duhet me aloku mjaftueshem hapesire ne Stack per vleren e vjeter, e ne kete rast ruan adresen. 
 #Pra e ruan adresen ne lokacionin e dyte tash ne stack pointer
 sw $s0, 8($sp) #e bon store njerin rezultat, e pastaj me poshte kryhet mbledhje
 #duke pasuar ne regjistra tjere
 
 
 bne $a0, 1, Kushti_Tjeter #Nese x != 1, shiko pastaj a eshte x == 0
 li $v0, 1 #Nese plotesohet kushti per (x==1), kthen return x, ne kete rast 1
 
 addi $sp, $sp, 12 #Restore stack (# po e lirojme ate pjese te stack-ut)
 jr $ra #shkon back to function ose vendin qe e ka thirre ket label(funskion ne kete rast), pra ne ate adrese



Kushti_Tjeter:

 bgtz $a0, Rekurzioni #bgtz eshte pseudo instrukcion, i bie if ($a0 > 0) - branch  greater than zero
 li $v0, 0 #Nese plotesohet kushti per (x==0), kthen return x, ne kete rast 0
 addi $sp, $sp, 12 #Restore stack (# po e lirojme ate pjese te stack-ut)
 jr $ra #kthimi i adreses



Rekurzioni: 

 subu $a0, $a0, 1 #Kjo eshte pjese te (x-1)
 jal fib # Thirrja rekurzive e funsionit 
 
 lw $a0, ($sp) # e bajme restore vleren reale te x
 add $s0, $v0, $zero  # e vendosim vleren e v0 ne regjistrin s0

 subu $a0, $a0, 2 #pjesa te x-2
 jal fib # Thirrja rekurzive e funsionit
 add $v0, $s0, $v0 #Pjese e kodit ne return(fib(x-1)+fib(x-2));

 lw $a0, 0($sp) #Po i bejme load vleren e variables lokale bact to register nga stacku
 lw $ra, 4($sp) # po e rikthejme adresen kthyese te ketij funksioni nga stack-u, pra vlera e adreses do behet load nga Ram-i
 #Pra eshte e kunderta e asaj qe e kemi bere ne sw $a0, 4($sp) psh, ku vlerat i kemi vendos ne Ram, e ketu sepse funksioni ka perfunduar
 #We are getting values back from the stack
 lw $s0, 8($sp)

 addu $sp, $sp, 12 #Do te bejme restore Stackun, sepse atje kemi marre 12bajt poshte, ndersa tash per ta rikthyer
 #Pra parimi i punes se stackut
 
 jr $ra #return prej funsionit
