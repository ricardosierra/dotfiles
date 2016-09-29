#!/bin/bash
#
# campo_minado.sh - jogo de campo minado
# 
# Homepage: http://rodneybr.t35.com
# Autor   : Rodney Barreto <rwbarreto@yahoo.com.br>
#
#  ----------------------------------------------------------------------
#   Este é o jogo CAMPO MINADO, totalmente feito em shell-script. O 
#   programa recebe as coordenadas digitadas pelo usuário, mostrando a
#   situação atual e informando se o usuário fez pontos ou perdeu o jogo.
#
#   Exemplo:
#
#            *** CAMPO MINADO ***
#
#         1     2     3     4     5    
#      +-----+-----+-----+-----+-----+
#    1 |  *  |     |     |     |     |
#      +-----+-----+-----+-----+-----+
#    2 |     |     |     |     |     |
#      +-----+-----+-----+-----+-----+
#    3 |     |     |     |     |     |
#      +-----+-----+-----+-----+-----+
#    4 |     |     |     |     |     |
#      +-----+-----+-----+-----+-----+
#    5 |     |     |     |     |     |
#      +-----+-----+-----+-----+-----+
#
#	 Digite as coordenadas. Por exemplo, caso queira ver o
#	 quadro que esta na linha 5 e coluna 5, digite: 55
#	 Coordenadas: 11
#
#    * BOMBA * FIM DE JOGO
#  ----------------------------------------------------------------------
#
#
# Histórico:
#
#    v1.0 2006-06-13, Rodney Barreto:
#       - Versão inicial
#
#
# COPYRIGHT: Este programa é GPL.
#

clear
echo "        *** CAMPO MINADO ***      "

echo "      1     2     3     4     5   "
echo "   +-----+-----+-----+-----+-----+"
echo " 1 |     |     |     |     |     |"
echo "   +-----+-----+-----+-----+-----+"
echo " 2 |     |     |     |     |     |"
echo "   +-----+-----+-----+-----+-----+"
echo " 3 |     |     |     |     |     |"
echo "   +-----+-----+-----+-----+-----+"
echo " 4 |     |     |     |     |     |"
echo "   +-----+-----+-----+-----+-----+"
echo " 5 |     |     |     |     |     |"
echo "   +-----+-----+-----+-----+-----+"

# Variável pontos inicializada com zero, utilizada para contar
# os pontos.
#
pontos=0 

# Variável fim, utilizada para terminar o laço, assumindo o valor 1,
# quando for encontrada uma BOMBA.
#
fim=0

while [ $fim -eq 0 ] 
do
	echo	
	echo 'Digite as coordenadas. Por exemplo, caso queira ver o'
	echo 'quadro que esta na linha 5 e coluna 5, digite: 55'
	echo -n 'Coordenadas: '; read coord

	case $coord in 
		11) # Posiciona o cursor na linha 4, coluna 7 e imprime (*)
			echo -e '\033[4;7H*\033[14B'
			echo '* BOMBA * FIM DE JOGO'
			fim=1
			;;
		12) # Posiciona o cursor na linha 4, coluna 13 e imprime (2)
			echo -e '\033[4;13H2'
			pontos=$(($pontos + 10))
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		13) # Posiciona o cursor na linha 4, coluna 19 e imprime (2)
			echo -e '\033[4;19H2'
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		14) # Posiciona o cursor na linha 4, coluna 25 e imprime (*)
			echo -e '\033[4;25H*\033[14B'
			echo '* BOMBA * FIM DE JOGO'
			fim=1
			;; 
		15) # Posiciona o cursor na linha 4, coluna 31 e imprime (1)
			echo -e '\033[4;31H1'
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		21) # Posiciona o cursor na linha 6, coluna 7 e imprime (2)
			echo -e '\033[6;7H2' 
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		22) # Posiciona o cursor na linha 6, coluna 13 e imprime (3)
			echo -e '\033[6;13H3'
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		23) # Posiciona o cursor na linha 6, coluna 19 e imprime (*)
			echo -e '\033[6;19H*\033[12B'
			echo '* BOMBA * FIM DE JOGO'
			fim=1
			;;
		24) # Posiciona o cursor na linha 6, coluna 25 e imprime (3)
			echo -e '\033[6;25H3'
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		25) # Posiciona o cursor na linha 6, coluna 31 e imprime (2)
			echo -e '\033[6;31H2'
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		31) # Posiciona o cursor na linha 8, coluna 7 e imprime (*)
			echo -e '\033[8;7H*\033[10B'
			echo '* BOMBA * FIM DE JOGO'
			fim=1
			;;
		32) # Posiciona o cursor na linha 8, coluna 13 e imprime (3)
			echo -e '\033[8;13H3'
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		33) # Posiciona o cursor na linha 8, coluna 19 e imprime (2)
			echo -e '\033[8;19H2'	
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		34) # Posiciona o cursor na linha 8, coluna 25 e imprime (3)
			echo -e '\033[8;25H3'
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		35) # Posiciona o cursor na linha 8, coluna 31 e imprime (*)
			echo -e '\033[8;31H*\033[10B'
			echo '* BOMBA * FIM DE JOGO'
			fim=1
			;;
		41) # Posiciona o cursor na linha 10, coluna 7 e imprime (*)
			echo -e '\033[10;7H*\033[8B'
			echo '* BOMBA * FIM DE JOGO'
			fim=1
			;;
		42) # Posiciona o cursor na linha 10, coluna 13 e imprime (3)
			echo -e '\033[10;13H3' 
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		43) # Posiciona o cursor na linha 10, coluna 19 e imprime (2)
			echo -e '\033[10;19H2' 	
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		44) # Posiciona o cursor na linha 10, coluna 25 e imprime (*)
			echo -e '\033[10;25H*\033[8B'
			echo '* BOMBA * FIM DE JOGO'
			fim=1
			;;
		45) # Posiciona o cursor na linha 10, coluna 31 e imprime (2)
			echo -e '\033[10;31H2' 	
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		51) # Posiciona o cursor na linha 12, coluna 7 e imprime (1)
			echo -e '\033[12;7H1' 
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		52) # Posiciona o cursor na linha 12, coluna 13 e imprime (1)
			echo -e '\033[12;13H1'
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		53) # Posiciona o cursor na linha 12, coluna 19 e imprime (*)
			echo -e '\033[12;19H*\033[6B'
			echo '* BOMBA * FIM DE JOGO'
			fim=1
			;;	
		54) # Posiciona o cursor na linha 12, coluna 25 e imprime (2)
			echo -e '\033[12;25H2'
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		55) # Posiciona o cursor na linha 12, coluna 31 e imprime (1)
			echo -e '\033[12;31H1'	
			pontos=$(($pontos + 10))   		
			echo -e "\033[8;50H$pontos PONTOS\033[4B"
			echo
		 	;;
		*)  echo
			echo -n 'Coordenada não existe, Tente novamente!' 
			sleep 2 
			# Apaga até o início da linha e depois sobe 6 linhas
			echo -e '\033[2K\033[6A'
			;;
	esac
	
	if [ $pontos -eq 170 ]; then 
		echo -e '\033[5B*** VENCEDOR ***'
		break;
	fi
done

echo 