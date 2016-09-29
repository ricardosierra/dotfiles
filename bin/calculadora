#!/bin/bash
#Autor: k666
#Data: 21/01/2013
#Algoritmo que calcula: soma, subtração, multiplicação,
#divisão, a raiz quadrada de números exatos como 4, 16,  121...
#e conversão de bases decimal e hexadecimal


menu ()
{

clear

echo "	_____________________________________"
echo 
echo "		CALCULADORA CONTA FÁCIL"
echo "		     Versão 0.1"
echo "	       Desenvolvido por K666"
echo "	_____________________________________"
echo 
echo 
echo "< 1 > Somar "
echo "< 2 > Subtração "
echo "< 3 > Multiplicação "
echo "< 4 > Divisão "
echo "< 5 > Raiz quadrada "
echo "< 0 > Sair "
echo 
echo "Escolha uma das opções acima:  "
read  opcao

case $opcao in
	1) soma ;;
	2) subtracao ;;
	3) multiplicacao ;; 
	4) divisao ;;
	5) raizquad ;;
	0) exit ;;
esac

}

soma ()
{
	
	clear
	echo "Digite um número: "
	read num1
	echo "Digite um número: "
	read num2

	soma=$(($num1 + $num2 ))
	
	echo "Resultado da soma: $soma"

echo
echo "--------------------------------"
echo

	echo "O que deseja fazer agora?"
	echo "< c > Continuar"
	echo "< m >  Menu Principal"
	echo "< s >  Sair"
	
	echo "Escolha uma opção"
	read op

	if [ "$op" = "c" ]
	then
		soma
	elif [ "$op" = "m" ]
	then
		menu
	elif [ "$op" = "s" ]
	then
		clear		
		exit 
	else
		echo " Opção Inválida! "
	fi

}

subtracao ()
{
	
	clear
	echo "Digite um número: "
	read num1
	echo "Digite um número: "
	read num2

	sub=$(($num1 - $num2 ))
	
	echo "Resultado da soma: $sub"

echo
echo "--------------------------------"
echo

	echo "O que deseja fazer agora?"
	echo "< c > Continuar"
	echo "< m >  Menu Principal"
	echo "< s >  Sair"
	
	echo "Escolha uma opção"
	read op

	if [ "$op" = "c" ]
	then
		subtracao
	elif [ "$op" = "m" ]
	then
		menu
	elif [ "$op" = "s" ]
	then
		clear		
		exit 
	else
		echo " Opção Inválida! "
	fi

}

multiplicacao ()
{

	clear
	echo "Digite um número: "
	read num1
	echo "Digite um número: "
	read num2

	mult=$(($num1 * $num2 ))
	
	echo "Resultado da soma: $mult"

echo
echo "--------------------------------"
echo

	echo "O que deseja fazer agora?"
	echo "< c > Continuar"
	echo "< m >  Menu Principal"
	echo "< s >  Sair"
	
	echo "Escolha uma opção"
	read op

	if [ "$op" = "c" ]
	then
		multiplicacao
	elif [ "$op" = "m" ]
	then
		menu
	elif [ "$op" = "s" ]
	then
		clear		
		exit 
	else
		echo " Opção Inválida! "
	fi

}

divisao ()
{

	clear
	echo "Digite um número: "
	read num1
	echo "Digite um número: "
	read num2

	div=$(($num1 / $num2 ))
	
	echo "Resultado da soma: $div"

echo
echo "--------------------------------"
echo

	echo "O que deseja fazer agora?"
	echo "< c > Continuar"
	echo "< m >  Menu Principal"
	echo "< s >  Sair"
	
	echo "Escolha uma opção"
	read op

	if [ "$op" = "c" ]
	then
		divisao
	elif [ "$op" = "m" ]
	then
		menu
	elif [ "$op" = "s" ]
	then
		clear		
		exit 
	else
		echo " Opção Inválida! "
	fi

}


raizquad ()
{

clear
echo "Digite um número: "
read num

#Iniciando o contandor com 1 pois não existe divisão por zero
i=1


while [ $i -lt $num ]
do

#Variável calc significa cálculo e calc2, cálculo2
#A variável calc fará a divisão do número passado pelo
#usuário e o contador. Em seguida este valor será multiplicado
#por ele mesmo na variável calc2.


	calc=$(($num / $i))
	calc2=$(($calc * $calc ))


#Aqui é realizado o teste que caso seja verdadeiro a
#condição $calc2 for igual a $num, haverá uma interrupção
#no loop (com o comando bread) e será mostrado o comando 
#echo logo abaixo
	

		if [ $calc2 -eq $num ]
		then
			break
		fi
	i=$(($i + 1))
done

echo "A raiz quadrada de $num é: $calc"

echo
echo "--------------------------------"
echo

	echo "O que deseja fazer agora?"
	echo "< c > Continuar"
	echo "< m >  Menu Principal"
	echo "< s >  Sair"
	
	echo "Escolha uma opção"
	read op

	if [ "$op" = "c" ]
	then
		divisao
	elif [ "$op" = "m" ]
	then
		menu
	elif [ "$op" = "s" ]
	then
		clear		
		exit 
	else
		echo " Opção Inválida! "
	fi

}


################### CHAMAR O MENU PRINCIPAL ###################


menu

##############################################################


