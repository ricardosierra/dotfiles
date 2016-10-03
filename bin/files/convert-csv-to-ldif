# Script para conversão de arquivos CSV para LDIF
# Autor: Ronil Estevam
# Adapte este Script conforme a sua necessidade
#!/bin/bash

clear
echo
echo
echo " ####################Bem-Vindo ao CONVERT_CSV-LDIF (Programa de conversão CSV para LDIF)################## "
echo
echo "Informe o nome do arquivo a ser convertido:" #Solicita o arquivo a ser convertido
	read arquivo1 # Lê o arquivo informado

echo "Informe o delimitador a ser utilizado:" #Solicita o delimitador utilizado no arquivo
	read delimitador #Lê o delimitador informado


	sed '1,$s/"//g' $arquivo1 > /tmp/arquivo2  # Expressão regular para retirar as aspas contidas no arquivo e dopois salva o arquivo sem aspas em /tmp/arquivo2

cont=1 #Variavél para contar as linhas do arquivo

	while [ $cont -le 90 ] #Comando de loop, utilizado para executar os comandos abaixo até que termine a ultima linha do arquivo( no meu caso 90)
		do #Faz parte do comando while

######### Trecho a ser executado até a condição do comando while ser satisfeita#######
c1=$(head -n$cont /tmp/arquivo2 | cut -f1 -d"$delimitador" | tail -n1)
c2=$(head -n$cont /tmp/arquivo2 | cut -f2 -d"$delimitador" | tail -n1)
c3=$(head -n$cont /tmp/arquivo2 | cut -f3 -d"$delimitador" | tail -n1)
c4=$(head -n$cont /tmp/arquivo2 | cut -f4 -d"$delimitador" | tail -n1)

echo cn: $c1 >> arq.ldif
echo dn: $c2 >> arq.ldif
echo sn: $c3 >> arq.ldif
echo pw: $c4 >> arq.ldif
echo " " >> arq.ldif	
	cont=`expr $cont + 1`  # Finalizando a contagem das linhas do arquivo
		done # Finalizando o comando while

###### Fim do trecho a ser executado #############

	rm /tmp/arquivo2  # Remove o arquivo temporario arquivo2

echo "Fim!!!! Os arquivos foram convertidos com sucesso" # Messagem de fim de execução do script

cat arq.ldif

