#!/bin/bash

# Jakub Bot 2024, MIT, 2024
# Porownywarka plikow, katalogow na podstawie algorytmu kryptograficznej funkcji skrotu SHA256 

source constants.sh

$selectedOption


# glowne menu
function printMainMenu {
  echo "$porownajPliki Siema asd"
  menu=("$porownajPliki" "$porownajKatalogi" "$komendaWTerminalu" "$wyjscie")
  # menu=("Porównaj pliki" "Porównaj katalogi" "Komenda w terminalu" "Wyjście")

  odp=`zenity --list --column=Menu "${menu[@]}" --height 420`

  echo $odp
}


function handleCompareFiles {
  #ads
  echo "Porównaj pliki"
}

# wywolywanie akcji dla glownego menu
function handleSelectedOption {
  case $selectedOption in
    "$porownajPliki")
      handleCompareFiles
      ;;
    "$porownajKatalogi")
      handleCompareDirectories
      ;;
    "$komendaWTerminalu")
      handleTerminalCommand
      ;;
    "$wyjscie")
      exit 0
      ;;
  esac
}


function start {

while [ 1 ]; do 
  selectedOption=$(printMainMenu)


done
}

start