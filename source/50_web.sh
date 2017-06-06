#!/bin/bash

alias google=search_web
search_web(){
  
  local search_query=$@
  browser-exec "https://www.google.com.br/search?client=ubuntu&channel=fs&q=${search_query}&ie=utf-8&oe=utf-8&gfe_rd=cr&ei=-2yaV9G_LunM8Af51ITAAQ"
}
