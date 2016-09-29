
# By: Motomagx - facebook.com/motomagx

A=" "
B=" "
C=" "
D=" "
E=" "
F=" "
G=" "
H=" "
I=" "

ERROR=0
INITUSER=X

_table()
{
	clear
	echo -e "\n"
	echo -e "    $A | $B | $C "
	echo -e "   -----------"
	echo -e "    $D | $E | $F "
	echo -e "   -----------"
	echo -e "    $G | $H | $I "
	echo -e "\n"
}

_testfail()
{
	COUNTER=0
	if [ "$A" != " " ]
	then
		COUNTER=$(($COUNTER+1))
	fi
	if [ "$B" != " " ]
	then
		COUNTER=$(($COUNTER+1))
	fi
	if [ "$C" != " " ]
	then
		COUNTER=$(($COUNTER+1))
	fi
	if [ "$D" != " " ]
	then
		COUNTER=$(($COUNTER+1))
	fi
	if [ "$E" != " " ]
	then
		COUNTER=$(($COUNTER+1))
	fi
	if [ "$F" != " " ]
	then
		COUNTER=$(($COUNTER+1))
	fi
	if [ "$G" != " " ]
	then
		COUNTER=$(($COUNTER+1))
	fi
	if [ "$H" != " " ]
	then
		COUNTER=$(($COUNTER+1))
	fi
	if [ "$I" != " " ]
	then
		COUNTER=$(($COUNTER+1))
	fi
	
	if [ $COUNTER == 9 ]
	then
		echo -e " Nenhum vencedor.\n"
		exit
	fi 
}

_random()
{
	_testfail

	STOP1=0
	while [ $STOP1 != 1 ]
	do
		NUMBER=`echo $((RANDOM %8))`
		NUMBER=$(($NUMBER+1)) # Esta ação é necessária para previnir que o número 0 seja sorteado
		case $NUMBER in
			1) if [ "$A" == " " ]
			   then
				A=O
				STOP1=1
			   fi ;;
			2) if [ "$B" == " " ]
			   then
				B=O
				STOP1=1
			   fi ;;
			3) if [ "$C" == " " ]
			   then
				C=O
				STOP1=1
			   fi ;;
			4) if [ "$D" == " " ]
			   then
				D=O
				STOP1=1
			   fi ;;
			5) if [ "$E" == " " ]
			   then
				E=O
				STOP1=1
			   fi ;;
			6) if [ "$F" == " " ]
			   then
				F=O
				STOP1=1
			   fi ;;
			7) if [ "$G" == " " ]
			   then
				G=O
				STOP1=1
			   fi ;;
			8) if [ "$H" == " " ]
			   then
				H=O
				STOP1=1
			   fi ;;
			9) if [ "$I" == " " ]
			   then
				I=O
				STOP1=1
			   fi ;;
		esac
	done
}

_display()
{
	PLAYER=X
	_check_for_winner

	PLAYER=O
	_check_for_winner

	_table

	_testfail

	if [ $INITUSER == X ]
	then
		ERROR=0

		echo -e " Jogador $INITUSER, selecione uma peça:" 

		read SELECT
	else
		MOVED=0

	if [ $MOVED == 0 ]
	then
		if [ "$A $B $C" == "  O O" ]
		then
			A=O
			NUMBER=1
			MOVED=1
		fi
	fi
	if [ $MOVED == 0 ]
	then
		if [ "$A $B $C" == "O   O" ]
		then
			B=O
			NUMBER=2
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$A $B $C" == "O O  " ]
		then
			C=O
			NUMBER=3
			MOVED=1
		fi
	fi

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$D $E $F" == "  O O" ]
		then
			D=O
			NUMBER=4
			MOVED=1
		fi
	fi
	if [ $MOVED == 0 ]
	then
		if [ "$D $E $F" == "O   O" ]
		then
			E=O
			NUMBER=5
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$D $E $F" == "O O  " ]
		then
			F=O
			NUMBER=6
			MOVED=1
		fi
	fi
	

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$G $H $I" == "  O O" ]
		then
			G=O
			NUMBER=7
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$G $H $I" == "O   O" ]
		then
			H=O
			NUMBER=8
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$G $H $I" == "O O  " ]
		then
			I=O
			NUMBER=9
			MOVED=1
		fi
	fi
	

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$A $D $G" == "  O O" ]
		then
			A=O
			NUMBER=1
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$A $D $G" == "O   O" ]
		then
			D=O
			NUMBER=4
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$A $D $G" == "O O  " ]
		then
			G=O
			NUMBER=7
			MOVED=1
		fi
	fi
	

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$B $E $H" == "  O O" ]
		then
			B=O
			NUMBER=2
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$B $E $H" == "O   O" ]
		then
			E=O
			NUMBER=5
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$B $E $H" == "O O  " ]
		then
			H=O
			NUMBER=8
			MOVED=1
		fi
	fi
	

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$C $F $I" == "  O O" ]
		then
			C=O
			NUMBER=3
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$C $F $I" == "O   O" ]
		then
			F=O
			NUMBER=6
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$C $F $I" == "O O  " ]
		then
			I=O
			NUMBER=9
			MOVED=1
		fi
	fi
	

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$A $E $I" == "  O O" ]
		then
			A=O
			NUMBER=1
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$A $E $I" == "O   O" ]
		then
			E=O
			NUMBER=5
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$A $E $I" == "O O  " ]
		then
			I=O
			NUMBER=9
			MOVED=1
		fi
	fi
	

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$C $E $G" == "  O O" ]
		then
			C=O
			NUMBER=3
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$C $E $G" == "O   O" ]
		then
			E=O
			NUMBER=5
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then

		if [ "$C $E $G" == "O O  " ]
		then
			G=O
			NUMBER=7
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$A $B $C" == "  X X" ]
		then
			A=O
			NUMBER=1
			MOVED=1
		fi
	fi
	if [ $MOVED == 0 ]
	then
		if [ "$A $B $C" == "X   X" ]
		then
			B=O
			NUMBER=2
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$A $B $C" == "X X  " ]
		then
			C=O
			NUMBER=3
			MOVED=1
		fi
	fi
	

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$D $E $F" == "  X X" ]
		then
			D=O
			NUMBER=4
			MOVED=1
		fi
	fi
	if [ $MOVED == 0 ]
	then
		if [ "$D $E $F" == "X   X" ]
		then
			E=O
			NUMBER=5
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$D $E $F" == "X X  " ]
		then
			F=O
			NUMBER=6
			MOVED=1
		fi
	fi
	

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$G $H $I" == "  X X" ]
		then
			G=O
			NUMBER=7
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$G $H $I" == "X   X" ]
		then
			H=O
			NUMBER=8
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$G $H $I" == "X X  " ]
		then
			I=O
			NUMBER=9
			MOVED=1
		fi
	fi
	

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$A $D $G" == "  X X" ]
		then
			A=O
			NUMBER=1
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$A $D $G" == "X   X" ]
		then
			D=O
			NUMBER=4
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$A $D $G" == "X X  " ]
		then
			G=O
			NUMBER=7
			MOVED=1
		fi
	fi
	

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$B $E $H" == "  X X" ]
		then
			B=O
			NUMBER=2
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$B $E $H" == "X   X" ]
		then
			E=O
			NUMBER=5
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$B $E $H" == "X X  " ]
		then
			H=O
			NUMBER=8
			MOVED=1
		fi
	fi
	

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$C $F $I" == "  X X" ]
		then
			C=O
			NUMBER=3
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$C $F $I" == "X   X" ]
		then
			F=O
			NUMBER=6
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$C $F $I" == "X X  " ]
		then
			I=O
			NUMBER=9
			MOVED=1
		fi
	fi
	

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$A $E $I" == "  X X" ]
		then
			A=O
			NUMBER=1
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$A $E $I" == "X   X" ]
		then
			E=O
			NUMBER=5
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$A $E $I" == "X X  " ]
		then
			I=O
			NUMBER=9
			MOVED=1
		fi
	fi
	

################################################################################

	if [ $MOVED == 0 ]
	then
		if [ "$C $E $G" == "  X X" ]
		then
			C=O
			NUMBER=3
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then
		if [ "$C $E $G" == "X   X" ]
		then
			E=O
			NUMBER=5
			MOVED=1
		fi
	fi
	
	if [ $MOVED == 0 ]
	then

		if [ "$C $E $G" == "X X  " ]
		then
			G=O
			NUMBER=7
			MOVED=1
		fi
	fi
	
################################################################################


		if [ $MOVED == 0 ]
		then
			_random
		fi

		echo " Peça selecionada: $NUMBER"
		sleep 1s
		INITUSER=X
	fi
}

_imput()
{
	case $SELECT in
		1) if [ "$A" == " " ]
		   then
			A=$INITUSER
			STOP=1
		   else
			ERROR=1
		   fi ;;

		2) if [ "$B" == " " ]
		   then
			B=$INITUSER
			STOP=1
		   else
			ERROR=1
		   fi ;;

		3) if [ "$C" == " " ]
		   then
			C=$INITUSER
			STOP=1
		   else
			ERROR=1
		   fi ;;

		4) if [ "$D" == " " ]
		   then
			D=$INITUSER
			STOP=1
		   else
			ERROR=1
		   fi ;;

		5) if [ "$E" == " " ]
		   then
			E=$INITUSER
			STOP=1
		   else
			ERROR=1
		   fi ;;

		6) if [ "$F" == " " ]
		   then
			F=$INITUSER
			STOP=1
		   else
			ERROR=1
		   fi ;;

		7) if [ "$G" == " " ]
		   then
			G=$INITUSER
			STOP=1
		   else
			ERROR=1
		   fi ;;

		8) if [ "$H" == " " ]
		   then
			H=$INITUSER
			STOP=1
		   else
			ERROR=1
		   fi ;;

		9) if [ "$I" == " " ]
		   then
			I=$INITUSER
			STOP=1
		   else
			ERROR=1
		   fi ;;
	esac
}

_winner()
{
	if [ $PLAYER == X ]
	then
		echo -e "\n\n O jogador é o vencedor!\n"
	else
		echo -e "\n\n O computador é o vencedor!\n"
	fi

	exit
}

_check_for_winner()
{

# Linhas:

	if [ "$A $B $C" == "$PLAYER $PLAYER $PLAYER" ]
	then
		clear
		echo
		echo
		echo -e "    \033[1;32m$A\033[0m | \033[1;32m$B\033[0m | \033[1;32m$C\033[0m "
		echo -e "   -----------"
		echo -e "    $D | $E | $F "
		echo -e "   -----------"
		echo -e "    $G | $H | $I "

		_winner
	fi

	if [ "$D $E $F" == "$PLAYER $PLAYER $PLAYER" ]
	then
		clear
		echo
		echo
		echo -e "    $A | $B | $C "
		echo -e "   -----------"
		echo -e "    \033[1;32m$D\033[0m | \033[1;32m$E\033[0m | \033[1;32m$F\033[0m "
		echo -e "   -----------"
		echo -e "    $G | $H | $I "

		_winner
	fi

	if [ "$G $H $I" == "$PLAYER $PLAYER $PLAYER" ]
	then
		clear
		echo
		echo
		echo -e "    $A | $B | $C "
		echo -e "   -----------"
		echo -e "    $D | $E | $F "
		echo -e "   -----------"
		echo -e "    \033[1;32m$G\033[0m | \033[1;32m$H\033[0m | \033[1;32m$I\033[0m "

		_winner
	fi

# Colunas:

	if [ "$A $D $G" == "$PLAYER $PLAYER $PLAYER" ]
	then
		clear
		echo
		echo
		echo -e "    \033[1;32m$A\033[0m | $B | $C "
		echo -e "   -----------"
		echo -e "    \033[1;32m$D\033[0m | $E | $F "
		echo -e "   -----------"
		echo -e "    \033[1;32m$G\033[0m | $H | $I "

		_winner
	fi

	if [ "$B $E $H" == "$PLAYER $PLAYER $PLAYER" ]
	then
		clear
		echo
		echo
		echo -e "    $A | \033[1;32m$B\033[0m | $C "
		echo -e "   -----------"
		echo -e "    $D | \033[1;32m$E\033[0m | $F "
		echo -e "   -----------"
		echo -e "    $G | \033[1;32m$H\033[0m | $I "

		_winner
	fi

	if [ "$C $F $I" == "$PLAYER $PLAYER $PLAYER" ]
	then
		clear
		echo
		echo
		echo -e "    $A | $B | \033[1;32m$C\033[0m "
		echo -e "   -----------"
		echo -e "    $D | $E | \033[1;32m$F\033[0m "
		echo -e "   -----------"
		echo -e "    $G | $H | \033[1;32m$I\033[0m "

		_winner
	fi

# Diagonais:

	if [ "$A $E $I" == "$PLAYER $PLAYER $PLAYER" ]
	then
		clear
		echo
		echo
		echo -e "    \033[1;32m$A\033[0m | $B | $C "
		echo -e "   -----------"
		echo -e "    $D | \033[1;32m$E\033[0m | $F "
		echo -e "   -----------"
		echo -e "    $G | $H | \033[1;32m$I\033[0m "

		_winner
	fi

	if [ "$C $E $G" == "$PLAYER $PLAYER $PLAYER" ]
	then
		clear
		echo
		echo
		echo -e "    $A | $B | \033[1;32m$C\033[0m "
		echo -e "   -----------"
		echo -e "    $D | \033[1;32m$E\033[0m | $F "
		echo -e "   -----------"
		echo -e "    \033[1;32m$G\033[0m | $H | $I "

		_winner
	fi
}

while true
do
	STOP=0

	while [ $STOP != 1 ]
	do
		_display
		_imput
	done

	if [ $INITUSER == X ]
	then
		INITUSER=O
	else
		INITUSER=X
	fi
done




