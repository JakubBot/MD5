#!/bin/bash

# Jakub Bot 2024, MIT, 2024
# Porownywarka plikow, katalogow na podstawie algorytmu kryptograficznego MD5

source constants.sh
source finder.sh
source compareMD5.sh

$selectedOption


# glowne menu
function printMainMenu {
    menu=("$porownajPliki" "$porownajKatalogi" "$porownajZListy" "$komendaWTerminalu" "$wyjscie")
    
    odp=`zenity --list --column=Menu "${menu[@]}" --height 420`
    
    echo $odp
}


function handleCompareFiles {
    filesCount=`zenity --entry --text="Podaj ilosc plikow do porownania" --title="Pliki"` 
    
    paths=()
    
    addedFiles=0
    
    while [ $filesCount -ne $addedFiles ]; do
        path=$(findFile)
        
        if [ -z "$path" ]; then
            continue
        fi
        
        paths+=("$path")
        addedFiles=$((addedFiles+1))
    done
    
    compareFiles "${paths[@]}"
    
}

function handleCompareDirectories {
    dirCount=`zenity --entry --text="Podaj ilosc folderow do porownania" --title="Foldery"`
    
    directories=()
    
    addedDirectories=0
    
    while [ $dirCount -ne $addedDirectories ]; do
        directory=$(handleFolderSearch)
        
        if [ -z "$directory" ]; then
            continue
        fi
        
        directories+=("$directory")
        addedDirectories=$((addedDirectories+1))
    done

    
    compareDirectories "${directories[@]}"
    
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