#!/bin/bash

# Jakub Bot 2024, MIT, 2024
# Porownywarka plikow, katalogow na podstawie algorytmu kryptograficznej funkcji skrotu SHA256 

source constants.sh
source finder.sh

$selectedOption


# glowne menu
function printMainMenu {
  menu=("$porownajPliki" "$porownajKatalogi" "$porownajZListy" "$komendaWTerminalu" "$wyjscie")

  odp=`zenity --list --column=Menu "${menu[@]}" --height 420`

  echo $odp
}


function handleCompareFiles {
  # podaj ilosc plikow
   iloscPlikow=`zenity --entry --text="Podaj ilosc plikow do porownania"`

  # petla pobierajaca sciezki do plikow
  for (( i=1; i<=$iloscPlikow; i++ ))
  do
  findFile
    # sciezkaPliku=`zenity --file-selection --title="Wybierz plik $i"`
    # echo "Sciezka pliku $i: $sciezkaPliku"
  done

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
    "$porownajZListy")
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

  handleSelectedOption

done
}

start