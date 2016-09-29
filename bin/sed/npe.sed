#!/bin/sed -f
#
# GNU sed version 4.1.5
#
# npe.sed (numeros por extenso) by Daemonio (undefinido at gmail.com)
#
# Fri Aug 21 16:14:01 BRT 2009 ( fim do script teste )
# Thu Nov  5 23:31:17 AMT 2009 ( uso da virgula )
# Sat Nov  7 16:14:58 AMT 2009 ( "um mil" --> "mil" )
# Sun Nov  8 18:06:04 AMT 2009 ( limite aumentado )
# Sun Nov  8 22:15:18 AMT 2009 ( fim da primeira versao )

#
# = Uso =
# $ echo '12345' | npe.sed
# doze mil, trezentos e quarenta e cinco
#
# = Observacoes e Limitacoes =
# 1) Digite ->somente numeros<- entre:
#      0 e 999999999999999999999999999
# 2) "um" no inicio da string nao vira "hum".
#

#
# begin
#

#
# Retira os zeros a esquerda.
#
s,^00*,,                               

#
# Se o PATT esta vazio entao interpreta como zero
# e pula para o fim do script.
# 
/./ !{                                 
    s,^,zero,                          
    b                                  
}                                      

#
# Separa o numero com um '-' em cada tres posicoes.
# ex: 12345 vira 12-345
#
:separar                               
s,\B[0-9]\{3\}\b,-&,                   
t separar                              

#
# Coloca um '-' no final para facilitar o
# algoritmo abaixo.
#
s,$,-,                                 

#
# Acrescenta:
#
#   => "a"   depois do numero das unidades
#   => "aa"  depois do numero das dezenas
#   => "aaa" depois do numero das centenas
#
# Veja que este conceito de unidades, dezenas e
# centenas toma como referencia o '-' e nao o
# numero propriamente dito.
#
s/\([0-9]\)-/\1a-,/g                   
s,\([0-9]\)\([0-9]a-\),\1aa\2,g        
s,\([0-9]\)\([0-9]aa\),\1aaa\2,g       

#
# Retira a virgula do fim da string.
#
s/.$//                                 

#
# Aqui vem os numeros que nao sao compostos por outros
# numeros (seus nomes nao possuem o 'e' como em - 25 -
# vinte E cinco).
#
# Sao eles: 
# 10,11,12,13,14,15,16,17,18,19,20,30,40, .. , 90
#
:naocompostos                          
/1aa[0-9]a-/ {                         
    s,$,;0dez1onze2doze3treze4quatorze5quinze,
    s,$,6dezesseis7dezessete8dezoito9dezenove,
    s,1aa\([0-9]\)a-\([^;]*\);.*\1\([^0-9]*\).*, \3-\2,
}                                      

/[2-9]aa0a-/ {                         
    s,$,;2vinte3trinta4quarenta5cinquenta,
    s,$,6sessenta7setenta8oitenta9noventa,
    s,\([2-9]\)aa0a-\([^;]*\);.*\1\([^0-9]*\).*, \3-\2,
}                                      
t naocompostos                         

#
# Um 100 seguido de '-' vira "cem", senao ele vai
# virar "cento" no processo de substituicao.
#
/,\{0,1\}1aaa0aa0a-/ s,, cem-,g        

#
# Retira o '-' do final.
#
s/-$//                                 

#
# Remove os zeros que estao entre os numeros.
#
/0a/ {                                 
    s/,0a/0a/g                         
    s/0aa*//g                          
}                                      

#
# Cada numero adiciona seu padrao no PATT e o processo
# de substituicao eh feito por lookup tables.
#
:loop                                  

/1a/ {                                 
    s,$,;1aum1aaacento,                
    s,\(1aa*\)\([^;]*\);.*\1\([^a][^0-9]*\).*, \3\2,
}                                      

/2a/ {                                 
    s,$,;2adois2aavinte2aaaduzentos,   
    s,\(2aa*\)\([^;]*\);.*\1\([^a][^0-9]*\).*, \3\2,
}                                      

/3a/ {                                 
    s,$,;3atres3aatrinta3aaatrezentos, 
    s,\(3aa*\)\([^;]*\);.*\1\([^a][^0-9]*\).*, \3\2,
}                                      

/4a/ {                                 
    s,$,;4aquatro4aaquarenta4aaaquatrocentos,
    s,\(4aa*\)\([^;]*\);.*\1\([^a][^0-9]*\).*, \3\2,
}                                      

/5a/ {                                 
    s,$,;5acinco5aacinquenta5aaaquinhentos,
    s,\(5aa*\)\([^;]*\);.*\1\([^a][^0-9]*\).*, \3\2,
}                                      

/6a/ {                                 
    s,$,;6aseis6aasessenta6aaaseiscentos,
    s,\(6aa*\)\([^;]*\);.*\1\([^a][^0-9]*\).*, \3\2,
}                                      

/7a/ {                                 
    s,$,;7asete7aasetenta7aaasetecentos,
    s,\(7aa*\)\([^;]*\);.*\1\([^a][^0-9]*\).*, \3\2,
}                                      

/8a/ {                                 
    s,$,;8aoito8aaoitenta8aaaoitocentos,
    s,\(8aa*\)\([^;]*\);.*\1\([^a][^0-9]*\).*, \3\2,
}                                      

/9a/ {                                 
    s,$,;9anove9aanoventa9aaanovecentos,
    s,\(9aa*\)\([^;]*\);.*\1\([^a][^0-9]*\).*, \3\2,
}                                      

t loop                                 

# 
# Remove o espaco inicial.
#
/^ / s,,,                              

#
# Aqui vamos tratar as posicoes dos '-'.
# O ultimo '-' (por isso usei o .* pra casar
# o maximo possivel) eh trocado por mil, o penultimo
# por millhoes e assim por diante.
#
/-/ {                                  
    s,^,mil#milhoes#bilhoes#trilhoes;, 
    s,;,#quatrilhoes#quintilhoes#sextilhoes#septilhoes#,
    :b                                 
    s,\([^#]*\)#\(.*\)-,\2%\1,         
    t b                                
}                                      

#
# Remove o restante da lookup que permaneceu no PATT.
#
/#/ s,.*#,,                            

#
# Retira o espaco apos a virgula para que ele nao
# se transforme em " e ".
#
s/, /,/g                               

#
# Troca todos os espacos por " e ".
#
/ / s,, e ,g                           

/%/ {                                  
    #
    # Como os zeros foram deletados, a posicao do trio
    # que eles ocupavam ficou vazia.
    #
    # ex: 2000000 >vira> 2-- >vira> dois%mil%milhoes
    #                             
    # O que a linha abaixo faz eh transformar o
    # dois%mil%milhoes em "dois mil".
    #
    s/%\([^% ,]*\)%[^ ,]*/%\1/g        

    #
    # Se necessario, passa para o singular.
    #
    s,um%\([^l]*\)lhoes,um%\1lhao,g    

    #
    # Transforma "um mil" para "mil" (sse "um mil" estiver
    # no inicio da string).
    # OBS: \b --> para nao casar com "um milhao" que a
    # principio tambem contem a string "um mil".
    #
    s/^um%mil\b/mil/                   

    #
    # Qualquer % solto no PATT eh transformado em espaco.
    #
    s,%, ,g                            

    #
    # Adiciona um espaco apos a virgula para facilitar
    # a visualizacao.
    #
    s/,/& /g                           

}                                      

#
# end
#
