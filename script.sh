#!/bin/bash

# Author           : Jakub Bot ( bkuba1401@gmail.com )
# Created On       : 21.04.2024
# Version          : 1.0.0
#
# Description      : Comparison of files, directories based on MD5 cryptographic algorithm. Creating backups, restoring files, checking changes in files.
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)

source constants.sh
source finder.sh
source compareMD5.sh
source backup.sh
source utils.sh

$selectedOption


# glowne menu
function printMainMenu {
    menu=("$porownajPliki" "$porownajKatalogi" "$stworzBackup" "$zmianyWPlikach" "$przywrocPliki"  "$informacjeOAplikcaji" "$wyjscie")
    
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



function handleCreateBackup {
    
    local backupDir=""
    
    while [ -z "$backupDir" ]; do
        backupDir=$(handleFolderSearch)
    done
    
    
    createBackup "$backupDir"
}

function handleRestoreBackupFiles {
    local _directory=""
    
    while [ -z "$_directory" ]; do
        _directory=$(handleFolderSearch)
        
        local backupFileName=$(filenameToBackupConverter "$_directory")
        
        if ! test -e "backup/$backupFileName.tar.gz"; then
            zenity --info --text "Nie stworzona kopi zapasowej folderu" --width=200 --height=200
            _directory=""
        fi
    done
    
    restoreBackupFiles "$_directory"
}

function handleFolderChanges {
    local _directory=""
    
    while [ -z "$_directory" ]; do
        _directory=$(handleFolderSearch)
        
        local backupFileName=$(filenameToBackupConverter "$_directory")
        
        if ! test -e "backup/$backupFileName.tar.gz"; then
            zenity --info --text "Nie stworzona kopi zapasowej folderu" --width=200 --height=200
            _directory=""
        fi
    done
    
    findChangesInFolder "$_directory"
}

function handleAppInfo {
    # zenity --info --text "Aplikacja do porownywania plikow, katalogow, tworzenia kopii zapasowych, przywracania plikow, sprawdzania zmian w plikach.\n\nAutor: Jakub Bot\nWersja: 1.0.0\nData utworzenia: 21.04.2024" --width=$universalInfoWidth --height=200
    local _menu=("$pomoc" "$wersja")
    
    odp=`zenity --list --column=Menu "${_menu[@]}" --height 350`
    
    if [ "$odp" == "$pomoc" ]; then
        zenity --info --text "Aplikacja do porownywania plikow, katalogow. Wykorzystuje md5 w porownaniach.\nTworzy kopie zapasowa, przywraca pliki i za pomoca md5 analizuje jakie pliki zostaly zmienione." --width=$universalInfoWidth --height=200
        elif [ "$odp" == "$wersja" ]; then
        zenity --info --text "\nAutor: Jakub Bot\nWersja: 1.0.0\nData utworzenia: 21.04.2024" --width=250 --height=240
    fi
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
        "$stworzBackup")
            handleCreateBackup
        ;;
        "$zmianyWPlikach")
            handleFolderChanges
        ;;
        "$przywrocPliki")
            handleRestoreBackupFiles
        ;;
        "$informacjeOAplikcaji")
            handleAppInfo
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