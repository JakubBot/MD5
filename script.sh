#!/bin/bash

# Jakub Bot 2024, MIT, 2024
# Porownywarka plikow, katalogow na podstawie algorytmu kryptograficznego MD5

source constants.sh
source finder.sh
source compareMD5.sh
source utils.sh

$selectedOption


# glowne menu
function printMainMenu {
    menu=("$porownajPliki" "$porownajKatalogi" "$porownajZListy" "$komendaWTerminalu" "$wyjscie")
    
    odp=`zenity --list --column=Menu "${menu[@]}" --height 420`
    
    echo $odp
}


function handleCompareFiles {
    filesCount=-1
    
    while [ $filesCount -lt 2 ]; do
        filesCount=`zenity --entry --text="Podaj ilosc plikow do porownania\n- minimum 2\n- 0 by przerwac" --title="Pliki"`
        
        isNum=$(isNumber "$filesCount")
        
        if [ $isNum -eq $FALSE ]; then
            filesCount=-1
            continue
        fi
        
        if [ $filesCount -eq 0 ]; then
            return
        fi
    done
    
    local _paths=()
    
    addedFiles=0
    
    while [ $filesCount -ne $addedFiles ]; do
        path=$(findFile)
        
        if [ -z "$path" ]; then
            zenity --info --text "Nie znaleziono pliku" --width=200 --height=200
            continue
        fi
        
        _paths+=("$path")
        addedFiles=$((addedFiles+1))
    done
    
    compareFiles "${_paths[@]}"
    
}

function handleCompareDirectories {
    dirCount=-1
    
    while [ $dirCount -lt 2 ]; do
        dirCount=`zenity --entry --text="Podaj ilosc folderow do porownania\n- minimum 2\n- 0 by przerwac" --title="Foldery"`
        
        isNum=$(isNumber "$dirCount")
        
        if [ $isNum -eq $FALSE ]; then
            dirCount=-1
            continue
        fi
        
        
        if [ $dirCount -eq 0 ]; then
            return
        fi
    done
    
     _directories=()
    
    addedDirectories=0
    
    while [ $dirCount -ne $addedDirectories ]; do
        directory=$(handleFolderSearch)
        
        if [ -z "$directory" ]; then
            
            zenity --info --text "Nie znaleziono folderu" --width=200 --height=200
            
            continue
        fi
        
        _directories+=("$directory")
        addedDirectories=$((addedDirectories+1))
    done
    
    
    compareDirectories "${_directories[@]}"
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