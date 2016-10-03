#!/bin/bash
#PARA MOSTRAR O TEMPO, UMIDADE, NO TORSMO
#muda o valor da var link para o link de sua cidade
link=http://www1.folha.uol.com.br/folha/tempo/br-piracicaba.shtml
lynx -accept_all_cookies -dump $link > tempo.txt
temperatura=$(cat tempo.txt | grep "Temp" | grep C)
vento=$(cat tempo.txt | grep "Vento:")
umidade=$(cat tempo.txt | grep "Umidade")
if [ -e tempo.txt ]
then
   echo $temperatura
   echo $vento
   echo $umidade
   rm tempo.txt
else
   echo 'Nao foi possivel receber informacoes sobre o tempo.'
fi
