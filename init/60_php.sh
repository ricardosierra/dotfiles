#!/bin/bash

#
#  Dependências para quem trabalha com PHP
#
install_php_dependences() {
  # Testes Unitários
  composer global require "codeception/codeception:*"
  # Statistics for PhpProjects
  composer global require 'phploc/phploc=*'  
}


install_php_dependences