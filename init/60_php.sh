#!/bin/bash

#
#  Dependências para quem trabalha com PHP
#
install_php_dependences() {
  # Testes Unitários
  composer global require "codeception/codeception:*"
  composer global require "phpdocumentor/phpdocumentor:2.*"
  # Statistics for PhpProjects
  composer global require 'phploc/phploc=*'
  composer global require "phpstan/phpstan:*"
}

asdf install php latest

pecl install redis
pecl install imagick
pecl install xdebug

echo "extension=redis.so
extension=imagick.so" >> $(asdf where php)/conf.d/php.ini


if [[ "$(pinpoint composer)" ]]; then
	install_php_dependences
fi
