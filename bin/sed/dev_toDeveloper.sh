#!/bin/sh
# 
echo "Mudando para Modo Desenvolvedor em $1"

sed -i "s/define('YII_DEBUG', false)/define('YII_DEBUG', true)/" $1
sed -i "s/define('_ENVIRONMENT_','production')/define('_ENVIRONMENT_','development')/" $1
