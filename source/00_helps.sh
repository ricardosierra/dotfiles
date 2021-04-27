# Convert p/ minusculo
strtolower(){
	local texto=$@
	echo ${texto,,}
}
# Convert p/ Maiusclo
strtoupper(){
	local texto=$@
	echo ${texto^^}
}


# Captura o Directory Atual
#
# printf '%s\n' "${PWD##*/}"
# use:
#result=$(get-actual-directory)   # or result=`get-actual-directory`
#echo $result
function get-actual-directory()
{
    local result=${PWD##*/}  
    echo "$result"
}

